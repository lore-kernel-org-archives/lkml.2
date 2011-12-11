Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab1LKJ6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 04:58:15 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34940 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1LKJ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 04:58:14 -0500
MIME-Version: 1.0
Date: Sun, 11 Dec 2011 17:52:47 +0800
Message-ID: <CABexPfEXWo4YYG=3hA-ZW1tqV8-R=BQj=COgUM6_7_epPavx5g@mail.gmail.com>
Subject: [Slub allocator] There are chances that kmem_cache_cpu->freelist is
 lost if the process is rescheduled to a differenet cpu before the local irq
 is disabled when calling __slab_alloc()
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone
        I'm reading the linux kernel and now focusing on memory
management. Image a case like below, a process on cpu0 is calling
slab_alloc for a free obj, and finds that the c0->freelist is null,
where c0 is the pointer to a kmem_cache_cpu object corresponding to
the current cpu0. Then the process resorts to the __slab_alloc and
HERE, the process MAY BE rescheduled to a different cpu1 before the
local irq is disabled. Then, a new kmem_cache_cpu pointer c1 is
retrieved. I think there are chances that with respect to this
different kmem_cache_cpu pointer c1, c1->freelist is NOT null and
could be lost if the  following code is executed in __slab_alloc:

         load_freelist:
                 VM_BUG_ON(!page->frozen);
                 c->freelist = get_free_pointer(s, object);
/* THIS ASSIGNMENT */
                 c->tid = next_tid(c->tid);
                 local_irq_restore(flags);
                 return object;

         I think the assignment above may cause the loss of the
freelist pointed by c->freelist, because c now  points to a different
kmem_cache_cpu object due the reschedule and this freelist may be NOT
null as I imaged earlier.
