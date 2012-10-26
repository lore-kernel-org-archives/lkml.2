Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2JZFwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 01:52:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41543 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab2JZFwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 01:52:46 -0400
Date: Fri, 26 Oct 2012 11:22:39 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
Message-ID: <20121026055239.GA4862@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-6-git-send-email-rabin@rab.in> <20121015165756.GA11737@redhat.com> <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com> <20121025145839.GB26929@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025145839.GB26929@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102605-5518-0000-0000-000008BC6530
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 04:58:39PM +0200, Oleg Nesterov wrote:
> On 10/16, Rabin Vincent wrote:
> >
> > 2012/10/15 Oleg Nesterov <oleg@redhat.com>:
> > > On 10/14, Rabin Vincent wrote:
> > >> Flush the cache so that the instructions written to the XOL area are
> > >> visible.
> > >>
> > >> Signed-off-by: Rabin Vincent <rabin@rab.in>
> > >> ---
> > >>  kernel/events/uprobes.c |    1 +
> > >>  1 file changed, 1 insertion(+)
> > >>
> > >> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > >> index ca000a9..8c52f93 100644
> > >> --- a/kernel/events/uprobes.c
> > >> +++ b/kernel/events/uprobes.c
> > >> @@ -1246,6 +1246,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
> > >>       offset = current->utask->xol_vaddr & ~PAGE_MASK;
> > >>       vaddr = kmap_atomic(area->page);
> > >>       arch_uprobe_xol_copy(&uprobe->arch, vaddr + offset);
> > >> +     flush_dcache_page(area->page);
> > >>       kunmap_atomic(vaddr);
> > >
> > > I agree... but why under kmap_atomic?
> >
> > No real reason; I'll move it to after the unmap.
> 
> OK. I assume you will send v2.
> 
> But this patch looks like a bugfix, flush_dcache_page() is not a nop
> on powerpc. So perhaps we should apply this fix right now?

Starting Power5, all Power processers have coherent caches.

> OTOH, I do not understand this stuff, everything is nop on x86. And
> when I look into Documentation/cachetlb.txt I am starting to think
> that may be this needs flush_icache_user_range instead?
>
> Rabin, Ananth could you clarify this?

Yes. We need flush_icache_user_range(). Though for x86 its always been a
nop, one never knows if there is some Power4 or older machine out there
that is still being used. We are fine for Power5 and later.

Ananth

