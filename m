Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab2IYAMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:12:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2IYAMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:12:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5555.1348531649@warthog.procyon.org.uk>
References: <5555.1348531649@warthog.procyon.org.uk>
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Tue, 25 Sep 2012 01:11:21 +0100
Message-ID: <5646.1348531881@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Note, this implementation of the X.509 certificate parser uses a couple of
> patterns to drive a reusable ASN.1 decoder.  I do, however, have a direct
> in-line decoder implementation also that can only decode X.509 certs.  The
> stack space usage is greater, but the code size is simpler and slightly
> smaller and the code is less capable (it can't handle indefinite-length
> elements for example), and it can't be reused for anything else (such as
> CIFS, netfilter, PKCS#7, Kerberos tickets), whereas the pattern-based
> decoder can.  I'll post this separately to see what people think.

Here's the direct inline X.509 ASN.1 decoder I mentioned.

David
---
/* X.509 certificate parser
 *
 * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
 * Written by David Howells (dhowells@redhat.com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public Licence
 * as published by the Free Software Foundation; either version
 * 2 of the Licence, or (at your option) any later version.
 */

#define pr_fmt(fmt) "X.509: "fmt
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/err.h>
#include <linux/oid_registry.h>
#include "linux/asn1.h"
#include "public_key.h"
#include "x509_parser.h"

struct x509_cursor {
	unsigned	start;			/* Start of this element's content */
	unsigned	len;			/* Remaining length of element's content */
	u8		hdrlen;			/* Length of header */
	u8		tag;			/* Tag found */
	bool		present;		/* Element present */
};

struct x509_parse_context {
	struct x509_certificate	*cert;		/* Certificate being constructed */
	const u8	*data;			/* Start of data */
	const void	*cert_start;		/* Start of cert content */
	const void	*key;			/* Key data */
	size_t		key_size;		/* Size of key data */
	enum OID	algo_oid;		/* Algorithm OID */
	unsigned char	nr_mpi;			/* Number of MPIs stored */
	int		error;
};

/*
 * Free an X.509 certificate
 */
void x509_free_certificate(struct x509_certificate *cert)
{
	if (cert) {
		public_key_destroy(cert->pub);
		kfree(cert->issuer);
		kfree(cert->subject);
		kfree(cert->fingerprint);
		kfree(cert->authority);
		kfree(cert);
	}
}

/*
 * Extract an ASN.1 element.
 */
static bool asn1_extract(struct x509_parse_context *ctx,
			 struct x509_cursor *cursor,
			 int expected_tag, bool optional,
			 struct x509_cursor *_extracted_cursor)
{
	unsigned start, len;
	u8 tag, l;

	pr_devel("==>%s(,{%u,%u},%02x,%u) [%02x%02x]\n",
		 __func__, cursor->start, cursor->len, expected_tag, optional,
		 ctx->data[cursor->start], ctx->data[cursor->start + 1]);

	if (ctx->error)
		return false;

	if (_extracted_cursor)
		_extracted_cursor->present = false;
	if (cursor->len == 0 && optional)
		return false;

	if (cursor->len < 2) {
		pr_debug("ASN.1 elem header underrun @%u+%u\n",
			 cursor->start, cursor->len);
		ctx->error = -EBADMSG;
		return false;
	}

	tag = ctx->data[cursor->start];
	len = ctx->data[cursor->start + 1];

	if (expected_tag != -1 && tag != expected_tag) {
		if (!optional) {
			pr_debug("ASN.1 unexpected tag %02x%02x not %02x @%u+%u\n",
				 tag, len, expected_tag,
				 cursor->start, cursor->len);
			ctx->error = -EBADMSG;
		}
		return false;
	}

	cursor->start += 2;
	cursor->len -= 2;

	if ((tag & 0x1f) == 0x1f) {
		pr_debug("ASN.1 long tag @%u\n", cursor->start);
		ctx->error = -EBADMSG;
		return false;
	}

	if (len == 0x80) {
		pr_debug("ASN.1 indefinite length @%u\n", cursor->start);
		ctx->error = -EBADMSG;
		return false;
	}

