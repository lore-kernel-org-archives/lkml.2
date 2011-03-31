Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1CaDiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:38:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753650Ab1CaDiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:38:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110331030917.GB26057@redhat.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Mar 2011 20:37:21 -0700
Message-ID: <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 8:09 PM, Dave Jones <davej@redhat.com> wrote:
>
> But rerunning the same tests on current head (6aba74f2791287ec407e0f92487a725a25908067)
> I can still reproduce the problem where kworker threads go nutso
> when the machine should be completely idle.
>
> top shows two kworker threads constantly at >80% cpu.

Ok, I've seen that "tons of cpu by kworker" triggered by a few
different issues. One was the intel graphics driver doing monitor
detection constantly, and spending all its time in one of the worker
threads doing __udelay() for the stupid i2c driver.

The other case I've seen is a wireless thing that falls back to GPIO,
and spends a lot of CPU time on that.

I'm not saying yours is either of those cases, but one of the problems
with that behavior is that it's actually fairly hard to figure out
what the hell is happening. You don't see some nice thread description
in 'top' any more (like you used to when everybody created their own
threads and didn't do the common worker thread thing), and the best
approach literally seems to be something like

   perf record -ag sleep 10
   perf report

which does tend to show what's going on, but it's still a ridiculous
way to this.

(Powertop can also do it, and is probably a better thing to use, I'm
just used to "perf record" for other reasons, so..)

Tejun, would there be some saner way to get the information about
_where_ all the kworker time is going?

                            Linus
