Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2CWNvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 09:51:01 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:57052
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752380Ab2CWNvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 09:51:00 -0400
Date: Fri, 23 Mar 2012 14:50:56 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] Add design document for UBIFS secure deletion
In-Reply-To: <1332346218.14983.20.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203231448520.22944@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>   <1329152067.22240.214.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>   <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net> 
 <1331277476.22872.2.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net> <1332346218.14983.20.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated design doc with comments.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 Documentation/filesystems/ubifsec.txt |  362 +++++++++++++++++++++++++++++++++
 1 files changed, 362 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/ubifsec.txt

diff --git a/Documentation/filesystems/ubifsec.txt b/Documentation/filesystems/ubifsec.txt
new file mode 100644
index 0000000..ae53791
--- /dev/null
+++ b/Documentation/filesystems/ubifsec.txt
@@ -0,0 +1,361 @@
+UBIFS Secure Deletion Enhancement
+
+Written by Joel Reardon <reardonj@inf.ethz.ch>
+Last revised: 19.3.2012
+
+Introduction
+============
+UBIFSec provides efficient secure deletion for the flash file system UBIFS.
+Trivial secure deletion by overwriting the deleted data does not work for
+UBI-accessed flash memory, as there is a large difference between the size of
+the I/O unit (page) and the erasure unit (logical erase block or LEB).
+UBIFSec encrypts each data node with a distinct key and stores the keys
+colocated in a key storage area (KSA).  Secure deletion is achieved by
+updating the (small) set of LEBs that constitute the KSA to remove keys
+corresponding to deleted data, thereby deleting the data nodes they encrypted.
+The additional wear due to flash erasure is small, only the LEBs containing
+the keys, and the operation of removing old keys---called purging---is done
+periodically so the actual increase in wear is controlled by the user.
+Moreover, the use of UBI's logical interface means that the additional wear is
+evenly spread over the flash memory and the new version of a LEB containing
+the keys can be written using UBI's atomic update proceedure to ensure no keys
+are lost during an update.
+
+Key Storage Area (KSA)
+======================
+UBIFSec uses a small set of LEBs to store all the data node's keys---this set
+is called the Key Storage Area (KSA). The KSA is managed separately from the
+rest of the file system. In particular, it does not behave like a
+log-structured file system: when a KSA LEB is updated, its contents are
+written to a new physical location on the flash memory, UBI's logical map is
+then updated to this new physical address and the previous version of the KSA
+LEB is then erased.  Thus, except while updating the KSA, only one copy of the
+data in the KSA is available on the storage medium.  When the file system is
+created, cryptographically-suitable random data is written from random_bytes()
+to each of the KSA's LEBs and all the keys are marked as unused.  Purging
+writes new versions of the KSA LEBs using UBI's atomic update feature.
+
+Each data node's header stores the logical KSA position that contains its
+decryption key. The LEBs in the KSA are periodically erased to securely delete
+any keys that decrypt deleted data. When the file system no longer needs a
+data node---i.e, it is removed or updated---we mark the data node's
+corresponding key in the KSA as deleted.  This is independent of the notion of
+files; keys are marked as deleted whenever a data node is discarded.  A key
+remains marked as deleted until it is removed from the storage medium and its
+location is replaced with fresh, unused random data, which is then marked as
+unused.
+
+When a new data node is written to the storage medium, an unused key is
+selected from the KSA and its position is written to the data node's header.
+The keys are in a protected area of the file system, so only users with root
+access to the storage medium are capable of reading the keys that encrypt
+data.
+
+Purging
+=======
+Purging is a periodic procedure that securely deletes keys from the KSA.
+Purging proceeds iteratively over each of the KSA's LEBs: a new version of the
+LEB is prepared where the used keys remain in the same position and all other
+keys (i.e., unused and deleted keys) are replaced with fresh, unused,
+cryptographically-appropriate random data from a source of hardware
+randomness. This fresh random data is then assigned to new keys as needed. We
+keep used keys logically-fixed because their corresponding data node has
+already written its logical position. The new version of the LEB is then
+written to an arbitrary empty LEB on the storage medium.  After completion,
+the LEB containing the old version is erased, thus securely deleting the
+unused and deleted keys along with the data nodes they encrypt.
+
+If a KSA LEB becomes a bad block while erasing it, it is possible that its
+contents will remain readable on the storage medium without the ability to
+remove them. In this case, it is necessary to re-encrypt any data node whose
+encryption key remains available and force the garbage collection of those
+LEBs on which the data nodes reside.
+
+Key State Map
+=============
+The key state map is an in-memory map that maps key positions to key states
+{unused, used, deleted}. Unused keys can be assigned and then marked used.
+Used keys are keys that encrypt some valid data node, so they must be
+preserved to ensure availability of the file system's data. Deleted keys are
+keys used to encrypt deleted data---i.e., data nodes that are no longer
+referenced by the index---and should be purged from the system to achieve
+secure deletion.
+
+A correct key state map is one that has the following three properties:
+1. every unused key must not decrypt any data node---either valid or invalid
+2. every used key must have exactly one data node it can decrypt and this data
+node must be valid according to the index
+3. every deleted key must not decrypt any data node that is valid according to
+the index.
+
+The operation of purging performed on a correct key state map guarantees
+soundness: purging securely deletes any key in the KSA marked as
+deleted---afterwards, every key either decrypts one valid data node or nothing
+at all and every valid data node can be decrypted.  A correct key state map
+also guarantees the integrity of our data during purging, because no key that
+is used to decrypt valid data will be removed.
+
+The key state map is stored, used, and updated in volatile memory. Initially,
+the key state map of a freshly-formatted UBIFSec file system is correct as it
+consists of no data nodes, and every key is fresh random data that is marked
+as unused. While mounted, UBIFSec performs appropriate key management to
+ensure that the key state map is always correct when new data is written,
+deleted, etc. We now show that we can always create a correct key state map
+when mounting an arbitrary UBIFSec file system.
+
+The key state map is built from a periodic checkpoint combined with a replay
+of the most recent changes while mounting.  We checkpoint the current key
+state map to the storage medium whenever the KSA is purged. After a purge,
+every key is either unused or used, and so a checkpoint of this map can be
+stored using one bit per key---less than 1% of the KSA's size---which is then
+compressed.  A special LEB is used to store checkpoints, where each new
+checkpoint is appended; when the LEB is full then the next checkpoint is
+written at the beginning using an atomic update.
+
+Correctness of the Key State Map
+================================
+As an invariant, we require that UBIFSec's key state map is always correct
+before and after executing a purge. This restriction---instead of requiring
+correctness at all times after mounting---is to allow writing new data during
+a purging operation, and to account for the time between marking a key as used
+and writing the data it encrypts onto the storage medium.
+
+The checkpoint is correct when it is written to the storage medium, and
+therefore it is correct when it is loaded during mounting if no other changes
+occurred to the file system. If the file system changed after committing and
+before unmounting, then UBIFS's replay mechanism is used to generate the
+correct key state map: first the checkpoint is loaded, then the replay entries
+are simulated. Therefore, we always perform purging during regular UBIFS
+commits; the nodes that are replayed for UBIFS are exactly the ones that must
+be replayed for UBIFSec. If the stored checkpoint gets corrupted, then a full
+scan of the valid data nodes can rebuild the correct key state map.
+
+As it is possible for the storage medium to fail during the commit operation
+(e.g., due to a  loss of power), we now show that our invariant holds
+regardless of the condition of unmounting.  Purging consists of atomically
+updating each LEB containing deleted keys and afterwards writing a new
+checkpoint. UBI's atomic update feature ensures that any failure before
+completing the update is equivalent to failing immediately before beginning.
+Therefore, the following is the complete list of possible failure points:
+1. before the first purge.
+2. between some purges.
+3. after all the purges but before the checkpoint.
+4. during the checkpoint.
+5. after the checkpoint but before finishing other UBIFS commit actions.
+
+We now show that we can construct a correct key state map in all these
+situations.
+
+First, failure can occur before purging the first LEB, which means the KSA is
+unchanged.  When remounting the device, the loaded checkpoint is updated  with
+the replay data, thereby constructing the exact key state map before
+purging---taken as correct by assumption.
+
+Second, failure can occur after purging one, several, or indeed  all of the
+KSA's LEBs. When remounting the device, the loaded checkpoint merged with the
+replay data  reflects the state before the first purge, so some purged LEBs
+contain new unused data while the key state map claims it is a deleted key.
+
+Third, failure can occur while writing to the checkpoint LEB.  When the
+checkpoint is written using atomic updates, then failing during the operation
+is equivalent to failing before it begins (compare the 2nd case).  Incomplete
+checkpoints are detected and so the previous valid checkpoint is loaded
+instead.  After replaying all the nodes, the key state map is equal to its
+state immediately before purging the KSA. This means that all entries marked
+as deleted are actually unused entries, so the invariant holds.
+
+Finally, failure can occur after successfully purging the KSA and
+checkpointing the key state map, but before completing the regular UBIFS
+commit.  In this case, the current key state map correctly reflects the
+contents of the KSA. When mounting, the replay mechanism incorrectly updates
+it with the journal entries of the previous iteration.  Table 1 shows the full
+space of possibilities when replaying old changes on the post-purged
+checkpoint. It shows that it is only possible for an unused key to be
+erroneously marked as deleted, which still results in a correct key state map.
+
++--------+--------------+--------+---------+-----------------------+---------+
+|old ckpt|   replay's   | ckpt   | value   |         cause         |  key's  |
+| value  |    effect    | value  | after   |                       |  state  |
+|        |              |        | recvry  |                       |         |
++--------+--------------+--------+---------+-----------------------+---------+
+| unused |    nothing   | unused | unused  |        no event       | correct |
+| unused |   mark used  |  used  |  used   |      key assigned     | correct |
+| unused | mark deleted | unused | deleted | key assigned, deleted | correct |
+|  used  |    nothing   |  used  |  used   |        no event       | correct |
+|  used  |  mark used   |  used  |  used   |      cannot occur     | correct |
+|  used  | mark deleted | unused | deleted |      key deleted      | correct |
++--------+--------------+--------+---------+-----------------------+---------+
+Table 1: Consequences of replaying false information during committing.
+
+Adding Encryption in Compression
+================================
+Currently, compression (respectively decompression) is applied to all data
+before (respectively after) storage medium operations.  We modify the compress
+and decompress functions to take an optional key parameter. If no key is
+provided, then the functions behave normally. If a key is provided, then the
+data is encrypted before compression (respectively decrypted after
+compression) using the provided key as an AES key in counter mode.
+
+Implementing the Keymap
+=======================
+The keymap data structure and its algorithms constitute the majority of
+UBIFSec's changes. The keymap  maintains KSA information and caches, along
+with the key state map, the current position for assigning fresh keys, and a
+buffer for atomic updates and checkpoint preparation.
+
+The KSA is divided into discrete KSA ranges, which are ranked in terms of
+expected data lifetime. Generational garbage collection is heuristically used
+to promote longer-lived data to long-term ranges of the KSA. The goal is to
+reduce the number of LEBs that need to be erased during purging by having data
+that remains on the device reside elsewhere, which reduces the time required
+to purge large storage media.  KSA LEBs that are skipped during a purge have
+their unused keys marked as nonassignable until the LEB is finally replaced
+with fresh, random data.
+
+Each time UBIFS garbage collects a data node, it may be promoted to a
+longer-term area of the KSA. This requires decrypting the stored data,
+encrypting with a new key, and updating the data node's key location and
+checksum. However, it does not incur additional cost to read or write the
+data, as it is only optionally  performed during regular UBIFS garbage
+collection when the data node is copied to a new location.
+
+The key state map is a two-dimensional array indexed first by the relative LEB
+number and then by the offset in the LEB. Key positions, stored in
+_crypto_lookup_ variables, are stored as 64-bit numbers where the first 32
+bits encode the relative LEB number and the next 32 bits encode the offset.  A
+key position's state can be changed to used or deleted by external functions,
+but only the keymap's purging function marks the state as unused. A lock
+synchronizes all access to the key state map. The function to get a free key
+position atomically searches for  an unused key position, marks the entry as
+used, and optionally returns the key.
+
+The keymap structure maintains an LEB-sized buffer for atomic updates.
+Purging the keymap proceeds iteratively for each of the KSA's LEBs. It reads
+the old version of the LEB into that buffer, performs the update, and provides
+it to UBI's atomic update function. Random data is taken from Linux kernel's
+hardware randomness source that is cryptographically suitable.  Purging is
+synchronized by a lock to prevent a second purge before the first has
+completed.
+
+The keymap structure also maintains a buffer for checkpoint preparation. After
+committing, the checkpoint is created  using one bit for each entry indicating
+if the key position is unused or used.  The checkpoint is then compressed,
+prefixed with the compressed size, and suffixed with the magic number.
+
+The external interface of the keymap consists of the following:
+keymap_purge() - purge the deleted keys, write a new checkpoint
+keymap_init() - initialization
+keymap_free() - deallocate memory
+keymap_free_key() - find and return an unused key
+keymap_read_key() - convert a key location to a key
+keymap_mark_used() - mark a key location as used
+keymap_mark_deleted() - mark a key location as deleted
+keymap_assign_lebs() - used during initialization to tell the keymap which
+		       LEBS are used for keys
+keymap_keys_per_eb() - returns the number of keys that fit on an LEB
+keymap_gc_should_promote() - returns true if we should reencrypt the data node
+			     during garbage collection
+keymap_swap_encryption_key() - performs the re-encryption of a data node during
+			       garbage collection
+
+Summary of Changes to UBIFS Components
+======================================
+
+Mounting.
+
+mounting the file system:
+- allocate and initialize the keymap
+- deallocate keymap if an error occurs
+- read the size of the KSA from the master node
+
+unmounting the file system:
+- deallocate the keymap
+
+creating default file system:
+- use storage medium's geometry to compute the required KSA size
+- store the size in the master node
+- call keymap's initialize KSA routine
+
+Commit.
+
+committing the journal:
+- call the keymap's purging routine
+
+Input/Output.
+
+writing data:
+- obtain an unused key position from the keymap
+- store the key's position in the data node's header
+- use the keymap and key position to look up the actual key
+- provide the key to the compress function
+
+recomputing last data node after truncation:
+- obtain the original key, decrypt the data
+- obtain a new key, encrypt the data with it after truncating
+
+reading data:
+- use the keymap and data node's key position to look up the actual key
+- provide the key to the decompress function
+
+Tree Node Cache.
+
+adding/updating the TNC:
+- provide a key position when adding data nodes
+- store the key position inside TNC entries
+- mark key position as used
+- if also updating, mark the old key position as deleted before storing the
+  new position.
+
+deleting/truncating the TNC:
+- when removing a data node from the TNC, mark the stored key position as
+  deleted
+
+committing the TNC:
+- read and write key position to stored tree nodes
+
+Garbage Collection.
+
+copying a data node to a new location:
+- decide whether to promote data nodes
+- re-encrypt promoted data node
+- mark old key is deleted, new key as used
+
+Future Extensions
+=================
+
+Encrypting metadata.
+
+UBIFSec securely deletes file content, but not a file's name and other
+metadata.  Some encrypted file systems, such as ecryptfs, encrypt this
+metadata along with the file data. Our implementation leverages the
+compression functionality of UBIFS to seamlessly add cryptographic operations.
+However, there is no technical reason that prohibits assigning an encryption
+key to non-data nodes (such as the index) and storing them encrypted on the
+storage medium.
+
+Purging Policies.
+
+Purging is currently performed after a user-controlled period of time and
+before unmounting the device. More elaborate policies could exist, where
+purging occurs once a threshold of deleted keys is passed, ensuring that the
+amount of exposable data is limited, so the deletion of many files would thus
+act as a trigger for purging.  An ioctl can be offered to allow user-level
+applications to trigger a purge, such as an email application that purges the
+file system after clearing the cache. We can alternatively use a new extended
+attribute to act a trigger: whenever any data node belonging to a sensitive
+file is deleted, then UBIFSec triggers an immediate purge. This allows users
+to have confidence that most files are periodically deleted, while sensitive
+files are promptly deleted.
+
+Password-protected Encrypted File System.
+
+UBIFSec can be trivially extended to offer a passphrase-protected encrypted
+file system: we simply encrypt the KSA whenever we write random data, and
+derive the decryption key from a provided passphrase when mounting. Since,
+with high probability, each randomly-generated key in the KSA is unique, we
+can use a block cipher in electronic codebook mode to allow rapid decryption
+of randomly accessed  offsets without storing additional initialization
+vectors. Such a scheme provides all the benefits of UBIFSec along with the
+additional guarantee that a non-coercive attacker (i.e., theft or repurposing)
+is unable to access any data stored on the device---provided the master secret
+does not reside in volatile memory at the time of the attack.
-- 
1.7.0.4


