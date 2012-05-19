Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971Ab2ESB4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:56:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13016 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab2ESB4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:56:01 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=bvAfA6HpYssA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=wpyJPee4o0gUS_mToHQA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337392560.7562.21.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Merge separate resize loops
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Laurent Chavey <chavey@google.com>, Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Date: Fri, 18 May 2012 21:56:00 -0400
In-Reply-To: <1337372991-14783-1-git-send-email-vnagarnaik@google.com>
References: <1337372991-14783-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 13:29 -0700, Vaibhav Nagarnaik wrote:
>  
>  		/* wait for all the updates to complete */
>  		for_each_buffer_cpu(buffer, cpu) {
>  			cpu_buffer = buffer->buffers[cpu];
> -			if (!cpu_buffer->nr_pages_to_update||
> -			    !cpu_online(cpu))
> +			if (!cpu_buffer->nr_pages_to_update)
>  				continue;
>  

Why did you make this change? As we only need to wait for completions.

> -			wait_for_completion(&cpu_buffer->update_completion);
> -			/* reset this value */
> +			if (cpu_online(cpu))
> +				wait_for_completion(&cpu_buffer->update_done);
>  			cpu_buffer->nr_pages_to_update = 0;

Or was the original patch buggy, where we never set nr_page_to_update to
zero for the offline case?

-- Steve

>  		}
>  
>  		put_online_cpus();
>  	} else {
>  		cpu_buffer = buffer->buffers[cpu_id];
> +
>  		if (nr_pages == cpu_buffer->nr_pages)
>  			goto out;
>  
> @@ -1588,13 +1579,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
>  		if (cpu_online(cpu_id)) {
>  			schedule_work_on(cpu_id,
>  					 &cpu_buffer->update_pages_work);
> -			wait_for_completion(&cpu_buffer->update_completion);
> +			wait_for_completion(&cpu_buffer->update_done);
>  		} else
>  			rb_update_pages(cpu_buffer);
>  
> -		put_online_cpus();
> -		/* reset this value */
>  		cpu_buffer->nr_pages_to_update = 0;
> +		put_online_cpus();
>  	}
>  
>   out:


