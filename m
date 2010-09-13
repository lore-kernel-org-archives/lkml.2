Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0IMPm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:42:58 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:48819 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0IMPm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:42:57 -0400
Date: Mon, 13 Sep 2010 17:42:49 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-s390@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        laijs@cn.fujitsu.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [-next Sept 13] s390 build break
 [nclude/linux/interrupt.h:local_softirq_pending()]
Message-ID: <20100913154249.GC2310@osiris.boeblingen.de.ibm.com>
References: <4C8E04C4.4060508@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C8E04C4.4060508@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 04:32:28PM +0530, Sachin Sant wrote:
> Today's next build failed on a s390 box with following
> 
> In file included from /tmp/build/linux/arch/s390/include/asm/hardirq.h:18,
>       from include/linux/hardirq.h:10,
>       from include/linux/pagemap.h:15,
>       from include/linux/blkdev.h:12,
>       from init/do_mounts.h:2,
>       from init/do_mounts_initrd.c:11:
> include/linux/interrupt.h: In function '__raise_softirq_irqoff':
> include/linux/interrupt.h:429: error: implicit declaration of function 'local_softirq_pending'
> include/linux/interrupt.h:429: error: lvalue required as left operand of assignment
> In file included from /tmp/build/linux/arch/s390/include/asm/hardirq.h:18,
>       from include/linux/hardirq.h:10,
>       from include/linux/ftrace_event.h:7,
>       from include/trace/syscall.h:6,
>       from include/linux/syscalls.h:76,
>       from init/initramfs.c:9:
> include/linux/interrupt.h: In function '__raise_softirq_irqoff':
> include/linux/interrupt.h:429: error: implicit declaration of function 'local_softirq_pending'
> include/linux/interrupt.h:429: error: lvalue required as left operand of assignment
> make[1]: *** [init/do_mounts_initrd.o] Error 1
> 
> and many more similar errors ..
> 
> The following commit added the code in question.
> 
> commit 2bf2160d8805de64308e2e7c3cd97813cb58ed2f
> irq: Add tracepoint to softirq_raise

Yes, header include dependencies suck here. But it's easy to fix since most
of the includes in s390's hardirq.h aren't necessary:

diff --git a/arch/s390/include/asm/hardirq.h b/arch/s390/include/asm/hardirq.h
index 498bc38..881d945 100644
--- a/arch/s390/include/asm/hardirq.h
+++ b/arch/s390/include/asm/hardirq.h
@@ -12,10 +12,6 @@
 #ifndef __ASM_HARDIRQ_H
 #define __ASM_HARDIRQ_H
 
-#include <linux/threads.h>
-#include <linux/sched.h>
-#include <linux/cache.h>
-#include <linux/interrupt.h>
 #include <asm/lowcore.h>
 
 #define local_softirq_pending() (S390_lowcore.softirq_pending)
