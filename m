Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab2ESG7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:59:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37091 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab2ESG7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:59:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
Date: Sat, 19 May 2012 00:59:19 -0600
In-Reply-To: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com> (Auke
	Kok's message of "Thu, 17 May 2012 12:50:00 -0700")
Message-ID: <87havchd14.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18iG8sWL8kLjqa4mmR19wi9sZ3O9hMZI50=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Auke Kok <auke-jan.h.kok@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Trace event for capable().
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Auke Kok <auke-jan.h.kok@intel.com> writes:

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

A small comment assigned from the other issues.

current->pid for anything going to userspace is broken,
and in fact current->pid should be killed on of these days.

Which pid namespace is your tracer running in?

> Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
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
