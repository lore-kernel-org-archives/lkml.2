Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab2AMB4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:56:54 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54124 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab2AMB4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:56:53 -0500
X-AuditID: b753bd60-96e5dba00000359c-01-4f0f8f611eb0
X-AuditID: b753bd60-96e5dba00000359c-01-4f0f8f611eb0
Message-ID: <4F0F8F41.3060806@hitachi.com>
Date: Fri, 13 Jan 2012 10:56:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v8 3.2.0-rc5 9/9] perf: perf interface for uprobes
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com> <20111216122951.2085.95511.sendpatchset@srdronam.in.ibm.com> <4F06D22D.9060906@hitachi.com> <20120109112236.GA10189@linux.vnet.ibm.com>
In-Reply-To: <20120109112236.GA10189@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/09 20:22), Srikar Dronamraju wrote:
>>>  		return true;
>>>
>>>  	for (i = 0; i < pev->nargs; i++)
>>> @@ -1344,11 +1389,17 @@ char *synthesize_probe_trace_command(struct
probe_trace_event *tev)
>>>  	if (buf == NULL)
>>>  		return NULL;
>>>
>>> -	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s%s+%lu",
>>> -			 tp->retprobe ? 'r' : 'p',
>>> -			 tev->group, tev->event,
>>> -			 tp->module ?: "", tp->module ? ":" : "",
>>> -			 tp->symbol, tp->offset);
>>> +	if (tev->uprobes)
>>> +		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s",
>>> +				 tp->retprobe ? 'r' : 'p',
>>> +				 tev->group, tev->event, tp->symbol);
>>> +	else
>>> +		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s%s+%lu",
>>> +				 tp->retprobe ? 'r' : 'p',
>>> +				 tev->group, tev->event,
>>> +				 tp->module ?: "", tp->module ? ":" : "",
>>> +				 tp->symbol, tp->offset);
>>
>> I think tp->module should be the executable file even when
>> tp is a user space probe, because when parsing the uprobes list
>> in tracing/trace_uprobes, exec file will be stored in tp->module.
>
> can be done. What I used to do is overload the tp->symbol with the
> real-name as well as the offset.  Now I will just keep the offset in the
> symbol and use the target that the user has requested.

I mean that tp->module always !NULL if uprobe, then, we don't need
to change the code. (thus we can reduce the patch size :))


>>> +int show_available_funcs(const char *target, struct strfilter *_filter,
>>> +					bool user)
>>> +{
>>> +	struct map *map;
>>> +	int ret;
>>> +
>>> +	setup_pager();
>>>  	available_func_filter = _filter;
>>> +
>>> +	if (!user)
>>> +		return available_kernel_funcs(target);
>>> +
>>> +	symbol_conf.try_vmlinux_path = false;
>>> +	symbol_conf.sort_by_name = true;
>>> +	ret = symbol__init();
>>> +	if (ret < 0) {
>>> +		pr_err("Failed to init symbol map.\n");
>>> +		return ret;
>>> +	}
>>> +	map = dso__new_map(target);
>>> +	ret = __show_available_funcs(map);
>>> +	dso__delete(map->dso);
>>> +	map__delete(map);
>>> +	return ret;
>>> +}
>>> +
>>> +#define DEFAULT_FUNC_FILTER "!_*"
>>
>> This is a hidden rule for users ... please remove it.
>> (or, is there any reason why we need to have it?)
>>
>
> This is to be in sync with your commit
> 3c42258c9a4db70133fa6946a275b62a16792bb5

I see, but that commit also provides filter option for changing
the function filter. Here, user can not change the filter rule.

I think, currently, we don't need to filter any function by name
here, since the user obviously intends to probe given function :)

>>> +
>>> +/*
>>> + * uprobe_events only accepts address:
>>> + * Convert function and any offset to address
>>> + */
>>> +static int convert_name_to_addr(struct perf_probe_event *pev, const char *exec)
>>> +{
>>
>> I'm not sure why wouldn't you convert function to "vaddr",
>> instead of "exec:vaddr"?
>>
>
> If the user provides a symbolic link, convert_name_to_addr would get the
> target executable for the given executable. This would handy if we were
> to compare existing probes registered on the same application using a
> different name (symbolic links). Since you seem to like that we register
> with the name the user has provided, I will just feed address here.

Hmm, why do we need to compare the probe points? Of course, event-name
conflict should be solved, but I think it is acceptable that user puts
several probes on the same exec:vaddr. Since different users may want
to use it concurrently bit different ways.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
