Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0KRMWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:22:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0KRMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:22:14 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=v8ohC7cffDsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BxAHAtWtgW3X9nbh26MA:9 a=g0vCfqefs7fAzDe4I44WZYDRtBMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing: Make event based
 trace_printk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "jason.wessel" <jason.wessel@windriver.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <4CE4BE8E.8060509@cn.fujitsu.com>
References: <20101118035803.453609353@goodmis.org>
	 <20101118040949.782054673@goodmis.org>  <4CE4BE8E.8060509@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Nov 2010 07:22:11 -0500
Message-ID: <1290082932.30543.101.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 13:50 +0800, Lai Jiangshan wrote:
> On 11/18/2010 11:58 AM, Steven Rostedt wrote:
> > +#define trace_printk(fmt, args...)					\
> > +	do {								\
> > +		static struct event_printk_struct			\
> > +		__attribute__((__aligned__(4)))				\
> > +		__attribute__((section("_trace_printk")))		\
> > +		______t = {						\
> > +			.format = fmt,					\
> 
> if fmt is not constant, the compiler will complain...

Ah you are right. I added that after I wrote all this code and wanted
the format to print in the file. The original code required the compile
check below.

-- Steve

> 
> > +			.func = __func__,				\
> > +			.file = __FILE__,				\
> > +			.line = __LINE__,				\
> > +		};							\
> > +		__trace_printk_check_format(fmt, ##args);		\
> > +		if (!__builtin_constant_p(fmt))				\
> > +			trace_printk_can_only_have_constant_format();	\
> 
> so this is not need.
> 
> > +		if (unlikely(__event_printk_test(&______t.enable)))	\
> > +			__trace_bprintk(_THIS_IP_, fmt, ##args); \
> > +	} while (0)


