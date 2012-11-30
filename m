Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab2K3QUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:20:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29759 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab2K3QUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:20:46 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=T9x2bjRdwFwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=dFgh_tzUenkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=R6e7cXeecl7ZAh5hFSAA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354292445.6276.162.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] ring-buffer: Fix NULL pointer if rb_set_head_page()
 fails
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 30 Nov 2012 11:20:45 -0500
In-Reply-To: <20121130161333.983378567@goodmis.org>
References: <20121130161238.909829067@goodmis.org>
	 <20121130161333.983378567@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-30 at 11:12 -0500, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The function rb_set_head_page() searches the list of ring buffer
> pages for a the page that has the HEAD page flag set. If it does
> not find it, it will do a WARN_ON(), disable the ring buffer and
> return NULL, as this should never happen.
> 
> But if this bug happens to happen, not all callers of this function
> can handle a NULL pointer being returned from it. That needs to be
> fixed.
> 
> Cc: stable@vger.kernel.org # 3.0+

Hmm, quilt didn't Cc. Grumble, I think a system update of quilt removed
my modification to not have quilt get confused by the hash symbol :-(

-- Steve

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index b979426..ec01803 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1396,6 +1396,8 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer)
>  		struct list_head *head_page_with_bit;
>  
>  		head_page = &rb_set_head_page(cpu_buffer)->list;
> +		if (!head_page)
> +			break;
>  		prev_page = head_page->prev;
>  
>  		first_page = pages->next;
> @@ -2934,7 +2936,7 @@ unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
>  	unsigned long flags;
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct buffer_page *bpage;
> -	unsigned long ret;
> +	unsigned long ret = 0;
>  
>  	if (!cpumask_test_cpu(cpu, buffer->cpumask))
>  		return 0;
> @@ -2949,7 +2951,8 @@ unsigned long ring_buffer_oldest_event_ts(struct ring_buffer *buffer, int cpu)
>  		bpage = cpu_buffer->reader_page;
>  	else
>  		bpage = rb_set_head_page(cpu_buffer);
> -	ret = bpage->page->time_stamp;
> +	if (bpage)
> +		ret = bpage->page->time_stamp;
>  	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
>  
>  	return ret;
> @@ -3260,6 +3263,8 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	 * Splice the empty reader page into the list around the head.
>  	 */
>  	reader = rb_set_head_page(cpu_buffer);
> +	if (!reader)
> +		goto out;
>  	cpu_buffer->reader_page->list.next = rb_list_head(reader->list.next);
>  	cpu_buffer->reader_page->list.prev = reader->list.prev;
>  


