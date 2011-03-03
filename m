Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab1CCBaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:30:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49758 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1CCBaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:30:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Subject: Re: [PATCH] procfs: fix /proc/<pid>/maps heap check
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        stable@kernel.org
In-Reply-To: <alpine.DEB.1.10.1103021449000.27610@esdhcp041196.research.nokia.com>
References: <1298996813-8625-1-git-send-email-aaro.koskinen@nokia.com> <alpine.DEB.1.10.1103021449000.27610@esdhcp041196.research.nokia.com>
Message-Id: <20110303102631.B939.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Mar 2011 10:30:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> On Tue, 1 Mar 2011, Aaro Koskinen wrote:
> > The current check looks wrong and prints "[heap]" only if the mapping
> > matches exactly the heap. However, the heap may be merged with some
> > other mappings, and there may be also be multiple mappings.
> >
> > Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
> > Cc: stable@kernel.org
> 
> Below is a test program and an example output showing the problem,
> and the correct output with the patch:
> 
> Without the patch:
> 
>  	# ./a.out &
>  	# cat /proc/$!/maps | head -4
>  	00008000-00009000 r-xp 00000000 01:00 9224       /a.out
>  	00010000-00011000 rw-p 00000000 01:00 9224       /a.out
>  	00011000-00012000 rw-p 00000000 00:00 0
>  	00012000-00013000 rw-p 00000000 00:00 0
> 
> With the patch:
> 
>  	# ./a.out &
>  	# cat /proc/$!/maps | head -4
>  	00008000-00009000 r-xp 00000000 01:00 9228       /a.out
>  	00010000-00011000 rw-p 00000000 01:00 9228       /a.out
>  	00011000-00012000 rw-p 00000000 00:00 0          [heap]
>  	00012000-00013000 rw-p 00000000 00:00 0          [heap]
> 
> The test program:
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/mman.h>
> 
> int main (void)
> {
>  	if (sbrk(4096) == (void *)-1) {
>  		perror("first sbrk(): ");
>  		return EXIT_FAILURE;
>  	}
> 
>  	if (mlockall(MCL_FUTURE)) {
>  		perror("mlockall(): ");
>  		return EXIT_FAILURE;
>  	}
> 
>  	if (sbrk(4096) == (void *)-1) {
>  		perror("second sbrk(): ");
>  		return EXIT_FAILURE;
>  	}

Your description said, 
	the heap may be merged with some other mappings,
                        ^^^^^^
but your example is splitting case. not merge. In other words, your
patch care splitting case but break merge case.

Ok, we have no obvious correct behavior. This is debatable. So,
Why do you think vma splitting case is important than merge?