	l = 0;
	if (len > 0x80) {
		l = len - 0x80;
		if (cursor->len < l) {
			pr_debug("ASN.1 elem len underrun (%u) @%u+%u\n",
				 l, cursor->start, cursor->len);
			ctx->error = -EBADMSG;
			return false;
		}

		switch (l) {
		case 0x01:
			len = ctx->data[cursor->start];
			break;
		case 0x02:
			len  = ctx->data[cursor->start + 0] << 8;
			len += ctx->data[cursor->start + 1];
			break;
		case 0x03:
			len  = ctx->data[cursor->start + 0] << 16;
			len += ctx->data[cursor->start + 1] << 8;
			len += ctx->data[cursor->start + 2];
			break;
		case 0x04:
			len  = ctx->data[cursor->start + 0] << 24;
			len += ctx->data[cursor->start + 1] << 16;
			len += ctx->data[cursor->start + 2] << 8;
			len += ctx->data[cursor->start + 3];
			break;
		default:
			pr_debug("ASN.1 elem excessive len (%u) @%u\n",
				 l, cursor->start);
			ctx->error = -EBADMSG;
			return false;
		}

		cursor->start += l;
		cursor->len -= l;
	}

	pr_debug("TAG %02x len: %u+%u\n", tag, l + 2, len);

	if (cursor->len < len) {
		pr_debug("ASN.1 data underrun (%u) @%u+%u\n",
			 len, cursor->start, cursor->len);
		ctx->error = -EBADMSG;
		return false;
	}

	start = cursor->start;
	cursor->start += len;
	cursor->len -= len;
	if (_extracted_cursor) {
		_extracted_cursor->start = start;
		_extracted_cursor->len = len;
		_extracted_cursor->hdrlen = 2 + l;
		_extracted_cursor->tag = tag;
		_extracted_cursor->present = true;
	}
	return true;
}

static bool asn1_check_end(struct x509_parse_context *ctx,
			   struct x509_cursor *cursor)
{
	if (ctx->error)
		return false;
	if (cursor->len != 0) {
		pr_debug("ASN.1 excess data @%u+%u\n",
			 cursor->start, cursor->len);
		ctx->error = -EBADMSG;
		return false;
	}
	return true;
}

/*
 * Parse the signature type.
 */
static void x509_parse_signature_type(struct x509_parse_context *ctx,
				      struct x509_cursor *data)
{
	struct x509_cursor type;
	enum OID oid;

	asn1_extract(ctx, data, ASN1_UNIV | ASN1_OID, false, &type);
	asn1_extract(ctx, data, -1, true, NULL);
	if (!asn1_check_end(ctx, data))
		return;

	oid = look_up_OID(ctx->data + type.start, type.len);

	switch (oid) {
	case OID_md2WithRSAEncryption:
	case OID_md3WithRSAEncryption:
	default:
		/* Unsupported combination */
		ctx->error = -ENOPKG;
		return;

	case OID_md4WithRSAEncryption:
		ctx->cert->sig_hash_algo = PKEY_HASH_MD5;
		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
		break;

	case OID_sha1WithRSAEncryption:
		ctx->cert->sig_hash_algo = PKEY_HASH_SHA1;
		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
		break;

	case OID_sha256WithRSAEncryption:
		ctx->cert->sig_hash_algo = PKEY_HASH_SHA256;
		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
		break;

	case OID_sha384WithRSAEncryption:
		ctx->cert->sig_hash_algo = PKEY_HASH_SHA384;
		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
		break;

	case OID_sha512WithRSAEncryption:
		ctx->cert->sig_hash_algo = PKEY_HASH_SHA512;
		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
		break;

	case OID_sha224WithRSAEncryption:
		ctx->cert->sig_hash_algo = PKEY_HASH_SHA224;
		ctx->cert->sig_pkey_algo = PKEY_ALGO_RSA;
		break;
	}

	ctx->algo_oid = oid;
}

/*
 * Parse a name
 */
