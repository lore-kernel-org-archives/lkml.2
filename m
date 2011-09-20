Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab1ITOrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:47:01 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:37930 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750892Ab1ITOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:47:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0C6TmiwVM1mrP03njhKkwyD5VAqORgVIc41xayyDgdwu9nF
 IcHfmuVxV45RKmNhIjSyi53CnSoU7cDF1wSFz0mvRn0GNmbX.Vedr_SCdoy8
 0GzuWAG5Gi.TZketvImLV1z_4ycEKtv_qX5LF9wKDFGN4hgccgiDu.kfrlLK
 CyogA_hzc5LLwYY4GpDLbDP_krHfxII_r1Id0ktsgpV0bgeEDRggZjUAieeD
 z8_SisR3ti_ZDOnHu37AVVf5hd5lk0jDqRo8sjB4YZuIG0SQHalLKXVo65Oz
 OUzkxbG55w5B5EQvqOG5lKJsQz6u5Pn5.PACPJIPmsR4KNQlE3W3EPHv3Y1F
 UJforJ5K3gRfJ6uX3HmRWbAEAhIjvhW6N2GVEm7iLFj8SYBM4CmqnK8Y7zBC
 gLtqQ1tjuYbIGe3G3SO.5Jno-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 09:46:53 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <1316476089.29966.9.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109200940240.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <20110919212640.688732950@goodmis.org>  <alpine.DEB.2.00.1109191657150.19059@router.home> <1316476089.29966.9.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Steven Rostedt wrote:

> On Mon, 2011-09-19 at 17:02 -0500, Christoph Lameter wrote:
> > On Mon, 19 Sep 2011, Steven Rostedt wrote:
> >
> > > From: Steven Rostedt <srostedt@redhat.com>
> > >
> > > The code in mod_state() is already made to handle the raciness of
> > > this_cpu_read(). Have the code use __this_cpu_read() instead so
> > > the debug code does not trigger warnings about it.
> >
> > Why would there be a warning triggered? this_cpu_read should take care of
> > disabling preemption for the read if needed. In fact the fallback case
> > does do exactly that.
>
> What does disabling preemption for just reading the cpu variable help
> anywhere? Once you read the variable, and enable preemption, you can
> migrate. Then that info you have could be useless.

The effects on just reading are not that severe. We may calculate the
address of the per cpu variable on one cpu and then be migrated to another
processor. Then there is an access to the per cpu area of another
processor which in many cases is harmless and will just cause the
cacheline to go from exclusive mode into shared mode on the other cpu. The
next write by the other cpu then brings it back to exclusive mode evicting
the cacheline from the cpu we migrated to.

The same conventions are also used for RMV instructions like this_cpu_inc.
In that case the situation is much more sever. Now we are locklessly
incrementing a counter in the per cpu area of another cpu. That is a race
condition that can corrupt the counter data.

> The point is, most places use this_cpu_read(). Adding a "__" or "raw_"
> prefix usually means that less checks are done. Think of the
> copy_from_user(). You have __copy_from_user() that does less checks.

Why do you need any checks there? this_cpu_xxx operations should take care
of preemption.

> Most of the per_cpu() and get_cpu_var() code was blindly replaced with
> the this_cpu_*() variants. The original code had preemption disabled
> checks. Now they don't. Which means if you use the this_cpu_read() and
> then make some decision on it, that read may be useless and buggy.
>
> We have smp_processor_id() that does the check (and the old per_cpu()
> and get_cpu_var()). Now we have this_cpu_read() which replaced most of
> the per_cpu() code in the kernel, making them vulnerable to bugs when
> preemption is enabled.

this_cpu_xx can only replace a get_cpu_var/per_cpu section where a single
word is read or updated. If multiple per cpu variables are accessed and
modified in one go then it is better to keep disabling preemption for
the whole section and use the __this_cpu_xx operations.

If there are cases where this was not done correctly then lets fix those.

