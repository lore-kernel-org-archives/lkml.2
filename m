Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968157Ab2ERWZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:25:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966531Ab2ERWZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:25:13 -0400
Date: Fri, 18 May 2012 17:25:07 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] Trace event for capable().
Message-ID: <20120518222507.GA7188@sergelap>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Auke Kok (auke-jan.h.kok@intel.com):
> Add a simple trace event for capable().
> 
> There's been a lot of discussion around capable(), and there
> are plenty of tools to help reduce capabilities' usage from
> userspace. A major gap however is that it's almost impossible
> to see or verify which bits are requested from either userspace
> or in the kernel.
> 
> This patch adds a minimal tracer that will print out which
> CAPs are requested and whether the request was granted.
> 
> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Hi,

is there any measurable performance impact by this patch?  (Have you
measured it?)

I'm not familiar enough with the tracing stuff, but if the tracing is
done so there's no impact when not tracing, then I have no problem with
this.  It could be quite useful as you say.

Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>

thanks,
-serge

> Cc: Eric Paris <eparis@redhat.com>
> ---
>  include/trace/events/capabilities.h |   33 +++++++++++++++++++++++++++++++++
>  kernel/capability.c                 |    5 +++++
>  2 files changed, 38 insertions(+)
>  create mode 100644 include/trace/events/capabilities.h
> 
> diff --git a/include/trace/events/capabilities.h b/include/trace/events/capabilities.h
> new file mode 100644
> index 0000000..97997fa
> --- /dev/null
> +++ b/include/trace/events/capabilities.h
> @@ -0,0 +1,33 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM capabilities
> +
> +#if !defined(_TRACE_CAPABILITIES_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_CAPABILITIES_H
> +
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(capable,
> +
> +	TP_PROTO(pid_t pid, int cap, bool rc),
> +
> +	TP_ARGS(pid, cap, rc),
> +
> +	TP_STRUCT__entry(
> +		__field(pid_t, pid)
> +		__field(int, cap)
> +		__field(bool, rc)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pid = pid;
> +		__entry->cap = cap;
> +		__entry->rc = rc;
> +	),
> +
> +	TP_printk("pid=%d cap=%d rc=%d", __entry->pid, __entry->cap, __entry->rc)
> +);
> +
> +#endif /* _TRACE_CAPABILITIES_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 3f1adb6..2941f37 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -17,6 +17,9 @@
>  #include <linux/user_namespace.h>
>  #include <asm/uaccess.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/capabilities.h>
> +
>  /*
>   * Leveraged for setting/resetting capabilities
>   */
> @@ -386,8 +389,10 @@ bool ns_capable(struct user_namespace *ns, int cap)
>  
>  	if (security_capable(current_cred(), ns, cap) == 0) {
>  		current->flags |= PF_SUPERPRIV;
> +		trace_capable(current->pid, cap, true);
>  		return true;
>  	}
> +	trace_capable(current->pid, cap, false);
>  	return false;
>  }
>  EXPORT_SYMBOL(ns_capable);
> -- 
> 1.7.10
> 
