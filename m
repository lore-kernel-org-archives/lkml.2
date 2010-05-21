Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0EULPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:15:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab0EULPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:15:41 -0400
X-Authority-Analysis: v=1.1 cv=APwCx09NCuKDvl2mjFwkKdJZScS8XOZHPgx3WG6BpL0= c=1 sm=0 a=itNhnfdbGUoA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=a0pwoTYIkv52p8aK-ukA:9 a=xzzUEe34HKX5hb3VoEkA:7 a=N4gP-O_OJuTe_jVDflXY5Xp0DfAA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 09/10] perf: Remove more fastpath code
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521090710.852926930@chello.nl>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.852926930@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 21 May 2010 07:15:38 -0400
Message-ID: <1274440538.26328.3575.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 11:02 +0200, Peter Zijlstra wrote:
> plain text document attachment (perf-opt-output-more.patch)
> Sanity checks cost instructions
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> -
> -	/*
> -	 * Check we didn't copy past our reservation window, taking the
> -	 * possible unsigned int wrap into account.
> -	 */
> -	if (WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0))
> -		return;

Are you sure you want to remove this? I mean, sanity checks are a small
cost (I have several in the ftrace ring buffer) and can catch bugs in
case something happens during development. Especially when the code is
under a lot of flux.

I even have a sanity check that Ingo asked me to add, which would detect
if a tracer (not the ring buffer, but the user of the ring buffer)
recursed on itself. I think that check detected one bug in the function
tracer in the begging, but hasn't caught anything since.

-- Steve

> -
>  	do {
> -		unsigned long size = min(handle->size, len);
> +		unsigned long size = min_t(unsigned long, handle->size, len);
>  
>  		memcpy(handle->addr, buf, size);
>  
> @@ -3054,15 +3045,12 @@ int perf_output_begin(struct perf_output
>  			goto fail;
>  	} while (local_cmpxchg(&data->head, offset, head) != offset);
>  
> -	handle->offset	= offset;
> -	handle->head	= head;
> -
>  	if (head - local_read(&data->wakeup) > data->watermark)
>  		local_add(data->watermark, &data->wakeup);
>  
> -	handle->page = handle->offset >> (PAGE_SHIFT + page_order(data));
> +	handle->page = offset >> (PAGE_SHIFT + page_order(data));
>  	handle->page &= data->nr_pages - 1;
> -	handle->size = handle->offset & ((PAGE_SIZE << page_order(data)) - 1);
> +	handle->size = offset & ((PAGE_SIZE << page_order(data)) - 1);
>  	handle->addr = data->data_pages[handle->page];
>  	handle->addr += handle->size;
>  	handle->size = (PAGE_SIZE << page_order(data)) - handle->size;
> 
> 


