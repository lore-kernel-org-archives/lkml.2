Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298Ab0HFQJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:09:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51915 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab0HFQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:09:32 -0400
X-Authority-Analysis: v=1.1 cv=puNM1lMKksHKE6hmMqMstpyRmqXf+M/teYaxpNq+S3U= c=1 sm=0 a=B1VgCmZP4EsA:10 a=Q9fys5e9bTEA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=11bicJdnmrU9iPctiGkA:9 a=6M8Un3bkZeRrejXRH60A:7 a=z6qxQ9q8ovR4ymwKwvHRe-yUlDcA:4 a=PUjeQqilurYA:10 a=x8gzFH9gYPwA:10 a=dGJ0OcVc7YAA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Subject: Re: [RFC]ftrace: fix a unallocated memory access in function_graph
From: Steven Rostedt <rostedt@goodmis.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        srostedt@redhat.com, "Huang, Ying" <ying.huang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
References: <1280217994.32400.76.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 06 Aug 2010 12:09:30 -0400
Message-ID: <1281110970.3352.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late response, I just got back from vacation.

Also note, please do not send to my RH account. I do not check it as
much. Send emails to me to this (goodmis) account.


On Tue, 2010-07-27 at 16:06 +0800, Shaohua Li wrote:
> With CONFIG_DEBUG_PAGEALLOC, I observed a unallocated memory access in
> function_graph trace. It appears we find a small size entry in ring buffer, but
> we access it as a big size entry. The access overflows a page size and touch
> a unallocated page.

Nice catch! This is a legit bug. I'll prepare it for 2.6.36, as well as
send it off to stable.

Thanks!

-- Steve

> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 79f4bac..33b379d 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -507,7 +507,10 @@ get_return_for_leaf(struct trace_iterator *iter,
>  			 * if the output fails.
>  			 */
>  			data->ent = *curr;
> -			data->ret = *next;
> +			if (next->ent.type == TRACE_GRAPH_RET)
> +				data->ret = *next;
> +			else
> +				data->ret.ent.type = next->ent.type;
>  		}
>  	}
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


