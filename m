Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab2EIFxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37060 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab2EIFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:12 -0400
X-AuditID: b753bd60-a3089ba000000655-ff-4faa0646c0a4
X-AuditID: b753bd60-a3089ba000000655-ff-4faa0646c0a4
Message-ID: <4FAA0641.7070409@hitachi.com>
Date: Wed, 09 May 2012 14:53:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 6/9][RFC] kprobes: Allow probe on ftrace reserved text
 (but move it)
References: <20120502192418.024103772@goodmis.org>    <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>   <1336002032.14207.52.camel@gandalf.stny.rr.com>   <4FA7B410.1000804@hitachi.com>  <1336394603.14207.117.camel@gandalf.stny.rr.com>  <4FA88E1B.1020708@hitachi.com> <1336482295.14207.172.camel@gandalf.stny.rr.com>
In-Reply-To: <1336482295.14207.172.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/08 22:04), Steven Rostedt wrote:
> I guess the question is what's best long term. That's what I would like
> to do. If a flag is "good enough" for both now and long term, than
> that's fine with me. But if we find that it would be better to have a
> "real_addr" then we should do it now and bite the bullet with all archs.

Well, I was not sure that the moving probe address method was the
short-term solution. Maybe that was wrong.

>
> Otherwise, we'll have all the archs doing something special with the
> MOVE flag and that would cause even more pain to update it later.

Just a comment. If user find that the MOVE flag is set, then they can
 choose;
- reject the probing request which on the ftrace
- stores original IP on another variable and use that instead of
  kp->regs.
So, they don't need to adjust address for each arch. :)


> I also like the real addr because it helps with the optimize probes. We
> only need to search one location. This doesn't matter with this patch
> set, but with the code I have that uses ftrace hooks. One solution with
> that is to have the optimize code see that the probe was moved, (or its
> real addr was on a ftrace nop) and then just use the ftrace code on
  ^^^^^^^^^ would you mean addr? :)
> optimization instead of normal optimizations (replacing with a jump).

OK, I misunderstood. I thought that ftrace-optimization could replace
the moving probe address solution, but it couldn't.
For example, jprobe, which puts a probe on the entry of function and
change IP to special handler, can not be optimized even with ftrace.
Thus, we still need to move probe address to the next instruction.

So, I agree with you. We need real_addr solution for transparent
moving the probepoint.

> Note, the big difference with using ftrace optimization and normal
> kprobe jump optimization is that the ftrace one can be used on a preempt
> kernel. But this code is still under development. I want to get a
> solution for the current code (this patch set) now. It would be nice if
> it was ready for 3.5.

I doubt that we can really do this. If this is possible, I can make
jump optimization work with preemptive kernel.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
