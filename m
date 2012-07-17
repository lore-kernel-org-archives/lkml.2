Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2GQTiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:38:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2GQTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:38:22 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=JxQDdpYhMz0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=IiqkAfQlhwmpuOJt4lsA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342553898.10332.9.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/8] pstore: Add persistent function tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Tue, 17 Jul 2012 15:38:18 -0400
In-Reply-To: <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
References: <20120710001004.GA22744@lizard>
	 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 17:10 -0700, Anton Vorontsov wrote:

> --- /dev/null
> +++ b/fs/pstore/ftrace.c
> @@ -0,0 +1,35 @@
> +/*
> + * Copyright 2012  Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/compiler.h>
> +#include <linux/irqflags.h>
> +#include <linux/percpu.h>
> +#include <linux/smp.h>
> +#include <linux/atomic.h>
> +#include <asm/barrier.h>
> +#include "internal.h"
> +
> +void notrace pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)

BTW, you can make the entire file 'notrace' without adding annotations
by including in the Makefile:

CFLAGS_REMOVE_ftrace.o = -pg


> +{
> +	struct pstore_ftrace_record rec = {};
> +
> +	if (unlikely(oops_in_progress))
> +		return;
> +
> +	rec.ip = ip;
> +	rec.parent_ip = parent_ip;
> +	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
> +	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
> +			  sizeof(rec), psinfo);
> +}

BTW, can any of the called functions go into module code that can be
removed? If so, then this is not safe at all. Normal function tracing
can not be synced in a preemptible kernel.

Also, I'm starting to wonder if this should be in its own utility
(separate debugfs?) than hooking directly into ftrace. Then you don't
need to modify ftrace at all and you can do the following:

static struct ftrace_ops trace_ops {
	.func = pstore_ftrace_call;
};

then in your write to debugfs file:

	register_ftrace_function(&trace_ops);

To turn off tracing:

	unregister_ftrace_function(&trace_ops);

Note, it's safe to use if the trace_ops (or anything the callback calls)
is a module. That's because it detects the trace_ops is not kernel core
code and will place a wrapper around it that allows the function tracing
to by synced with module unload. You still need to unregister the
trace_ops before unloading the module, or you can have a crash that way.

-- Steve


