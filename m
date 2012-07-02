Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2GBQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:16:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2GBQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:16:26 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ics2-dk43mUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=F3LAwMfMUjJWa2PUErQA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341245784.6578.6.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/4] ring-buffer: Fix uninitialized read_stamp
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Sharp <dhsharp@google.com>
Date: Mon, 02 Jul 2012 12:16:24 -0400
In-Reply-To: <20120628231807.699907647@goodmis.org>
References: <20120628231625.869980334@goodmis.org>
	 <20120628231807.699907647@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 19:16 -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The ring buffer reader page is used to swap a page from the writable
> ring buffer. If the writer happens to be on that page, it ends up on the
> reader page, but will simply move off of it, back into the writable ring
> buffer as writes are added.
> 
> The time stamp passed back to the readers is stored in the cpu_buffer per
> CPU descriptor. This stamp is updated when a swap of the reader page takes
> place, and it reads the current stamp from the page taken from the writable
> ring buffer. Everytime a writer goes to a new page, it updates the time stamp
> of that page.
> 
> The problem happens if a reader reads a page from an empty per CPU ring buffer.
> If the buffer is empty, the swap still takes place, placing the writer at the
> start of the reader page. If at a later time, a write happens, it updates the
> page's time stamp and continues. But the problem is that the read_stamp does
> not get updated, because the page was already swapped.
> 
> The solution to this was to not swap the page if the ring buffer happens to
> be empty. This also removes the side effect that the writes on the reader
> page will not get updated because the writer never gets back on the reader
> page without a swap. That is, if a read happens on an empty buffer, but then
> no reads happen for a while. If a swap took place, and the writer were to start
> writing a lot of data (function tracer), it will start overflowing the ring buffer
> and overwrite the older data. But because the writer never goes back onto the
> reader page, the data left on the reader page never gets overwritten. This
> causes the reader to see really old data, followed by a jump to newer data.
> 
> Link: http://lkml.kernel.org/r/1340060577-9112-1-git-send-email-dhsharp@google.com
> Google-Bug-Id: 6410455
> Reported-by: David Sharp <dhsharp@google.com>
> tested-by: David Sharp <dhsharp@google.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

I'm starting to consider that this patch should be in stable.

Ingo, should I push this to urgent?

-- Steve

> ---
>  kernel/trace/ring_buffer.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 1d0f6a8..82a3e0c 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -3239,6 +3239,10 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	if (cpu_buffer->commit_page == cpu_buffer->reader_page)
>  		goto out;
>  
> +	/* Don't bother swapping if the ring buffer is empty */
> +	if (rb_num_of_entries(cpu_buffer) == 0)
> +		goto out;
> +
>  	/*
>  	 * Reset the reader page to size zero.
>  	 */


