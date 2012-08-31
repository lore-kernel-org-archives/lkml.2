Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab2HaTym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:54:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54727 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2HaTyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120831191321.GQ4259@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
	<1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1346360743-3628-2-git-send-email-paulmck@linux.vnet.ibm.com>
	<20120831191321.GQ4259@jtriplet-mobl1>
Date: Fri, 31 Aug 2012 21:54:39 +0200
Message-ID: <CAFTL4hxsM7LUG5-NVnZsDCM7UpprqSmBXTyUni6GuO9NcwsDeA@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 02/26] rcu: New rcu_user_enter_irq() and
 rcu_user_exit_irq() APIs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        sbw@mit.edu, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/31 Josh Triplett <josh@joshtriplett.org>:
> On Thu, Aug 30, 2012 at 02:05:19PM -0700, Paul E. McKenney wrote:
>> From: Frederic Weisbecker <fweisbec@gmail.com>
>>
>> In some cases, it is necessary to enter or exit userspace-RCU-idle mode
>> from an interrupt handler, for example, if some other CPU sends this
>> CPU a resched IPI.  In this case, the current CPU would enter the IPI
>> handler in userspace-RCU-idle mode, but would need to exit the IPI handler
>> after having exited that mode.
>>
>> To allow this to work, this commit adds two new APIs to TREE_RCU:
>>
>> - rcu_user_enter_irq(). This must be called from an interrupt between
>> rcu_irq_enter() and rcu_irq_exit().  After the irq calls rcu_irq_exit(),
>> the irq handler will return into an RCU extended quiescent state.
>> In theory, this interrupt is never a nested interrupt, but in practice
>> it might interrupt softirq, which looks to RCU like a nested interrupt.
>>
>> - rcu_user_exit_irq(). This must be called from a non-nesting
>> interrupt, interrupting an RCU extended quiescent state, also
>> between rcu_irq_enter() and rcu_irq_exit(). After the irq calls
>> rcu_irq_exit(), the irq handler will return in an RCU non-quiescent
>> state.
>
> These names seem a bit confusing.  From the descriptions, it sounds like
> you don't always need to pair them; rcu_irq_exit() will return to a
> non-quiescent state, unless you call rcu_user_enter_irq and *don't* call
> rcu_user_exit_irq.  Did I get that semantic right?

Yeah. They indeed don't always need to be paired. We can enter into
user (from rcu POV) with rcu_user_enter_irq() and exit user with
rcu_user_exit().

It's just a matter of context: from where do we set/unset RCU as in
user mode: irq or not. The only thing that is paired is the fact we
enter/exit that RCU user mode. There are just different APIs to do so.

> Given that, the "enter" and "exit" names seem confusing.  This seems
> more like a flag you can set and clear, rather than a delimited region
> as suggested by an enter/exit pair.
>
> How about something vaguely like rcu_user_irq_set_eqs and
> rcu_user_irq_clear_eqs?

I'd rather suggest rcu_user_enter_after_irq and
rcu_user_exit_after_irq. It describes precisely what it does.
>
> - Josh Triplett
