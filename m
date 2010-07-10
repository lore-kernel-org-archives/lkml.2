Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0GJBRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 21:17:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0GJBRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 21:17:13 -0400
X-Authority-Analysis: v=1.1 cv=iR3a2x+wy8z+UqYHl7KFtKHYySPA0Tf/DXXAzrkvAHo= c=1 sm=0 a=WnsvnuwlmikA:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=fv-tAh-MAAAA:8 a=pnv-ruCEqLdSKi3lwqYA:9 a=2aAGGiN3FwlFPvjjuOYA:7 a=qDVtEUcC4mASgp7AA31N32AxG-kA:4 a=PUjeQqilurYA:10 a=ZnwwQfAZUQcA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/2] Add trace events to mmap and brk
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Eric B Munson <emunson@mgebm.net>
Cc: akpm@linux-foundation.org, mingo@redhat.com, hugh.dickins@tiscali.co.uk,
       riel@redhat.com, peterz@infradead.org, anton@samba.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1278690830-22145-1-git-send-email-emunson@mgebm.net>
References: <1278690830-22145-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 21:17:11 -0400
Message-ID: <1278724631.1537.176.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 16:53 +0100, Eric B Munson wrote:
> As requested by Peter Zijlstra, this patch builds on my earlier patch
> and adds the corresponding trace points to mmap and brk.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> ---
>  include/trace/events/mm.h |   38 ++++++++++++++++++++++++++++++++++++++
>  mm/mmap.c                 |   10 +++++++++-
>  2 files changed, 47 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/mm.h b/include/trace/events/mm.h
> index c3a3857..1563988 100644
> --- a/include/trace/events/mm.h
> +++ b/include/trace/events/mm.h
> @@ -24,6 +24,44 @@ TRACE_EVENT(munmap,
>  	TP_printk("unmapping %u bytes at %lu\n", __entry->len, __entry->start)
>  );
>  
> +TRACE_EVENT(brk,
> +	TP_PROTO(unsigned long addr, unsigned long len),
> +
> +	TP_ARGS(addr, len),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, addr)
> +		__field(unsigned long, len)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->addr = addr;
> +		__entry->len = len;
> +	),
> +
> +	TP_printk("brk mmapping %lu bytes at %lu\n", __entry->len,
> +		   __entry->addr)
> +);
> +
> +TRACE_EVENT(mmap,
> +	TP_PROTO(unsigned long addr, unsigned long len),
> +
> +	TP_ARGS(addr, len),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, addr)
> +		__field(unsigned long, len)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->addr = addr;
> +		__entry->len = len;
> +	),
> +
> +	TP_printk("mmapping %lu bytes at %lu\n", __entry->len,
> +		   __entry->addr)
> +);
> +

Please convert the above two into DECLARE_EVENT_CLASS() and
DEFINE_EVENT(). You don't need the "mapping" and "brk mapping" in the
TP_printk() format since the event name will be displayed as well to
differentiate the two.

Thanks,

-- Steve

>  #endif /* _TRACE_MM_H_ */
>  
>  /* This part must be outside protection */
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0775a30..252e3e0 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -952,6 +952,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>  	unsigned int vm_flags;
>  	int error;
>  	unsigned long reqprot = prot;
> +	unsigned long ret;
>  
>  	/*
>  	 * Does the application expect PROT_READ to imply PROT_EXEC?
> @@ -1077,7 +1078,12 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>  	if (error)
>  		return error;
>  
> -	return mmap_region(file, addr, len, flags, vm_flags, pgoff);
> +	ret =  mmap_region(file, addr, len, flags, vm_flags, pgoff);
> +
> +	if (!(ret & ~PAGE_MASK))
> +		trace_mmap(addr, len);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(do_mmap_pgoff);
>  
> @@ -2218,6 +2224,8 @@ out:
>  		if (!mlock_vma_pages_range(vma, addr, addr + len))
>  			mm->locked_vm += (len >> PAGE_SHIFT);
>  	}
> +
> +	trace_brk(addr, len);
>  	return addr;
>  }
>  


