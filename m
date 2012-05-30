Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2E3Tod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:44:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab2E3Toc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:44:32 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=bRFhsiWK_QYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=KKAkSRfTAAAA:8 a=tMn7H1j0pZg76wYNDCgA:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338407068.13348.312.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] tracing: Fix initialization failure path in
 tracing_set_tracer()
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
Date: Wed, 30 May 2012 15:44:28 -0400
In-Reply-To: <1338039549-24498-1-git-send-email-anton.vorontsov@linaro.org>
References: <20120526133412.GA18001@lizard>
	 <1338039549-24498-1-git-send-email-anton.vorontsov@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 06:39 -0700, Anton Vorontsov wrote:
> If tracer->init() fails, current code will leave current_tracer pointing
> to an unusable tracer, which at best makes 'current_tracer' report
> inaccurate value.
> 
> Fix the issue by pointing current_tracer to nop tracer, and only update
> current_tracer with the new one after all the initialization succeeds.
> 

Hmm, I'll look at this in more detail. This may be something I pull now.
(for 3.6).

-- Steve

> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  kernel/trace/trace.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 68032c6..5cf7e67 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3172,10 +3172,10 @@ static int tracing_set_tracer(const char *buf)
>  	}
>  	destroy_trace_option_files(topts);
>  
> -	current_trace = t;
> +	current_trace = &nop_trace;
>  
> -	topts = create_trace_option_files(current_trace);
> -	if (current_trace->use_max_tr) {
> +	topts = create_trace_option_files(t);
> +	if (t->use_max_tr) {
>  		int cpu;
>  		/* we need to make per cpu buffer sizes equivalent */
>  		for_each_tracing_cpu(cpu) {
> @@ -3195,6 +3195,7 @@ static int tracing_set_tracer(const char *buf)
>  			goto out;
>  	}
>  
> +	current_trace = t;
>  	trace_branch_enable(tr);
>   out:
>  	mutex_unlock(&trace_types_lock);