static void x509_parse_name(struct x509_parse_context *ctx,
			    struct x509_cursor *name, char **_name)
{
	const u8 *data = ctx->data;
	unsigned o_offset = 0, cn_offset = 0, email_offset = 0, offset;
	unsigned namesize;
	u8 o_size = 0, cn_size = 0, email_size = 0;
	char *buffer;

	BUG_ON(*_name);

	while (!ctx->error && name->len > 0) {
		struct x509_cursor rdn, attr, n_oid, n_val;
		enum OID oid;

		asn1_extract(ctx, name, ASN1_UNIV | ASN1_CONS | ASN1_SET,
			     false, &rdn);
		while (!ctx->error && rdn.len > 0) {
			asn1_extract(ctx, &rdn, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
				     false, &attr);
			asn1_extract(ctx, &attr, ASN1_UNIV | ASN1_OID, false, &n_oid);
			asn1_extract(ctx, &attr, -1, false, &n_val);
			if (!asn1_check_end(ctx, &attr))
				return;

			oid = look_up_OID(data + n_oid.start, n_oid.len);
			switch (oid) {
			case OID_organizationName:
				o_size = n_val.len;
				o_offset = n_val.start;
				break;
			case OID_commonName:
				cn_size = n_val.len;
				cn_offset = n_val.start;
				break;
			case OID_email_address:
				email_size = n_val.len;
				email_offset = n_val.start;
				break;
			default:
				continue;
			}
		}

		if (!asn1_check_end(ctx, &rdn))
			return;
	}

	if (!asn1_check_end(ctx, name))
		return;

	/* Empty name string if no material */
	if (!cn_size && !o_size && !email_size) {
		buffer = kmalloc(1, GFP_KERNEL);
		if (!buffer) {
			ctx->error = -ENOMEM;
			return;
		}
		buffer[0] = 0;
		goto done;
	}

	if (cn_size && o_size) {
		/* Consider combining O and CN, but use only the CN if it is
		 * prefixed by the O, or a significant portion thereof.
		 */
		namesize = cn_size;
		offset = cn_offset;
		if (cn_size >= o_size &&
		    memcmp(data + cn_offset, data + o_offset, o_size) == 0)
			goto single_component;
		if (cn_size >= 7 &&
		    o_size >= 7 &&
		    memcmp(data + cn_offset, data + o_offset, 7) == 0)
			goto single_component;

		buffer = kmalloc(o_size + 2 + cn_size + 1, GFP_KERNEL);
		if (!buffer) {
			ctx->error = -ENOMEM;
			return;
		}

		memcpy(buffer, data + o_offset, o_size);
		buffer[o_size + 0] = ':';
		buffer[o_size + 1] = ' ';
		memcpy(buffer + o_size + 2, data + cn_offset, cn_size);
		buffer[o_size + 2 + cn_size] = 0;
		goto done;

	} else if (cn_size) {
		namesize = cn_size;
		offset = cn_offset;
	} else if (o_size) {
		namesize = o_size;
		offset = o_offset;
	} else {
		namesize = email_size;
		offset = email_offset;
	}

single_component:
	buffer = kmalloc(namesize + 1, GFP_KERNEL);
	if (!buffer) {
		ctx->error = -ENOMEM;
		return;
	}
	memcpy(buffer, data + offset, namesize);
	buffer[namesize] = 0;

done:
	*_name = buffer;
}

/*
 * Record a certificate time.
 */
