Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2J2Ffa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 01:35:30 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54223 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2J2Ff2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 01:35:28 -0400
Date: Mon, 29 Oct 2012 11:05:22 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
Message-ID: <20121029053522.GC3400@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-6-git-send-email-rabin@rab.in> <20121015165756.GA11737@redhat.com> <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com> <20121025145839.GB26929@redhat.com> <20121026055239.GA4862@in.ibm.com> <20121026163951.GA17742@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026163951.GA17742@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102905-5112-0000-0000-00000DF38C2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 06:39:51PM +0200, Oleg Nesterov wrote:
> On 10/26, Ananth N Mavinakayanahalli wrote:
> >
> > On Thu, Oct 25, 2012 at 04:58:39PM +0200, Oleg Nesterov wrote:
> > > On 10/16, Rabin Vincent wrote:
> > > >
> > > > >> --- a/kernel/events/uprobes.c
> > > > >> +++ b/kernel/events/uprobes.c
> > > > >> @@ -1246,6 +1246,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
> > > > >>       offset = current->utask->xol_vaddr & ~PAGE_MASK;
> > > > >>       vaddr = kmap_atomic(area->page);
> > > > >>       arch_uprobe_xol_copy(&uprobe->arch, vaddr + offset);
> > > > >> +     flush_dcache_page(area->page);
> > > > >>       kunmap_atomic(vaddr);
> > > > >
> > > > > I agree... but why under kmap_atomic?
> > > >
> > > > No real reason; I'll move it to after the unmap.
> > >
> > > OK. I assume you will send v2.
> > >
> > > But this patch looks like a bugfix, flush_dcache_page() is not a nop
> > > on powerpc. So perhaps we should apply this fix right now?
> >
> > Starting Power5, all Power processers have coherent caches.
> >
> > > OTOH, I do not understand this stuff, everything is nop on x86. And
> > > when I look into Documentation/cachetlb.txt I am starting to think
> > > that may be this needs flush_icache_user_range instead?
> > >
> > > Rabin, Ananth could you clarify this?
> >
> > Yes. We need flush_icache_user_range(). Though for x86 its always been a
> > nop, one never knows if there is some Power4 or older machine out there
> > that is still being used. We are fine for Power5 and later.
> 
> This is bad...
> 
> flush_icache_user needs vma. perhaps just to check VM_EXEC...
> 
> So let me repeat to be sure I really understand, do you confirm that
> _in general_ flush_dcache_page() is not enough?

flush_dcache_page() on powerpc already checks for
CPU_FTR_COHERENT_ICACHE. So, yes, that is enough.

Ananth

