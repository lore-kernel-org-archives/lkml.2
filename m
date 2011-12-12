Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1LLO2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:28:45 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56147 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1LLO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:28:43 -0500
MIME-Version: 1.0
Date: Mon, 12 Dec 2011 22:28:43 +0800
Message-ID: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>
Subject: [Slub allocator] There are chances that kmem_cache_cpu->freelist gets
 lost if the process happens to be rescheduled to a differenet cpu before the
 local_irq_save() completes in __slab_alloc()
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone

        I'm reading code of version 3.1.5 and I guess I come across a
memory leak involving with slub allocating process. I image a case
like below.

        Process p0 running on cpu0 is requesting a small piece of
memory by calling slab_alloc(). It finds that the c0->freelist is null
and resorts to __slab_alloc(), where c0 is a pointer of kmem_cache_cpu
corresponding to cpu0. Unfortunately, scheduling happens right the
moment and p0 is now running on a different cpu1. P0 then disables the
local interrupts of cpu1 at the beginning of __slab_alloc() (line
2057),  and retrieves a different pointer of kmem_cache_cpu, c1,
corresponding to cpu1(line 2064). P0 continues executing to line 2116
where c1->freelist is assigned a new value while there is no any check
to it before at all!!! So I think there are chances that memory leak
could happen if scheduling happens right before line 2057.

2057 local_irq_disable();  /* scheduling happens before here */

2064 c = this_cpu_ptr(s->cpu_slab);

2114 load_freelist:
2115         VM_BUG_ON(!page->frozen);
2116         c->freelist = get_freepointer(s, object);  /* memory leak
happens here */

         I wonder if I think in a wrong way.

         Furthermore, I find in the earlier version like 2.6.38.8, the
local interrupts have been disabled in slab_alloc() before the control
enters the __slab_alloc(), so I think the memory leak is not present
in the earlier versions.
