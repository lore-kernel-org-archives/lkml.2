Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2LHBYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:24:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab2LHBYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:24:14 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=u9ToMuZyKG8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=KTMpUcITluEA:10 a=r_1tXGB3AAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=2aemuAASldm4hqe6c4sA:9 a=PUjeQqilurYA:10 a=EDSpbFuiShEA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354929851.17101.105.camel@gandalf.local.home>
Subject: Re: [PATCH v2 04/44] trace/ring_buffer: handle 64bit aligned structs
From: Steven Rostedt <rostedt@goodmis.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Fri, 07 Dec 2012 20:24:11 -0500
In-Reply-To: <1354723742-6195-5-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
	 <1354723742-6195-5-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-05 at 16:08 +0000, James Hogan wrote:
> Some 32 bit architectures have 64 bit struct alignment (for example
> Meta which has 64 bit read/write instructions). These require 8 byte
> alignment of event data too, so use CONFIG_HAVE_64BIT_ALIGNED_STRUCT
> instead of CONFIG_64BIT to decide alignment, and align
> buffer_data_page::data accordingly.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index b979426..c4dc029 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -177,7 +177,8 @@ void tracing_off_permanent(void)
>  #define RB_MAX_SMALL_DATA	(RB_ALIGNMENT * RINGBUF_TYPE_DATA_TYPE_LEN_MAX)
>  #define RB_EVNT_MIN_SIZE	8U	/* two 32bit words */
>  
> -#if !defined(CONFIG_64BIT) || defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> +#if !defined(CONFIG_HAVE_64BIT_ALIGNED_STRUCT) || \
> +	defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>  # define RB_FORCE_8BYTE_ALIGNMENT	0
>  # define RB_ARCH_ALIGNMENT		RB_ALIGNMENT
>  #else
> @@ -185,6 +186,8 @@ void tracing_off_permanent(void)
>  # define RB_ARCH_ALIGNMENT		8U
>  #endif
>  
> +#define RB_ALIGN_DATA		__aligned(RB_ARCH_ALIGNMENT)
> +
>  /* define RINGBUF_TYPE_DATA for 'case RINGBUF_TYPE_DATA:' */
>  #define RINGBUF_TYPE_DATA 0 ... RINGBUF_TYPE_DATA_TYPE_LEN_MAX
>  
> @@ -333,7 +336,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_event_data);
>  struct buffer_data_page {
>  	u64		 time_stamp;	/* page time stamp */
>  	local_t		 commit;	/* write committed index */
> -	unsigned char	 data[];	/* data of buffer page */
> +	unsigned char	 data[] RB_ALIGN_DATA;	/* data of buffer page */
>  };
>  
>  /*


