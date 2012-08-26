Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2HZATb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 20:19:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2HZAT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 20:19:26 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=AHs9r33zl8UA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Vzmi2hJzzP0A:10 a=meVymXHHAAAA:8 a=m0xyThlhAAAA:8 a=yCNFPZJBO34YLDsK70cA:9 a=QEXdDO2ut3YA:10 a=6BTljOyc3qUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: Re: [REVIEW][PATCH 11/15] userns: Teach trace to use from_kuid
From: Steven Rostedt <rostedt@goodmis.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <87wr0mecxz.fsf@xmission.com>
References: <87lih2h6i4.fsf@xmission.com>  <87wr0mecxz.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Aug 2012 20:18:36 -0400
Message-ID: <1345940316.19381.1.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-25 at 17:04 -0700, Eric W. Biederman wrote:
> - When tracing capture the kuid.
> - When displaying the data to user space convert the kuid into the
>   user namespace of the process that opened the report file.
> 

> index 5c38c81..c9ace83 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2060,7 +2060,8 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
>  	seq_puts(m, "#    -----------------\n");
>  	seq_printf(m, "#    | task: %.16s-%d "
>  		   "(uid:%d nice:%ld policy:%ld rt_prio:%ld)\n",
> -		   data->comm, data->pid, data->uid, data->nice,
> +		   data->comm, data->pid,
> +		   from_kuid_munged(seq_user_ns(m), data->uid), data->nice,

This is a global id. That is, it stored whatever process triggered the
report, not the one reading it. Thus, two different readers could get a
different uid for the same task that triggered the latency?

-- Steve

>  		   data->policy, data->rt_priority);
>  	seq_puts(m, "#    -----------------\n");
>  
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 55e1f7f..40a6f30 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -147,7 +147,7 @@ struct trace_array_cpu {
>  	unsigned long		skipped_entries;
>  	cycle_t			preempt_timestamp;
>  	pid_t			pid;
> -	uid_t			uid;
> +	kuid_t			uid;
>  	char			comm[TASK_COMM_LEN];
>  };
>  


