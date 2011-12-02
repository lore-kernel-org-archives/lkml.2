Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1LBSmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:42:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab1LBSmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:42:42 -0500
From: David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 00/21] Crypto keys and module signing [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Date: Fri, 02 Dec 2011 18:42:30 +0000
Message-ID: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
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

[!!Note I've changed the architecture of this quite a lot.  See the changelog
 below.]

The basic crypto key has no requirements as to how the key is implemented; it's
basically an anchor for any relevant data.  The crypto key also uses
registerable data parsers that are used to extract information from key blobs
and signature blobs and from that construct keys and determine signature
verification contexts, thus connecting everything together.

I have provided an asymmetric public-key subtype with a couple of public-key
algorithms (DSA and RSA).  These provide signature verification facilities only
at this time.  The public-key subtype defines a structure for storing key data
that is useful to both algorithms.

I have provided a PGP parser that can take PGP key blobs and PGP signatures and
set up public-key subtype keys and orchestrate signature verification using the
public key algorithms.

Iit would be possible to merely refer to keys held in a hardware keystore (such
as a TPM) and have the parser and subtype offload the actual work to that
keystore to be done in hardware.

With kernel module signing enabled, and a pair of keys (one RSA, one DSA)
compiled into the kernel, root can see these keys and the keyring that holds
them in /proc/keys:

195fa736 I-----     1 perm 3f010000     0     0 crypto    modsign.1: DSA 5acc2142 []
335ab517 I-----     1 perm 1f030000     0     0 keyring   .module_sign: 2/4
38d7d169 I-----     1 perm 3f010000     0     0 crypto    modsign.0: RSA 57532ca5 []

Module signing combinations that have been tested: DSA with SHA1 and RSA with
all the SHA algorithms.

The patches break down into a number of areas:

 (0) Dmitry Kasatkin's MPI library patches - which I have not included in this
     posting, but can be obtained from the GIT tree.

 (1) MPI library alterations.

 (2) Some small key-handling core code changes to make things easier.

 (3) Crypto key type: key handling and verification access functions.

 (4) Public key subtype and DSA and RSA algorithms.

 (5) PGP definitions and parsing utilities library.

 (6) PGP data parser for key blobs and signature blobs.

 (7) PGP key preloader for module signing to use.

 (6) Module ELF verification and module signature verification.

The complete crypto type documentation can be found within the GIT tree here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=blob;f=Documentation/security/keys-crypto.txt;h=ba2ab554fafc6db194448fd6791ba26874d60e53;hb=9f4ee2281ca85f32be544bbe5b196baa7562a090

and the module signature verification documentation can be found here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=blob;f=Documentation/module-signing.txt;h=300b91a701818409f37f6065d5f14c5c73ce1b44;hb=601655221b69072a2bbb8371df09b16892d9c261

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

Changes made 02/12/2011:

 (*) Completely overhauled the architecture.

     - Introduced data parsers.
     - Reduced subtype to cryptographic data carrier.
     - Extracted out the common PGP bits of DSA and RSA algorithms.
     - Defined an asymmetric public-key subtype.
     - Reduced DSA and RSA algorithms to minimum.
     - Rolled verification initiation and key selection together into one.
     - Moved verification add_data/finish/cancel op pointers into verification
       context.

David
---
David Howells (21):
      MODSIGN: Apply signature checking to modules on module load
      MODSIGN: Module ELF verifier
      MODSIGN: Add indications of module ELF types
      KEYS: Provide a function to load keys from a PGP keyring blob
      KEYS: PGP format signature parser
      KEYS: PGP-based public key signature verification
      KEYS: PGP data parser
      PGPLIB: Signature parser
      PGPLIB: Basic packet parser
      PGPLIB: PGP definitions (RFC 4880)
      KEYS: RSA signature verification algorithm
      KEYS: DSA signature verification algorithm
      KEYS: Asymmetric public-key algorithm crypto key subtype
      KEYS: Add signature verification facility
      KEYS: Create a key type that can be used for general cryptographic operations
      KEYS: Reorganise keys Makefile
      KEYS: Announce key type (un)registration
      KEYS: Move the key config into security/keys/Kconfig
      KEYS: Permit key_serial() to be called with a const key pointer
      MPILIB: Add a missing ENOMEM check
      MPILIB: Export some more symbols


 .gitignore                             |   15 +
 Documentation/module-signing.txt       |  186 +++++++
 Documentation/security/keys-crypto.txt |  302 +++++++++++
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
 include/keys/crypto-subtype.h          |   77 +++
 include/keys/crypto-type.h             |   37 +
 include/linux/elfnote.h                |    4 
 include/linux/key.h                    |    2 
 include/linux/modsign.h                |   27 +
 include/linux/module.h                 |    3 
 include/linux/pgp.h                    |  255 +++++++++
 init/Kconfig                           |   65 ++
 kernel/Makefile                        |    4 
 kernel/modsign-pubkey.c                |   44 ++
 kernel/module-verify-elf.c             |  344 ++++++++++++
 kernel/module-verify-sig.c             |  526 ++++++++++++++++++
 kernel/module-verify.c                 |   44 ++
 kernel/module-verify.h                 |   68 ++
 kernel/module.c                        |   25 +
 lib/mpi/mpi-cmp.c                      |    2 
 lib/mpi/mpi-div.c                      |    1 
 lib/mpi/mpi-inv.c                      |    1 
 lib/mpi/mpi-mpow.c                     |    1 
 lib/mpi/mpi-mul.c                      |    1 
 lib/mpi/mpicoder.c                     |    2 
 net/dns_resolver/dns_key.c             |    5 
 scripts/Makefile.modpost               |   85 +++
 scripts/mod/.gitignore                 |    1 
 scripts/mod/Makefile                   |    2 
 scripts/mod/mod-extract.c              |  913 ++++++++++++++++++++++++++++++++
 scripts/mod/modsign-note.sh            |   16 +
 security/Kconfig                       |   68 --
 security/keys/Kconfig                  |  128 ++++
 security/keys/Makefile                 |   26 +
 security/keys/crypto_dsa.c             |  126 ++++
 security/keys/crypto_keys.h            |   28 +
 security/keys/crypto_rsa.c             |  282 ++++++++++
 security/keys/crypto_type.c            |  230 ++++++++
 security/keys/crypto_verify.c          |  111 ++++
 security/keys/key.c                    |    3 
 security/keys/pgp_key_parser.c         |  343 ++++++++++++
 security/keys/pgp_library.c            |  531 +++++++++++++++++++
 security/keys/pgp_parser.h             |   35 +
 security/keys/pgp_preload.c            |   90 +++
 security/keys/pgp_pubkey_sig.c         |  323 +++++++++++
 security/keys/pgp_sig_parser.c         |  104 ++++
 security/keys/public_key.c             |   55 ++
 security/keys/public_key.h             |  109 ++++
 60 files changed, 5642 insertions(+), 85 deletions(-)
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
 create mode 100644 security/keys/Kconfig
 create mode 100644 security/keys/crypto_dsa.c
 create mode 100644 security/keys/crypto_keys.h
 create mode 100644 security/keys/crypto_rsa.c
 create mode 100644 security/keys/crypto_type.c
 create mode 100644 security/keys/crypto_verify.c
 create mode 100644 security/keys/pgp_key_parser.c
 create mode 100644 security/keys/pgp_library.c
 create mode 100644 security/keys/pgp_parser.h
 create mode 100644 security/keys/pgp_preload.c
 create mode 100644 security/keys/pgp_pubkey_sig.c
 create mode 100644 security/keys/pgp_sig_parser.c
 create mode 100644 security/keys/public_key.c
 create mode 100644 security/keys/public_key.h

