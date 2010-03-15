Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965790Ab0COT1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:27:55 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:58891 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965760Ab0COT1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:27:51 -0400
Date: Mon, 15 Mar 2010 21:28:13 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Micha?? Nazarewicz <m.nazarewicz@samsung.com>
Cc: me@felipebalbi.com, linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] USB: f_mass_storage: dynamic buffers for better
 alignment
Message-ID: <20100315192812.GE25452@gandalf>
Reply-To: me@felipebalbi.com
References: <1268647795-4095-1-git-send-email-m.nazarewicz@samsung.com>
 <20100315181020.GD3857@gandalf>
 <op.u9minutl7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.u9minutl7p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 08:20:08PM +0100, Micha?? Nazarewicz wrote:
> > On Mon, Mar 15, 2010 at 11:09:55AM +0100, Michal Nazarewicz wrote:
> >> "Static" buffers in fsg_buffhd structure (ie. fields which are arrays
> >> rather then pointers to dynamically allocated memory) are not aligned
> >> to any "big" power of two which may lead to poor DMA performance
> 
> On Mon, 15 Mar 2010 19:10:21 +0100, Felipe Balbi <me@felipebalbi.com> wrote:
> > not so true as you can add __attribute__ ((aligned(32))) to those.
> 
> I admit, I haven't thought about that.  Some fields rearrangement
> could help avoid some padding but yes, it can be done.
> 
> However, there is one more thing I've had in mind.  Each buffer
> is 4 pages (16 KiB) and there are two such buffers in struct
> fsg_common therefore the whole size of the structure is
> 9 pages (> 32 KiB).
> 
> I've been simply concerned about using kamlloc() for such big
> structures so in the end decided to split it into 3 allocations.
> 
> Maybe I'm overeating though?  Or maybe vmalloc() would solve those
> problems?  But then again, vmalloc() could degrade DMA performance
> on systems w/o scatter-gather.
> 
> What do you think?

I have no opinion anymore :-p

I can only think about the devices I've been working on which would be a
pain to allocate so much memory and would suffer if you use vmalloc()
too, so both would be a no-no for me :-p

> 	bh = common->buffhds;
> 	rc = -ENOMEM;
> 	i = FSG_NUM_BUFFERS;
> 	for(;;) {
> 		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
> 		if (unlikely(!bh->buf))
> 			goto error_release;
> 		if (!--i)
> 			break;
> 		bh->next = bh + 1;
> 		++bh;
> 	}
> 	bh->next = common->buffhds;
> 
> What do you think?

how about ?

for (i = FSG_NUM_BUFFER; i; i--, ++bh) {
	bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
	if (!bh->buf)
		goto error_release;
}

-- 
balbi
