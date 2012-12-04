Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2LDXjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 18:39:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2LDXjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 18:39:13 -0500
Date: Tue, 4 Dec 2012 15:39:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] aoe: improve handling of misbehaving network paths
Message-Id: <20121204153912.2e6b4d2f.akpm@linux-foundation.org>
In-Reply-To: <f7df7cd5fe1a303debe7cbf086853663e3c59366.1354501189.git.ecashin@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
	<f7df7cd5fe1a303debe7cbf086853663e3c59366.1354501189.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012 20:40:55 -0500
Ed Cashin <ecashin@coraid.com> wrote:

> An AoE target can have multiple network ports used for AoE, and
> in the aoe driver, those are tracked by the aoetgt struct.  These
> changes allow the aoe driver to handle network paths, or aoetgts,
> that are not working well, compared to the others.
> 
> Paths that do not get responses despite the retransmission of AoE
> commands are marked as "tainted", and non-tainted paths are
> preferred.
> 
> Meanwhile, the aoe driver attempts to "probe" the tainted path in
> the background by issuing reads of LBA 0 that are padded out to
> full (possibly jumbo-frame) size.  If the probes get responses,
> then the path is "redeemed", and its taint is removed.
> 
> This mechanism has been shown to be helpful in transparently
> handling and recovering from real-world network "brown outs" in
> ways that the earlier "shoot the help-needing target in the head"
> mechanism could not.
> 
>
> ...
>
> +static void
> +ata_rw_frameinit(struct frame *f)
> +{
> +	struct aoetgt *t;
> +	struct aoe_hdr *h;
> +	struct aoe_atahdr *ah;
> +	struct sk_buff *skb;
> +	char writebit, extbit;
> +
> +	skb = f->skb;
> +	h = (struct aoe_hdr *) skb_mac_header(skb);
> +	ah = (struct aoe_atahdr *) (h + 1);

Well.  It would be neater to have a

struct whatever {
	struct aoe_hdr hdr;
	struct aoe_atahdr atahdr;
};

> +	skb_put(skb, sizeof(*h) + sizeof(*ah));
> +	memset(h, 0, skb->len);
> +
> +	writebit = 0x10;
> +	extbit = 0x4;
> +
>
> ...
>
> @@ -462,11 +488,14 @@ resend(struct aoedev *d, struct frame *f)
>  	h = (struct aoe_hdr *) skb_mac_header(skb);
>  	ah = (struct aoe_atahdr *) (h+1);
>  
> -	snprintf(buf, sizeof buf,
> -		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",
> -		"retransmit", d->aoemajor, d->aoeminor, f->tag, jiffies, n,
> -		h->src, h->dst, t->nout);
> -	aoechr_error(buf);
> +	if (!(f->flags & FFL_PROBE)) {
> +		snprintf(buf, sizeof(buf),
> +			"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x s=%pm d=%pm nout=%d\n",
> +			"retransmit", d->aoemajor, d->aoeminor,
> +			f->tag, jiffies, n,
> +			h->src, h->dst, t->nout);
> +		aoechr_error(buf);

Could use kasprintf() here.  That avoids the fixed-size local buffer
and avoids the GFP_ATOMIC allocation and copy in aoechr_error().

> +	}
>  
>  	f->tag = n;
>  	fhash(f);
>
> ...
>
>  aoecmd_init(void)
>  {
> +	void *p;
> +
> +	/* get_zeroed_page returns page with ref count 1 */
> +	p = (void *) get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
> +	if (!p)
> +		return -ENOMEM;
> +	empty_page = virt_to_page(p);

Could use alloc_pages() and remove `p' and the virt_to_page().

Why is __GFP_REPEAT used?  I don't think this __init function is more
important than all the other ones in the kernel?


>  	INIT_LIST_HEAD(&iocq.head);
>  	spin_lock_init(&iocq.lock);
>  	init_waitqueue_head(&ktiowq);
>
> ...
>

