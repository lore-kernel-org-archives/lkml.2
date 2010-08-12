Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460Ab0HLUxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:53:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51862 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab0HLUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:53:24 -0400
Subject: Re: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
From: john stultz <johnstul@us.ibm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C64571F.6000606@lwfinger.net>
References: <4C64571F.6000606@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 13:52:48 -0700
Message-ID: <1281646368.4002.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 15:18 -0500, Larry Finger wrote:
> Guys,
> 
> With the above commit, building an i386 version of the kernel results in the
> following from the build:
> 
> kernel/built-in.o: In function `logarithmic_accumulation':
> /home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
> `__umoddi3'
> /home/finger/linux-realtek/kernel/time/timekeeping.c:715: undefined reference to
> `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Reverting the patch allows the system to build correctly.

Ugh. I'm surprised it picks *this* loop to optimize instead of the
similar one right above. I'm guessing its the local raw_nsecs value, but
whatever.  Also surprised Jason's testing didn't hit this issue, but its
probably a gcc version thing.

Regardless, I clearly need to give i386 more love in my testing.
My profuse apologies.

As suggested by Linus, here's the do_div explicit version. It builds ok
on i386 & x86_64, but I have not yet tested it. 

Larry, Jason: Could you verify it works for you (and avoids the original
issue)?

thanks
-john



>From 70b106aaaa1de81a635bbd7ea6edc244ba098d7e Mon Sep 17 00:00:00 2001
From: John Stultz <johnstul@us.ibm.com>
Date: Thu, 12 Aug 2010 13:45:28 -0700
Subject: [PATCH] time: Workaround gcc loop optimization that causes 64bit div errors

Some versions of gcc apparently aggressively optimize the raw time
accumulation loop, replacing it with a divide.

On 32bit systems, this causes the following link errors:
	undefined reference to `__umoddi3'
	undefined reference to `__udivdi3'

This patch replaces the accumulation loop with a do_div, as suggested
by Linus.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/time/timekeeping.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dc54b72..d0ef5aa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -710,9 +710,10 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 	/* Accumulate raw time */
 	raw_nsecs = timekeeper.raw_interval << shift;
 	raw_nsecs += raw_time.tv_nsec;
-	while (raw_nsecs >= NSEC_PER_SEC) {
-		raw_nsecs -= NSEC_PER_SEC;
-		raw_time.tv_sec++;
+	if (raw_nsecs >= NSEC_PER_SEC) {
+		u64 raw_secs = raw_nsecs;
+		raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
+		raw_time.tv_sec += raw_secs;
 	}
 	raw_time.tv_nsec = raw_nsecs;
 
-- 
1.6.0.4



