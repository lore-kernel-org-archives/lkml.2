Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037Ab2IMXs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:48:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab2IMXsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:48:24 -0400
From: David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 00/16] Asymmetric / Public-key cryptography key type
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:48:02 +0100
Message-ID: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Herbert, Rusty,

I've redone my crypto keys patches to be more specific, implementing an
asymmetric key type for containing the stuff required for public-key
cryptography and anything else one might want an asymmetric key for.

This facility can be used for module signing, firmware signing and eCryptfs.

The patches can be found here as well as following this covering note:

	http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/crypto-keys-post-KS

I have arranged things such that:

 (1) Keys of the asymmetric key type are just simple containers.  They have
     three attributes:

     (a) A subtype.

     (b) The data for the subtype.  This is entirely defined by the subtype.

     (c) A binary identifier (in addition to the usual text decription) that
     	 can also be used to match the key.

 (2) The asymmetric key subtype provides the mechanism used to operate with the
     key.  The mechanism can be entirely in-kernel, or can be offloaded to
     hardware.

     A completely software subtype is provided that can support a multiplicity
     of public-key algorithms.  One such algorithm is currently provided (RSA).

 (3) Parsers can be registered that can take the instantiation data and turn it
     into a subtype pointer, appropriate subtype data, a binary identifier and
     a proposed description (keys can be auto-described).

     An X.509 certificate parser is provided.  It can be given a certificate
     like this:

	keyctl padd asymmetric "" @s </tmp/x509.cert

     giving something like:

	102492b2 I--Q---     1 perm 39390000     0     0 asymmetri bfbc0cd76d050ea4:/C=GB/L=Cambridge/O=Red Hat/CN=kernel key: X509.RSA 0c688c7b []

     Note that the X.509 parser uses the ASN.1 decoder and fast OID registry
     patches.

     I have dropped the PGP key parser for the moment.

     Parsers can be provided that interpret the instantiation data to be a
     pointer to where the key is actually stored (eg. a hardware key store).
     Examples might be:

	keyctl add asymmetric "" "tpm:bfbc0cd76d050ea4" @s
	keyctl add asymmetric "" "uefi:bfbc0cd76d050ea4" @s

     The parser could then, for example, extract the key from a key store and
     set up for the software subtype or it could use a subtype that offloads
     crypto operations to the hardware.

 (4) The main interface for using it is in include/crypto/public_key.h.
     Currently, there is one operation function provided: verify_signature() -
     it takes a key, the parsed-out signature data and the signed data digest
     and indicates whether the signature is valid or not.

 (5) The sources are under crypto/ rather than security/ as that's a better fit
     for them.

I wonder if I should rename the key type to public_key (rather than
asymmetric).  I'm not sure what else it might be used for.

