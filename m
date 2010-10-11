Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0JKULy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:11:54 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42863 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0JKULw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:11:52 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [PATCH v1.1 0/4] keys: trusted and encrypted keys 
Date: Mon, 11 Oct 2010 16:11:39 -0400
Message-Id: <1286827903-3066-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the original posting, the encrypted keys are started at
late_initcall, in order to wait for the crypto API to be
initialized, minor changes were made to Kconfig, Roberto Sassu's
fixes (adding missing 'update' keyword, freeing allocated memory
on failure) were merged, increased the data size limit, based on
Roberto's request, and added Rajiv Andrade's ack for the TPM
patch.

Trusted and Encrypted Keys are two new key types added to the
existing kernel key ring service. Both of these new types are
variable length symmetic keys, and in both cases all keys are
created in the kernel, and user space sees, stores, and loads 
only encrypted blobs. Trusted Keys require the availability of a
Trusted Platform Module (TPM) chip for greater security, while
Encrypted Keys can be used on any system. All user level blobs,
are displayed and loaded in hex ascii for convenience, and
are integrity verified.

Trusted Keys use a TPM both to generate and to seal the keys.
Keys are sealed under a 2048 bit RSA key in the TPM, and optionally
sealed to specified PCR (integrity measurement) values, and only
unsealed by the TPM, if PCRs and blob integrity verifications match.
A loaded Trusted Key can be updated with new (future) PCR values,
so keys are easily migrated to new pcr values, such as when the
kernel and initramfs are updated. The same key can have many
saved blobs under different PCR values, so multiple boots are
easily supported.

Trusted Keys are sealed under the SRK, which must have the default
authorization value (20 zeros). This can be set at takeownership
time with the trouser's utility "tpm_takeownership -u -z".

Usage:
    keyctl add trusted name "NEW keylen [hex_pcrinfo]" ring
    keyctl add trusted name "LOAD hex_blob" ring
    keyctl update key "UPDATE hex_pcrinfo"
    keyctl print keyid
    keyctl pipe keyid > filename

The key length for new keys are always in bytes.
Trusted Keys can be 32 - 128 bytes (256 - 1024 bits), the upper
limit is to fit within the 2048 bit SRK (RSA) keylength, with
all necessary structure/padding. The keywords NEW, LOAD, and
UPDATE can be all upper or all lower case.

Encrypted keys do not depend on a TPM, and are faster, as they
use AES for encryption/decryption. New keys are created from kernel
generated random numbers, and are encrypted/decrypted using a
specified 'master' key. The 'master' key can either be a trusted-key
or user-key type. The main disadvantage of encrypted keys is that if
they are not rooted in a trusted key, they are only as secure as the
user key encrypting them. The master user key should therefore
be loaded in as secure a way as possible, preferably early in
boot.

Usage:
  keyctl add encrypted name "NEW master-key-name keylen" ring
  keyctl add encrypted name "LOAD master-key-name keylen hex_blob" ring
  keyctl update keyid "UPDATE master-key-name"

The initial consumer of trusted keys is EVM, which at boot time
needs a high quality symmetric key for HMAC protection of file
metadata. The use of a trusted key provides strong guarantees
that the EVM key has not been compromised by a user level problem,
and when sealed to specific boot PCR values, protects against
boot and offline attacks. Other uses for trusted and encrypted
keys, such as for disk and file encryption are anticipated.

Mimi Zohar
Dave Safford

Mimi Zohar (4):
  lib: hex2bin converts ascii hexadecimal string to binary
  key: add tpm_send command
  keys: add new trusted key-type
  keys: add new key-type encrypted

 drivers/char/tpm/tpm.c            |   17 +
 include/keys/encrypted-type.h     |   30 ++
 include/keys/trusted-type.h       |   33 ++
 include/linux/kernel.h            |    1 +
 include/linux/tpm.h               |    3 +
 lib/hexdump.c                     |   16 +
 security/Kconfig                  |   31 ++
 security/keys/Makefile            |    2 +
 security/keys/encrypted_defined.c |  782 +++++++++++++++++++++++++++++
 security/keys/encrypted_defined.h |   52 ++
 security/keys/trusted_defined.c   |  997 +++++++++++++++++++++++++++++++++++++
 security/keys/trusted_defined.h   |  125 +++++
 12 files changed, 2089 insertions(+), 0 deletions(-)
 create mode 100644 include/keys/encrypted-type.h
 create mode 100644 include/keys/trusted-type.h
 create mode 100644 security/keys/encrypted_defined.c
 create mode 100644 security/keys/encrypted_defined.h
 create mode 100644 security/keys/trusted_defined.c
 create mode 100644 security/keys/trusted_defined.h

-- 
1.7.2.2

Mimi Zohar (4):
  lib: hex2bin converts ascii hexadecimal string to binary
  key: add tpm_send command
  keys: add new trusted key-type
  keys: add new key-type encrypted

 drivers/char/tpm/tpm.c            |   17 +
 include/keys/encrypted-type.h     |   30 ++
 include/keys/trusted-type.h       |   33 ++
 include/linux/kernel.h            |    1 +
 include/linux/tpm.h               |    3 +
 lib/hexdump.c                     |   16 +
 security/Kconfig                  |   31 ++
 security/keys/Makefile            |    2 +
 security/keys/encrypted_defined.c |  804 +++++++++++++++++++++++++++++
 security/keys/encrypted_defined.h |   52 ++
 security/keys/trusted_defined.c   |  999 +++++++++++++++++++++++++++++++++++++
 security/keys/trusted_defined.h   |  125 +++++
 12 files changed, 2113 insertions(+), 0 deletions(-)
 create mode 100644 include/keys/encrypted-type.h
 create mode 100644 include/keys/trusted-type.h
 create mode 100644 security/keys/encrypted_defined.c
 create mode 100644 security/keys/encrypted_defined.h
 create mode 100644 security/keys/trusted_defined.c
 create mode 100644 security/keys/trusted_defined.h

-- 
1.7.2.2

