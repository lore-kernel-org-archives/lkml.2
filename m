Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab0C2SUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:20:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0C2SUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:20:47 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=V-gup5Z7nNkA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=YgwN3AOMAAAA:8 a=GAayKU688pGI6bjy5XoA:9 a=HLo66CJCR9zrFfBTZ6IA:7 a=Nq_Rc0-nB5GcPO80AFnDHvYP-OAA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 12/12] kernel/trace: Add missing unlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Julia Lawall <julia@diku.dk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1003291736440.21896@ask.diku.dk>
References: <Pine.LNX.4.64.1003291736440.21896@ask.diku.dk>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 29 Mar 2010 14:20:44 -0400
Message-ID: <1269886844.19685.4705.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 17:37 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In some error handling cases the lock is not unlocked.  The return is
> converted to a goto, to share the unlock at the end of the function.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression E1;
> identifier f;
> @@
> 
> f (...) { <+...
> * spin_lock_irq (E1,...);
> ... when != E1
> * return ...;
> ...+> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks!

-- Steve

> ---
>  kernel/trace/ring_buffer.c          |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 05a9f83..cd2e1d8 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1201,18 +1201,19 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned nr_pages)
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
> -			return;
> +			goto out;
>  		p = cpu_buffer->pages->next;
>  		bpage = list_entry(p, struct buffer_page, list);
>  		list_del_init(&bpage->list);
>  		free_buffer_page(bpage);
>  	}
>  	if (RB_WARN_ON(cpu_buffer, list_empty(cpu_buffer->pages)))
> -		return;
> +		goto out;
>  
>  	rb_reset_cpu(cpu_buffer);
>  	rb_check_pages(cpu_buffer);
>  
> +out:
>  	spin_unlock_irq(&cpu_buffer->reader_lock);
>  }
>  
> @@ -1229,7 +1230,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  
>  	for (i = 0; i < nr_pages; i++) {
>  		if (RB_WARN_ON(cpu_buffer, list_empty(pages)))
> -			return;
> +			goto out;
>  		p = pages->next;
>  		bpage = list_entry(p, struct buffer_page, list);
>  		list_del_init(&bpage->list);
> @@ -1238,6 +1239,7 @@ rb_insert_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	rb_reset_cpu(cpu_buffer);
>  	rb_check_pages(cpu_buffer);
>  
> +out:
>  	spin_unlock_irq(&cpu_buffer->reader_lock);
>  }
>  