David
---
David Howells (16):
      X.509: Add a crypto key parser for binary (DER) X.509 certificates
      MPILIB: Provide a function to read raw data into an MPI
      X.509: Add an ASN.1 decoder
      X.509: Add simple ASN.1 grammar compiler
      X.509: Add utility functions to render OIDs as strings
      X.509: Implement simple static OID registry
      RSA: Fix signature verification for shorter signatures
      RSA: Implement signature verification algorithm [PKCS#1 / RFC3447]
      MPILIB: Reinstate mpi_cmp[_ui]() and export for RSA signature verification
      KEYS: Provide signature verification with an asymmetric key
      KEYS: Asymmetric public-key algorithm crypto key subtype
      KEYS: Asymmetric key pluggable data parsers
      KEYS: Implement asymmetric key type
      KEYS: Document asymmetric key type
      MPILIB: Provide count_leading/trailing_zeros() based on arch functions
      KEYS: Add payload preparsing opportunity prior to key instantiate or update


 Documentation/crypto/asymmetric-keys.txt  |  312 ++++++
 Documentation/security/keys.txt           |   50 +
 crypto/Kconfig                            |    1 
 crypto/Makefile                           |    1 
 crypto/asymmetric_keys/.gitignore         |    1 
 crypto/asymmetric_keys/Kconfig            |   38 +
 crypto/asymmetric_keys/Makefile           |   27 +
 crypto/asymmetric_keys/asymmetric_keys.h  |   15 
 crypto/asymmetric_keys/asymmetric_type.c  |  274 +++++
 crypto/asymmetric_keys/public_key.c       |  108 ++
 crypto/asymmetric_keys/public_key.h       |   30 +
 crypto/asymmetric_keys/rsa.c              |  277 +++++
 crypto/asymmetric_keys/signature.c        |   49 +
 crypto/asymmetric_keys/x509.asn1          |   60 +
 crypto/asymmetric_keys/x509_cert_parser.c |  503 +++++++++
 crypto/asymmetric_keys/x509_parser.h      |   37 +
 crypto/asymmetric_keys/x509_public_key.c  |  206 ++++
 crypto/asymmetric_keys/x509_rsakey.asn1   |    4 
 fs/cifs/cifs_spnego.c                     |    6 
 fs/cifs/cifsacl.c                         |    8 
 include/asm-generic/bitops/count_zeros.h  |   57 +
 include/crypto/public_key.h               |  113 ++
 include/keys/asymmetric-parser.h          |   37 +
 include/keys/asymmetric-subtype.h         |   55 +
 include/keys/asymmetric-type.h            |   25 
 include/keys/user-type.h                  |    6 
 include/linux/asn1.h                      |   67 +
 include/linux/asn1_ber_bytecode.h         |   87 ++
 include/linux/asn1_decoder.h              |   24 
 include/linux/key-type.h                  |   35 +
 include/linux/mpi.h                       |    1 
 include/linux/oid_registry.h              |   92 ++
 init/Kconfig                              |    8 
 lib/.gitignore                            |    2 
 lib/Kconfig                               |    5 
 lib/Makefile                              |   18 
 lib/asn1_decoder.c                        |  473 +++++++++
 lib/build_OID_registry                    |  209 ++++
 lib/mpi/Makefile                          |    1 
 lib/mpi/longlong.h                        |  138 ---
 lib/mpi/mpi-bit.c                         |    2 
 lib/mpi/mpi-cmp.c                         |   70 +
 lib/mpi/mpi-pow.c                         |    4 
 lib/mpi/mpicoder.c                        |   55 +
 lib/oid_registry.c                        |  170 +++
 net/ceph/crypto.c                         |    9 
 net/dns_resolver/dns_key.c                |    6 
 net/rxrpc/ar-key.c                        |   40 -
 scripts/.gitignore                        |    1 
 scripts/Makefile                          |    2 
 scripts/Makefile.build                    |   11 
 scripts/asn1_compiler.c                   | 1544 +++++++++++++++++++++++++++++
 security/keys/encrypted-keys/encrypted.c  |   16 
 security/keys/key.c                       |  114 ++
 security/keys/keyctl.c                    |   18 
 security/keys/keyring.c                   |    6 
 security/keys/request_key_auth.c          |    8 
 security/keys/trusted.c                   |   16 
 security/keys/user_defined.c              |   14 
 59 files changed, 5324 insertions(+), 242 deletions(-)
 create mode 100644 Documentation/crypto/asymmetric-keys.txt
 create mode 100644 crypto/asymmetric_keys/.gitignore
 create mode 100644 crypto/asymmetric_keys/Kconfig
 create mode 100644 crypto/asymmetric_keys/Makefile
 create mode 100644 crypto/asymmetric_keys/asymmetric_keys.h
 create mode 100644 crypto/asymmetric_keys/asymmetric_type.c
 create mode 100644 crypto/asymmetric_keys/public_key.c
 create mode 100644 crypto/asymmetric_keys/public_key.h
 create mode 100644 crypto/asymmetric_keys/rsa.c
 create mode 100644 crypto/asymmetric_keys/signature.c
 create mode 100644 crypto/asymmetric_keys/x509.asn1
 create mode 100644 crypto/asymmetric_keys/x509_cert_parser.c
 create mode 100644 crypto/asymmetric_keys/x509_parser.h
 create mode 100644 crypto/asymmetric_keys/x509_public_key.c
 create mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1
 create mode 100644 include/asm-generic/bitops/count_zeros.h
 create mode 100644 include/crypto/public_key.h
 create mode 100644 include/keys/asymmetric-parser.h
 create mode 100644 include/keys/asymmetric-subtype.h
 create mode 100644 include/keys/asymmetric-type.h
 create mode 100644 include/linux/asn1.h
 create mode 100644 include/linux/asn1_ber_bytecode.h
 create mode 100644 include/linux/asn1_decoder.h
 create mode 100644 include/linux/oid_registry.h
 create mode 100644 lib/asn1_decoder.c
 create mode 100755 lib/build_OID_registry
 create mode 100644 lib/mpi/mpi-cmp.c
 create mode 100644 lib/oid_registry.c
 create mode 100644 scripts/asn1_compiler.c

