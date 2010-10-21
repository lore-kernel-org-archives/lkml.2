Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0JUDnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:43:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52794 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392Ab0JUDnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UFCvwBYxP9nZdaRws3nZmUsrAW5dDF5t5O4sC1Mn6aWvetzPd9iLz41DqtVZ6eOxJm
         eOdAtmWLMBHs8Clp21rLZCBT1uTQQVQ7a2VEJsSlBO7vHi6hWRvjjU7WNPB8ICNaqRjd
         GwlnyizaBqasHVAwRGS26wUPDIPRw9I9PCFP4=
Date: Thu, 21 Oct 2010 05:42:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] tracing: Prevent unloadable modules from using
	trace_bprintk()
Message-ID: <20101021034255.GG5387@nowhere>
References: <20101021024233.530237054@goodmis.org> <20101021024304.827826848@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021024304.827826848@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 10:42:34PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> While debugging a module, I found that unloading the module and
> then reading the ring buffer can cause strange side effects, including
> a kernel crash.
> 
> This is due to the trace_bprintk(). The trace_bprintk() is a faster
> version of trace_printk(). The difference is that trace_bprintk()
> only copies the arguments and a pointer to the format string into
> the ring buffer.
> 
> If a module uses this function and is unloaded, the pointer back to
> the format string in the module is still around. If the trace file
> is read, then the pointer is referenced and this can cause a kernel
> oops.
> 
> The simple solution is to not let modules use trace_bprintk() and
> instead it will use the slower version of this.
> 
> When talking with Frederic Weisbecker about it, he suggested not to
> punish modules that can not be unloaded since they do not have
> this side effect. Modules that can not be unloaded can still use
> trace_bprintk(). We added a check for MODVERSIONS to be set to make
> sure that the module and kernel have the same options. If you
> run without MODVERSIONS set, and you load a module that was compiled
> differently, then that's just your tough luck.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/kernel.h      |   21 +++++++++++++++++++--
>  kernel/trace/trace_printk.c |    2 ++
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2b0a35e..1003476 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -538,6 +538,23 @@ do {									\
>  		____trace_printk_check_format(fmt, ##args);		\
>  } while (0)
>  
> +/*
> + * Module code must not use trace_bprintk, because if it is unloaded
> + * then we leave a pointer back to the module code inside
> + * the ring buffer, and then reading the ring buffer may cause a bug.
> + *
> + * We do allow for modules to use it if the kernel does not allow
> + * unloading of modules, and MODVERSIONS is set (to make sure kernel
> + * and module are the same). If you load modules without MODVERSIONS
> + * set, then you deserve what you get.
> + */
> +#if defined(MODULE) &&							\



Did you mean CONFIG_MODULE may be?

Thanks.

