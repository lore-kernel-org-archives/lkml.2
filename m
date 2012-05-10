Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab2EJXjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932836Ab2EJXjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:39:18 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/29] Crypto keys and module signing [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Date: Fri, 11 May 2012 00:39:01 +0100
Message-ID: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rusty,

Here's my latest take on my module signing patch set.  I've retained my
strip-proof[*] signature-in-module concept, but I've shrunk the module
verification code by nearly half.  Its .text segment now stands at just over 2K
in size for an x86_64 kernel.

There were a lot of redundant tests, either redundant due to other tests, or
redundant due to the data being tested also being added to the digest before
being used.  Also rearranging things helped - and gcc's optimiser doesn't
always make good decisions, particularly when deciding whether to inline large
functions:-/.  I've tried to better comment/describe where I've found a
redundancy.

I think that a further reduction in size could probably be achieved by
combining the ELF checks with the layout code in kernel/module.c - but then it
is mandatory to perform the checks.

Note there is a patch in there (look for "Guard check in module loader against
integer overflow") that is a bugfix to kernel/module.c.

Can you please consider applying these patches?

David

[*] Not proof against strip or strip -s which totally break the module by
    removing the symbol table entirely, but proof against strip -g, strip -x
    and eu-strip.

---

Here are a set of patches that create a framework for using cryptographic keys
within the kernel.  The patches can also be found at:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign

The basic crypto key has no requirements as to how the key is implemented; it's
an anchor for any relevant data.  The crypto key uses registerable data parsers
that are used to extract information from key blobs and signature blobs and
from that construct keys and determine signature verification contexts, thus
connecting everything together.

I have provided an asymmetric public-key subtype with one public-key algorithm
(RSA).  This only provides signature verification facilities at this time.  The
public-key subtype defines a structure for storing key data that is useful to
this algorithm and to DSA, should it be added.

I have provided a PGP parser that can take PGP key blobs and PGP signatures,
set up public-key subtype keys and orchestrate signature verification using the
public key algorithms.

It would be possible to merely refer to keys held in a hardware keystore (such
as a TPM) and have the parser and subtype offload the actual work to that
keystore to be done in hardware.

With kernel module signing enabled, and a pair of keys (one RSA, one DSA)
compiled into the kernel, root can see these keys and the keyring that holds
them in /proc/keys:

195fa736 I-----     1 perm 3f010000     0     0 crypto    modsign.1: DSA 5acc2142 []
335ab517 I-----     1 perm 1f030000     0     0 keyring   .module_sign: 2/4
38d7d169 I-----     1 perm 3f010000     0     0 crypto    modsign.0: RSA 57532ca5 []

Module signing combinations that have been tested: RSA with all the SHA
algorithms.  I have a patch (not included here) that does DSA too, and that has
been tested with SHA-1.

The patches break down into a number of areas:

 (1) MPI library alterations.

 (2) Some small key-handling core code changes to make things easier.

 (3) Crypto key type: key handling and verification access functions.

 (4) Public key subtype and RSA algorithm.

 (5) PGP definitions and parsing utilities library.

 (6) PGP data parser for key blobs and signature blobs.

 (7) PGP key preloader for module signing to use.

 (8) A pair of macros for providing ELF note name wrappers.

 (9) A fix for the core module code to handle an integer overflow in a check.

(10) Module ELF verification and module signature verification.

The complete crypto type documentation can be found within the GIT tree here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=blob;f=Documentation/security/keys-crypto.txt;h=ba2ab554fafc6db194448fd6791ba26874d60e53;hb=958049a9def253735019a5acf19b4c2aeec9f01c
	
and the module signature verification documentation can be found here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=blob;f=Documentation/module-signing.txt;h=d75d47369406f7a6b78aa95926a310fe913e4b8b;hb=958049a9def253735019a5acf19b4c2aeec9f01c

---

Changes made 10/05/2012:

 (*) Overhauled the ELF checking code and module signing code.

     - Moved into one file.
     - Removed a lot of redundant ELF checks, relying a lot on the signature to
       catch stuff.
     - Rearranged the ELF checker function.
     - Commented thoroughly and documented things better in the commit messages.
     - Made it possible to exclude REL or RELA relocation handling.
     - Rearranged the modsign patch subset to be more logical.
     - Massively reduced the code size.

 (*) Applied a patch to handle short signatures.

 (*) Fixed a potential overflow in a check in the core module code.

Changes made 07/12/2011:

 (*) Dropped the DSA algorithm.

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

---
David Howells (29):
      MODSIGN: Suppress some redundant ELF checks
      MODSIGN: Automatically generate module signing keys if missing
      MODSIGN: Create digest of module content and check signature
      MODSIGN: Produce a filtered and canonicalised section list
      MODSIGN: Check the ELF container
      MODSIGN: Provide module signing public keys to the kernel
      MODSIGN: Module signature verification stub
      MODSIGN: Sign modules during the build process
      MODSIGN: Provide Documentation and Kconfig options
      MODSIGN: Provide gitignore and make clean rules for extra files
      MODSIGN: Add indications of module ELF types
      Guard check in module loader against integer overflow
      Provide macros for forming the name of an ELF note and its section
      KEYS: Provide a function to load keys from a PGP keyring blob
      KEYS: PGP format signature parser
      KEYS: PGP-based public key signature verification
      KEYS: PGP data parser
      PGPLIB: Signature parser
      PGPLIB: Basic packet parser
      PGPLIB: PGP definitions (RFC 4880)
      Fix signature verification for shorter signatures
      KEYS: RSA signature verification algorithm
      KEYS: Asymmetric public-key algorithm crypto key subtype
      KEYS: Add signature verification facility
      KEYS: Create a key type that can be used for general cryptographic operations
      KEYS: Reorganise keys Makefile
      KEYS: Announce key type (un)registration
      KEYS: Move the key config into security/keys/Kconfig
      MPILIB: Export some more symbols


 .gitignore                             |   12 
 Documentation/module-signing.txt       |  194 +++++++
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
 arch/x86/include/asm/module.h          |    6 
 include/asm-generic/module.h           |   10 
 include/keys/crypto-subtype.h          |   77 +++
 include/keys/crypto-type.h             |   37 +
 include/linux/elfnote.h                |    4 
 include/linux/modsign.h                |   27 +
 include/linux/module.h                 |    3 
 include/linux/pgp.h                    |  255 +++++++++
 init/Kconfig                           |   53 ++
 kernel/Makefile                        |   42 +
 kernel/modsign-pubkey.c                |   74 +++
 kernel/module-verify-defs.h            |   81 +++
 kernel/module-verify.c                 |  732 ++++++++++++++++++++++++++
 kernel/module-verify.h                 |   19 +
 kernel/module.c                        |   29 +
 lib/mpi/mpi-cmp.c                      |    2 
 lib/mpi/mpi-div.c                      |    1 
 lib/mpi/mpi-inv.c                      |    1 
 lib/mpi/mpi-mpow.c                     |    1 
 lib/mpi/mpi-mul.c                      |    1 
 net/dns_resolver/dns_key.c             |    5 
 scripts/Makefile.modpost               |   87 +++
 scripts/mod/.gitignore                 |    1 
 scripts/mod/Makefile                   |    2 
 scripts/mod/mod-extract.c              |  913 ++++++++++++++++++++++++++++++++
 scripts/mod/modsign-note.sh            |   16 +
 security/Kconfig                       |   68 --
 security/keys/Kconfig                  |   73 +++
 security/keys/Makefile                 |   13 
 security/keys/crypto/Kconfig           |   51 ++
 security/keys/crypto/Makefile          |   17 +
 security/keys/crypto/crypto_keys.h     |   28 +
 security/keys/crypto/crypto_rsa.c      |  290 ++++++++++
 security/keys/crypto/crypto_type.c     |  228 ++++++++
 security/keys/crypto/crypto_verify.c   |  111 ++++
 security/keys/crypto/pgp_key_parser.c  |  344 ++++++++++++
 security/keys/crypto/pgp_library.c     |  531 +++++++++++++++++++
 security/keys/crypto/pgp_parser.h      |   35 +
 security/keys/crypto/pgp_preload.c     |   90 +++
 security/keys/crypto/pgp_pubkey_sig.c  |  323 +++++++++++
 security/keys/crypto/pgp_sig_parser.c  |  104 ++++
 security/keys/crypto/public_key.c      |   55 ++
 security/keys/crypto/public_key.h      |  108 ++++
 security/keys/key.c                    |    3 
 59 files changed, 5441 insertions(+), 85 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 Documentation/security/keys-crypto.txt
 create mode 100644 include/keys/crypto-subtype.h
 create mode 100644 include/keys/crypto-type.h
 create mode 100644 include/linux/modsign.h
 create mode 100644 include/linux/pgp.h
 create mode 100644 kernel/modsign-pubkey.c
 create mode 100644 kernel/module-verify-defs.h
 create mode 100644 kernel/module-verify.c
 create mode 100644 kernel/module-verify.h
 create mode 100644 scripts/mod/mod-extract.c
 create mode 100644 scripts/mod/modsign-note.sh
 create mode 100644 security/keys/Kconfig
 create mode 100644 security/keys/crypto/Kconfig
 create mode 100644 security/keys/crypto/Makefile
 create mode 100644 security/keys/crypto/crypto_keys.h
 create mode 100644 security/keys/crypto/crypto_rsa.c
 create mode 100644 security/keys/crypto/crypto_type.c
 create mode 100644 security/keys/crypto/crypto_verify.c
 create mode 100644 security/keys/crypto/pgp_key_parser.c
 create mode 100644 security/keys/crypto/pgp_library.c
 create mode 100644 security/keys/crypto/pgp_parser.h
 create mode 100644 security/keys/crypto/pgp_preload.c
 create mode 100644 security/keys/crypto/pgp_pubkey_sig.c
 create mode 100644 security/keys/crypto/pgp_sig_parser.c
 create mode 100644 security/keys/crypto/public_key.c
 create mode 100644 security/keys/crypto/public_key.h

