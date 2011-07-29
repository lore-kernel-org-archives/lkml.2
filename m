Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1G2SKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:10:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1G2SKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:10:20 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=iXCjJXf3P6AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=xnBfsPzpLUH7H9hBMUwA:9 a=gQP61ArXGkIlXC2wjIkA:7 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=A1St5Q3enI9pJ2dP:21 a=_RhiicLDNiV2r0AU:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/5] trace: Add ring buffer stats to measure rate of
 events
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1311721194-12164-3-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
	 <1311721194-12164-3-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 14:10:18 -0400
Message-ID: <1311963018.21143.73.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 15:59 -0700, Vaibhav Nagarnaik wrote:
> The stats file under per_cpu folder provides the number of entries,
> overruns and other statistics about the CPU ring buffer. However, the
> numbers do not provide any indication of how full the ring buffer is in
> bytes compared to the overall size in bytes. Also, it is helpful to know
> the rate at which the cpu buffer is filling up.
> 
> This patch adds an entry "bytes: " in printed stats for per_cpu ring
> buffer which provides the actual bytes consumed in the ring buffer. This
> field includes the number of bytes used by recorded events and the
> padding bytes added when moving the tail pointer to next page.
> 
> It also adds the following time stamps:
> "head ts:" - the oldest timestamp in the ring buffer


I hate the name of "head_ts", as it really is meaningless. The head of
our ring buffer is indeed the oldest events, but other ring buffers have
head as the newest. This is an internal name that should not be used
outside of the ring buffer code itself. Maybe call it "oldest_ts", or
even more verbose (and what it actually is), "oldest_event_ts".


> "now ts:"  - the timestamp at the time of reading
> 
> The field "now ts" provides a consistent time snapshot to the userspace
> when being read. This is read from the same trace clock used by tracing
> event timestamps.
> 
> Together, these values provide the rate at which the buffer is filling
> up, from the formula:
> bytes / (now_ts - head_ts)
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---

>  /**
> + * ring_buffer_head_ts - get the oldest event timestamp from the buffer
> + * @buffer: The ring buffer
> + * @cpu: The per CPU buffer to read from.
> + */
> +unsigned long ring_buffer_head_ts(struct ring_buffer *buffer, int cpu)

Hence, replace head_ts, with something else here.

Thanks,

-- Steve

> +{
> +	unsigned long flags;
> +	struct ring_buffer_per_cpu *cpu_buffer;
> +	struct buffer_page *bpage;
> +	unsigned long ret;
> +
> +	if (!cpumask_test_cpu(cpu, buffer->cpumask))
> +		return 0;
> +
> +	cpu_buffer = buffer->buffers[cpu];
> +	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
> +	/*
> +	 * if the tail is on reader_page, oldest time stamp is on the reader
> +	 * page
> +	 */
> +	if (cpu_buffer->tail_page == cpu_buffer->reader_page)
> +		bpage = cpu_buffer->reader_page;
> +	else
> +		bpage = rb_set_head_page(cpu_buffer);
> +	ret = bpage->page->time_stamp;
> +	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
> +
> +	return ret;
> +}


