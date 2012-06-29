Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2F2MZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:25:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18733 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2F2MZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:25:43 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=2lFTh0urSm0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=1XWaLZrsAAAA:8 a=DhiXXOCnvGlBRRFihSkA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340972741.16702.105.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tracing: Update entries counter when removing pages
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 29 Jun 2012 08:25:41 -0400
In-Reply-To: <1340046722-11477-1-git-send-email-vnagarnaik@google.com>
References: <1340046722-11477-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 12:12 -0700, Vaibhav Nagarnaik wrote:
> When removing pages from the ring buffer, its state is not reset. This
> means that the counters need to be correctly updated to account for the
> pages removed.
> 
> Update the entries counter to reflect the removed events from the
> pages just like entries_bytes counter.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  kernel/trace/ring_buffer.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 96c2dd1..a2bec4c 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1346,10 +1346,10 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned int nr_pages)
>  			 * If something was added to this page, it was full
>  			 * since it is not the tail page. So we deduct the
>  			 * bytes consumed in ring buffer from here.
> -			 * No need to update overruns, since this page is
> -			 * deleted from ring buffer and its entries are
> -			 * already accounted for.
> +			 * No need to update overruns, since updating
> +			 * 'entries' accounts for that.
>  			 */
> +			local_sub(page_entries, &cpu_buffer->entries);

Actually, I think it would be better to increment overrun instead. As
these are lost events, and that is what overrun counts. I just tested it
with: local_add(page_entries, &cpu_buffer->overrun); and it works well.
Showing the lost events.

-- Steve

>  			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
>  		}
>  


