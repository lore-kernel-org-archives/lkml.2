Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2FFPS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:18:26 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48258 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2FFPSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:18:25 -0400
X-AuditID: b753bd60-98cf0ba000000f6c-53-4fcf74b6b06b
X-AuditID: b753bd60-98cf0ba000000f6c-53-4fcf74b6b06b
Message-ID: <4FCF74B4.2060309@hitachi.com>
Date: Thu, 07 Jun 2012 00:18:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 06/12] ftrace/x86: Add save_regs for i386 function
 calls
References: <20120606035058.108720095@goodmis.org>  <20120606040014.660425497@goodmis.org> <1338993457.13348.547.camel@gandalf.stny.rr.com>
In-Reply-To: <1338993457.13348.547.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/06 23:37), Steven Rostedt wrote:
> On Tue, 2012-06-05 at 23:51 -0400, Steven Rostedt wrote:
> 
>> +ENTRY(ftrace_regs_caller)
>> +	pushf	/* push flags before compare */
>> +	cmpl $0, function_trace_stop
>> +	jne ftrace_exit
>> +
>> +
> 
> Masami,
> 
> Do we really need to push before the compare? As the compare flags are
> really meaningless with calling functions, and here we are only trying
> to hide what the cmpl did. If something else was tracing without regs,
> and we put a probe just after the nop, then it would include the cmpl
> changes. My version of the patch doesn't restore the flags, so two
> probes would have different values. But again, do we care? What would
> need to know the value of cmp flags when calling into a function when
> they are not going to be restored anyway.

Yes, it needs to be saved and restored too, for transparency.
If we don't guarantee it, users must check whether a probe
can do what they are doing, before they put the probe. And
if not, they must find another appropriate place. It's not
compatible with previous kprobes.

Actually, I think we can push flags after compare if we
add a note on kprobes document, so that user can expect
compare flags will be not correct if KPROBE_FLAG_FTRACE
is set. (Of course, it is better to provide an API
(ftrace_location is enough?) for giving him a hint how he
can get a correct flags with kprobes)

But if you'd like to introduce -mfentry, I hope ftrace to
restore flags, which will be useful for debugging/investigation
by tweaking flags while executing a function.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
