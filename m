Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0IAAsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:48:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55662 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0IAAsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:48:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org
In-Reply-To: <4C7BE25B.1020504@superonline.com>
References: <20100830083704.5231.A69D9226@jp.fujitsu.com> <4C7BE25B.1020504@superonline.com>
Message-Id: <20100901093219.9744.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Sep 2010 09:48:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> === 8< ===
> PM: Marking nosave pages: ...0009f000 - ...000100000
> PM: basic memory bitmaps created
> PM: Syncing filesystems ... done
> Freezing user space processes ... (elapsed 0.01 seconds) done.
> Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> PM: Preallocating image memory...
> shrink_all_memory start
> PM: shrink memory: pass=1, req:310171 reclaimed:15492 free:360936
> PM: shrink memory: pass=2, req:294679 reclaimed:28864 free:373981
> PM: shrink memory: pass=3, req:265815 reclaimed:60311 free:405374
> PM: shrink memory: pass=4, req:205504 reclaimed:97870 free:443024
> PM: shrink memory: pass=5, req:107634 reclaimed:146948 free:492141
> shrink_all_memory: req:107634 reclaimed:146948 free:492141
> PM: preallocate_image_highmem 556658 278329
> PM: preallocate_image_memory 103139 103139
> PM: preallocate_highmem_fraction 183908 556658 760831 -> 183908
> === >8 ===

Rafael, this log mean hibernate_preallocate_memory() has a bug.
It allocate memory as following order.
 1. preallocate_image_highmem()  (i.e. __GFP_HIGHMEM)
 2. preallocate_image_memory()   (i.e. GFP_KERNEL)
 3. preallocate_highmem_fraction (i.e. __GFP_HIGHMEM)
 4. preallocate_image_memory()   (i.e. GFP_KERNEL)

But, please imazine following scenario (as Vefa's scenario).
 - system has 3GB memory. 1GB is normal. 2GB is highmem.
 - all normal memory is free
 - 1.5GB memory of highmem are used for tmpfs. rest 500MB is free.

At that time, hibernate_preallocate_memory() works as following.

1. call preallocate_image_highmem(1GB)
2. call preallocate_image_memory(500M)		total 1.5GB allocated
3. call preallocate_highmem_fraction(660M)	total 2.2GB allocated

then, all of normal zone memory was exhaust. next preallocate_image_memory()
makes OOM, and oom_killer_disabled makes infinite loop.
(oom_killer_disabled careless is vmscan bug. I'll fix it soon)

The problem is, alloc_pages(__GFP_HIGHMEM) -> alloc_pages(GFP_KERNEL) is
wrong order. alloc_pages(__GFP_HIGHMEM) may allocate page from lower zone.
then, next alloc_pages(GFP_KERNEL) lead to OOM.

Please consider alloc_pages(GFP_KERNEL) -> alloc_pages(__GFP_HIGHMEM) order.
Even though vmscan fix can avoid infinite loop, OOM situation might makes
big slow down on highmem machine. It seems no good.


Thanks.


