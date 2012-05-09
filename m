Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab2EIIMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:12:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53436 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab2EIIMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:12:19 -0400
X-AuditID: b753bd60-9658fba000007b1b-d2-4faa26e09a7f
X-AuditID: b753bd60-9658fba000007b1b-d2-4faa26e09a7f
Message-ID: <4FAA26DD.4050403@hitachi.com>
Date: Wed, 09 May 2012 17:12:13 +0900
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
References: <20120502192418.024103772@goodmis.org>    <20120502193237.321234712@goodmis.org> <y0mhavyl3kg.fsf@fche.csb>   <1336002032.14207.52.camel@gandalf.stny.rr.com>   <4FA7B410.1000804@hitachi.com>  <1336394603.14207.117.camel@gandalf.stny.rr.com>  <4FA88E1B.1020708@hitachi.com> <1336482295.14207.172.camel@gandalf.stny.rr.com> <4FAA0641.7070409@hitachi.com>
In-Reply-To: <4FAA0641.7070409@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/09 14:53), Masami Hiramatsu wrote:
> (2012/05/08 22:04), Steven Rostedt wrote:
>> Note, the big difference with using ftrace optimization and normal
>> kprobe jump optimization is that the ftrace one can be used on a preempt
>> kernel. But this code is still under development. I want to get a
>> solution for the current code (this patch set) now. It would be nice if
>> it was ready for 3.5.
> 
> I doubt that we can really do this. If this is possible, I can make
> jump optimization work with preemptive kernel.

Now I'm clear that it can be done only with ftrace-nop.
What I concerned with is out-of-line execution buffer releasing
timing. but with the ftrace-nop, we don't need to do that.

Theoretically, that will be done in following steps;

1. call mcount (w/ push call-site address+5)
2. mcount calls ftrace handlers
3. mcount makes pt_regs on the stack
 - on x86-32, regs->cs should be the call-site address+5, since
   regs->sp must be the top of original stack.
 - on x86-64, it is enough that regs->sp points the top of original
   stack.
4. mcount store call-site address+5 to %ax
5. mcount calls new-optprobe handler (which returns call-site address+5)
6. mcount restores registers
7. mcount returns to the call-site address+5.

Between 6 and 7, original opt-probe has to do out-of-line execution,
but this ftrace-based one doesn't need to do that. In that case,
we don't need to allocate nor to release out-of-line execution buffer
for this probe.

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
