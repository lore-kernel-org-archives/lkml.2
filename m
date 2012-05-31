Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab2EaPB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:01:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41988 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2EaPB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:01:58 -0400
X-AuditID: b753bd60-93cfdba000001453-16-4fc787e3be72
X-AuditID: b753bd60-93cfdba000001453-16-4fc787e3be72
Message-ID: <4FC787D8.4010904@hitachi.com>
Date: Fri, 01 Jun 2012 00:01:44 +0900
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
Subject: Re: Re: [RFC PATCH -tip  0/9]ftrace, kprobes: Ftrace-based kprobe
 optimization
References: <20120529124833.9191.23007.stgit@localhost.localdomain>  <1338331514.13348.298.camel@gandalf.stny.rr.com>  <4FC5C55E.9000909@hitachi.com> <1338377978.13348.308.camel@gandalf.stny.rr.com>
In-Reply-To: <1338377978.13348.308.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/30 20:39), Steven Rostedt wrote:
> On Wed, 2012-05-30 at 15:59 +0900, Masami Hiramatsu wrote:
> 
>> Hmm, I'm not so sure how the notrace and filter works.
>> What happens if I set a foo function-entry on filter
>> and keep notrace empty?
>>  - only foo's nop is replaced with call?
>>  - or all functions including foo is traced?
> 
> From Documentation/trace/ftrace.txt:
> 
> "If a function exists in both set_ftrace_filter
>  and set_ftrace_notrace, the function will _not_ be traced."
> 
> The filters work exactly the same. If notrace always take precedence
> over filter. If you have foo and bar in filter, and put foo in notrace,
> then only bar is traced.
> 
> "filter" means "limit tracing only to these functions"
> "notrace" means "do not trace this function"
> 
> Think of 'filter' as a way of making the 'available_filter_functions'
> smaller. It filters the list. But 'notrace' is just like adding a
> 'notrace' tag. It stops it from being traced regardless.

OK, that's same as what I expected. In that case,
all __kprobes functions are already filtered out
by kprobes itself. So we don't need to set that anymore.

Hmm, CFLAGS_REMOVE_kprobes.o can also keep kprobes from
function tracer. So I'd like to try to use that instead
of including notrace into __kprobes.
However, in that case, kprobe users must remove -pg from
their kernel modules too, and take care that they must
call only notrace kernel APIs...

Perhaps, we'd better introduce new kprobe flag which allow
kprobe to accept new probe on ftrace, so that user can
explicitly understand what he will do.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
