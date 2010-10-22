Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0JVFaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:30:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64981 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0JVFaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:30:05 -0400
Message-ID: <4CC1218E.9090104@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 13:30:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from
 using trace_bprintk()
References: <1287668742.16971.585.camel@gandalf.stny.rr.com> <201010221413.28588.rusty@rustcorp.com.au> <1287719918.16971.615.camel@gandalf.stny.rr.com> <201010221504.51535.rusty@rustcorp.com.au>
In-Reply-To: <201010221504.51535.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Can't you detect this on module unload and fix it up?  Or delay freeing the
>>>>> module until the trace ring is emptied?
>>>> One possibility is to magically make all string formats used in
>>>> trace_printk into its own section, and keep it allocated until the ring
>>>> buffer is empty. Or, we can just do that with the module's entire string
>>>> section, since we know whether or not that module has a trace_printk in
>>>> it or not.
>>> Exactly.  Set a flag in the module if it resolves trace_printk, and defer freeing
>>> the module in that case.  This shouldn't be that hard...
>> Here's my worry.
>>
>> 1) Some module with tracepoints is loaded at boot up.
>> 2) The user does tracing and forgets about it (ring buffer filled)
>> 3) Unloads module (don't free)
>> 4) loads module with trace points
>> 5) unloads module (don't free)
>> etc, etc
>>
>> memory leak.
> 
> Sure.  Then mark the rb count or something in the module at init time,
> then compare before deciding too dangerous to free.
> 
>> Thus this is not that trivial. We probably need to have a way to lock a
>> module when its tracepoint is activated, and only unlock it when the
>> ring buffer is emptied.
> 
> How about the intuitive and completely obvious thing?  When a tp activated,
> use the module.  When deactivated, unuse it?
> 

Do you mean inc module refcnt when a tp is activated, and dec the refcnt
if deactivated? That's what we already have.

In fact tracepoint is free from this bug, because we'll empty the ring
buffer if the unloading module has tracepoints in it.

So for trace_bprintk, why can't we do the same thing? If a module has
trace_bprintk calls in it, just empty the ring buffer when unloading
module.

And that's as simple as something like this:

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2547d88..103987f 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -80,6 +80,13 @@ static int module_trace_bprintk_format_notify(struct notifier_block *self,
 
 		if (val == MODULE_STATE_COMING)
 			hold_module_trace_bprintk_format(start, end);
+		else if (val == MODULE_STATE_GOING) {
+			/*
+			 * It is safest to reset the ring buffer if the
+			 * module being unloaded uses trace_bprintk.
+			 */
+			tracing_reset_current_online_cpus();
+		}
 	}
 	return 0;
 }

>> Do we want to prevent the module from being unloaded while the ring
>> buffer is full (after that module has been traced?), or do we let the
>> module be unloaded, but just prevent this one section from being freed?
> 
> I was thinking the latter, basically defer the module_free() call.
> 
