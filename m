Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab1ESHbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:31:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52157 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449Ab1ESHbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:31:39 -0400
Date: Thu, 19 May 2011 09:31:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
Message-ID: <20110519073136.GB14049@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Stephane Eranian <eranian@google.com>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:06:25AM +0200, Frederic Weisbecker wrote:
> Keeping perf_output_copy() inlined is responsible
> of some ugliness there.
> 
> A solution could be to have an internal only
> perf_output_copy_inline() version in internal.h
> and a wrapper in buffer.c that exports it.
> 
> Or we can completely uninline it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/perf_event.h |   47 +++++-
>  kernel/events/Makefile     |    2 +-
>  kernel/events/buffer.c     |  394 +++++++++++++++++++++++++++++++++++++++
>  kernel/events/core.c       |  442 +-------------------------------------------
>  kernel/events/internal.h   |   28 +++
>  5 files changed, 476 insertions(+), 437 deletions(-)
>  create mode 100644 kernel/events/buffer.c
>  create mode 100644 kernel/events/internal.h
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 3412684..02952d4 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1142,12 +1142,55 @@ extern void perf_bp_event(struct perf_event *event, void *data);
>  # define perf_instruction_pointer(regs)	instruction_pointer(regs)
>  #endif
>  
> +#ifdef CONFIG_PERF_USE_VMALLOC
> +/*
> + * Back perf_mmap() with vmalloc memory.
> + *
> + * Required for architectures that have d-cache aliasing issues.
> + */
> +
> +static inline int perf_output_page_order(struct perf_buffer *buffer)
> +{
> +	return buffer->page_order;
> +}
> +
> +#else
> +
> +static inline int perf_output_page_order(struct perf_buffer *buffer)
> +{
> +	return 0;
> +}
> +#endif
> +
>  extern int perf_output_begin(struct perf_output_handle *handle,
>  			     struct perf_event *event, unsigned int size,
>  			     int nmi, int sample);
>  extern void perf_output_end(struct perf_output_handle *handle);
> -extern void perf_output_copy(struct perf_output_handle *handle,
> -			     const void *buf, unsigned int len);
> +
> +static inline void
> +perf_output_copy(struct perf_output_handle *handle,
> +		 const void *buf, unsigned int len)
> +{
> +	do {
> +		unsigned long size = min_t(unsigned long, handle->size, len);
> +
> +		memcpy(handle->addr, buf, size);
> +
> +		len -= size;
> +		handle->addr += size;
> +		buf += size;
> +		handle->size -= size;
> +		if (!handle->size) {
> +			struct perf_buffer *buffer = handle->buffer;
> +
> +			handle->page++;
> +			handle->page &= buffer->nr_pages - 1;
> +			handle->addr = buffer->data_pages[handle->page];
> +			handle->size = PAGE_SIZE << perf_output_page_order(buffer);
> +		}
> +	} while (len);
> +}

Ok, maybe I'm missing something looking at this from the side but
perf_output_copy is used only internally by perf_event.c, i.e.
events/core.c, why not put it into the internal.h header?

The rest looks ok.

Thanks.

-- 
Regards/Gruss,
    Boris.