static bool x509_note_time(struct x509_parse_context *ctx,
			   time_t *_time, u8 tag, const u8 *value, size_t vlen)
{
	unsigned YY, MM, DD, hh, mm, ss;
	const u8 *p = value;

#define dec2bin(X) ((X) - '0')
#define DD2bin(P) ({ unsigned x = dec2bin(P[0]) * 10 + dec2bin(P[1]); P += 2; x; })

	if (tag == ASN1_UNITIM) {
		/* UTCTime: YYMMDDHHMMSSZ */
		if (vlen != 13)
			goto unsupported_time;
		YY = DD2bin(p);
		if (YY > 50)
			YY += 1900;
		else
			YY += 2000;
	} else if (tag == ASN1_GENTIM) {
		/* GenTime: YYYYMMDDHHMMSSZ */
		if (vlen != 15)
			goto unsupported_time;
		YY = DD2bin(p) * 100 + DD2bin(p);
	} else {
		goto unsupported_time;
	}

	MM = DD2bin(p);
	DD = DD2bin(p);
	hh = DD2bin(p);
	mm = DD2bin(p);
	ss = DD2bin(p);

	if (*p != 'Z')
		goto unsupported_time;

	*_time = mktime(YY, MM, DD, hh, mm, ss);
	return true;

unsupported_time:
	pr_debug("Got unsupported time [tag %02x]: '%*.*s'\n",
		 tag, (int)vlen, (int)vlen, value);
	ctx->error = -EBADMSG;
	return false;
}

/*
 * Parse the validity data.
 */
static void x509_parse_validity(struct x509_parse_context *ctx,
				struct x509_cursor *data)
{
	struct x509_cursor not_before, not_after;

	asn1_extract(ctx, data, -1, false, &not_before);
	asn1_extract(ctx, data, -1, false, &not_after);
	if (!asn1_check_end(ctx, data))
		return;

	if (x509_note_time(ctx, &ctx->cert->valid_from, not_before.tag,
			   ctx->data + not_before.start, not_before.len) < 0) {
		ctx->error = -EBADMSG;
		return;
	}
	if (x509_note_time(ctx, &ctx->cert->valid_to, not_after.tag,
			   ctx->data + not_after.start, not_after.len) < 0) {
		ctx->error = -EBADMSG;
		return;
	}
}

/*
 * Extract a RSA public key value
 */
static void x509_parse_rsa_key(struct x509_parse_context *ctx,
			       struct x509_cursor *data)
{
	struct x509_cursor list, integer;
	MPI mpi;

	asn1_extract(ctx, data, ASN1_UNIV | ASN1_CONS | ASN1_SEQ, false, &list);
	if (!asn1_check_end(ctx, data))
		return;

	while (list.len > 0) {
		if (ctx->nr_mpi >= ARRAY_SIZE(ctx->cert->pub->mpi)) {
			pr_debug("Too many public key MPIs in certificate\n");
			ctx->error = -EBADMSG;
			return;
		}

		if (!asn1_extract(ctx, &list, ASN1_UNIV | ASN1_INT,
				  false, &integer))
			return;

		mpi = mpi_read_raw_data(ctx->data + integer.start, integer.len);
		if (!mpi) {
			ctx->error = -ENOMEM;
			return;
		}

		ctx->cert->pub->mpi[ctx->nr_mpi++] = mpi;
	}

	asn1_check_end(ctx, &list);
}

/*
 * Parse the key.
 */
static void x509_parse_key(struct x509_parse_context *ctx,
			   struct x509_cursor *data)
{
	struct x509_cursor algo, type, str;
	enum OID oid;

	asn1_extract(ctx, data, ASN1_UNIV | ASN1_CONS | ASN1_SEQ, false, &algo);
	asn1_extract(ctx, data, ASN1_UNIV | ASN1_BTS, false, &str);
	if (!asn1_check_end(ctx, data))
		return;

	asn1_extract(ctx, &algo, ASN1_UNIV | ASN1_OID, false, &type);
	asn1_extract(ctx, &algo, -1, true, NULL);
	if (!asn1_check_end(ctx, &algo))
		return;

	oid = look_up_OID(ctx->data + type.start, type.len);

	if (oid != OID_rsaEncryption) {
		ctx->error = -ENOPKG;
		return;
	}
	ctx->cert->pkey_algo = PKEY_ALGO_RSA;

	/* Remove the bit string's initial unused bit count */
	if (str.len < 1) {
		pr_debug("ASN.1 short BIT STRING @%u+%u\n", str.start, str.len);
		ctx->error = -EBADMSG;
		return;
	}
	str.start++;
	str.len--;
	x509_parse_rsa_key(ctx, &str);
}

