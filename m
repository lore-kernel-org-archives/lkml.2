Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab0FOEQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:16:06 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:35142 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0FOEQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:16:04 -0400
X-AuditID: b753bd60-a7602ba000007d15-df-4c16fdfa4d99
Message-ID: <4C16FDF5.1070803@hitachi.com>
Date: Tue, 15 Jun 2010 13:13:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH v5 10/14] trace: Common code for kprobes/uprobes traceevents
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6> <20100614082953.29068.76083.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100614082953.29068.76083.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
> share_traceevents.patch.
> 
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Changelog from v5: Addressed comments from Masami.
>         Also shared lot more code from kprobes traceevents.
> 
> Move common parts of trace_kprobe.c and trace_uprobec.
> Adjust kernel/trace/trace_kprobe.c after moving common code to
> kernel/trace/trace_probe.h. However they still have few duplicate
> functions.

Hi Shriker,

OK, sharing fetch codes between them is acceptable.

> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> new file mode 100644
> index 0000000..b4c5763
> --- /dev/null
> +++ b/kernel/trace/trace_probe.h
[...]

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

Please do NOT define static variables in header file...
It should be in trace_probe_common.c.

> +
> +/* Data fetch function type */
> +typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
> +
> +struct fetch_param {
> +	fetch_func_t	fn;
> +	void *data;
> +};
> +
> +#define FETCH_FUNC_NAME(kind, type)	fetch_##kind##_##type
> +/*
> + * Define macro for basic types - we don't need to define s* types, because
> + * we have to care only about bitwidth at recording time.
> + */
> +#define DEFINE_BASIC_FETCH_FUNCS(kind)  \
> +DEFINE_FETCH_##kind(u8)			\
> +DEFINE_FETCH_##kind(u16)		\
> +DEFINE_FETCH_##kind(u32)		\
> +DEFINE_FETCH_##kind(u64)
> +
> +#define CHECK_BASIC_FETCH_FUNCS(kind, fn)	\
> +	((FETCH_FUNC_NAME(kind, u8) == fn) ||	\
> +	 (FETCH_FUNC_NAME(kind, u16) == fn) ||	\
> +	 (FETCH_FUNC_NAME(kind, u32) == fn) ||	\
> +	 (FETCH_FUNC_NAME(kind, u64) == fn))
> +
> +/* Data fetch function templates */
> +#define DEFINE_FETCH_reg(type)						\
> +static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
> +					  void *offset, void *dest)	\
> +{									\
> +	*(type *)dest = (type)regs_get_register(regs,			\
> +				(unsigned int)((unsigned long)offset));	\
> +}
> +DEFINE_BASIC_FETCH_FUNCS(reg)
> +
> +/* Default (unsigned long) fetch type */
> +#define __DEFAULT_FETCH_TYPE(t) u##t
> +#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
> +#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
> +#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
> +
> +#define ASSIGN_FETCH_FUNC(kind, type)	\
> +	.kind = FETCH_FUNC_NAME(kind, type)

And, please do not split these macros and function bodies.
I think we should make a new .c and put them into there.
Maybe, we need a new interface for generating new fetch_arg
according to its type (and access region, user/kernel).

> +
> +/* Flags for trace_probe */
> +#define TP_FLAG_TRACE	1
> +#define TP_FLAG_PROFILE	2
> +
> +#define PARAM_MAX_ARGS 16
> +#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
> +
> +struct probe_arg {
> +	struct fetch_param	fetch;
> +	unsigned int		offset;	/* Offset from argument entry */
> +	const char		*name;	/* Name of this argument */
> +	const char		*comm;	/* Command of this argument */
> +	const struct fetch_type	*type;	/* Type of this argument */
> +};
> +
> +static __kprobes void call_fetch(struct fetch_param *fprm,
> +				 struct pt_regs *regs, void *dest)
> +{
> +	return fprm->fn(regs, fprm->data, dest);
> +}
> +
> +/* Check the name is good for event/group */
> +static inline int check_event_name(const char *name)
> +{
> +	if (!isalpha(*name) && *name != '_')
> +		return 0;
> +	while (*++name != '\0') {
> +		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
> +			return 0;
> +	}
> +	return 1;
> +}
> +
> +static int probe_event_raw_init(struct ftrace_event_call *event_call)
> +{
> +	return 0;
> +}

Exporting these interfaces are OK.

Thank you,



