Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352Ab2EKOc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760105Ab2EKOcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:32:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201205112230.EED65669.tQOVFMSOFOFHJL@I-love.SAKURA.ne.jp>
References: <201205112230.EED65669.tQOVFMSOFOFHJL@I-love.SAKURA.ne.jp> <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 00/29] Crypto keys and module signing [ver #4]
Date: Fri, 11 May 2012 15:32:03 +0100
Message-ID: <11253.1336746723@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:

> +	int npkey = key->algo->n_pub_mpi;
> +	int i, ret = -ENOMEM;
> +
> +	kenter("");
> +
> +	n = (pgp->version < PGP_KEY_VERSION_4) ? 8 : 6;
> +	for (i = 0; i < npkey; i++) {
> +		nb[i] = mpi_get_nbits(key->mpi[i]);
> 
> Is key->algo->n_pub_mpi < ARRAY_SIZE(key->mpi) guaranteed?

Yes.  It's hard-coded in the public_key_algorithm struct - for instance the
one to be found at the bottom of security/keys/crypto_rsa.c.

We also check for an excessive quantity of MPIs in pgp_process_public_key().

> +		if( pgp->expires_at)
> 
> checkpatch.pl

Fixed some of those.

> +error:
> +	for (i = 0; i < npkey; i++)
> +		kfree(pp[i]);
> 
> Stack memory may not be initialized.

Fair point.

> +		hashedsz = 4 + 2 + (data[4] << 8) + data[5];
> 
> Given the (datalen <= 2) check below, can we trust data[4,5] here?

We've already done some length and content checking on the signature data.  In
the module verification case, this happens:

 (1) module_verify_sig() has already passed the signature data to
     verify_sig_begin(),

 (2) which passed it to pgp_pkey_verify_sig_begin(),

 (3) which invoked pgp_parse_packets(),

 (4) which called back to pgp_pkey_parse_signature(),

 (5) which then invoked pgp_parse_sig_params() which did sufficient length
     checking to make sure we're okay here.

by the time we get to pgp_pkey_digest_signature() we're at the end of the
process (in verify_sig_end()).

The trailer, however, is not checked at that point - though I suppose it
probably should be.  There isn't currently an MPI function to do just a check
rather than an extraction.

I can add comments to this effect if you think it would help reduce confusion.

> +static int module_verify_canonicalise(struct module_verify_data *mvdata)
> +{
> +	const Elf_Shdr *sechdrs = mvdata->sections;
> +	unsigned *canonlist, canon, loop, tmp;
> +	bool changed;
> +
> +	canonlist = kmalloc(sizeof(unsigned) * mvdata->nsects * 2, GFP_KERNEL);
> +	if (!canonlist)
> +		return -ENOMEM;
> 
> Can mvdata->nsects == (UINT_MAX + 1) / (sizeof(unsigned) * 2) due to size_t?
> I think we want kmalloc() variant that does not return ZERO_SIZE_PTR.

This line should prevent that:

	elfcheck(hdr->e_shnum < SHN_LORESERVE);

given:

	#define SHN_LORESERVE	0xff00

Thanks for the thorough review!

David
