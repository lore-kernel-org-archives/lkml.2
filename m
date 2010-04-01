Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0DAFy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 01:54:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58452 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0DAFyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 01:54:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1270092024.3552.1054.camel@calx>
References: <alpine.LFD.2.00.1003311754110.3707@i5.linux-foundation.org> <1270092024.3552.1054.camel@calx>
Message-Id: <20100401144329.BE42.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Apr 2010 14:54:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So Matt, please actually address the _bug_ I pointed out rather than talk 
> > about other things. And yes, getting rid of the vma accesses sounds like 
> > it would fix it best. If that means that it doesn't work for hugepages, so 
> > be it.
> 
> That'd actually take us back to where it was when it hit mainline, which
> would make a lot of people unhappy. I wouldn't be one of them as there
> thankfully aren't any huge pages in my world. But I'm convinced
> put_user() must go. In which case, get_user_pages() stays, and I've got
> to switch things to direct physical page access into that array. 

no. direct physical page access for /proc is completely wrong idea, i think.
please imazine the caller process is multi threaded and it use fork case, 

example scenario)
1. the parent process has thread-A and thread-B.
2. thread-A call read_pagemap
3. read_pagemap grab the page-C
3. at the same time, thread-B call fork(), now page-C pointed from two process.
4. thread-B touch page-C, cow occur, then the parent process has cowed page (page-C')
   and the child process has original page-C.
5. thread-A write page-C by physical page access, then the child page is
   modified, instead parent one.

I just recommend simply do double buffering.

thanks.

> Even if I fix that, I believe San's original bug can still be triggered
> though, as all the new callers to find_vma are run outside of the
> target's mm_sem. Fixing that should be reasonably straight-forward.



