Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956Ab0J2U2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:28:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64165 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761904Ab0J2U2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YUgU/DYJeeBNO2muDZ1LgOuHLNhhwzo/knJRvmz9QMKTvOVb2so6HNe8ST81ZLMSFH
         9NM466YXYfNGXsSs2oH7FEzPvzx7sAsGbd3dJeeXd6nbNeBqdCypp9osFivnXpX3c0rj
         e0z49Ym0Hfi2Ru3mCgDnm62XpLlBQ5QB85B4Q=
Date: Sat, 30 Oct 2010 00:28:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware
	allocations
Message-ID: <20101029202809.GB6130@lenovo>
References: <1288276854.2649.607.camel@edumazet-laptop> <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org> <1288377146.1988.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288377146.1988.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 08:32:26PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 06:43 +0000, tip-bot for Eric Dumazet wrote:
> > +       irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> > +                                              THREAD_FLAGS,
> > +                                              THREAD_ORDER)); 
> 
> Shouldn't we be checking for a NULL return from alloc_pages_node()
> before calling page_address() on it?
> --

 Something like below I guess, but probably we could try to allocate
on appropriate NUMA node first and if it fails -- via old alloc_pages
and if it fail in turn -- then we panic.

  Cyrill
---
 arch/x86/kernel/irq_32.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irq_32.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6.git/arch/x86/kernel/irq_32.c
@@ -122,13 +122,16 @@ execute_on_irq_stack(int overflow, struc
 void __cpuinit irq_ctx_init(int cpu)
 {
 	union irq_ctx *irqctx;
+	struct page *page;
 
 	if (per_cpu(hardirq_ctx, cpu))
 		return;
 
-	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
-					       THREAD_FLAGS,
-					       THREAD_ORDER));
+	page = alloc_pages_node(cpu_to_node(cpu),
+				THREAD_FLAGS, THREAD_ORDER);
+	BUG_ON(!page);
+
+	irqctx				= page_address(page);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
@@ -137,9 +140,11 @@ void __cpuinit irq_ctx_init(int cpu)
 
 	per_cpu(hardirq_ctx, cpu) = irqctx;
 
-	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
-					       THREAD_FLAGS,
-					       THREAD_ORDER));
+	page = alloc_pages_node(cpu_to_node(cpu),
+				THREAD_FLAGS, THREAD_ORDER);
+	BUG_ON(!page);
+
+	irqctx				= page_address(page);
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
