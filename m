Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0F1MWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:22:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43745 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0F1MWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:22:49 -0400
X-AuditID: b753bd60-a9241ba000006d9b-ee-4c289416770d
Message-ID: <4C289414.6070703@hitachi.com>
Date: Mon, 28 Jun 2010 21:22:44 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>
Subject: Re: [PATCHv6 2.6.35-rc3-tip 8/12]  trace: Extract out common code
 for kprobes/uprobes traceevents.
References: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6> <20100628055921.6869.48368.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100628055921.6869.48368.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sriker,

Srikar Dronamraju wrote:
> trace: Extract out common code for kprobes/uprobes traceevents.
> 
> Changelog from v5: Addressed comments from Masami Hiramatsu
> 	and Steven Rostedt. Also shared lot more code from kprobes
>         traceevents.
> 
> Move common parts of trace_kprobe.c and trace_uprobe.c
> Adjust kernel/trace/trace_kprobe.c after moving common code to
> kernel/trace/trace_probe.h and kernel/trace/trace_probe.c.

Great! That's what I need.

I have just some comments. But basically it looks good to me.

> 
> TODO: Merge both events to a single probe event.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
[...]
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> new file mode 100644
> index 0000000..91056d8
> --- /dev/null
> +++ b/kernel/trace/trace_probe.c
> @@ -0,0 +1,521 @@
> +/*
> + * Common code for probe-based Dynamic events.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * Copyright (C) IBM Corporation, 2010
> + * Author:     Srikar Dronamraju
> + *
> + * Derived from kernel/trace/trace_kprobe.c written by
> + * Masami Hiramatsu <mhiramat@redhat.com>
> + */
> +
> +#include "trace_probe.h"
> +
> +const char *reserved_field_names[] = {
> +	"common_type",
> +	"common_flags",
> +	"common_preempt_count",
> +	"common_pid",
> +	"common_tgid",
> +	"common_lock_depth",
> +	FIELD_STRING_IP,
> +	FIELD_STRING_RETIP,
> +	FIELD_STRING_FUNC,
> +};
> +
> +/* Printing function type */
> +#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
> +#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
> +
> +/* Printing  in basic type function template */
> +#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
> +static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
> +						const char *name, void *data)\
> +{									\
> +	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
> +}									\
> +static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
> +
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
> +
> +__kprobes void tp_call_fetch(struct fetch_param *fprm,
> +				 struct pt_regs *regs, void *dest)
> +{
> +	return fprm->fn(regs, fprm->data, dest);
> +}

I'd like to put this call_fetch() in header, as an inline, because
it's just wrapping handler calling.

And also, I feel "tp_" implies "tracepoint". Perhaps "probe_" or
"traceprobe_" is more obvious. It will increase amount of typing,
but more readable. ;)

BTW, could you update my e-mail address to masami.hiramatsu.pt@hitachi.com ? :)

Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
