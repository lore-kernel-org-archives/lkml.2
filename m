Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1HWAtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:49:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1HWAtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:49:05 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=WwlJiVmu3h4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WeO8DyxonXgUeFibRtwA:9 a=xGH53cSU8azWbwAAuZAA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v3] trace: Add per_cpu ring buffer control files
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1314050999-10409-1-git-send-email-vnagarnaik@google.com>
References: <1313531179-9323-4-git-send-email-vnagarnaik@google.com>
	 <1314050999-10409-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 22 Aug 2011 20:49:00 -0400
Message-ID: <1314060540.15704.143.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 15:09 -0700, Vaibhav Nagarnaik wrote:
>  
> @@ -3740,10 +3757,6 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
>  		goto out;
>  
> -	/* At least make sure the two buffers are somewhat the same */
> -	if (buffer_a->pages != buffer_b->pages)
> -		goto out;
> -
>  	ret = -EAGAIN;
>  
>  	if (ring_buffer_flags != RB_BUFFERS_ON)
> @@ -3758,6 +3771,12 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
>  	cpu_buffer_a = buffer_a->buffers[cpu];
>  	cpu_buffer_b = buffer_b->buffers[cpu];

I would move the cpu_buffer_(ab) assignments up instead, as I want the
EINVAL to have dominance. The record_disable just says that we are
temporarily out of commission, when in fact it could be invalid. Thus
the invalid conditions need to be treated first.

-- Steve

>  
> +	ret = -EINVAL;
> +	/* At least make sure the two buffers are somewhat the same */
> +	if (cpu_buffer_a->pages != cpu_buffer_b->pages)
> +		goto out;
> +
> +	ret = -EAGAIN;
>  	if (atomic_read(&cpu_buffer_a->record_disabled))
>  		goto out;
>  


