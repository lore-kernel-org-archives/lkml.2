Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1ISXsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:48:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1ISXsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:48:11 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=6qbAnu_Q0HoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=gKTgFYEEQGM3ugIp74UA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <alpine.DEB.2.00.1109191657150.19059@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212640.688732950@goodmis.org>
	 <alpine.DEB.2.00.1109191657150.19059@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 19 Sep 2011 19:48:09 -0400
Message-ID: <1316476089.29966.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 17:02 -0500, Christoph Lameter wrote:
> On Mon, 19 Sep 2011, Steven Rostedt wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > The code in mod_state() is already made to handle the raciness of
> > this_cpu_read(). Have the code use __this_cpu_read() instead so
> > the debug code does not trigger warnings about it.
> 
> Why would there be a warning triggered? this_cpu_read should take care of
> disabling preemption for the read if needed. In fact the fallback case
> does do exactly that.

What does disabling preemption for just reading the cpu variable help
anywhere? Once you read the variable, and enable preemption, you can
migrate. Then that info you have could be useless.


> 
> I think it would make more sence if __this_cpu_read() could be made to
> trigger a warning if used in context where preemption could be off.

Hmm, maybe I should have called it raw_this_cpu_read() then it would
probably have better meaning. Just like smp_processor_id() and
raw_smp_processor_id().

The point is, most places use this_cpu_read(). Adding a "__" or "raw_"
prefix usually means that less checks are done. Think of the
copy_from_user(). You have __copy_from_user() that does less checks.

Most of the per_cpu() and get_cpu_var() code was blindly replaced with
the this_cpu_*() variants. The original code had preemption disabled
checks. Now they don't. Which means if you use the this_cpu_read() and
then make some decision on it, that read may be useless and buggy.

We have smp_processor_id() that does the check (and the old per_cpu()
and get_cpu_var()). Now we have this_cpu_read() which replaced most of
the per_cpu() code in the kernel, making them vulnerable to bugs when
preemption is enabled.

-- Steve




