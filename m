Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1K2XnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:43:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab1K2XnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:43:10 -0500
From: David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 00/16] Crypto keys and module signing [ver #2]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Date: Tue, 29 Nov 2011 23:42:58 +0000
Message-ID: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are a set of patches that create a framework for using cryptographic keys
within the kernel.  The patches can also be found at:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel

The basic crypto key has no requirements as to how the key is implemented; it's
basically a jump table for the operations and an anchor for any relevant data.

I have provided a couple of subtypes: DSA and RSA.  Both types have signature
verification facilities available within the kernel, and both can be used for
module signature verification with any encryption algorithm known by the PGP
parser, provided the appropriate algorithm is compiled directly into the
kernel.

These two subtypes store their public key data attached to the key and
implement the algorithms within the kernel.  However, it would be possible to
merely refer to keys held in a hardware keystore (such as a TPM) and have the
accessor methods offload the actual work to that keystore to be done in
hardware.

With kernel module signing enabled, and a pair of keys (one RSA, one DSA)
compiled into the kernel, root can see these keys and the keyring that holds
them in /proc/keys:

195fa736 I-----     1 perm 3f010000     0     0 crypto    modsign.1: dsa 5acc2142 []
335ab517 I-----     1 perm 1f030000     0     0 keyring   .module_sign: 2/4
38d7d169 I-----     1 perm 3f010000     0     0 crypto    modsign.0: rsa 57532ca5 []

Module signing combinations that have been tested: DSA with SHA1 and RSA with
all the SHA algorithms.

The patches break down into a number of areas:

 (0) Dmitry Kasatkin's MPI library patches - which I have not included in this
     posting, but can be obtained from the GIT tree.

 (1) Utility: MPI function exports and make key_serial() handle a const
     pointer.  Also fix a bug in the MPI library.

 (2) PGP defs and PGP packet parser; basic crypto key infrastructure.

 (3) DSA key and RSA key basic implementations.

 (4) PGP signature parser; signature verification operations.

 (5) DSA and RSA verification algorithms.

 (6) Module ELF verification and module signature verification.

The complete crypto type documentation can be found within the GIT tree here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=blob;f=Documentation/security/keys-crypto.txt;h=35e61b1bc636543bc77c0c2a33c3ef323b9f96b5;hb=6eea6dc28e465163611d26112f0ea68ec0e0a0d2

and the module signature verification documentation can be found here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=blob;f=Documentation/module-signing.txt;h=300b91a701818409f37f6065d5f14c5c73ce1b44;hb=20258f1df3a9580a26c5fc5028086bf02d28974d

---
Changes made 29/11/2011:

 (*) Added RSA signature verification.

 (*) Stopped signature verification crashing on unsupported hash algorithm.

 (*) Fixed ENOMEM handling bug in MPI.

 (*) Worked around ccache problems with compilation of PGP public keyring into
     kernel (ccache hashes the preprocessor output, but the assembler includes
     the binary data, so ccache doesn't see that it changed).

 (*) Added a choice in kernel config for hash algorithm to use; forced the
     appropriate crypto module to be built directly into the kernel.

 (*) Cleaned out some debugging code.

 (*) Updated documentation.

David
---
David Howells (16):
      MODSIGN: Apply signature checking to modules on module load
      MODSIGN: Module ELF verifier
      MODSIGN: Add indications of module ELF types
      KEYS: Provide a function to load keys from a PGP keyring blob
      KEYS: Add a crypto key request function
      KEYS: RSA key signature verification
      KEYS: DSA key signature verification
      KEYS: Add signature verification facility
      PGP: Add signature parser
      KEYS: Add a RSA crypto key subtype
      KEYS: Add a DSA crypto key subtype
      KEYS: Create a key type that can be used for general cryptographic operations
      PGP: Add definitions (RFC 4880) and packet parser
      KEYS: Permit key_serial() to be called with a const key pointer
      MPILIB: Add a missing ENOMEM check
      MPILIB: Export some more symbols


 .gitignore                             |   15 +
 Documentation/module-signing.txt       |  186 +++++++
 Documentation/security/keys-crypto.txt |  299 ++++++++++
 Makefile                               |    1 
 arch/alpha/include/asm/module.h        |    3 
 arch/arm/include/asm/module.h          |    5 
 arch/cris/include/asm/module.h         |    5 
 arch/h8300/include/asm/module.h        |    5 
 arch/ia64/include/asm/module.h         |    5 
 arch/m32r/include/asm/module.h         |    5 
 arch/m68k/include/asm/module.h         |    5 
 arch/mips/include/asm/module.h         |   12 
 arch/parisc/include/asm/module.h       |    8 
 arch/powerpc/include/asm/module.h      |   10 
 arch/s390/include/asm/module.h         |    3 
 include/asm-generic/module.h           |   10 
 include/keys/crypto-subtype.h          |   61 ++
 include/keys/crypto-type.h             |   40 +
 include/linux/elfnote.h                |    4 
 include/linux/key.h                    |    2 
 include/linux/modsign.h                |   27 +
 include/linux/module.h                 |    3 
 include/linux/pgp.h                    |  254 +++++++++
 init/Kconfig                           |   62 ++
 kernel/Makefile                        |    4 
 kernel/modsign-pubkey.c                |   44 ++
 kernel/module-verify-elf.c             |  344 ++++++++++++
 kernel/module-verify-sig.c             |  535 +++++++++++++++++++
 kernel/module-verify.c                 |   44 ++
 kernel/module-verify.h                 |   68 ++
 kernel/module.c                        |   25 +
 lib/mpi/mpi-cmp.c                      |    2 
 lib/mpi/mpi-div.c                      |    1 
 lib/mpi/mpi-inv.c                      |    1 
 lib/mpi/mpi-mpow.c                     |    1 
 lib/mpi/mpi-mul.c                      |    1 
 lib/mpi/mpicoder.c                     |    2 
 scripts/Makefile.modpost               |   85 +++
 scripts/mod/.gitignore                 |    1 
 scripts/mod/Makefile                   |    2 
 scripts/mod/mod-extract.c              |  913 ++++++++++++++++++++++++++++++++
 scripts/mod/modsign-note.sh            |   16 +
 security/Kconfig                       |   27 +
 security/keys/Makefile                 |    7 
 security/keys/crypto_dsa.h             |   47 ++
 security/keys/crypto_dsa_subtype.c     |  338 ++++++++++++
 security/keys/crypto_dsa_verify.c      |  384 +++++++++++++
 security/keys/crypto_keys.h            |   21 +
 security/keys/crypto_request.c         |  153 +++++
 security/keys/crypto_rsa.h             |   47 ++
 security/keys/crypto_rsa_subtype.c     |  386 ++++++++++++++
 security/keys/crypto_rsa_verify.c      |  519 ++++++++++++++++++
 security/keys/crypto_type.c            |  315 +++++++++++
 security/keys/crypto_verify.c          |   87 +++
 security/keys/pgp_parse.c              |  528 +++++++++++++++++++
 55 files changed, 5968 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 Documentation/security/keys-crypto.txt
 create mode 100644 include/keys/crypto-subtype.h
 create mode 100644 include/keys/crypto-type.h
 create mode 100644 include/linux/modsign.h
 create mode 100644 include/linux/pgp.h
 create mode 100644 kernel/modsign-pubkey.c
 create mode 100644 kernel/module-verify-elf.c
 create mode 100644 kernel/module-verify-sig.c
 create mode 100644 kernel/module-verify.c
 create mode 100644 kernel/module-verify.h
 create mode 100644 scripts/mod/mod-extract.c
 create mode 100644 scripts/mod/modsign-note.sh
 create mode 100644 security/keys/crypto_dsa.h
 create mode 100644 security/keys/crypto_dsa_subtype.c
 create mode 100644 security/keys/crypto_dsa_verify.c
 create mode 100644 security/keys/crypto_keys.h
 create mode 100644 security/keys/crypto_request.c
 create mode 100644 security/keys/crypto_rsa.h
 create mode 100644 security/keys/crypto_rsa_subtype.c
 create mode 100644 security/keys/crypto_rsa_verify.c
 create mode 100644 security/keys/crypto_type.c
 create mode 100644 security/keys/crypto_verify.c
 create mode 100644 security/keys/pgp_parse.c

