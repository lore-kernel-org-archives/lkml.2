Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2B2Mw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:52:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab2B2Mwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:52:54 -0500
Message-ID: <4F4E1F91.9080705@redhat.com>
Date: Wed, 29 Feb 2012 09:52:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org>
In-Reply-To: <1330445487-15020-2-git-send-email-bp@amd64.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-02-2012 13:11, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> The idea here is to pass an additional decoded MCE message through
> the tracepoint and into the ring buffer for userspace to consume. The
> designated consumers are RAS daemons and other tools collecting RAS
> information.
> 
> Drop unneeded fields while at it, thus saving some room in the ring
> buffer.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  include/trace/events/mce.h       |   22 +++++++---------------
>  2 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 5a11ae2e9e91..072e020ecaf3 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -144,7 +144,7 @@ void mce_log(struct mce *mce)
>  	int ret = 0;
>  
>  	/* Emit the trace record: */
> -	trace_mce_record(mce);
> +	trace_mce_record("", mce);
>  
>  	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
>  	if (ret == NOTIFY_STOP)
> diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
> index 4cbbcef6baa8..5fada9a40708 100644
> --- a/include/trace/events/mce.h
> +++ b/include/trace/events/mce.h
> @@ -10,11 +10,12 @@
>  
>  TRACE_EVENT(mce_record,
>  
> -	TP_PROTO(struct mce *m),
> +	TP_PROTO(const char *msg, struct mce *m),

While is very easy to fold everything into a single errror message field,
doing that makes harder for userspace to break the string into the components, 
as already discussed.

The big advantage of using perf, instead of printk is that it allows to pass
the fields into a binary form, instead of passing a single string to userspace.
We should use this feature, otherwise, there's no sense on using perf at all.

Also, even if we agree on some string format to make parsing easier, we're not
good on preserving the kernel-userspace API for string messages, so regressions
can (and will likely) be introduced by a simple change at the "msg" field.

On a complex environment, the network farm is monitored by a Network Management
System. On such systems, there are some fields that are very relevant:
	- how critical is the error;
	- the location of the error;
	- the error message.

So, we should, at least, break it into 3 fields. Yet, for location, there are
two ways of reporting it: The silkscreen label of the affected component
(a CPU socket label, a memory slot label, a PCI slot label, etc),
and the location of the affected element, which generally more granular, like
the cache level, the memory bank, etc.

What I'm saying is that, we should, at least, add 4 fields there, instead of one:

	- severity
	- location
	- silkscreen_label
	- error_msg
	
The severity should be an enum type. 

>  
> -	TP_ARGS(m),
> +	TP_ARGS(msg, m),
>  
>  	TP_STRUCT__entry(
> +		__string(	msg,		msg		)
>  		__field(	u64,		mcgcap		)
>  		__field(	u64,		mcgstatus	)
>  		__field(	u64,		status		)
> @@ -24,15 +25,12 @@ TRACE_EVENT(mce_record,
>  		__field(	u64,		tsc		)
>  		__field(	u64,		walltime	)
>  		__field(	u32,		cpu		)

This one can be merged into the location field, for the errors where
it is pertinent.

> -		__field(	u32,		cpuid		)
> -		__field(	u32,		apicid		)

It seems safe to get rid of them.

> -		__field(	u32,		socketid	)

For CPU errors, the socket ID is the location of the error. This is
probably the most important "ID" field, as it represents the component
that may need to be replaced.

Yet, by adding a silkscreen_label field, it seems safe to get rid of it.

>  		__field(	u8,		cs		)
>  		__field(	u8,		bank		)
> -		__field(	u8,		cpuvendor	)

Assuming that some daemon would collect those errors on the monitored machine
and pass them to another machine that will store it and parse (this is a typical
scenario for monitored environments),  I don't think we can get rid of the
cpuvendor, as this field is required to decode the MCE registers. It is likely
that we need to add also the CPU family and step here, as the MCE decoding
depends on them.

On the other hand, the userspace daemon can easily get it by parsing /proc/cpuinfo.

So, it is probably ok to remove it.

>  	),
>  
>  	TP_fast_assign(
> +		__assign_str(msg,	msg);
>  		__entry->mcgcap		= m->mcgcap;
>  		__entry->mcgstatus	= m->mcgstatus;
>  		__entry->status		= m->status;
> @@ -42,25 +40,19 @@ TRACE_EVENT(mce_record,
>  		__entry->tsc		= m->tsc;
>  		__entry->walltime	= m->time;
>  		__entry->cpu		= m->extcpu;
> -		__entry->cpuid		= m->cpuid;
> -		__entry->apicid		= m->apicid;
> -		__entry->socketid	= m->socketid;
>  		__entry->cs		= m->cs;
>  		__entry->bank		= m->bank;
> -		__entry->cpuvendor	= m->cpuvendor;
>  	),
>  
> -	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
> +	TP_printk("%s" HW_ERR "CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, TIME: %llu)",
> +		__get_str(msg),
>  		__entry->cpu,
>  		__entry->mcgcap, __entry->mcgstatus,
>  		__entry->bank, __entry->status,
>  		__entry->addr, __entry->misc,
>  		__entry->cs, __entry->ip,
>  		__entry->tsc,
> -		__entry->cpuvendor, __entry->cpuid,
> -		__entry->walltime,
> -		__entry->socketid,
> -		__entry->apicid)
> +		__entry->walltime)
>  );
>  
>  #endif /* _TRACE_MCE_H */

