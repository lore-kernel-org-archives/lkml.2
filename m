Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab1K1Q2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:28:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1K1Q22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:28:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: [PATCH 00/14][RFC] Crypto keys and module signing
In-Reply-To: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
References: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
Date: Mon, 28 Nov 2011 16:27:53 +0000
Message-ID: <8668.1322497673@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are a set of patches that create a framework for using cryptographic keys
within the kernel.  The basic crypto key has no requirements as to how the key
is implemented; it's basically a jump table for the operations and an anchor
for any relevant data.

I have provided a couple of subtypes: DSA and RSA.  The DSA type has signature
verification facilities available within the kernel, and is used for module
signature verification.

These two subtypes store their public key data attached to the key and
implement the algorithms within the kernel.  However, it would be possible to
merely refer to keys held in a hardware keystore (such as a TPM) and have the
accessor methods offload the actual work to that keystore to be done in
hardware.


The patches break down into a number of areas:

 (0) Dmitry Kasatkin's MPI library patches - which I have not included here
     but that can be obtained from the security GIT tree.

 (1) Utility: MPI function exports and make key_serial() handle a const pointer.

 (2) PGP defs and PGP packet parser; basic crypto key infrastructure.

 (3) DSA key and RSA key basic implementations.

 (4) PGP signature parser; signature verification operations.

 (5) DSA verification algorithm.

 (6) Module ELF verification and module signature verification.

I have included the documentation for the crypto key type below.

David

---
			    ======================
			    CRYPTOGRAPHIC KEY TYPE
			    ======================

Contents:

  - Overview.
  - Key identification.
  - Crypto subtypes.
  - Accessing crypto keys.
    - Signature verification.
    - Initial pgp key loading.
  - Implementing crypto subtypes.
    - Registration.


========
OVERVIEW
========

The "crypto" key type is designed to be a container for cryptographic keys,
without imposing any particular restrictions on the form of the cryptography or
the key.

The crypto key is given a subtype that defines what sort of data is associated
with the key and what operations might be performed with it.  However, no
requirement is made that the key data actually be loaded into the key or that
the operations are done by the kernel.

For instance, cryptographic hardware (such as a TPM) might be used to both
retain the relevant key and provide operations using that key.  In such a case,
the crypto key would then merely be an interface to the TPM driver.


==================
KEY IDENTIFICATION
==================

Because the identity of a key is not necessarily known or is not easily
calculated when a crypto key is allocated, it may not be a simple matter to set
a key description to something that's useful for determining whether this is
the key you're looking for.  Furthermore, it may be necessary to perform a
partial match upon the key identity.

To help with this, when a key is loaded, the key subtype's instantiation
routine calculates the key fingerprint and stores a copy in the key struct.

The crypto key type's key matching function then performs more checks than just
the straightforward comparison of the description with the criterion string:

 (1) If the criterion string is of the form "id:<hexdigits>" then the match
     function will examine a key's fingerprint to see if the hex digits given
     after the "id:" match the tail.  For instance:

	keyctl search @s crypto id:5acc2142

     will match a key with fingerprint:

	1A00 2040 7601 7889 DE11  882C 3823 04AD 5ACC 2142

 (2) If the criterion string is of the form "<subtype>:<hexdigits>" then the
     match will match the ID as in (1), but with the added restriction that
     only keys of the specified subtype (e.g. dsa or rsa) will be matched.  For
     instance:

	keyctl search @s crypto dsa:5acc2142

Looking in /proc/keys, the last 8 hex digits of the key fingerprint are
displayed, along with the subtype:

	1a39e171 I-----     1 perm 3f010000     0     0 crypto    modsign.0: dsa 5acc2142 []


===============
CRYPTO SUBTYPES
===============

The crypto key is just a simple container.  It contains no data of its own and
does very little except provide a place to hang a function pointer table.  The
key subtype does the actual work.

When a crypto key is instantiated, it looks through its list of registered
subtypes to try and find one that can handle the data blob it is given.  If the
data blob begins with a byte with the top bit set, it is assumed to be a PGP
packet format blob [RFC 4880] and is treated so.  The blob is parsed to find a
PGP key, and then a subtype is looked for that says it can handle the
appropriate algorithm type.


=====================
ACCESSING CRYPTO KEYS
=====================

To access crypto keys from within the kernel, the following inclusion is
required:

	#include <keys/crypto-type.h>

This gives access to the key type:

	struct key_type key_type_crypto;


SIGNATURE VERIFICATION
----------------------

The four operations that can perform cryptographic signature verification,
using a key to provide the public key:

 (1) Begin verification procedure.

	struct crypto_key_verify_context *
	verify_sig_begin(struct key *key, const void *sig, size_t siglen);

     This function sets up a verification context from the specified key and
     the signature blob.  The signature blob must be presented again at the end
     of the procedure.  The key is checked against parameters in the signature,
     and if it's not the right key then an error will be given.

     If such a thing applies, the hashing algorithm, will be extracted from the
     signature and the appropriate crypto module will be used.  -ENOPKG will be
     returned if the hash algorithm is unavailable.

     The return value is an opaque pointer to be passed to the other functions,
     or a negative error code.

 (2) Indicate data to be verified.

	int verify_sig_add_data(struct crypto_key_verify_context *ctx,
				const void *data, size_t datalen);

     This function is used to shovel data to the verification procedure so that
     it can load it into the hash, pass it to hardware or whatever is
     appropriate for the algorithm being employed.

     The data is not canonicalised for the document type specified in the
     signature.  The caller must do that.

     It will return 0 if successful and a negative error code if not.

 (3) Complete the verification process.

	int verify_sig_end(struct crypto_key_verify_context *ctx,
			   const void *sig, size_t siglen);

     This function performs the actual signature verification step and cleans
     up the resources allocated at the beginning.  The signature must be
     presented again as some of the data therein may need to be added to the
     internal hash.

     It will return -EKEYREJECTED if the signature didn't match, 0 if
     successful and may return other errors as appropriate.

 (4) Cancel the verification process.

	void verify_sig_cancel(struct crypto_key_verify_context *ctx);

     This function cleans up the resources allocated at the beginning.  This is
     not necessary if verify_sig_end() was called.


