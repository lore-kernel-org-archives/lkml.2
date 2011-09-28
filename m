Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1I1FE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:04:27 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48337 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1I1FE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:04:26 -0400
X-AuditID: b753bd60-a0aaaba0000019f4-3a-4e82aad79d99
X-AuditID: b753bd60-a0aaaba0000019f4-3a-4e82aad79d99
Message-ID: <4E82AAC5.9080105@hitachi.com>
Date: Wed, 28 Sep 2011 14:04:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 19/26]   tracing: Extract out common
 code for kprobes/uprobes traceevents.
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120345.25326.21966.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20110920120345.25326.21966.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/20 21:03), Srikar Dronamraju wrote:
> Move parts of trace_kprobe.c that can be shared with upcoming
> trace_uprobe.c. Common code to kernel/trace/trace_probe.h and
> kernel/trace/trace_probe.c.

This seems including different changes (as below). Please separate it.
(Maybe "Use Boolean instead of integer" patch? :))

[...]
> @@ -651,7 +107,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
>  					     void *addr,
>  					     const char *symbol,
>  					     unsigned long offs,
> -					     int nargs, int is_return)
> +					     int nargs, bool is_return)
>  {
>  	struct trace_probe *tp;
>  	int ret = -ENOMEM;
[...]

> @@ -1153,7 +366,7 @@ static int create_trace_probe(int argc, char **argv)
>  	 */
>  	struct trace_probe *tp;
>  	int i, ret = 0;
> -	int is_return = 0, is_delete = 0;
> +	bool is_return = false, is_delete = false;
>  	char *symbol = NULL, *event = NULL, *group = NULL;
>  	char *arg;
>  	unsigned long offset = 0;
> @@ -1162,11 +375,11 @@ static int create_trace_probe(int argc, char **argv)
>  
>  	/* argc must be >= 1 */
>  	if (argv[0][0] == 'p')
> -		is_return = 0;
> +		is_return = false;
>  	else if (argv[0][0] == 'r')
> -		is_return = 1;
> +		is_return = true;
>  	else if (argv[0][0] == '-')
> -		is_delete = 1;
> +		is_delete = true;
>  	else {
>  		pr_info("Probe definition must be started with 'p', 'r' or"
>  			" '-'.\n");

And also, this has bugs in selftest code.

[...]
> @@ -2020,7 +1166,7 @@ static __init int kprobe_trace_self_tests_init(void)
>  
>  	pr_info("Testing kprobe tracing: ");
>  
> -	ret = command_trace_probe("p:testprobe kprobe_trace_selftest_target "
> +	ret = traceprobe_command("p:testprobe kprobe_trace_selftest_target "
>  				  "$stack $stack0 +0($stack)");
>  	if (WARN_ON_ONCE(ret)) {
>  		pr_warning("error on probing function entry.\n");
> @@ -2035,7 +1181,7 @@ static __init int kprobe_trace_self_tests_init(void)
>  			enable_trace_probe(tp, TP_FLAG_TRACE);
>  	}
>  
> -	ret = command_trace_probe("r:testprobe2 kprobe_trace_selftest_target "
> +	ret = traceprobe_command("r:testprobe2 kprobe_trace_selftest_target "
>  				  "$retval");
>  	if (WARN_ON_ONCE(ret)) {
>  		pr_warning("error on probing function return.\n");
> @@ -2055,13 +1201,13 @@ static __init int kprobe_trace_self_tests_init(void)
>  
>  	ret = target(1, 2, 3, 4, 5, 6);
>  
> -	ret = command_trace_probe("-:testprobe");
> +	ret = traceprobe_command_trace_probe("-:testprobe");
>  	if (WARN_ON_ONCE(ret)) {
>  		pr_warning("error on deleting a probe.\n");
>  		warn++;
>  	}
>  
> -	ret = command_trace_probe("-:testprobe2");
> +	ret = traceprobe_command_trace_probe("-:testprobe2");
>  	if (WARN_ON_ONCE(ret)) {
>  		pr_warning("error on deleting a probe.\n");
>  		warn++;

traceprobe_command(str) and traceprobe_command_trace_probe(str) should be
traceprobe_command(str, create_trace_probe).

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
