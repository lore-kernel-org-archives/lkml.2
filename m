Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0KRFoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 00:44:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61469 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab0KRFoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 00:44:22 -0500
Message-ID: <4CE4BE8E.8060509@cn.fujitsu.com>
Date: Thu, 18 Nov 2010 13:50:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing: Make event based trace_printk()
References: <20101118035803.453609353@goodmis.org> <20101118040949.782054673@goodmis.org>
In-Reply-To: <20101118040949.782054673@goodmis.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 13:44:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 13:44:41,
	Serialize complete at 2010-11-18 13:44:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 11:58 AM, Steven Rostedt wrote:
> +#define trace_printk(fmt, args...)					\
> +	do {								\
> +		static struct event_printk_struct			\
> +		__attribute__((__aligned__(4)))				\
> +		__attribute__((section("_trace_printk")))		\
> +		______t = {						\
> +			.format = fmt,					\

if fmt is not constant, the compiler will complain...

> +			.func = __func__,				\
> +			.file = __FILE__,				\
> +			.line = __LINE__,				\
> +		};							\
> +		__trace_printk_check_format(fmt, ##args);		\
> +		if (!__builtin_constant_p(fmt))				\
> +			trace_printk_can_only_have_constant_format();	\

so this is not need.

> +		if (unlikely(__event_printk_test(&______t.enable)))	\
> +			__trace_bprintk(_THIS_IP_, fmt, ##args); \
> +	} while (0)

