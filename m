Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab2CUN0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:26:14 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:44158
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754634Ab2CUN0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:26:12 -0400
Date: Wed, 21 Mar 2012 14:26:06 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] Add design document for UBIFS secure deletion
In-Reply-To: <4F68E420.30801@xenotime.net>
Message-ID: <alpine.DEB.2.00.1203211413240.6054@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>  <1329152067.22240.214.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>  <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>
 <1331277476.22872.2.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net> <4F68E420.30801@xenotime.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for giving it a readover and finding a few errant remnants of the
academic version of this design doc. With your suggestions, the update
follows.

cheers,
Joel Reardon

p.s., I'm new to this git; git format-patch gives me one patch per commit,
which is a pity for a commit that e.g, fixes a typo. Format-patch
doesn't obviously report how to produce unified patches. Creating a new
branch, applying the patches, committing, and generating a new patch seems
too much overkill but I've seen it proposed. Simpler way?

---
 Documentation/filesystems/ubifsec.txt |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/ubifsec.txt b/Documentation/filesystems/ubifsec.txt
index 4eb41fb..175f13d 100644
--- a/Documentation/filesystems/ubifsec.txt
+++ b/Documentation/filesystems/ubifsec.txt
@@ -10,9 +10,16 @@ Trivial secure deletion by overwriting the deleted data does not work for
 flash memory, as there is a large difference between the size of the I/O unit
 (page) and the erasure unit (erase block). UBIFSec encrypts each data node
 with a distinct key and stores the keys colocated in a key storage area (KSA).
-Secure deletion is achieved by atomically updating the (small) set of erase
-blocks that constitute the KSA to remove keys corresponding to deleted data,
-thereby deleting the data nodes they encrypted.
+Secure deletion is achieved by updating the (small) set of erase blocks that
+constitute the KSA to remove keys corresponding to deleted data, thereby
+deleting the data nodes they encrypted. The additional wear due to flash
+erasure is small, only the erase blocks containing the keys, and the operation
+of removing old keys---called purging---is done periodically so the actual
+increase in wear is controled by the user. Moreover, the use of UBI's logical
+erase block (LEB) interface means that the additional wear is evenly spread
+over the flash memory and the new version of a LEB containing the keys can be
+written using UBI's atomic update proceedure to ensure no keys are lost during
+an update.

 Key Storage Area (KSA)
 ======================
@@ -83,7 +90,7 @@ node must be valid according to the index
 the index.

 The operation of purging performed on a correct key state map guarantees
-DNEFS's soundness: purging securely deletes any key in the KSA marked as
+soundness: purging securely deletes any key in the KSA marked as
 deleted---afterwards, every key either decrypts one valid data node or nothing
 at all and every valid data node can be decrypted.  A correct key state map
 also guarantees the integrity of our data during purging, because no key that
@@ -101,7 +108,7 @@ The key state map is built from a periodic checkpoint combined with a replay
 of the most recent changes while mounting.  We checkpoint the current key
 state map to the storage medium whenever the KSA is purged. After a purge,
 every key is either unused or used, and so a checkpoint of this map can be
-stored using one bit per key---less than 1\% of the KSA's size---which is then
+stored using one bit per key---less than 1% of the KSA's size---which is then
 compressed.  A special LEB is used to store checkpoints, where each new
 checkpoint is appended; when the erase block is full then the next checkpoint
 is written at the beginning using an atomic update.
@@ -148,13 +155,11 @@ purging---taken as correct by assumption.
 Second, failure can occur after purging one, several, or indeed  all of the
 KSA's LEBs. When remounting the device, the loaded checkpoint merged with the
 replay data  reflects the state before the first purge, so some purged LEBs
-contain new unused data while the key state map claims it is a deleted key. As
-these are cryptographically-suitable random values, with high probability they
-cannot successfully decrypt any existing valid data node.
+contain new unused data while the key state map claims it is a deleted key.

 Third, failure can occur while writing to the checkpoint LEB.  When the
 checkpoint is written using atomic updates, then failing during the operation
-is equivalent to failing before it begins (cf. 2nd case).  Incomplete
+is equivalent to failing before it begins (compare the 2nd case).  Incomplete
 checkpoints are detected and so the previous valid checkpoint is loaded
 instead.  After replaying all the nodes, the key state map is equal to its
 state immediately before purging the KSA. This means that all entries marked
-- 
1.7.0.4


