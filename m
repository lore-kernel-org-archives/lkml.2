Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959Ab0HLU1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:27:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988Ab0HLU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <4C64571F.6000606@lwfinger.net>
References: <4C64571F.6000606@lwfinger.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 13:26:37 -0700
Message-ID: <AANLkTi==5umTtLWSoLfLPjHYAVpnPNHN-uzq7q2t-nfr@mail.gmail.com>
Subject: Re: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 1:18 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
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

Damn. It's your compiler turning a while-loop into a divide. Which
likely isn't even an optimization, but whatever.

John: I think that while-loop needs to be something like

   if (raw_nsecs >= NSEC_PER_SEC) {
      u64 raw_secs = raw_nsecs;
      raw_nsecs = do_div(raw_secs, NSEC_PER_SEC);
      raw_time.tv_sec += taw_secs;
  }
  raw_time.tc_nsec = raw_nsecs;

which is sad and overly complicated, but the simple thing seems to get
messed up by the compiler.

Untested. Maybe I got the complex do_div() semantics wrong. Somebody
needs to check.

                     Linus