/*
 * Parse the extension list.
 */
static void x509_parse_extensions(struct x509_parse_context *ctx,
				  struct x509_cursor *data)
{
	struct x509_cursor extensions, ext;
	char *f;

	if (!data->present)
		return;

	asn1_extract(ctx, data, ASN1_UNIV | ASN1_CONS | ASN1_SEQ, false, &extensions);
	if (!asn1_check_end(ctx, data))
		return;

	while (extensions.len > 0 &&
	       asn1_extract(ctx, &extensions, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			    false, &ext)
	       ) {
		struct x509_cursor type, val, wrapper, part;
		const u8 *v;
		enum OID oid;
		int i;

		asn1_extract(ctx, &ext, ASN1_UNIV | ASN1_OID, false, &type);
		asn1_extract(ctx, &ext, ASN1_UNIV | ASN1_BOOL, true, NULL);
		asn1_extract(ctx, &ext, ASN1_UNIV | ASN1_OTS, false, &val);
		if (!asn1_check_end(ctx, &ext))
			return;

		oid = look_up_OID(ctx->data + type.start, type.len);
		switch (oid) {
		case OID_subjectKeyIdentifier:
			/* Get hold of the key fingerprint */
			asn1_extract(ctx, &val, ASN1_UNIV | ASN1_OTS, false,
				     &part);
			if (!asn1_check_end(ctx, &val))
				return;
			if (part.len == 0) {
				pr_debug("Empty subjectKeyIdentifier\n");
				ctx->error = -EBADMSG;
				return;
			}

			f = kmalloc(part.len * 2 + 1, GFP_KERNEL);
			if (!f) {
				ctx->error = -ENOMEM;
				return;
			}
			v = ctx->data + part.start;
			for (i = 0; i < part.len; i++)
				sprintf(f + i * 2, "%02x", v[i]);
			pr_debug("fingerprint %s\n", f);
			ctx->cert->fingerprint = f;
			break;

		case OID_authorityKeyIdentifier:
			/* Get hold of the CA key fingerprint */
			asn1_extract(ctx, &val, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
				     false, &wrapper);
			if (!asn1_check_end(ctx, &val))
				return;
			asn1_extract(ctx, &wrapper, ASN1_CONT | 0, false, &part);
			if (!asn1_check_end(ctx, &wrapper))
				return;
			if (part.len == 0) {
				pr_debug("Empty authorityKeyIdentifier\n");
				ctx->error = -EBADMSG;
				return;
			}

			f = kmalloc(part.len * 2 + 1, GFP_KERNEL);
			if (!f) {
				ctx->error = -ENOMEM;
				return;
			}
			v = ctx->data + part.start;
			for (i = 0; i < part.len; i++)
				sprintf(f + i * 2, "%02x", v[i]);
			pr_debug("authority   %s\n", f);
			ctx->cert->authority = f;
			break;

		default:
			continue;
		}
	}

	asn1_check_end(ctx, &extensions);
}

/*
 * Parse the signature algorithm.
 */
static void x509_parse_signature_algo(struct x509_parse_context *ctx,
				      struct x509_cursor *data)
{
	struct x509_cursor type;
	enum OID oid;

	asn1_extract(ctx, data, ASN1_UNIV | ASN1_OID, false, &type);
	asn1_extract(ctx, data, -1, true, NULL);
	if (!asn1_check_end(ctx, data))
		return;

	oid = look_up_OID(ctx->data + type.start, type.len);

	pr_debug("Signature type: %u\n", oid);

	if (oid != ctx->algo_oid) {
		pr_debug("Got cert with pkey (%u) and sig (%u) algorithm OIDs\n",
			 ctx->algo_oid, oid);
		ctx->error = -EINVAL;
	}
}

/*
 * Parse the basic structure of the certificate.
 */
