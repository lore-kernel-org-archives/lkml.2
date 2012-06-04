Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2FDLpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:45:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46974 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2FDLpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:45:30 -0400
X-AuditID: b753bd60-a0885ba000000655-4c-4fcc9fd73324
X-AuditID: b753bd60-a0885ba000000655-4c-4fcc9fd73324
Message-ID: <4FCC9FC8.7060302@hitachi.com>
Date: Mon, 04 Jun 2012 20:45:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe optimization
References: <20120529124833.9191.23007.stgit@localhost.localdomain>    <1338331514.13348.298.camel@gandalf.stny.rr.com>    <4FC5C55E.9000909@hitachi.com>   <1338377978.13348.308.camel@gandalf.stny.rr.com>   <4FC787D8.4010904@hitachi.com>  <1338477346.13348.351.camel@gandalf.stny.rr.com>  <4FC8C557.9010407@hitachi.com> <1338560427.13348.466.camel@gandalf.stny.rr.com>
In-Reply-To: <1338560427.13348.466.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/01 23:20), Steven Rostedt wrote:
> On Fri, 2012-06-01 at 22:36 +0900, Masami Hiramatsu wrote:
> 
>> OK, so I've introduced new noprobe tag and replaced __kprobes
>> with it. And now __kprobes tag which is a combination of noprobe
>> and notrace, means that the function is not probed and it can be
>> called from kprobe handler. (thus user must use this with their
>> handlers and functions which will be used from the handlers)
>> And also most of __kprobes tags are replaced by noprobe only.
> 
> You still haven't answered my question. Why can't function tracer still
> trace these? If kprobes does not allow it to be probed, it should not
> interfere with your code. But normal function tracing should still allow
> these.

Because those are called from ftrace-based kprobe, which means
it is directly invoked from kprobe_ftrace_handler. I think
that should be handled as a part of ftrace handler.
Currently, I just added notrace on below two kind of functions

 - handler functions which can be called intermediately from ftrace
 - get_kprobe, set_kprobe_instance, etc. internal utility functions
   which is called directly from kprobe ftrace handler.


> I still do not understand why you need to add 'notrace' at all.

Because I'd like to solve a recursive call problem.

I saw a problem which I hit some odd function tracer behavior.
When I removed notrace from get_kprobe(), which is an essential
internal function called directly from kprobe_ftrace_handler,
I hit a kernel crash caused by recursive call right after I
registered kprobe_ftrace_handler to ftrace. At that time,
ftrace_ops.filter was empty so I thought there is no function
traced, but the kprobe_ftrace_handler was called from somewhere.
So I saw it hit a recursive loop of ftrace_call ->
kprobe_ftrace_handler -> get_kprobe -> ftrace_call ...

I think if I just register kprobe's ftrace_ops without start
tracing, I think we can just do tracing without "notrace".

>> This means that you can trace those by function tracer :)
>>
>> BTW, currently kprobes allows user cases pagefault in their
>> handler (kprobe.fault_handler will handle it). I guess that
>> can cause some problem with ftrace, isn't it? If so, I need
>> to deny a kprobe using ftrace if it has fault_handler.
> 
> As long as there's recursion protection you are fine. In fact, I may add
> recursion protection within the assembly itself, that will make all
> function tracing safe. (does not solve the breakpoint bug from the other
> thread, but will solve most other things). In fact, this may allow us to
> remove notraces that were added because of recursion issues.

OK, I think kprobe already solves that as long as
get_kprobe and kprobe_running doesn't cause recursion...

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
