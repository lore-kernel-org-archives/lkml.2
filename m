Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2K3QVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:21:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab2K3QVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:21:21 -0500
X-Authority-Analysis: v=2.0 cv=cuMZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=tT9fRLUzu9sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9vvjUtWwzb8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=tN5xWe8_vvL4AfRlGK0A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354292479.6276.163.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2] ring-buffer: Fix race between integrity check and
 readers
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 30 Nov 2012 11:21:19 -0500
In-Reply-To: <20121130161334.164485242@goodmis.org>
References: <20121130161238.909829067@goodmis.org>
	 <20121130161334.164485242@goodmis.org>
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
> The function rb_check_pages() was added to make sure the ring buffer's
> pages were sane. This check is done when the ring buffer size is modified
> as well as when the iterator is released (closing the "trace" file),
> as that was considered a non fast path and a good place to do a sanity
> check.
> 
> The problem is that the check does not have any locks around it.
> If one process were to read the trace file, and another were to read
> the raw binary file, the check could happen while the reader is reading
> the file.
> 
> The issues with this is that the check requires to clear the HEAD page
> before doing the full check and it restores it afterward. But readers
> require the HEAD page to exist before it can read the buffer, otherwise
> it gives a nasty warning and disables the buffer.
> 
> By adding the reader lock around the check, this keeps the race from
> happening.
> 
> Cc: stable@vger.kernel.org # 3.6

Again, quilt failed to Cc stable :-(

-- Steve

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index ec01803..4cb5e51 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -3783,12 +3783,17 @@ void
>  ring_buffer_read_finish(struct ring_buffer_iter *iter)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
> +	unsigned long flags;
>  
>  	/*
>  	 * Ring buffer is disabled from recording, here's a good place
> -	 * to check the integrity of the ring buffer. 
> +	 * to check the integrity of the ring buffer.
> +	 * Must prevent readers from trying to read, as the check
> +	 * clears the HEAD page and readers require it.
>  	 */
> +	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
>  	rb_check_pages(cpu_buffer);
> +	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
>  
>  	atomic_dec(&cpu_buffer->record_disabled);
>  	atomic_dec(&cpu_buffer->buffer->resize_disabled);


