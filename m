Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1ITOvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:51:12 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:27241 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751723Ab1ITOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:51:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zzsPFbsVM1n0_RvOlWmT054E44HnU1SEZNQOQrvTUSb6Ohu
 3duhguLSMwkKl8oCXoW39.Eq5Y7qgowzylj9SMiBpGQUxELZH8eIHcW2gouQ
 G9MKXAQsmIrFcPhwB66Oh69ewkNU1cHhhtj.4WLIwpN1ybF.uI5Pu_XOa4.c
 2hICj9lEJEfKCi8NsOuH_jNa0S_ddK8ZQkbJFGh9BiY5lBbHwi39Y2BSbkz8
 R_a0wWYZkctdRAdVJMURuHDuabrYm9mNaUncyEDKVut4EE8Y1ush9iHAOHuZ
 OraAxCo.VEXxBqrekZELfsMabXRLlYDH_.cpL4Q7mx28gj4vGgaNt9_fMKvE
 8fGUjitgm0CQ07NH5x63XKkrchgASVqVdcjhluLRHZDMYwlnPElllPZOXTeG
 R1f2upujPh3mA4FyQwCUTTZw-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 09:51:06 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <alpine.LFD.2.02.1109201334590.2723@ionos>
Message-ID: <alpine.DEB.2.00.1109200947100.8056@router.home>
References: <20110919212040.745370781@goodmis.org> <20110919212640.688732950@goodmis.org> <alpine.DEB.2.00.1109191657150.19059@router.home> <alpine.LFD.2.02.1109201334590.2723@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Thomas Gleixner wrote:

> > Why would there be a warning triggered? this_cpu_read should take care of
> > disabling preemption for the read if needed. In fact the fallback case
> > does do exactly that.
>
> And what exactly is the purpose of having a preempt_disable()/enable()
> pair in this_cpu_read()?

It avoids a read from one cpu of another processors per cpu area. In the
fallback case the processor has to calculate the per cpu address and then
retrieve data from the calculated address. The process can be migrated
between calculation of the address and the actual fetch.

The more severe cases are the RMV operations like this_cpu_inc.

> functions we should add a more sensible debug interface like:
>
>   debug_check_percpu_access()
>
> and the per cpu sections which require protection over a series (1
> .. N) of this_cpu_* operations want to have
>
>   this_cpu_start()
>   this_cpu_end()
>
> or similar annotations around them.
>
> This allows us to do proper analysis of this_cpu usage and makes the
> code understandable.

Not sure what you want to check in this_cpu_xx operations. Why could
there be issues with this_cpu_xx operations?

I see that __this_cpu_xx operations may not work as intended in
preemptable contexts and there we could have more changes.

this_cpu ops are single instructions that do not guarantee any consistency
with other this_cpu_ops. If you want consistency (same per cpu area data)
then preemption needs to be disabled.

