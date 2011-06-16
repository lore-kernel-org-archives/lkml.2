Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab1FPNR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:17:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1FPNRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:17:21 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=0tApZq9ujVUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=r_1tXGB3AAAA:8 a=1eaDYNr8cK8zg3hpklsA:9 a=iNyUJHFp_bhoJqoB2oUA:7 a=PUjeQqilurYA:10 a=EDSpbFuiShEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] ring_buffer: Ensure that buffer page data is aligned.
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Newton <will.newton@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTimG_oBX1bDTEVfZ81_uqXOahqR1ww@mail.gmail.com>
References: <BANLkTimG_oBX1bDTEVfZ81_uqXOahqR1ww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Jun 2011 09:17:19 -0400
Message-ID: <1308230239.9218.137.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 14:03 +0100, Will Newton wrote:
> Explicitly align the start of the buffer page data array to the
> required arch alignment. This is required for architectures that
> require 8 byte alignment but do not have a 8 byte local_t.

What arch does that? A 32bit arch that forces 8 byte alignment?

> 
> Signed-off-by: Will Newton <will.newton@imgtec.com>
> ---
>  kernel/trace/ring_buffer.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> I don't believe that any currently in-tree architecture is affected by
> this, but it can be an issue on 32bit architectures that require an
> 8 byte aligment but only have a 32bit local_t. I think it's potentially
> cleaner to make the alignment explicit anyway.
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 0ef7b4b..36d5699 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -215,6 +215,8 @@ EXPORT_SYMBOL_GPL(tracing_is_on);
>  # define RB_ARCH_ALIGNMENT		8U
>  #endif
> 
> +#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
> +

Note, the code above this is:

#define RB_EVNT_HDR_SIZE (offsetof(struct ring_buffer_event, array))
#define RB_ALIGNMENT		4U
#define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
#define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */

#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
# define RB_FORCE_8BYTE_ALIGNMENT	0
# define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
#else
# define RB_FORCE_8BYTE_ALIGNMENT	1
# define RB_ARCH_ALIGNMENT		8U
#endif


Which means that when CONFIG_64BIT is not set, RB_ARCH_ALIGNMENT is 4.
This means that this patch is really a nop and doesn't do anything for
your arch.

-- Steve

>  /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
>  #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
> 
> @@ -363,7 +365,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
>  struct buffer_data_page {
>  	u64		 time_stamp;	/* page time stamp */
>  	local_t		 commit;	/* write committed index */
> -	unsigned char	 data[];	/* data of buffer page */
> +	unsigned char	 data[] RB_ALIGN_DATA;	/* data of buffer page */
>  };
> 
>  /*


