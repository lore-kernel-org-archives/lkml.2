Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1EZD3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 23:29:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1EZD3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 23:29:54 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vVy0PQ3ZQx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BSRpaT8CubRYMRhdPBkA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Add a free on close control mechanism for
 buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
In-Reply-To: <1304118968-6620-1-git-send-email-vnagarnaik@google.com>
References: <1304106356-11277-1-git-send-email-vnagarnaik@google.com>
	 <1304118968-6620-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 25 May 2011 23:29:51 -0400
Message-ID: <1306380591.1465.140.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 16:16 -0700, Vaibhav Nagarnaik wrote:

> +static ssize_t tracing_resize_ring_buffer(unsigned long size)
> +{
> +	int cpu, ret = 0;
> +
> +	mutex_lock(&trace_types_lock);
> +
> +	tracing_stop();
> +
> +	/* disable all cpu buffers */
> +	for_each_tracing_cpu(cpu) {
> +		if (global_trace.data[cpu])
> +			atomic_inc(&global_trace.data[cpu]->disabled);
> +		if (max_tr.data[cpu])
> +			atomic_inc(&max_tr.data[cpu]->disabled);
> +	}
> +
> +	if (size != global_trace.entries)
> +		ret = __tracing_resize_ring_buffer(size);
> +
> +	/* If check pages failed, return ENOMEM */
> +	if (tracing_disabled)
> +		ret = -ENOMEM;

This is incorrect. tracing_disabled is set from
__tracing_resize_ring_buffer() if the max buffer can't become the same
size as the global buffer.

What you should do is just check if ret is less than zero here.

	if (ret < 0)
		ret = -ENOMEM;

-- Steve


> +
> +	for_each_tracing_cpu(cpu) {
> +		if (global_trace.data[cpu])
> +			atomic_dec(&global_trace.data[cpu]->disabled);
> +		if (max_tr.data[cpu])
> +			atomic_dec(&max_tr.data[cpu]->disabled);
> +	}
> +
> +	tracing_start();
> +	mutex_unlock(&trace_types_lock);
> +
> +	return ret;
> +}
> +
>  

