Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2GSKPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:15:12 -0400
Received: from plane.gmane.org ([80.91.229.3]:52103 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab2GSKPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:15:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 0/2] [RFC] Volatile ranges (v4)
Date: Thu, 19 Jul 2012 10:13:41 +0000 (UTC)
Message-ID: <loom.20120719T113441-155@post.gmane.org>
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 72.14.228.1 (Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz <at> linaro.org> writes:
> Ok. So here's another iteration of the fadvise volatile range code.
> 
> I realize this is still a way off from being ready, but I wanted to post
> what I have to share with folks working on the various range/interval
> management ideas as well as update folks who've provided feedback on the
> volatile range code.

Hi John,

May you please confirm whether the fadvise(FADV_VOLATILE)
will work for me in the following case?
I am developing a dynamic data race detector (ThreadSanitizer).
It needs to associate some meta-data (shadow) with each byte
of application memory (4 bytes of shadow for 1 byte of app 
memory). We mmap(MAP_ANONYMOUS|MAP_NORESERVE)
40TB of virtual address space for 
shadow, and then just access it as needed. It works.
But for some apps that consume too much 
memory, it eventually leads to swapping/OOM kills.
There is a property of shadow memory that I would like to exploit
 - any region of shadow memory can be reset to zero at any point
w/o any bad consequences (it can lead to missed data 
races, but it's better than OOM kill).
I've tried to execute madvise(MADV_DONTNEED) every X 
seconds for whole shadow memory. It almost works.
The problem is that madvise() seems to be 
not atomic, occasionally I see missed writes, that's not acceptable,
I need either zero pages or 
consistent pages.
Your FADV_VOLATILE looks like it may be the solution.
To summarize: I have a huge region of memory that
I would like to mark as "volatile" at program 
startup. The region is anonymous (not backed by any file).
The kernel must be able to take away 
any pages in the range, and then return zero pages later.
I do have concurrent writes to the 
range, and missed writes are unacceptable.
Ideally, pages are revoked on LRU basis
TIA

