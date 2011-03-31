Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab1CaG4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:56:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42333 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab1CaG4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iy4XvzrwaL9E86FwEr9qTOh/PbYBvFt8BKOSwHQwcIzqxVGdBGR9GfHz34eatFER6v
         qzkTYS/vEhOAJ68bZHqVnK111wa/Po8TxVx6HOlf0rOOMtPoNfrzx6R1RDGgyqvxwEhR
         M97ZE6EYf8IAt27HU764VjaaKREVTz4FxZafw=
Date: Thu, 31 Mar 2011 08:56:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption
 in today's -git)
Message-ID: <20110331065642.GA3385@htj.dyndns.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 30, 2011 at 08:37:21PM -0700, Linus Torvalds wrote:
> On Wed, Mar 30, 2011 at 8:09 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > But rerunning the same tests on current head (6aba74f2791287ec407e0f92487a725a25908067)
> > I can still reproduce the problem where kworker threads go nutso
> > when the machine should be completely idle.
> >
> > top shows two kworker threads constantly at >80% cpu.
> 
> Ok, I've seen that "tons of cpu by kworker" triggered by a few
> different issues. One was the intel graphics driver doing monitor
> detection constantly, and spending all its time in one of the worker
> threads doing __udelay() for the stupid i2c driver.
> 
> The other case I've seen is a wireless thing that falls back to GPIO,
> and spends a lot of CPU time on that.
> 
> I'm not saying yours is either of those cases, but one of the problems
> with that behavior is that it's actually fairly hard to figure out
> what the hell is happening. You don't see some nice thread description
> in 'top' any more (like you used to when everybody created their own
> threads and didn't do the common worker thread thing), and the best
> approach literally seems to be something like

Yes, not having dedicated workers decrease immediate visibility via
ps/top but I don't think the actual vsibility is worse.  There are two
types for kworker looping - something being scheduled in rapid
succession or a single work consuming lots of CPU cycles.

The first one can be tracked using tracing.

  $ echo workqueue:workqueue_queue_work > /sys/kernel/debug/tracing/set_event
  $ cat /sys/kernel/debug/tracing/trace_pipe > out.txt
  (wait a few secs)
  ^C

If something is busy looping on work queueing, it would be dominating
the output and the offender can be determined with the work item
function.

For the second type, "cat /proc/THE_OFFENDING_KWORKER/stack" is the
easiest.  The work item function will be trivially visible in the
stack trace.

Thanks.

-- 
tejun
