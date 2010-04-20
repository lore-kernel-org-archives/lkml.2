Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0DTE2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:28:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34173 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab0DTE2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:28:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Apr 2010 13:24:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: error at compaction (Re: mmotm 2010-04-15-14-42 uploaded
Message-Id: <20100420132429.1049ca84.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <g2x28c262361004192058y64f4d316qcb1547909168e31f@mail.gmail.com>
References: <201004152210.o3FMA7KV001909@imap1.linux-foundation.org>
	<20100419190133.50a13021.kamezawa.hiroyu@jp.fujitsu.com>
	<20100419181442.GA19264@csn.ul.ie>
	<20100419193919.GB19264@csn.ul.ie>
	<s2v28c262361004191939we64e5490ld59b21dc4fa5bc8d@mail.gmail.com>
	<20100420120753.b161dea9.kamezawa.hiroyu@jp.fujitsu.com>
	<g2x28c262361004192058y64f4d316qcb1547909168e31f@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 12:58:43 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, Apr 20, 2010 at 12:07 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Tue, 20 Apr 2010 11:39:46 +0900
> >> Dumb question. Why can't we call arch_alloc_page and kernel_map_pages
> >> as interrupt disabled? It's deadlock issue or latency issue?
> >> I don't found any comment about it.
> >> It should have added the comment around that functions. :)
> >>
> >
> > I guess it's from the same reason as vfree(), which can't be called under
> > irq-disabled.
> >
> > Both of them has to flush TLB of all cpus. At flushing TLB (of other cpus), cpus has
> > to send IPI via smp_call_function. What I know from old stories is below.
> >
> > At sendinf IPI, usual sequence is following. (This may be old.)
> >
> >        spin_lock(&ipi_lock);
> >                set up cpu mask for getting notification from other cpu for declearing
> >                "I received IPI and finished my own work".
> >        spin_unlock(&ipi_lock);
> >
> > Then,
> >          CPU0                             CPU1
> >
> >    irq_disable (somewhere)             spin_lock
> >                                        send IPI and wait for notification.
> >    spin_lock()
> >
> > deadlock.  Seeing decription of kernel/smp.c::smp_call_function_many(), it says
> > this function should not be called under irq-disabled.
> > (Maybe the same kind of spin-wait deadlock can happen.)
> >
> 
> Thanks for kind explanation.
> Actually I guessed TLB issue but I can't find any glue point which
> connect tlb flush to smp_call_function_xxx. :(
> 
> Now look at the __native_flush_tlb_global.
> It just read and write cr4 with just mask off X86_CR4_PGE.
> So i don't know how connect this and smp_schedule_xxxx.
> Hmm,, maybe APIC?
> 
> Sorry for dumb question.
> 
Hmm...seeing again,

arch/x86/mm/pageattr.c::kernel_map_pages() says:

1293         /*
1294          * We should perform an IPI and flush all tlbs,
1295          * but that can deadlock->flush only current cpu:
1296          */

Wow. It just flush only local cpu. Then, no IPI.

Hmm...all other archs does the same thing ? If so, kernel_map_pages()
can be called under irq_disabled. The author of kernel_map_pages() 
is aware that this can be called under irq-disabled.

Hmm...

Thanks,
-Kame






