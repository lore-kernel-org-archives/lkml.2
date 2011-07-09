Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1GIElg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 00:41:36 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55611 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GIElf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 00:41:35 -0400
X-AuditID: b753bd60-a467eba0000050a4-04-4e17dbfc3a4b
X-AuditID: b753bd60-a467eba0000050a4-04-4e17dbfc3a4b
Message-ID: <4E17DBEA.200@hitachi.com>
Date: Sat, 09 Jul 2011 13:41:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -tip 02/13] [CLEANUP]tracing/kprobes: merge trace probe
 enable/disable functions
References: <20110627072626.6528.41792.stgit@fedora15>  <20110627072644.6528.26910.stgit@fedora15> <1310143024.26417.236.camel@gandalf.stny.rr.com>
In-Reply-To: <1310143024.26417.236.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/09 1:37), Steven Rostedt wrote:
> On Mon, 2011-06-27 at 16:26 +0900, Masami Hiramatsu wrote:
>> Merge redundant enable/disable functions into enable_trace_probe()
>> and disable_trace_probe().
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> ---
>>
>>  kernel/trace/trace_kprobe.c |   88 +++++++++++++++++--------------------------
>>  1 files changed, 34 insertions(+), 54 deletions(-)
>>
>> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
>> index bad87e9..ce5e6aa 100644
>> --- a/kernel/trace/trace_kprobe.c
>> +++ b/kernel/trace/trace_kprobe.c
>> @@ -683,6 +683,34 @@ static struct trace_probe *find_trace_probe(const char
*event,
>>  	return NULL;
>>  }
>>
>> +/* Enable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
>> +static int enable_trace_probe(struct trace_probe *tp, int flag)
>> +{
>> +	int ret = 0;
>> +
>> +	tp->flags |= flag;
>> +	if (tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE)) {
>> +		if (trace_probe_is_return(tp))
>> +			ret = enable_kretprobe(&tp->rp);
>> +		else
>> +			ret = enable_kprobe(&tp->rp.kp);
>> +	}
>
> Hmm, this seems weird. Should we have any protection here? I mean, is it
> ok to call the enable_kprobe() twice? Or should we have something like:
>
> {
> 	int old_flags = tp->flags;
> 	int ret = 0;
>
> 	tp->flags |= flag;
>
> 	if (!(old_flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE)) &&
> 	    flag & (TP_FLAG_TRACE | TP_FLAG_PROFILE)) {
> 		[...]
> 	}
>
> 	return ret;
> }


Ah, no problem, enable_kprobe() enables given kprobe only if it is
disabled.

>
>
>> +
>> +	return ret;
>> +}
>> +
>> +/* Disable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
>> +static void disable_trace_probe(struct trace_probe *tp, int flag)
>> +{
>> +	tp->flags &= ~flag;
>> +	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
>> +		if (trace_probe_is_return(tp))
>> +			disable_kretprobe(&tp->rp);
>> +		else
>> +			disable_kprobe(&tp->rp.kp);
>> +	}
>> +}
>
> Same here.

Same as above.

>
> Or do we want to reenable or re disable the probe?

Yeah, we do it for enabling/disabling each event.

Thank you,


>
> -- Steve

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
