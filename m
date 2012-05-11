Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab2EKNag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:30:36 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57009 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2EKNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:30:34 -0400
X-Nat-Received: from [202.181.97.72]:50963 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1336743008.7726
To: dhowells@redhat.com
Cc: rusty@rustcorp.com.au, kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH 00/29] Crypto keys and module signing [ver #4]
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
Message-Id: <201205112230.EED65669.tQOVFMSOFOFHJL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 May 2012 22:30:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 11052012 #7965120, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+static int pgp_calc_pkey_keyid(struct shash_desc *digest,
+			       struct pgp_parse_pubkey *pgp,
+			       struct public_key *key)
+{
+	unsigned nb[ARRAY_SIZE(key->mpi)];
+	unsigned nn[ARRAY_SIZE(key->mpi)];
+	unsigned n;
+	u8 *pp[ARRAY_SIZE(key->mpi)];
+	u32 a32;
+	int npkey = key->algo->n_pub_mpi;
+	int i, ret = -ENOMEM;
+
+	kenter("");
+
+	n = (pgp->version < PGP_KEY_VERSION_4) ? 8 : 6;
+	for (i = 0; i < npkey; i++) {
+		nb[i] = mpi_get_nbits(key->mpi[i]);

Is key->algo->n_pub_mpi < ARRAY_SIZE(key->mpi) guaranteed?

+		pp[i] = mpi_get_buffer(key->mpi[i], nn + i, NULL);
+		if (!pp[i])
+			goto error;
+		n += 2 + nn[i];
+	}
+
+	digest_putc(digest, 0x99);     /* ctb */
+	digest_putc(digest, n >> 8);   /* 16-bit header length */
+	digest_putc(digest, n);
+	digest_putc(digest, pgp->version);
+
+	a32 = pgp->creation_time;
+	digest_putc(digest, a32 >> 24);
+	digest_putc(digest, a32 >> 16);
+	digest_putc(digest, a32 >>  8);
+	digest_putc(digest, a32 >>  0);
+
+	if (pgp->version < PGP_KEY_VERSION_4) {
+		u16 a16;
+
+		if( pgp->expires_at)

checkpatch.pl

+			a16 = (pgp->expires_at - pgp->creation_time) / 86400UL;
+		else
+			a16 = 0;
+		digest_putc(digest, a16 >> 8);
+		digest_putc(digest, a16 >> 0);
+	}
+
+	digest_putc(digest, pgp->pubkey_algo);
+
+	for (i = 0; i < npkey; i++) {
+		digest_putc(digest, nb[i] >> 8);
+		digest_putc(digest, nb[i]);
+		crypto_shash_update(digest, pp[i], nn[i]);
+	}
+	ret = 0;
+
+error:
+	for (i = 0; i < npkey; i++)
+		kfree(pp[i]);

Stack memory may not be initialized.

+	kleave(" = %d", ret);
+	return ret;
+}



+static int pgp_pkey_digest_signature(struct pgp_parse_context *context,
+				     enum pgp_packet_tag type,
+				     u8 headerlen,
+				     const u8 *data,
+				     size_t datalen)
+{
+	struct pgp_pkey_sig_digest_context *ctx =
+		container_of(context, struct pgp_pkey_sig_digest_context, pgp);
+	enum pgp_signature_version version;
+	int i;
+
+	kenter(",%u,%u,,%zu", type, headerlen, datalen);
+
+	version = *data;
+	if (version == PGP_SIG_VERSION_3) {
+		/* We just include an excerpt of the metadata from a V3
+		 * signature.
+		 */
+		crypto_shash_update(&ctx->sig->hash, data + 1, 5);
+		data += sizeof(struct pgp_signature_v3_packet);
+		datalen -= sizeof(struct pgp_signature_v3_packet);
+	} else if (version == PGP_SIG_VERSION_4) {
+		/* We add the whole metadata header and some of the hashed data
+		 * for a V4 signature, plus a trailer.
+		 */
+		size_t hashedsz, unhashedsz;
+		u8 trailer[6];
+
+		hashedsz = 4 + 2 + (data[4] << 8) + data[5];

Given the (datalen <= 2) check below, can we trust data[4,5] here?

+		crypto_shash_update(&ctx->sig->hash, data, hashedsz);
+
+		trailer[0] = version;
+		trailer[1] = 0xffU;
+		trailer[2] = hashedsz >> 24;
+		trailer[3] = hashedsz >> 16;
+		trailer[4] = hashedsz >> 8;
+		trailer[5] = hashedsz;
+
+		crypto_shash_update(&ctx->sig->hash, trailer, 6);
+		data += hashedsz;
+		datalen -= hashedsz;
+
+		unhashedsz = 2 + (data[0] << 8) + data[1];
+		data += unhashedsz;
+		datalen -= unhashedsz;
+	}
+
+	if (datalen <= 2) {
+		kleave(" = -EBADMSG");
+		return -EBADMSG;
+	}



+static int module_verify_canonicalise(struct module_verify_data *mvdata)
+{
+	const Elf_Shdr *sechdrs = mvdata->sections;
+	unsigned *canonlist, canon, loop, tmp;
+	bool changed;
+
+	canonlist = kmalloc(sizeof(unsigned) * mvdata->nsects * 2, GFP_KERNEL);
+	if (!canonlist)
+		return -ENOMEM;

Can mvdata->nsects == (UINT_MAX + 1) / (sizeof(unsigned) * 2) due to size_t?
I think we want kmalloc() variant that does not return ZERO_SIZE_PTR.
