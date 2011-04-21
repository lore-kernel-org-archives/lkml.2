Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1DUQ37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:29:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:48672 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1DUQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:29:58 -0400
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nikhil Rao <ncrao@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110421061643.GA31388@elte.hu>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
	 <20110421061643.GA31388@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 18:32:37 +0200
Message-ID: <1303403557.2035.148.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 08:16 +0200, Ingo Molnar wrote:
> * Nikhil Rao <ncrao@google.com> wrote:
> 
> > Major TODOs:
> > - Detect overflow in update shares calculations (time * load), and set load_avg
> >   to maximum possible value (~0ULL).
> > - tg->task_weight uses an atomic which needs to be updates to 64-bit on 32-bit
> >   machines. Might need to add a lock to protect this instead of atomic ops.
> > - Check wake-affine math and effective load calculations for overflows.
> > - Needs more testing and need to ensure fairness/balancing is not broken.
> 
> Please measure micro-costs accurately as well, via perf stat --repeat 10 or so.
> 
> For example, on a testsystem doing 200k pipe triggered context switches (100k 
> pipe ping-pongs) costs this much:
> 
>  $ taskset 1 perf stat --repeat 10 ./pipe-test-100k
> 

> We want to know the delta in the 'instructions' value resulting from the patch 
> (this can be measured very accurately) and we also want to see the 'cycles' 
> effect - both can be measured pretty accurately.
> 
> I've attached the testcase - you might need to increase the --repeat value so 
> that noise drops below the level of the effect from these patches. (the effect 
> is likely in the 0.01% range)
> 
> It would also be nice to see how 'size vmlinux' changes with these patches 
> applied, on a 'make defconfig' build.

Well, it shouldn't change at all for 64bit kernels (would be good to
double check), however 32bit kernels will get bigger and slower.

The problem is, the only alternative is to make 32bit !cgroup kernels
different, but then we end up with a massive wrappery mess... and the
last thing the load-balance code needs is more obfuscation.





