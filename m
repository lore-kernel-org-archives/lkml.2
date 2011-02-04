Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1BDBV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:21:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab1BDBVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:21:25 -0500
Date: Fri, 4 Feb 2011 02:21:09 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] x86: hold mm->page_table_lock while doing vmalloc_sync
Message-ID: <20110204012109.GP5843@random.random>
References: <4CB76E8B.2090309@goop.org>
 <4CC0AB73.8060609@goop.org>
 <20110203024838.GI5843@random.random>
 <4D4B1392.5090603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4B1392.5090603@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 12:44:02PM -0800, Jeremy Fitzhardinge wrote:
> On 02/02/2011 06:48 PM, Andrea Arcangeli wrote:
> > Hello,
> >
> > Larry (CC'ed) found a problem with the patch in subject. When
> > USE_SPLIT_PTLOCKS is not defined (NR_CPUS == 2) it will deadlock in
> > ptep_clear_flush_notify in rmap.c because it's sending IPIs with the
> > page_table_lock already held, and the other CPUs now spins on the
> > page_table_lock with irq disabled, so the IPI never runs. With
> > CONFIG_TRANSPARENT_HUGEPAGE=y this deadlocks happens even with
> > USE_SPLIT_PTLOCKS defined so it become visible but it needs to be
> > fixed regardless (for NR_CPUS == 2).
> 
> What's "it" here?  Do you mean vmalloc_sync_all?  vmalloc_sync_one?
> What's the callchain?

Larry just answered to that. If something is unclear let me know. I
never reproduced it, but it also can happen without THP enabled, you
just need to set NR_CPUS to 2 during "make menuconfig".

> > spin_lock_irqsave(pgd_lock) so I guess it's either common code, or
> > it's superfluous and not another Xen special requirement.
> 
> There's no special Xen requirement here.

That was my thought too considering the other archs...

> mmdrop() can be called from interrupt context, but I don't know if it
> will ever drop the last reference from interrupt, so maybe you can get
> away with it.

Yes the issue is __mmdrop, so it'd be nice to figure if __mmdrop can
also run from irq (or only mmdrop fast path which would be safe even
without _irqsave).

Is this a Xen only thing? Or is mmdrop called from regular
linux. Considering other archs also _irqsave I assume it's common code
calling mmdrop (otherwise it means they cut-and-pasted a Xen
dependency). This comment doesn't really tell me much.

static void pgd_dtor(pgd_t *pgd)
{
	unsigned long flags; /* can be called from interrupt context 	*/

	if (SHARED_KERNEL_PMD)
	   return;

	   VM_BUG_ON(in_interrupt());
	   spin_lock(&pgd_lock);

This comment tells the very __mmdrop can be called from irq context,
not just mmdrop. But I didn't find where yet... Can you tell me?

> > @@ -247,7 +248,7 @@ void vmalloc_sync_all(void)
> >  			if (!ret)
> >  				break;
> >  		}
> > -		spin_unlock_irqrestore(&pgd_lock, flags);
> > +		spin_unlock(&pgd_lock, flags);
> 
> Urp.  Did this compile?

Yes it builds and it also runs fine still (I left it running since I
posted the email and no problems yet, but this may not be reproducible
and we really need to know who calls __mmdrop from irq context to
tell). The above is under CONFIG_X86_32 and I did a 64bit build ;).

I'm not reposting a version that builds for 32bit x86 too until we
figure out the mmdrop thing...

Thanks,
Andrea
