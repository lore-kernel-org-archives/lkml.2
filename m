Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869Ab2FANga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:36:30 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48182 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759851Ab2FANg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:36:28 -0400
X-AuditID: b753bd60-922cbba000001453-be-4fc8c5595e0a
X-AuditID: b753bd60-922cbba000001453-be-4fc8c5595e0a
Message-ID: <4FC8C557.9010407@hitachi.com>
Date: Fri, 01 Jun 2012 22:36:23 +0900
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
References: <20120529124833.9191.23007.stgit@localhost.localdomain>   <1338331514.13348.298.camel@gandalf.stny.rr.com>   <4FC5C55E.9000909@hitachi.com>  <1338377978.13348.308.camel@gandalf.stny.rr.com>  <4FC787D8.4010904@hitachi.com> <1338477346.13348.351.camel@gandalf.stny.rr.com>
In-Reply-To: <1338477346.13348.351.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/01 0:15), Steven Rostedt wrote:
> On Fri, 2012-06-01 at 00:01 +0900, Masami Hiramatsu wrote:
> 
>> OK, that's same as what I expected. In that case,
>> all __kprobes functions are already filtered out
>> by kprobes itself. So we don't need to set that anymore.
>>
>> Hmm, CFLAGS_REMOVE_kprobes.o can also keep kprobes from
>> function tracer. So I'd like to try to use that instead
>> of including notrace into __kprobes.
>> However, in that case, kprobe users must remove -pg from
>> their kernel modules too, and take care that they must
>> call only notrace kernel APIs...
>>
>> Perhaps, we'd better introduce new kprobe flag which allow
>> kprobe to accept new probe on ftrace, so that user can
>> explicitly understand what he will do.
> 
> Please do not make kprobe functions not allow function tracing! I *want*
> to trace these functions! For example, I trace functions in NMIs all the
> time, and I know these are prohibited by kprobes.
> 
> Why can't we function trace this? If kprobes does not trace functions
> marked with kprobes already, then it should not have any issue. Kprobes
> will only use the function tracer for what its allowed to use.

OK, so I've introduced new noprobe tag and replaced __kprobes
with it. And now __kprobes tag which is a combination of noprobe
and notrace, means that the function is not probed and it can be
called from kprobe handler. (thus user must use this with their
handlers and functions which will be used from the handlers)
And also most of __kprobes tags are replaced by noprobe only.
This means that you can trace those by function tracer :)

BTW, currently kprobes allows user cases pagefault in their
handler (kprobe.fault_handler will handle it). I guess that
can cause some problem with ftrace, isn't it? If so, I need
to deny a kprobe using ftrace if it has fault_handler.

As far as I know, systemtap relays on it.
(of course, kprobe-tracer doesn't use it)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
