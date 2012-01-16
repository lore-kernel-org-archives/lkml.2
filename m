Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab2APM4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:56:16 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50603 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2APM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:56:12 -0500
Subject: Re: [PATCH 07/21] KEYS: Create a key type that can be used for
 general cryptographic operations [ver #3]
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Date: Mon, 16 Jan 2012 07:53:13 -0500
In-Reply-To: <20111202184354.21874.57647.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	 <20111202184354.21874.57647.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326718394.2276.1.camel@falcor>
Mime-Version: 1.0
x-cbid: 12011612-3270-0000-0000-0000033DBDDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 18:43 +0000, David Howells wrote:
> Create a key type that can be used for general cryptographic operations, such
> as encryption, decryption, signature generation and signature verification.
> 
> The key type is "crypto" and can provide access to a variety of cryptographic
> algorithms.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Nice! Basically the 'crypto' key type ties crypto/ with security/keys.
Other than the posted pgp key parser used for verifying kernel module
signatures, I assume another use case could be to expose kernel
cryptography to userspace.  As there was a submission
https://lkml.org/lkml/2010/8/20/103 to do just this, there must be
userspace apps that would benefit.  This architecture would address a
number of concerns raised with the prior submission. (Refer to
http://lwn.net/Articles/401548/.)

You'd probably want to move the 'crypto' key type to its own directory.

Acked-by: Mimi Zohar <zohar@us.ibm.com>

thanks,
Mimi

> ---
> 
>  Documentation/security/keys-crypto.txt |  181 +++++++++++++++++++++++++
>  include/keys/crypto-subtype.h          |   56 ++++++++
>  include/keys/crypto-type.h             |   25 +++
>  security/keys/Kconfig                  |    8 +
>  security/keys/Makefile                 |    3 
>  security/keys/crypto_keys.h            |   28 ++++
>  security/keys/crypto_type.c            |  230 ++++++++++++++++++++++++++++++++
>  7 files changed, 531 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/security/keys-crypto.txt
>  create mode 100644 include/keys/crypto-subtype.h
>  create mode 100644 include/keys/crypto-type.h
>  create mode 100644 security/keys/crypto_keys.h
>  create mode 100644 security/keys/crypto_type.c
> 
> 
> diff --git a/Documentation/security/keys-crypto.txt b/Documentation/security/keys-crypto.txt
> new file mode 100644
> index 0000000..97dee80
> --- /dev/null
> +++ b/Documentation/security/keys-crypto.txt
> @@ -0,0 +1,181 @@
> +			    ======================
> +			    CRYPTOGRAPHIC KEY TYPE
> +			    ======================
> +
> +Contents:
> +
> +  - Overview.
> +  - Key identification.
> +  - Accessing crypto keys.
> +  - Implementing crypto parsers.
> +  - Implementing crypto subtypes.
> +
> +
> +========
> +OVERVIEW
> +========
> +
> +The "crypto" key type is designed to be a container for cryptographic keys,
> +without imposing any particular restrictions on the form of the cryptography or
> +the key.
> +
> +The crypto key is given a subtype that defines what sort of data is associated
> +with the key and provides operations to describe and destroy it.  However, no
> +requirement is made that the key data actually be loaded into the key.
> +
> +The crypto key also has a number of data parsers registered with it.  The data
> +parsers are responsible for extracing information the blobs of data passed to
> +the instantiator function.  The first data parser that recognises the blob gets
> +to set the subtype of the key and define the operations that can be done on
> +that key.
> +
> +Completely in-kernel key retention and operation subtypes and parsers can be
> +defined, but it would also be possible to provide access to cryptographic
> +hardware (such as a TPM) that might be used to both retain the relevant key and
> +perform operations using that key.  In such a case, the crypto key would then
> +merely be an interface to the TPM driver.
> +
> +
> +==================
> +KEY IDENTIFICATION
> +==================
> +
> +Because the identity of a key is not necessarily known and may not be easily
> +calculated when a crypto key is allocated, it may not be a simple matter to set
> +a key description to something that's useful for determining whether this is
> +the key you're looking for.  Furthermore, it may be necessary to perform a
> +partial match upon the key identity.
> +
> +To help with this, when a key is loaded, the parser calculates the key
> +fingerprint and stores a copy in the key structure.
> +
> +The crypto key type's key matching function then performs more checks than just
> +the straightforward comparison of the description with the criterion string:
> +
> + (1) If the criterion string is of the form "id:<hexdigits>" then the match
> +     function will examine a key's fingerprint to see if the hex digits given
> +     after the "id:" match the tail.  For instance:
> +
> +	keyctl search @s crypto id:5acc2142
> +
> +     will match a key with fingerprint:
> +
> +	1A00 2040 7601 7889 DE11  882C 3823 04AD 5ACC 2142
> +
> + (2) If the criterion string is of the form "<subtype>:<hexdigits>" then the
> +     match will match the ID as in (1), but with the added restriction that
> +     only keys of the specified subtype (e.g. dsa or rsa) will be matched.  For
> +     instance:
> +
> +	keyctl search @s crypto dsa:5acc2142
> +
> +Looking in /proc/keys, the last 8 hex digits of the key fingerprint are
> +displayed, along with the subtype:
> +
> +	1a39e171 I-----     1 perm 3f010000     0     0 crypto    modsign.0: DSA 5acc2142 []
> +
> +
> +=====================
> +ACCESSING CRYPTO KEYS
> +=====================
> +
> +To access crypto keys from within the kernel, the following inclusion is
> +required:
> +
> +	#include <keys/crypto-type.h>
> +
> +This gives access to the key type:
> +
> +	struct key_type key_type_crypto;
> +
> +
> +===========================
> +IMPLEMENTING CRYPTO PARSERS
> +===========================
> +
> +The crypto key type keeps a list of registered data parsers.  An example of
> +such a parser is one that parses OpenPGP packet formatted data [RFC 4880].
> +
> +During key instantiation each parser in the list is tried until one doesn't
> +return -EBADMSG.
> +
> +The parser definition structure looks like the following:
> +
> +	struct crypto_key_parser {
> +		struct module		*owner;
> +		const char		*name;
> +
> +		int (*instantiate)(struct key *key,
> +				   const void *data, size_t datalen);
> +	};
> +
> +The owner and name fields should be set to the owning module and the name of
> +the parser.
> +
> +There are a number of operations defined by the parser.  They are all optional,
> +but it is expected that at least one will be defined.
> +
> + (1) instantiate().
> +
> +     The arguments are the same as for the instantiate function in the key
> +     type.  'key' is the crypto key being instantiated; data and datalen are
> +     the instantiation data, presumably containing cryptographic key data, and
> +     the length of that data.
> +
> +     If the data format is not recognised, -EBADMSG should be returned.  If it
> +     is recognised, but the key cannot for some reason be set up, some other
> +     negative error code should be returned.
> +
> +     If the key can be successfully set up, then key->payload should be set to
> +     point to the retained data, key->type_data.p[0] should be set to point to
> +     the subtype chosen and key->type_data.p[1] should be set to point to a
> +     copy of the key's identity string and 0 should be returned.
> +
> +     The key's identity string may be partially matched upon.  For a public-key
> +     algorithm such as RSA and DSA this will likely be a printable hex version
> +     of the key's fingerprint.
> +
> +Functions are provided to register and unregister parsers:
> +
> +	int register_crypto_key_parser(struct crypto_key_parser *parser);
> +	void unregister_crypto_key_parser(struct crypto_key_parser *subtype);
> +
> +Parsers may not have the same name.  The names are only used for displaying in
> +debugging messages.
> +
> +
> +============================
> +IMPLEMENTING CRYPTO SUBTYPES
> +============================
> +
> +The parser selects the appropriate subtype directly and sets it on the key; the
> +crypto key then retains a reference on the subtype module (which means the
> +parser can be removed thereafter).
> +
> +The subtype definition structure looks like the following:
> +
> +	struct crypto_key_subtype {
> +		struct module		*owner;
> +		const char		*name;
> +
> +		void (*describe)(const struct key *key, struct seq_file *m);
> +		void (*destroy)(void *payload);
> +	};
> +
> +The owner and name fields should be set to the owning module and the name of
> +the subtype.
> +
> +There are a number of operations defined by the subtype:
> +
> + (1) describe().
> +
> +     Mandatory.  This allows the subtype to display something in /proc/keys
> +     against the key.  For instance the name of the public key algorithm type
> +     could be displayed.  The key type will display the tail of the key
> +     identity string after this.
> +
> + (2) destroy().
> +
> +     Mandatory.  This should free the memory associated with the key.  The
> +     crypto key will look after freeing the fingerprint and releasing the
> +     reference on the subtype module.
> diff --git a/include/keys/crypto-subtype.h b/include/keys/crypto-subtype.h
> new file mode 100644
> index 0000000..fa87555
> --- /dev/null
> +++ b/include/keys/crypto-subtype.h
> @@ -0,0 +1,56 @@
> +/* Cryptographic key subtype
> + *
> + * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + *
> + * See Documentation/security/keys-crypto.txt
> + */
> +
> +#ifndef _KEYS_CRYPTO_SUBTYPE_H
> +#define _KEYS_CRYPTO_SUBTYPE_H
> +
> +#include <linux/seq_file.h>
> +#include <keys/crypto-type.h>
> +
> +extern struct key_type key_type_crypto;
> +
> +/*
> + * Keys of this type declare a subtype that indicates the handlers and
> + * capabilities.
> + */
> +struct crypto_key_subtype {
> +	struct module		*owner;
> +	const char		*name;
> +	unsigned short		name_len;	/* length of name */
> +
> +	void (*describe)(const struct key *key, struct seq_file *m);
> +
> +	void (*destroy)(void *payload);
> +};
> +
> +/*
> + * Data parser.  Called during instantiation and signature verification
> + * initiation.
> + */
> +struct crypto_key_parser {
> +	struct list_head	link;
> +	struct module		*owner;
> +	const char		*name;
> +
> +	/* Attempt to instantiate a key from the data blob passed to add_key()
> +	 * or keyctl_instantiate().
> +	 *
> +	 * Return EBADMSG if not recognised.
> +	 */
> +	int (*instantiate)(struct key *key, const void *data, size_t datalen);
> +};
> +
> +extern int register_crypto_key_parser(struct crypto_key_parser *);
> +extern void unregister_crypto_key_parser(struct crypto_key_parser *);
> +
> +#endif /* _KEYS_CRYPTO_SUBTYPE_H */
> diff --git a/include/keys/crypto-type.h b/include/keys/crypto-type.h
> new file mode 100644
> index 0000000..47c00c7
> --- /dev/null
> +++ b/include/keys/crypto-type.h
> @@ -0,0 +1,25 @@
> +/* Cryptographic key type interface
> + *
> + * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + *
> + * See Documentation/security/keys-crypto.txt
> + */
> +
> +#ifndef _KEYS_CRYPTO_TYPE_H
> +#define _KEYS_CRYPTO_TYPE_H
> +
> +#include <linux/key-type.h>
> +
> +extern struct key_type key_type_crypto;
> +
> +/*
> + * The payload is at the discretion of the subtype.
> + */
> +
> +#endif /* _KEYS_CRYPTO_TYPE_H */
> diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> index a90d6d3..290c9d3 100644
> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -69,3 +69,11 @@ config KEYS_DEBUG_PROC_KEYS
>  	  the resulting table.
> 
>  	  If you are unsure as to whether this is required, answer N.
> +
> +config CRYPTO_KEY_TYPE
> +	tristate "Cryptographic key type"
> +	depends on KEYS
> +	help
> +	  This option provides support for a type of key that holds the keys
> +	  required for cryptographic operations such as encryption, decryption,
> +	  signature generation and signature verification.
> diff --git a/security/keys/Makefile b/security/keys/Makefile
> index 504aaa0..67fceaa 100644
> --- a/security/keys/Makefile
> +++ b/security/keys/Makefile
> @@ -24,3 +24,6 @@ obj-$(CONFIG_SYSCTL) += sysctl.o
>  #
>  obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
>  obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
> +obj-$(CONFIG_CRYPTO_KEY_TYPE) += crypto_keys.o
> +
> +crypto_keys-y := crypto_type.o
> diff --git a/security/keys/crypto_keys.h b/security/keys/crypto_keys.h
> new file mode 100644
> index 0000000..a339ce0
> --- /dev/null
> +++ b/security/keys/crypto_keys.h
> @@ -0,0 +1,28 @@
> +/* Internal crypto type stuff
> + *
> + * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +static inline
> +struct crypto_key_subtype *crypto_key_subtype(const struct key *key)
> +{
> +	return key->type_data.p[0];
> +}
> +
> +static inline char *crypto_key_id(const struct key *key)
> +{
> +	return key->type_data.p[1];
> +}
> +
> +
> +/*
> + * crypto_type.c
> + */
> +extern struct list_head crypto_key_parsers;
> +extern struct rw_semaphore crypto_key_parsers_sem;
> diff --git a/security/keys/crypto_type.c b/security/keys/crypto_type.c
> new file mode 100644
> index 0000000..a06413a
> --- /dev/null
> +++ b/security/keys/crypto_type.c
> @@ -0,0 +1,230 @@
> +/* Cryptographic key type
> + *
> + * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + *
> + * See Documentation/security/keys-crypto.txt
> + */
> +#include <keys/crypto-subtype.h>
> +#include <linux/seq_file.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include "crypto_keys.h"
> +
> +MODULE_LICENSE("GPL");
> +
> +LIST_HEAD(crypto_key_parsers);
> +DECLARE_RWSEM(crypto_key_parsers_sem);
> +
> +/*
> + * Match crypto_keys on (part of) their name
> + * We have some shorthand methods for matching keys.  We allow:
> + *
> + *	"<desc>"	- request a key by description
> + *	"id:<id>"	- request a key matching the ID
> + *	"<subtype>:<id>" - request a key of a subtype
> + */
> +static int crypto_key_match(const struct key *key, const void *description)
> +{
> +	const struct crypto_key_subtype *subtype = crypto_key_subtype(key);
> +	const char *spec = description;
> +	const char *id, *kid;
> +	ptrdiff_t speclen;
> +	size_t idlen, kidlen;
> +
> +	if (!subtype || !spec || !*spec)
> +		return 0;
> +
> +	/* See if the full key description matches as is */
> +	if (key->description && strcmp(key->description, description) == 0)
> +		return 1;
> +
> +	/* All tests from here on break the criterion description into a
> +	 * specifier, a colon and then an identifier.
> +	 */
> +	id = strchr(spec, ':');
> +	if (!id)
> +		return 0;
> +
> +	speclen = id - spec;
> +	id++;
> +
> +	/* Anything after here requires a partial match on the ID string */
> +	kid = crypto_key_id(key);
> +	if (!kid)
> +		return 0;
> +
> +	idlen = strlen(id);
> +	kidlen = strlen(kid);
> +	if (idlen > kidlen)
> +		return 0;
> +
> +	kid += kidlen - idlen;
> +	if (strcasecmp(id, kid) != 0)
> +		return 0;
> +
> +	if (speclen == 2 &&
> +	    memcmp(spec, "id", 2) == 0)
> +		return 1;
> +
> +	if (speclen == subtype->name_len &&
> +	    memcmp(spec, subtype->name, speclen) == 0)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +/*
> + * Describe the crypto key
> + */
> +static void crypto_key_describe(const struct key *key, struct seq_file *m)
> +{
> +	const struct crypto_key_subtype *subtype = crypto_key_subtype(key);
> +	const char *kid = crypto_key_id(key);
> +	size_t n;
> +
> +	seq_puts(m, key->description);
> +
> +	if (subtype) {
> +		seq_puts(m, ": ");
> +		subtype->describe(key, m);
> +
> +		if (kid) {
> +			seq_putc(m, ' ');
> +			n = strlen(kid);
> +			if (n <= 8)
> +				seq_puts(m, kid);
> +			else
> +				seq_puts(m, kid + n - 8);
> +		}
> +
> +		seq_puts(m, " [");
> +		/* put something here to indicate the key's capabilities */
> +		seq_putc(m, ']');
> +	}
> +}
> +
> +/*
> + * Instantiate a crypto_key defined key
> + */
> +static int crypto_key_instantiate(struct key *key,
> +				  const void *data, size_t datalen)
> +{
> +	struct crypto_key_parser *parser;
> +	int ret;
> +
> +	pr_devel("==>%s()\n", __func__);
> +
> +	if (datalen == 0)
> +		return -EINVAL;
> +
> +	down_read(&crypto_key_parsers_sem);
> +
> +	ret = -EBADMSG;
> +	list_for_each_entry(parser, &crypto_key_parsers, link) {
> +		pr_debug("Trying parser '%s'\n", parser->name);
> +
> +		ret = parser->instantiate(key, data, datalen);
> +		if (ret != -EBADMSG) {
> +			pr_debug("Parser recognised the format (ret %d)\n",
> +				 ret);
> +			if (ret == 0)
> +				module_get(crypto_key_subtype(key));
> +			break;
> +		}
> +	}
> +
> +	up_read(&crypto_key_parsers_sem);
> +	pr_devel("<==%s() = %d\n", __func__, ret);
> +	return ret;
> +}
> +
> +/*
> + * dispose of the data dangling from the corpse of a crypto key
> + */
> +static void crypto_key_destroy(struct key *key)
> +{
> +	struct crypto_key_subtype *subtype = crypto_key_subtype(key);
> +	if (subtype) {
> +		subtype->destroy(key->payload.data);
> +		module_put(subtype->owner);
> +		key->type_data.p[0] = NULL;
> +	}
> +	kfree(key->type_data.p[1]);
> +	key->type_data.p[1] = NULL;
> +}
> +
> +struct key_type key_type_crypto = {
> +	.name		= "crypto",
> +	.instantiate	= crypto_key_instantiate,
> +	.match		= crypto_key_match,
> +	.destroy	= crypto_key_destroy,
> +	.describe	= crypto_key_describe,
> +};
> +EXPORT_SYMBOL_GPL(key_type_crypto);
> +
> +/**
> + * register_crypto_key_parser - Register a crypto key blob parser
> + * @parser: The parser to register
> + */
> +int register_crypto_key_parser(struct crypto_key_parser *parser)
> +{
> +	struct crypto_key_parser *cursor;
> +	int ret;
> +
> +	down_write(&crypto_key_parsers_sem);
> +
> +	list_for_each_entry(cursor, &crypto_key_parsers, link) {
> +		if (strcmp(cursor->name, parser->name) == 0) {
> +			pr_err("Crypto key parser '%s' already registered\n",
> +			       parser->name);
> +			ret = -EEXIST;
> +			goto out;
> +		}
> +	}
> +
> +	list_add_tail(&parser->link, &crypto_key_parsers);
> +
> +	pr_notice("Crypto key parser '%s' registered\n", parser->name);
> +	ret = 0;
> +
> +out:
> +	up_write(&crypto_key_parsers_sem);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(register_crypto_key_parser);
> +
> +/**
> + * unregister_crypto_key_parser - Unregister a crypto key blob parser
> + * @parser: The parser to unregister
> + */
> +void unregister_crypto_key_parser(struct crypto_key_parser *parser)
> +{
> +	down_write(&crypto_key_parsers_sem);
> +	list_del(&parser->link);
> +	up_write(&crypto_key_parsers_sem);
> +
> +	pr_notice("Crypto key parser '%s' unregistered\n", parser->name);
> +}
> +EXPORT_SYMBOL_GPL(unregister_crypto_key_parser);
> +
> +/*
> + * Module stuff
> + */
> +static int __init crypto_key_init(void)
> +{
> +	return register_key_type(&key_type_crypto);
> +}
> +
> +static void __exit crypto_key_cleanup(void)
> +{
> +	unregister_key_type(&key_type_crypto);
> +}
> +
> +module_init(crypto_key_init);
> +module_exit(crypto_key_cleanup);
> 



