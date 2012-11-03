Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2KCQcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:32:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab2KCQcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:32:20 -0400
Date: Sat, 3 Nov 2012 17:33:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
Message-ID: <20121103163301.GA9496@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-6-git-send-email-rabin@rab.in> <20121015165756.GA11737@redhat.com> <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com> <20121025145839.GB26929@redhat.com> <20121026055239.GA4862@in.ibm.com> <20121026163951.GA17742@redhat.com> <20121029053522.GC3400@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029053522.GC3400@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Ananth N Mavinakayanahalli wrote:
>
> On Fri, Oct 26, 2012 at 06:39:51PM +0200, Oleg Nesterov wrote:
> > >
> > > > OTOH, I do not understand this stuff, everything is nop on x86. And
> > > > when I look into Documentation/cachetlb.txt I am starting to think
> > > > that may be this needs flush_icache_user_range instead?
> > > >
> > > > Rabin, Ananth could you clarify this?
> > >
> > > Yes. We need flush_icache_user_range(). Though for x86 its always been a
> > > nop, one never knows if there is some Power4 or older machine out there
> > > that is still being used. We are fine for Power5 and later.
> >
> > This is bad...
> >
> > flush_icache_user needs vma. perhaps just to check VM_EXEC...
> >
> > So let me repeat to be sure I really understand, do you confirm that
> > _in general_ flush_dcache_page() is not enough?
>
> flush_dcache_page() on powerpc already checks for
> CPU_FTR_COHERENT_ICACHE. So, yes, that is enough.

Thanks Ananth.

Still it is not clear to me if flush_dcache_page() would be always right
if we add the new port.

OK. So I assume we need the fix and I am going to apply the patch below.

Ananth, Rabin, will you ack it (including the comment I affed) ?

Oleg.

------------------------------------------------------------------------------
[PATCH] uprobes: flush cache after xol write

From: Rabin Vincent <rabin@rab.in>

Flush the cache so that the instructions written to the XOL area are
visible.

Signed-off-by: Rabin Vincent <rabin@rab.in>

--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -1199,6 +1199,11 @@ static unsigned long xol_get_insn_slot(s
 	vaddr = kmap_atomic(area->page);
 	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
 	kunmap_atomic(vaddr);
+	/*
+	 * We probably need flush_icache_user_range() but it needs vma.
+	 * This should work on supported architectures too.
+	 */
+	flush_dcache_page(area->page);
 
 	return current->utask->xol_vaddr;
 }

