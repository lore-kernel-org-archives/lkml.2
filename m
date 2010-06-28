Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0F1Dij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 23:38:39 -0400
Received: from sh.osrg.net ([192.16.179.4]:41798 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0F1Dih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 23:38:37 -0400
Date: Mon, 28 Jun 2010 12:37:56 +0900
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       grundler@parisc-linux.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] scsi: remove dma_is_consistent usage in 53c700
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1277651328.4366.7.camel@mulgrave.site>
References: <1277633423-5700-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1277651328.4366.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100628123503Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 28 Jun 2010 12:37:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jun 2010 10:08:48 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sun, 2010-06-27 at 19:10 +0900, FUJITA Tomonori wrote:
> > 53c700 is the only user of dma_is_consistent():
> > 
> > BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
> > 
> > The above code tries to see if the system can allocate coherent memory
> > or not. It's for some old systems that can't allocate coherent memory
> > at all (e.g some parisc systems).
> 
> Actually, that's not the right explanation.  The BUG_ON is because of an
> efficiency in the driver ... it's nothing to do with the architecture.
> 
> The driver uses a set of mailboxes, but for efficiency's sake, it packs
> them into a single coherent area and separates the different usages by a
> L1 cache stride).  On architectures capable of manufacturing coherent
> memory, this is a nice speed up in the DMA infrastructure.  However, for
> incoherent architectures, it's fatal if the dma coherence stride is
> greater than the L1 cache size, because now we'll get data corruption
> due to cacheline interference.  That's what the BUG_ON is checking for.

Sorry, I should have looked the details of the driver.

You are talking about the following tricks, right?

#define	MSG_ARRAY_SIZE	8
#define	MSGOUT_OFFSET	(L1_CACHE_ALIGN(sizeof(SCRIPT)))
	__u8	*msgout;
#define MSGIN_OFFSET	(MSGOUT_OFFSET + L1_CACHE_ALIGN(MSG_ARRAY_SIZE))
	__u8	*msgin;
#define STATUS_OFFSET	(MSGIN_OFFSET + L1_CACHE_ALIGN(MSG_ARRAY_SIZE))
	__u8	*status;
#define SLOTS_OFFSET	(STATUS_OFFSET + L1_CACHE_ALIGN(MSG_ARRAY_SIZE))
	struct NCR_700_command_slot	*slots;
#define	TOTAL_MEM_SIZE	(SLOTS_OFFSET + L1_CACHE_ALIGN(sizeof(struct NCR_700_command_slot) * NCR_700_COMMAND_SLOTS_PER_HOST))


> > I think that we can safely remove the above usage:
> > 
> > - such old systems haven't triger the above checking for long.
> > 
> > - the above condition is important for systems that can't allocate
> >   coherent memory if these systems do DMA. So probably it would be
> >   better to have such checking in arch's DMA initialization code
> >   instead of a driver.
> 
> Well, we can't check in the architecture because it's a driver specific
> thing ... I suppose making it a rule that dma_get_cache_alignment()
> *must* be <= L1_CACHE_BYTES fixes it ... we seem to have no architecture
> violating that, so just add it to the documentation, and the check can
> go.

Seems that on some architectures (arm and mips at least),
dma_get_cache_alignment() could greater than L1_CACHE_BYTES. But they
simply return the possible maximum size of cache size like:

static inline int dma_get_cache_alignment(void)
{
	/* XXX Largest on any MIPS */
	return 128;
}

So practically, we should be safe. I guess that we can simply convert
them to return L1_CACHE_BYTES.

Some PARISC and mips are only the fully non-coherent architectures
that we support now? We can remove the above checking if
dma_get_cache_alignment() is <= L1_CACHE_BYTES on PARISC and mips?
