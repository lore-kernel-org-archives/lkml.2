Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0IQMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:25:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53662 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753370Ab0IQMZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:25:26 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19K+0R+7jVKg1cc5CFxJWku9ktkOXW/aRwXJek5WU
	ovVSwkkwB4IEFX
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: Patch "percpu: fix a memory leak in pcpu_extend_area_map()" has been added to the 2.6.35-stable tree
Date: Fri, 17 Sep 2010 14:25:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-4.slh.12-aptosid-686; KDE/4.4.5; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org,
        stable@kernel.org
References: <12845915543097@site> <201009162339.05158.s.L-H@gmx.de> <AANLkTikhf-qz5bHT=V1P-Osyxhhgx+2OJgjqVWzEsOGn@mail.gmail.com>
In-Reply-To: <AANLkTikhf-qz5bHT=V1P-Osyxhhgx+2OJgjqVWzEsOGn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171425.20738.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 17 September 2010, Huang Shijie wrote:
> hi :
> 
>     I think this maybe caused by the kfree/vfree.
>     I do not have any AMD machine. Could you add some log to debug it
> ?  such as in pcpu_extend_area_map():
> 
>         ================================
[...]
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -390,7 +390,9 @@ static int pcpu_extend_area_map(struct p
 		goto out_unlock;
 
 	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
-	memcpy(new, chunk->map, old_size);
+	old = chunk->map;
+
+	memcpy(new, old, old_size);
 
 	/*
 	 * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the chunk is
@@ -410,8 +412,11 @@ out_unlock:
 	 * pcpu_mem_free() might end up calling vfree() which uses
 	 * IRQ-unsafe lock and thus can't be called under pcpu_lock.
 	 */
+	printk(KERN_INFO "[ %s ] line : %d\n", __func__, __LINE__);
 	pcpu_mem_free(old, old_size);
+	printk(KERN_INFO "[ %s ] line : %d\n", __func__, __LINE__);
 	pcpu_mem_free(new, new_size);
+	printk(KERN_INFO "[ %s ] line : %d\n", __func__, __LINE__);
 
 	return 0;
 }
>         ================================
>   The system will print the log before it hung.

Unfortunately those printk lines aren't reached and the systems freezes
earlier.

> Best Regards.
> Huang Shijie
> 
> 
> 2010/9/17 Stefan Lippers-Hollmann <s.L-H@gmx.de>:
[...]
> >> to the 2.6.35-stable tree which can be found at:
> >>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > [...]
> >> From a002d148426f40bc2b7dc066982eb177cdebeaaa Mon Sep 17 00:00:00 2001
> >> From: Huang Shijie <shijie8@gmail.com>
> >> Date: Sun, 8 Aug 2010 14:39:07 +0200
> >> Subject: percpu: fix a memory leak in pcpu_extend_area_map()
[...]
> > This patch, as part of the current -stable queue-2.6.35, breaks booting for
> > me on nforce4/ AMD64 X2. Unfortunately it fails even before the serial
> > console is initialized and the only messages shown on screen are:
> >
> > Decompressing Linux... Parsing ELF... done.
> > Booting kernel.

I'm still stuck on those lines, before the system freezes, but I can 
reproduce the same issues in Intel Q9550/ ICH10 (x86_64) and Intel 
Pentium M (Banias)/ ICH4-M.

All systems use current Debian/ unstable (gcc-4.4 4.4.4-14, binutils 
2.20.1-14) and are booted by grub2 (grub-pc 1.98+20100804-4). 
Queue-2.6.35 with this patch backed out and current linux-2.6 HEAD 
(v2.6.36-rc4-134-g03a7ab0) are working fine on all tested systems.

Regards
	Stefan Lippers-Hollmann
