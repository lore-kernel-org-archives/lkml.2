Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0DXPrq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 11:47:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:36807 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753264Ab0DXPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 11:47:44 -0400
X-Authenticated: #46697607
X-Provags-ID: V01U2FsdGVkX18SdPpLlVkSXERSHsRM8DZUQ2Ahf3L/pcE0VcCOr5
	GGhJkNae57QIwF
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
From: Egon Alter <egon.alter@gmx.net>
Date: Sat, 24 Apr 2010 17:47:40 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004241747.41045.egon.alter@gmx.net>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm wondering if this is similar to the "Cleancache" patches send a few days 
before. 

Could bcache provide a (block-dev) backend to cleancache? Also there is fs-
cache (for networks-fs only currently). Can these caches be combined somehow?

Egon

Kent Overstreet:
> The core code is getting close to stable and feature complete. Garbage
> collection is done, and locking is mostly done (I'm not refcounting data
> buckets yet, and it does need to be stared at a whole lot more but it
> passes lockdep and seems to be working).
> 
> Basic bucket priority calculation is done (right now it acts as an LRU);
> you can fill the cache up and everything works like it ought to. And,
> I've yet to see it return bad data; I think it's not all that far off
> from being useful.
> 
> The one thing that has me at a loss right now is the performance isn't
> where it should be, and for no obvious reason. The problem is most
> succinctly demonstrated thusly:
> 
> With cache, no cache misses:
> root@utumno:~# mount -o ro /dev/sdb /mnt/
> root@utumno:~# cd /mnt/
> root@utumno:/mnt# time find > /dev/null
> 
>  real	0m29.618s
>  user	0m0.000s
>  sys	0m0.840s
> 
> No cache device:
> root@utumno:~# mount -o ro /dev/sdb /mnt/
> root@utumno:~# cd /mnt/
> root@utumno:/mnt# time find > /dev/null
> 
> real	0m1.597s
> user	0m0.050s
> sys	0m1.240s
> 
> This is a vm, so the wall clock time in the latter case doesn't mean
> much, it's all in the hosts's cache. But the former case is bewildering;
> the cache device lives on a tmpfs so it shouldn't be waiting on IO, and
> cpu time is less than the uncached case. Clearly it's waiting on
> something, but I haven't been able to figure out what the heck to trace;
> there's no lock contention, blktrace shows nothing unexpected, I keep
> running into dead ends. Any pointers here would be much appreciated.
> 
> Besides that, there shouldn't be anything complex left before I add
> write support, and that should be pretty straightforward too.
> 
> This patch does have some changes to the generic bio code for completion
> of split bios, I'm going to split it out and submit it seperately after
> I've gone over it more and it's actually been tested.
> 
> Any comments/review much appreciated.
> [patch sniped]
