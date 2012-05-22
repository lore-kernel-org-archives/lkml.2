Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab2EVXCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:02:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab2EVXCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:02:33 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/23] Crypto keys and module signing
To: rusty@rustcorp.com.au, kyle@mcmartin.ca
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Date: Wed, 23 May 2012 00:02:19 +0100
Message-ID: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay Rusty,

Here's a set of patches that does module signing attaching the signature in the
way you wanted.  I do not agree with doing it this way.  However, as you
insisted rather forcefully...


===============
<<< WARNING >>>
===============

    Anyone wanting to use the module signing facility contained in these
    patches MUST FIRST make sure that modules are not stripped after being
    signed.  This includes by packaging systems (such as rpmbuild) extracting
    debug information and due to size reduction for initramfs composition.

    This is likely to require alterations to userspace packages, both on the
    build machine and the installed machine.

    If the module is passed through strip, but the signature is _not_
    discarded, then the module load will be rejected, potentially resulting in
    an unbootable machine.  If you are in FIPS mode the kernel will panic.

To make the modules more usable from an initramfs (which may have limited
capacity), the module files are maximally stripped (by both strip -x -g and
eu-strip) before being signed.  This appears to result in the smallest,
still-viable module possible.

However, all debug information is discarded, along with chunks of the symbol
and string tables that might otherwise be useful.  An unstripped, unsigned copy
of the module is left in the build tree (called foo.ko.unsigned) that should be
usable for debugging purposes.

The extended module file format is as follows:

  The module signature is appended to the end of the module file, followed by
  "@mod_size@\n@sig_size@\nThis Is A Crypto Signed Module".

  The EOF must follow the magic string directly, so nothing further must be
  appended to the file.

  mod_size and sig_size are left-aligned decimal numbers, space-padded to 8
  characters.  mod_size is the size of the module payload part of the file and
  sig_size is the size of the signature blob.


Note the first patch is a bugfix to kernel/module.c (look for "Guard check in
module loader against integer overflow").

The patches can also be found here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-rusty

David
---

Changes made 22/05/2012:

 (*) Fixes for the PGP/keys handling parts:

     - Fix some checkpatch noise [Thanks to Tetsuo Handa].
     - Preclear array on stack [Thanks to Tetsuo Handa].
     - Check (sub)packet length [Thanks to Stephan Mueller].
     - Decrease (not increase) remnant length in signature parsing.
     - Handle new-format 5-octet length encoding.
     - Better report encounter of Partial Body Length spec.
     - Adjust the error handling.

 (*) Completely redo how signature is attached to the module file to comply
     with Rusty's specified method.  Also pre-strip modules.

 (*) Drop the MPILIB extra-exports patch as it's only required for the DSA
     algorithm.

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
David Howells (23):
      MODSIGN: Panic the kernel if FIPS is enabled upon module signing failure
      MODSIGN: Automatically generate module signing keys if missing
      MODSIGN: Module signature verification
      MODSIGN: Provide module signing public keys to the kernel
      MODSIGN: Sign modules during the build process
      MODSIGN: Provide Documentation and Kconfig options
      MODSIGN: Provide gitignore and make clean rules for extra files
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
      Guard check in module loader against integer overflow


 .gitignore                             |   13 +
 Documentation/module-signing.txt       |  183 +++++++++++
 Documentation/security/keys-crypto.txt |  302 ++++++++++++++++++
 Makefile                               |    1 
 include/keys/crypto-subtype.h          |   77 ++++
 include/keys/crypto-type.h             |   37 ++
 include/linux/modsign.h                |   27 ++
 include/linux/module.h                 |    3 
 include/linux/pgp.h                    |  255 +++++++++++++++
 init/Kconfig                           |   62 ++++
 kernel/Makefile                        |   42 ++
 kernel/modsign-pubkey.c                |   74 ++++
 kernel/module-verify.c                 |  153 +++++++++
 kernel/module-verify.h                 |   20 +
 kernel/module.c                        |   29 +-
 net/dns_resolver/dns_key.c             |    5 
 scripts/Makefile.modpost               |   98 ++++++
 security/Kconfig                       |   68 ----
 security/keys/Kconfig                  |   73 ++++
 security/keys/Makefile                 |   13 +
 security/keys/crypto/Kconfig           |   51 +++
 security/keys/crypto/Makefile          |   17 +
 security/keys/crypto/crypto_keys.h     |   28 ++
 security/keys/crypto/crypto_rsa.c      |  290 +++++++++++++++++
 security/keys/crypto/crypto_type.c     |  228 +++++++++++++
 security/keys/crypto/crypto_verify.c   |  111 ++++++
 security/keys/crypto/pgp_key_parser.c  |  347 ++++++++++++++++++++
 security/keys/crypto/pgp_library.c     |  550 ++++++++++++++++++++++++++++++++
 security/keys/crypto/pgp_parser.h      |   35 ++
 security/keys/crypto/pgp_preload.c     |   90 +++++
 security/keys/crypto/pgp_pubkey_sig.c  |  324 +++++++++++++++++++
 security/keys/crypto/pgp_sig_parser.c  |  113 +++++++
 security/keys/crypto/public_key.c      |   55 +++
 security/keys/crypto/public_key.h      |  108 ++++++
 security/keys/key.c                    |    3 
 35 files changed, 3803 insertions(+), 82 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 Documentation/security/keys-crypto.txt
 create mode 100644 include/keys/crypto-subtype.h
 create mode 100644 include/keys/crypto-type.h
 create mode 100644 include/linux/modsign.h
 create mode 100644 include/linux/pgp.h
 create mode 100644 kernel/modsign-pubkey.c
 create mode 100644 kernel/module-verify.c
 create mode 100644 kernel/module-verify.h
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

