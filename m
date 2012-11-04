Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2KDO3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 09:29:39 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49231 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2KDO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 09:29:36 -0500
Date: Sun, 4 Nov 2012 19:59:27 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
Message-ID: <20121104142927.GA4087@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-6-git-send-email-rabin@rab.in> <20121015165756.GA11737@redhat.com> <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com> <20121025145839.GB26929@redhat.com> <20121026055239.GA4862@in.ibm.com> <20121026163951.GA17742@redhat.com> <20121029053522.GC3400@in.ibm.com> <20121103163301.GA9496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103163301.GA9496@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110414-2398-0000-0000-00000D4C20D0
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00188395; UDB=6.00042665; UTC=2012-11-04
 14:29:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 05:33:01PM +0100, Oleg Nesterov wrote:
> On 10/29, Ananth N Mavinakayanahalli wrote:
> >
> > On Fri, Oct 26, 2012 at 06:39:51PM +0200, Oleg Nesterov wrote:
> > > >
> > > > > OTOH, I do not understand this stuff, everything is nop on x86. And
> > > > > when I look into Documentation/cachetlb.txt I am starting to think
> > > > > that may be this needs flush_icache_user_range instead?
> > > > >
> > > > > Rabin, Ananth could you clarify this?
> > > >
> > > > Yes. We need flush_icache_user_range(). Though for x86 its always been a
> > > > nop, one never knows if there is some Power4 or older machine out there
> > > > that is still being used. We are fine for Power5 and later.
> > >
> > > This is bad...
> > >
> > > flush_icache_user needs vma. perhaps just to check VM_EXEC...
> > >
> > > So let me repeat to be sure I really understand, do you confirm that
> > > _in general_ flush_dcache_page() is not enough?
> >
> > flush_dcache_page() on powerpc already checks for
> > CPU_FTR_COHERENT_ICACHE. So, yes, that is enough.
> 
> Thanks Ananth.
> 
> Still it is not clear to me if flush_dcache_page() would be always right
> if we add the new port.
> 
> OK. So I assume we need the fix and I am going to apply the patch below.
> 
> Ananth, Rabin, will you ack it (including the comment I affed) ?
> 
> Oleg.
> 
> ------------------------------------------------------------------------------
> [PATCH] uprobes: flush cache after xol write
> 
> From: Rabin Vincent <rabin@rab.in>
> 
> Flush the cache so that the instructions written to the XOL area are
> visible.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> 
> --- x/kernel/events/uprobes.c
> +++ x/kernel/events/uprobes.c
> @@ -1199,6 +1199,11 @@ static unsigned long xol_get_insn_slot(s
>  	vaddr = kmap_atomic(area->page);
>  	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
>  	kunmap_atomic(vaddr);
> +	/*
> +	 * We probably need flush_icache_user_range() but it needs vma.
> +	 * This should work on supported architectures too.
> +	 */
> +	flush_dcache_page(area->page);
> 
>  	return current->utask->xol_vaddr;
>  }