To find a key to use for signature verification, the following function may be
called:

	struct key *request_crypto_key_for_PGP_sig(struct key *keyring,
						  const u8 *sig, size_t siglen);

This parses the specified signature blob to find the signing key identity and
then searches the given keyring for a matching key.  It may also examine a
hardware keystore (such as a TPM) for a usable signature matching service and
generate a key to provide an access method to that service.


INITIAL PGP KEY LOADING
-----------------------

A function is provided to perform an initial load of a set of public keys bound
into a PGP keyring blob:

	int load_PGP_keys(const u8 *pgpdata, size_t pgpdatalen,
			  struct key *keyring, const char *descprefix);

This takes the blob of data defined by pgpdata and pgpdatalen, extracts keys
from them and adds them to the specified keyring.  The keys are labelled with
descprefix plus a simple uniquifier - it is not expected that the description
will be used to identify the key.  The description is required to prevent all
but the last key being discarded when the keys are linked into the keyring.

This function is only available during initial kernel set up.


============================
IMPLEMENTING CRYPTO SUBTYPES
============================

Each subtype is specified through a definition structure:

	struct crypto_key_subtype {
		struct module		*owner;
		const char		*name;
		enum pgp_pubkey_algo	pubkey_algo : 8;
		unsigned short		info;

		int (*instantiate)(struct key *key,
				   const void *data, size_t datalen);

		void (*revoke)(struct key *key);
		void (*destroy)(struct key *key);

		struct crypto_key_verify_context *(*verify_sig_begin)(
			struct key *key, const u8 *sig, size_t siglen);
		int (*verify_sig_add_data)(struct crypto_key_verify_context *ctx,
					   const void *data, size_t datalen);
		int (*verify_sig_end)(struct crypto_key_verify_context *ctx,
				      const u8 *sig, size_t siglen);
		void (*verify_sig_cancel)(struct crypto_key_verify_context *ctx);
	};

The owner and name fields should be set to the owning module and the name of
the subtype.

If the subtype represents a PGP public key algorithm the info field should have
CRYPTO_KEY_IS_PUBKEY_ALGO OR'd into it and pubkey_algo should be set to the
appropriate PGP_PUBKEY_ constant from the enumeration in <linux/pgp.h>.


There are a number of operations defined by the subtype.  The first few are for
management of the key itself:

 (1) instantiate().

     Mandatory.  When the subtype is selected, the instantiate() method will be
     given the key being instantiated and the data blob.  If the first byte of
     the data blob has bit 7 set, then it's a PGP packet blob and can be parsed
     with the routines declared in <linux/pgp.h>.

     If the key has a fingerprint or other auxiliary identifier, this should be
     determined or calculated and a copy attached to key->type_data.p[1].

     If successful, the subtype must set key->type_data.p[0] to point to its
     definition.

     The subtype may use key->payload in anyway it sees fit.

 (2) revoke().

     Optional.  Notification that the key has been revoked.  This provides the
     subtype the opportunity to discard some memory, but care should be taken
     as the key may be in use when this is called.

 (3) destroy().

     Mandatory.  key->type_data.p[0] is cleared by the caller and the module
     usage will be decremented upon return.  The memory pointed to by
     key->type_data.[1] will be freed after this method returns.  This method
     must free whatever key->payload refers to.


There are then sets of method pointers to actually use the key for things:

 (*) Signature verification

     Then there are functions to verify a signature using the public key stored in
     this key:

	(1) verify_sig_begin().
	(2) verify_sig_add_data().
	(3) verify_sig_end().
	(4) verify_sig_cancel().

     These correspond to the accessor functions mentioned in the previous
     section.  The first function is optional - if it is not provided, then
     verification is not a service available with this key.  The other three
     are mandatory if the first is supplied and unnecessary otherwise.

     The subtype should allocate a context in ->verify_sig_begin() and embed
     the following struct in it:

	struct crypto_key_verify_context {
		struct key *key;
	};

     A pointer to this struct is then returned to the caller.  This is used by
     the master routines to route the operations to the right place.  This is
     passed to the _add_data, _end and _cancel routines - which should use
     container_of() on it to get the full context.


REGISTRATION
------------

Functions are provided to register and unregister key subtypes:

	int register_crypto_key_subtype(struct crypto_key_subtype *subtype);
	void unregister_crypto_key_subtype(struct crypto_key_subtype *subtype);

Key subtypes may have the same name, provided they differ in some other
criterion, such as the public key algorithm ID.  This makes it possible to
handle algorithms such as RSA that have multiple algorithm IDs.