static void x509_parse_basic(struct x509_parse_context *ctx,
			     size_t datalen)
{
	struct x509_cursor cert, tbs;
	struct x509_cursor tmp = {
		.start = 0,
		.len = datalen
	};

	if (!asn1_extract(ctx, &tmp, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			  false, &cert) ||
	    !asn1_check_end(ctx, &tmp))
		return;

	if (!asn1_extract(ctx, &cert, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			  false, &tbs))
		return;
	pr_debug("x509_note_tbs_certificate(,%02x,%u,%u)!\n",
		 tbs.tag, tbs.start, tbs.len);
	ctx->cert->tbs = ctx->data + (tbs.start - tbs.hdrlen);
	ctx->cert->tbs_size = tbs.hdrlen + tbs.len;

	{
		asn1_extract(ctx, &tbs, ASN1_CONT | ASN1_CONS | 0,
			     true, NULL); /* Version */
		asn1_extract(ctx, &tbs, ASN1_UNIV | ASN1_INT,
			     false, NULL); /* Serial */
		asn1_extract(ctx, &tbs, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			     false, &tmp);
		x509_parse_signature_type(ctx, &tmp);
		asn1_extract(ctx, &tbs, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			     false, &tmp);
		x509_parse_name(ctx, &tmp, &ctx->cert->issuer);
		asn1_extract(ctx, &tbs, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			     false, &tmp);
		x509_parse_validity(ctx, &tmp);
		asn1_extract(ctx, &tbs, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			     false, &tmp);
		x509_parse_name(ctx, &tmp, &ctx->cert->subject);
		asn1_extract(ctx, &tbs, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
			     false, &tmp);
		x509_parse_key(ctx, &tmp);
		asn1_extract(ctx, &tbs, ASN1_CONT | ASN1_CONS | 1,
			     true, NULL); /* Issuer uid */
		asn1_extract(ctx, &tbs, ASN1_CONT | ASN1_CONS | 2,
			     true, NULL); /* Subject uid */
		asn1_extract(ctx, &tbs, ASN1_CONT | ASN1_CONS | 3,
			     true, &tmp);
		x509_parse_extensions(ctx, &tmp);
	}
	if (!asn1_check_end(ctx, &tbs))
		return;

	asn1_extract(ctx, &cert, ASN1_UNIV | ASN1_CONS | ASN1_SEQ,
		     false, &tmp);
	x509_parse_signature_algo(ctx, &tmp);
	asn1_extract(ctx, &cert, ASN1_UNIV | ASN1_BTS, false, &tmp);
	if (!asn1_check_end(ctx, &cert))
		return;

	/* Remove the bit string's initial unused bit count */
	if (tmp.len < 1) {
		pr_debug("ASN.1 short BIT STRING @%u+%u\n", tmp.start, tmp.len);
		ctx->error = -EBADMSG;
		return;
	}
	tmp.start++;
	tmp.len--;

	pr_debug("Signature size %u\n", tmp.len);
	ctx->cert->sig = ctx->data + tmp.start;
	ctx->cert->sig_size = tmp.len;
}

/*
 * Parse an X.509 certificate
 */
struct x509_certificate *x509_cert_parse(const void *data, size_t datalen)
{
	struct x509_certificate *cert;
	struct x509_parse_context *ctx;
	long ret;

	ret = -ENOMEM;
	cert = kzalloc(sizeof(struct x509_certificate), GFP_KERNEL);
	if (!cert)
		goto error_no_cert;
	cert->pub = kzalloc(sizeof(struct public_key), GFP_KERNEL);
	if (!cert->pub)
		goto error_no_ctx;
	ctx = kzalloc(sizeof(struct x509_parse_context), GFP_KERNEL);
	if (!ctx)
		goto error_no_ctx;

	ctx->cert = cert;
	ctx->data = data;

	/* Attempt to decode the certificate */
	x509_parse_basic(ctx, datalen);
	ret = ctx->error;
	if (ret < 0)
		goto error_decode;

	kfree(ctx);
	return cert;

error_decode:
	kfree(ctx);
error_no_ctx:
	x509_free_certificate(cert);
error_no_cert:
	return ERR_PTR(ret);
}
