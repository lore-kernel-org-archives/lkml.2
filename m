Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1LSTfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:35:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1LSTfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:35:37 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wmh8ChsIkccA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=CVA9PuTcrOcQG3FV2c4A:9 a=SKI9P3IgRp6s9dMVleQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324323335.5916.46.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv2 03/10] ftrace: Add enable/disable ftrace_ops control
 interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Christoph Lameter <christoph@lameter.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 19 Dec 2011 14:35:35 -0500
In-Reply-To: <1323105776-26961-4-git-send-email-jolsa@redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1323105776-26961-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 18:22 +0100, Jiri Olsa wrote:
>  
> +static inline void enable_ftrace_function(struct ftrace_ops *ops)
> +{
> +	atomic_t *disabled = this_cpu_ptr(ops->disabled);
> +	atomic_dec(disabled);
> +}
> +
> +static inline void disable_ftrace_function(struct ftrace_ops *ops)
> +{
> +	atomic_t *disabled = this_cpu_ptr(ops->disabled);
> +	atomic_inc(disabled);
> +}
> +

The above should be renamed to ftrace_function_enable/disable(), and
they should pass in the cpu. There may be a case we want to disable
ftrace functions on another CPU.

Not to mention, this is the perfect example of "this_cpu_ptr" being used
incorrectly. It's not made for this purpose, and again the naming of
"this_cpu" totally confuses other kernel developers. We need to change
this name as it was agreed to at Kernel Summit.

If the above is called with preemption enabled, it will not do what is
expected. We could disable function tracing on one CPU and then
re-enable it for another CPU even though it is already enabled.

-- Steve


