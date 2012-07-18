Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2GRH2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:28:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57533 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab2GRH2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:28:13 -0400
Date: Wed, 18 Jul 2012 00:26:08 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
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
Subject: Re: [PATCH] pstore/ftrace: Convert to its own enable/disable debugfs
 knob
Message-ID: <20120718072608.GA17026@lizard>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
 <1342553898.10332.9.camel@gandalf.stny.rr.com>
 <20120717200130.GA31678@lizard>
 <1342561102.10332.18.camel@gandalf.stny.rr.com>
 <20120718034722.GA18081@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120718034722.GA18081@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 08:47:22PM -0700, Anton Vorontsov wrote:
[...]
> -void notrace pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)
> +static void notrace pstore_ftrace_call(unsigned long ip,
> +				       unsigned long parent_ip)
>  {
> +	unsigned long flags;
>  	struct pstore_ftrace_record rec = {};
>  
> +	if (unlikely(!ftrace_enabled))
> +		return;
>  	if (unlikely(oops_in_progress))
>  		return;
>  
> +	local_irq_save(flags);
> +
>  	rec.ip = ip;
>  	rec.parent_ip = parent_ip;
>  	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
>  	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
>  			  sizeof(rec), psinfo);

Btw, here we might be running w/o recurse protection, and that helped
to find a bug in the persistent ram module.

The bug was quite subtle: it only happened if pstore tracing was
enabled before any other tracers. And it magically disappeared
otherwise.

This is because ftrace_ops_list_func() does its own recurse protection,
but ftrace_ops_list_func() is only used when there are more than
one 'struct ops' registered, otherwise ->func is called directly.

Of course, if I specify FL_GLOBAL/FL_CONTROL flag for the tracer,
then it will not try to call the func directly. But then there is
a question: do we really want to set these flags if we yet don't
want removable modules?

Or, setting at least FL_CONTROL would be a good idea anyway, since
it will then react to ftrace_function_local_{enable,disable}()?

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
