Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2HPBeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab2HPBeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:34:22 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/25] Crypto keys and module signing
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:34:05 +0100
Message-ID: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rusty,

I've posted new versions of my module signing patches to my GIT trees.

The patches with (approximately) your preferred way of attaching the signature
can be found here and I've followed this message with them:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign-rusty

And using an ELF note can be found here:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/modsign

A slightly older version of the latter patches are being used in Fedora 18 and
Rawhide kernels.  I'm still doing some development on them to get X.509 and
PKCS#7 working with module signing for UEFI purposes.

If you look here, you can find most of an X.509 key parser:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel-x509

I'm also working on a PKCS#7 signature parser and have a chunk of it working,
though it's not ready for release yet.  At the moment, I can add X.509
certificates as public keys like so:

	keyctl padd crypto "" @s </tmp/x509.cert

giving something like:

	102492b2 I--Q---     1 perm 39390000     0     0 crypto    bfbc0cd76d050ea4:/C=GB/L=Cambridge/O=Red Hat/CN=kernel key: X509.RSA 0c688c7b []

David
---

Changes made 16/08/2012:

 (*) Improvements for key handling:

     - Made it possible to pre-parse a payload blob without locks held.
     - Made it possible for a key to name itself if the adder doesn't give a
       description.
     - Preloaded keys are now named from their contents.

 (*) Fixes for the PGP/keys handling parts:
     
     - Put the signature parsers onto their own list, separate from the key
       parsers.  This makes PKCS#7 simpler.
     - Don't crash in RSA if given an unsupported digest type.
     - Various compile fixes [Thanks to Fengguang Wu].
     - Reverted a removal of a piece of MPILIB for a required check in the RSA
       algorithm as used from PGP.

 (*) Generalised asm/module.h.  Created Kconfig keys for the REL/RELA choice.

 (*) Fixes for testing in Fedora:

     - Adjusted the module signing policy to permit modules with unknown keys
       if we permit unsigned modules.

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
      KEYS: Provide PGP key description autogeneration
      KEYS: PGP format signature parser
      KEYS: PGP-based public key signature verification
      KEYS: PGP data parser
      PGPLIB: Signature parser
      PGPLIB: Basic packet parser
      PGPLIB: PGP definitions (RFC 4880)
      KEYS: RSA: Fix signature verification for shorter signatures
      KEYS: RSA: Implement signature verification algorithm [PKCS#1 / RFC3447]
      MPILIB: Reinstate mpi_cmp[_ui]() and export for RSA signature verification
      KEYS: Asymmetric public-key algorithm crypto key subtype
      KEYS: Add signature verification facility
      KEYS: Create a key type that can be used for general cryptographic operations
      MPILIB: Provide count_leading/trailing_zeros() based on arch functions
      KEYS: Add payload preparsing opportunity prior to key instantiate or update

Josh Boyer (1):
      MODSIGN: Allow modules to be signed with an unknown key unless enforcing

Peter Jones (1):
      MODSIGN: Fix documentation of signed-nokey behavior when not enforcing.


 .gitignore                               |   13 +
 Documentation/module-signing.txt         |  183 ++++++++++
 Documentation/security/keys-crypto.txt   |  301 ++++++++++++++++
 Documentation/security/keys.txt          |   50 +++
 Makefile                                 |    1 
 fs/cifs/cifs_spnego.c                    |    6 
 fs/cifs/cifsacl.c                        |    8 
 include/asm-generic/bitops/count_zeros.h |   57 +++
 include/keys/crypto-subtype.h            |   89 +++++
 include/keys/crypto-type.h               |   37 ++
 include/keys/user-type.h                 |    6 
 include/linux/key-type.h                 |   35 ++
 include/linux/modsign.h                  |   27 +
 include/linux/module.h                   |    3 
 include/linux/pgp.h                      |  206 +++++++++++
 include/linux/pgplib.h                   |   72 ++++
 init/Kconfig                             |   62 +++
 kernel/Makefile                          |   42 ++
 kernel/modsign-pubkey.c                  |   74 ++++
 kernel/module-verify.c                   |  148 ++++++++
 kernel/module-verify.h                   |   20 +
 kernel/module.c                          |   26 +
 lib/mpi/Makefile                         |    1 
 lib/mpi/longlong.h                       |  138 --------
 lib/mpi/mpi-bit.c                        |    2 
 lib/mpi/mpi-cmp.c                        |   70 ++++
 lib/mpi/mpi-pow.c                        |    4 
 net/ceph/crypto.c                        |    9 
 net/dns_resolver/dns_key.c               |    6 
 net/rxrpc/ar-key.c                       |   40 +-
 scripts/Makefile.modpost                 |   99 +++++
 security/keys/Kconfig                    |    2 
 security/keys/Makefile                   |    1 
 security/keys/crypto/Kconfig             |   51 +++
 security/keys/crypto/Makefile            |   17 +
 security/keys/crypto/crypto_keys.h       |   27 +
 security/keys/crypto/crypto_rsa.c        |  275 +++++++++++++++
 security/keys/crypto/crypto_type.c       |  272 +++++++++++++++
 security/keys/crypto/crypto_verify.c     |  159 +++++++++
 security/keys/crypto/pgp_library.c       |  548 ++++++++++++++++++++++++++++++
 security/keys/crypto/pgp_parser.h        |   29 ++
 security/keys/crypto/pgp_preload.c       |  115 ++++++
 security/keys/crypto/pgp_public_key.c    |  386 +++++++++++++++++++++
 security/keys/crypto/pgp_sig_parser.c    |  136 +++++++
 security/keys/crypto/pgp_sig_verify.c    |  325 ++++++++++++++++++
 security/keys/crypto/public_key.c        |   82 ++++
 security/keys/crypto/public_key.h        |  125 +++++++
 security/keys/encrypted-keys/encrypted.c |   16 -
 security/keys/key.c                      |  108 ++++--
 security/keys/keyctl.c                   |   18 +
 security/keys/keyring.c                  |    6 
 security/keys/request_key_auth.c         |    8 
 security/keys/trusted.c                  |   16 -
 security/keys/user_defined.c             |   14 -
 54 files changed, 4325 insertions(+), 246 deletions(-)
 create mode 100644 Documentation/module-signing.txt
 create mode 100644 Documentation/security/keys-crypto.txt
 create mode 100644 include/asm-generic/bitops/count_zeros.h
 create mode 100644 include/keys/crypto-subtype.h
 create mode 100644 include/keys/crypto-type.h
 create mode 100644 include/linux/modsign.h
 create mode 100644 include/linux/pgp.h
 create mode 100644 include/linux/pgplib.h
 create mode 100644 kernel/modsign-pubkey.c
 create mode 100644 kernel/module-verify.c
 create mode 100644 kernel/module-verify.h
 create mode 100644 lib/mpi/mpi-cmp.c
 create mode 100644 security/keys/crypto/Kconfig
 create mode 100644 security/keys/crypto/Makefile
 create mode 100644 security/keys/crypto/crypto_keys.h
 create mode 100644 security/keys/crypto/crypto_rsa.c
 create mode 100644 security/keys/crypto/crypto_type.c
 create mode 100644 security/keys/crypto/crypto_verify.c
 create mode 100644 security/keys/crypto/pgp_library.c
 create mode 100644 security/keys/crypto/pgp_parser.h
 create mode 100644 security/keys/crypto/pgp_preload.c
 create mode 100644 security/keys/crypto/pgp_public_key.c
 create mode 100644 security/keys/crypto/pgp_sig_parser.c
 create mode 100644 security/keys/crypto/pgp_sig_verify.c
 create mode 100644 security/keys/crypto/public_key.c
 create mode 100644 security/keys/crypto/public_key.h

