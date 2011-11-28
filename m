Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1K1PrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:47:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab1K1PpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:45:10 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/14] PGP: Add definitions (RFC 4880) and packet parser
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, mitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Mon, 28 Nov 2011 15:45:01 +0000
Message-ID: <20111128154501.6009.18571.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
References: <20111128154436.6009.77586.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some useful PGP definitions from RFC 4880.  These describe details of
public key crypto as used by crypto keys for things like signature
verification.

Also add a simple parser that extracts the packets from a PGP blob and passes
the desirous ones to the given processor function:

	struct pgp_parse_context {
		u64 types_of_interest;
		int (*process_packet)(struct pgp_parse_context *context,
				      enum pgp_packet_tag type,
				      u8 headerlen,
				      const u8 *data,
				      size_t datalen);
	};

	int pgp_parse_packets(const u8 *data, size_t datalen,
			      struct pgp_parse_context *ctx);

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/pgp.h       |  230 +++++++++++++++++++++++++++++++++++++++++
 security/keys/pgp_parse.c |  254 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 484 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pgp.h
 create mode 100644 security/keys/pgp_parse.c


diff --git a/include/linux/pgp.h b/include/linux/pgp.h
new file mode 100644
index 0000000..7e86a06
--- /dev/null
+++ b/include/linux/pgp.h
@@ -0,0 +1,230 @@
+/* PGP definitions (RFC 4880)
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_PGP_H
+#define _LINUX_PGP_H
+
+#include <linux/types.h>
+
+struct pgp_key_ID {
+	u8 id[8];
+};
+
+struct pgp_time {
+	u8 time[4];
+};
+
+/*
+ * PGP public-key algorithm identifiers [RFC4880: 9.1]
+ */
+enum pgp_pubkey_algo {
+	PGP_PUBKEY_RSA_ENC_OR_SIG	= 1,
+	PGP_PUBKEY_RSA_ENC_ONLY		= 2,
+	PGP_PUBKEY_RSA_SIG_ONLY		= 3,
+	PGP_PUBKEY_ELGAMAL		= 16,
+	PGP_PUBKEY_DSA			= 17,
+};
+
+/*
+ * PGP symmetric-key algorithm identifiers [RFC4880: 9.2]
+ */
+enum pgp_symkey_algo {
+	PGP_SYMKEY_PLAINTEXT		= 0,
+	PGP_SYMKEY_IDEA			= 1,
+	PGP_SYMKEY_3DES			= 2,
+	PGP_SYMKEY_CAST5		= 3,
+	PGP_SYMKEY_BLOWFISH		= 4,
+	PGP_SYMKEY_AES_128KEY		= 7,
+	PGP_SYMKEY_AES_192KEY		= 8,
+	PGP_SYMKEY_AES_256KEY		= 9,
+	PGP_SYMKEY_TWOFISH_256KEY	= 10,
+};
+
+/*
+ * PGP compression algorithm identifiers [RFC4880: 9.3]
+ */
+enum pgp_compr_algo {
+	PGP_COMPR_UNCOMPRESSED		= 0,
+	PGP_COMPR_ZIP			= 1,
+	PGP_COMPR_ZLIB			= 2,
+	PGP_COMPR_BZIP2			= 3,
+};
+
+/*
+ * PGP hash algorithm identifiers [RFC4880: 9.4]
+ */
+enum pgp_hash_algo {
+	PGP_HASH_MD5			= 1,
+	PGP_HASH_SHA1			= 2,
+	PGP_HASH_RIPE_MD_160		= 3,
+	PGP_HASH_SHA256			= 8,
+	PGP_HASH_SHA384			= 9,
+	PGP_HASH_SHA512			= 10,
+	PGP_HASH_SHA224			= 11,
+	PGP_HASH__LAST
+};
+
+extern const char *const pgp_hash_algorithms[PGP_HASH__LAST];
+
+/*
+ * PGP packet type tags [RFC4880: 4.3].
+ */
+enum pgp_packet_tag {
+	PGP_PKT_RESERVED		= 0,
+	PGP_PKT_PUBKEY_ENC_SESSION_KEY	= 1,
+	PGP_PKT_SIGNATURE		= 2,
+	PGP_PKT_SYMKEY_ENC_SESSION_KEY	= 3,
+	PGP_PKT_ONEPASS_SIGNATURE	= 4,
+	PGP_PKT_SECRET_KEY		= 5,
+	PGP_PKT_PUBLIC_KEY		= 6,
+	PGP_PKT_SECRET_SUBKEY		= 7,
+	PGP_PKT_COMPRESSED_DATA		= 8,
+	PGP_PKT_SYM_ENC_DATA		= 9,
+	PGP_PKT_MARKER			= 10,
+	PGP_PKT_LITERAL_DATA		= 11,
+	PGP_PKT_TRUST			= 12,
+	PGP_PKT_USER_ID			= 13,
+	PGP_PKT_PUBLIC_SUBKEY		= 14,
+	PGP_PKT_USER_ATTRIBUTE		= 17,
+	PGP_PKT_SYM_ENC_AND_INTEG_DATA	= 18,
+	PGP_PKT_MODIFY_DETECT_CODE	= 19,
+	PGP_PKT_PRIVATE_0		= 60,
+	PGP_PKT_PRIVATE_3		= 63,
+	PGP_PKT__HIGHEST		= 63
+};
+
+/*
+ * Signature (tag 2) packet [RFC4880: 5.2].
+ */
+enum pgp_signature_version {
+	PGP_SIG_VERSION_3			= 3,
+	PGP_SIG_VERSION_4			= 4,
+};
+
+enum pgp_signature_type {
+	PGP_SIG_BINARY_DOCUMENT_SIG		= 0x00,
+	PGP_SIG_CANONICAL_TEXT_DOCUMENT_SIG	= 0x01,
+	PGP_SIG_STANDALONE_SIG			= 0x02,
+	PGP_SIG_GENERAL_CERT_OF_UID_PUBKEY	= 0x10,
+	PGP_SIG_PERSONAL_CERT_OF_UID_PUBKEY	= 0x11,
+	PGP_SIG_CASUAL_CERT_OF_UID_PUBKEY	= 0x12,
+	PGP_SIG_POSTITIVE_CERT_OF_UID_PUBKEY	= 0x13,
+	PGP_SIG_SUBKEY_BINDING_SIG		= 0x18,
+	PGP_SIG_PRIMARY_KEY_BINDING_SIG		= 0x19,
+	PGP_SIG_DIRECTLY_ON_KEY			= 0x1F,
+	PGP_SIG_KEY_REVOCATION_SIG		= 0x20,
+	PGP_SIG_SUBKEY_REVOCATION_SIG		= 0x28,
+	PGP_SIG_CERT_REVOCATION_SIG		= 0x30,
+	PGP_SIG_TIMESTAMP_SIG			= 0x40,
+	PGP_SIG_THIRD_PARTY_CONFIRM_SIG		= 0x50,
+};
+
+struct pgp_signature_v3_packet {
+	enum pgp_signature_version version : 8; /* == PGP_SIG_VERSION_3 */
+	u8	length_of_hashed;	/* == 5 */
+	struct {
+		enum pgp_signature_type signature_type : 8;
+		struct pgp_time	creation_time;
+	} hashed;
+	struct pgp_key_ID issuer;
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	enum pgp_hash_algo hash_algo : 8;
+};
+
+struct pgp_signature_v4_packet {
+	enum pgp_signature_version version : 8;	/* == PGP_SIG_VERSION_4 */
+	enum pgp_signature_type signature_type : 8;
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	enum pgp_hash_algo hash_algo : 8;
+};
+
+/*
+ * V4 signature subpacket types [RFC4880: 5.2.3.1].
+ */
+enum pgp_sig_subpkt_type {
+	PGP_SIG_CREATION_TIME			= 2,
+	PGP_SIG_EXPIRATION_TIME			= 3,
+	PGP_SIG_EXPORTABLE_CERT			= 4,
+	PGP_SIG_TRUST_SIG			= 5,
+	PGP_SIG_REGEXP				= 6,
+	PGP_SIG_REVOCABLE			= 7,
+	PGP_SIG_KEY_EXPIRATION_TIME		= 9,
+	PGP_SIG_PREF_SYM_ALGO			= 11,
+	PGP_SIG_REVOCATION_KEY			= 12,
+	PGP_SIG_ISSUER				= 16,
+	PGP_SIG_NOTATION_DATA			= 20,
+	PGP_SIG_PREF_HASH_ALGO			= 21,
+	PGP_SIG_PREF_COMPR_ALGO			= 22,
+	PGP_SIG_KEY_SERVER_PREFS		= 23,
+	PGP_SIG_PREF_KEY_SERVER			= 24,
+	PGP_SIG_PRIMARY_USER_ID			= 25,
+	PGP_SIG_POLICY_URI			= 26,
+	PGP_SIG_KEY_FLAGS			= 27,
+	PGP_SIG_SIGNERS_USER_ID			= 28,
+	PGP_SIG_REASON_FOR_REVOCATION		= 29,
+	PGP_SIG_FEATURES			= 30,
+	PGP_SIG_TARGET				= 31,
+	PGP_SIG_EMBEDDED_SIG			= 32,
+	PGP_SIG__LAST
+};
+
+#define PGP_SIG_SUBPKT_TYPE_CRITICAL_MASK	0x80
+
+/*
+ * Key (tag 5, 6, 7 and 14) packet
+ */
+enum pgp_key_version {
+	PGP_KEY_VERSION_2			= 2,
+	PGP_KEY_VERSION_3			= 3,
+	PGP_KEY_VERSION_4			= 4,
+};
+
+struct pgp_key_v3_packet {
+	enum pgp_key_version version : 8;
+	struct pgp_time	creation_time;
+	u8 expiry[2];				/* 0 or time in days till expiry */
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	u8 key_material[0];
+};
+
+struct pgp_key_v4_packet {
+	enum pgp_key_version version : 8;
+	struct pgp_time	creation_time;
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	u8 key_material[0];
+};
+
+/*
+ * PGP packet parser
+ */
+struct pgp_parse_context {
+	u64 types_of_interest;
+	int (*process_packet)(struct pgp_parse_context *context,
+			      enum pgp_packet_tag type,
+			      u8 headerlen,
+			      const u8 *data,
+			      size_t datalen);
+};
+
+extern int pgp_parse_packets(const u8 *data, size_t datalen,
+			     struct pgp_parse_context *ctx);
+
+struct pgp_parse_pubkey {
+	enum pgp_key_version version : 8;
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	time_t		creation_time;
+	time_t		expires_at;
+};
+
+extern int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
+				struct pgp_parse_pubkey *pk);
+
+#endif /* _LINUX_PGP_H */
diff --git a/security/keys/pgp_parse.c b/security/keys/pgp_parse.c
new file mode 100644
index 0000000..fb8d64a
--- /dev/null
+++ b/security/keys/pgp_parse.c
@@ -0,0 +1,254 @@
+/* PGP packet parser (RFC 4880)
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#define pr_fmt(fmt) "PGP: "fmt
+#include <linux/pgp.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+MODULE_LICENSE("GPL");
+
+const char *const pgp_hash_algorithms[PGP_HASH__LAST] = {
+	[PGP_HASH_MD5]			= "md5",
+	[PGP_HASH_SHA1]			= "sha1",
+	[PGP_HASH_RIPE_MD_160]		= "rmd160",
+	[PGP_HASH_SHA256]		= "sha256",
+	[PGP_HASH_SHA384]		= "sha384",
+	[PGP_HASH_SHA512]		= "sha512",
+	[PGP_HASH_SHA224]		= "sha224",
+};
+EXPORT_SYMBOL_GPL(pgp_hash_algorithms);
+
+/**
+ * pgp_parse_packet_header - Parse a PGP packet header
+ * @_data: Start of the PGP packet (updated to PGP packet data)
+ * @_datalen: Amount of data remaining in buffer (decreased)
+ * @_type: Where the packet type will be returned
+ * @_headerlen: Where the header length will be returned
+ *
+ * Parse a set of PGP packet header [RFC 4880: 4.2].
+ *
+ * Returns packet data size on success; non-zero on error.  If successful,
+ * *_data and *_datalen will have been updated and *_headerlen will be set to
+ * hold the length of the packet header.
+ */
+ssize_t pgp_parse_packet_header(const u8 **_data, size_t *_datalen,
+				enum pgp_packet_tag *_type,
+				u8 *_headerlen)
+{
+	enum pgp_packet_tag type;
+	const u8 *data = *_data;
+	size_t size, datalen = *_datalen;
+
+	pr_devel("-->pgp_parse_packet_header(,%zu,,)", datalen);
+
+	if (datalen < 2)
+		goto short_packet;
+
+	pr_devel("pkthdr %02x, %02x\n", data[0], data[1]);
+
+	type = *data++;
+	datalen--;
+	if (!(type & 0x80)) {
+		pr_warning("Packet type does not have MSB set\n");
+		return -EBADMSG;
+	}
+	type &= ~0x80;
+
+	if (type & 0x40) {
+		/* New packet length format */
+		type &= ~0x40;
+		pr_devel("new format: t=%u\n", type);
+		switch (data[0]) {
+		case 0x00 ... 0xbf:
+			/* One-byte length */
+			size = data[0];
+			data++;
+			datalen--;
+			*_headerlen = 2;
+			break;
+		case 0xc0 ... 0xdf:
+			/* Two-byte length */
+			if (datalen < 2)
+				goto short_packet;
+			size = (data[0] - 192) * 256;
+			size += data[1] + 192;
+			data += 2;
+			datalen -= 2;
+			*_headerlen = 3;
+			break;
+		case 0xff:
+			pr_warning("Five-byte packet length not supported\n");
+			return -EBADMSG;
+		default:
+			pr_warning("Error parsing packet length\n");
+			return -EBADMSG;
+		}
+	} else {
+		/* Old packet length format */
+		u8 length_type = type & 0x03;
+		type >>= 2;
+		pr_devel("old format: t=%u lt=%u\n", type, length_type);
+
+		switch (length_type) {
+		case 0:
+			/* One-byte length */
+			size = data[0];
+			data++;
+			datalen--;
+			*_headerlen = 2;
+			break;
+		case 1:
+			/* Two-byte length */
+			if (datalen < 2)
+				goto short_packet;
+			size  = data[0] << 8;
+			size |= data[1];
+			data += 2;
+			datalen -= 2;
+			*_headerlen = 3;
+			break;
+		case 2:
+			/* Four-byte length */
+			if (datalen < 4)
+				goto short_packet;
+			size  = data[0] << 24;
+			size |= data[1] << 16;
+			size |= data[2] << 8;
+			size |= data[3];
+			data += 4;
+			datalen -= 4;
+			*_headerlen = 5;
+			break;
+		default:
+			pr_warning("Indefinite length packet not supported\n");
+			return -EBADMSG;
+		}
+	}
+
+	pr_devel("datalen=%zu size=%zu", datalen, size);
+	if (datalen < size)
+		goto short_packet;
+
+	*_data = data;
+	*_datalen = datalen;
+	*_type = type;
+	pr_devel("Found packet type=%u size=%zd\n", type, size);
+	return size;
+
+short_packet:
+	pr_warning("Attempt to parse short packet\n");
+	return -EBADMSG;
+}
+
+/**
+ * pgp_parse_packets - Parse a set of PGP packets
+ * @_data: Data to be parsed (updated)
+ * @_datalen: Amount of data (updated)
+ * @ctx: Parsing context
+ *
+ * Parse a set of PGP packets [RFC 4880: 4].
+ */
+int pgp_parse_packets(const u8 *data, size_t datalen,
+		      struct pgp_parse_context *ctx)
+{
+	enum pgp_packet_tag type;
+	ssize_t pktlen;
+	u8 headerlen;
+	int ret;
+
+	while (datalen > 2) {
+		pktlen = pgp_parse_packet_header(&data, &datalen, &type,
+						 &headerlen);
+		if (pktlen < 0)
+			return pktlen;
+
+		if ((ctx->types_of_interest >> type) & 1) {
+			ret = ctx->process_packet(ctx, type, headerlen,
+						  data, pktlen);
+			if (ret < 0)
+				return ret;
+		}
+		data += pktlen;
+		datalen -= pktlen;
+	}
+
+	if (datalen != 0) {
+		pr_warning("Excess octets in packet stream\n");
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_packets);
+
+/**
+ * pgp_parse_public_key - Parse the common part of a PGP pubkey packet
+ * @_data: Content of packet (updated)
+ * @_datalen: Length of packet remaining (updated)
+ * @pk: Public key data
+ *
+ * Parse the common data struct for a PGP pubkey packet [RFC 4880: 5.5.2].
+ */
+int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
+			 struct pgp_parse_pubkey *pk)
+{
+	const u8 *data = *_data;
+	size_t datalen = *_datalen;
+	__be32 tmp;
+
+	if (datalen < 12) {
+		pr_warning("Public key packet too short\n");
+		return -EBADMSG;
+	}
+
+	pk->version = *data++;
+	switch (pk->version) {
+	case PGP_KEY_VERSION_2:
+	case PGP_KEY_VERSION_3:
+	case PGP_KEY_VERSION_4:
+		break;
+	default:
+		pr_warning("Public key packet with unhandled version %d\n",
+			   pk->version);
+		return -EBADMSG;
+	}
+
+	tmp  = *data++ << 24;
+	tmp |= *data++ << 16;
+	tmp |= *data++ << 8;
+	tmp |= *data++;
+	pk->creation_time = tmp;
+	if (pk->version == PGP_KEY_VERSION_4) {
+		pk->expires_at = 0; /* Have to get it from the selfsignature */
+	} else {
+		unsigned short ndays;
+		ndays  = *data++ << 8;
+		ndays |= *data++;
+		if (ndays)
+			pk->expires_at = pk->creation_time + ndays * 86400UL;
+		else
+			pk->expires_at = 0;
+		datalen -= 2;
+	}
+
+	pk->pubkey_algo = *data++;
+	datalen -= 6;
+
+	pr_devel("%x,%x,%lx,%lx",
+		 pk->version, pk->pubkey_algo, pk->creation_time,
+		 pk->expires_at);
+
+	*_data = data;
+	*_datalen = datalen;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_public_key);

