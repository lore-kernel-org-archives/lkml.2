Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0HQJN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:13:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:33974 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab0HQJN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,381,1278313200"; 
   d="scan'208";a="828879690"
Subject: Re: [RFC -tip]
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100816110253.GD5805@lenovo>
References: <20100816110253.GD5805@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 17:14:01 +0800
Message-ID: <1282036441.11858.14.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 19:02 +0800, Cyrill Gorcunov wrote:
> Hi,
> 
> please review the approach, I can't test it due to lack
> of hw (btw Ming, if you have some spare minutes -- mind to
> pass some event as RAW and see how it goes?).

#raw event for cpu cycles
perf top -e r3000020c0403c000

#raw event for cache-misses
perf top -e r120e00030803e000

I tried some raw events and it works.

> 
> It just unifdef perf_event_p4.h and export it to user space.
> 
> Any complains are welcome. I've considered a separate header
> file without #ifdef which would consists of definitions user
> space may need but in result it become more messy then a few
> #ifdefs in shared header.
> 
> 	-- Cyrill
> ---
> perf, x86: Export RAW events specification to user space
> 
> P4 RAW events are tricky and need special bits passed from
> userspace, we export RAW events specification so the user
> space libraries may use it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Stephane Eranian <eranian@google.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Frédéric Weisbecker <fweisbec@gmail.com>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/include/asm/Kbuild          |    1 +
>  arch/x86/include/asm/perf_event_p4.h |   35 +++++++++++++++++++++++++++++++----
>  2 files changed, 32 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/Kbuild
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/Kbuild
> +++ linux-2.6.git/arch/x86/include/asm/Kbuild
> @@ -24,3 +24,4 @@ unifdef-y += unistd_32.h
>  unifdef-y += unistd_64.h
>  unifdef-y += vm86.h
>  unifdef-y += vsyscall.h
> +unifdef-y += perf_event_p4.h

+header-y += perf_event_p4.h

Need to update this to header-y.

Thanks,
Lin Ming

> Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
> +++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
> @@ -5,6 +5,8 @@
>  #ifndef PERF_EVENT_P4_H
>  #define PERF_EVENT_P4_H
>  
> +#ifdef __KERNEL__
> +
>  #include <linux/cpu.h>
>  #include <linux/bitops.h>
>  
> @@ -92,10 +94,16 @@
>  #define P4_ESCR_EMASK_BIT(class, name)		class##__##name
>  
>  /*
> - * config field is 64bit width and consists of
> - * HT << 63 | ESCR << 32 | CCCR
> - * where HT is HyperThreading bit (since ESCR
> - * has it reserved we may use it for own purpose)
> + * the config field is 64 bit width and has the following format
> + *
> + * Bits		Meaning
> + * -----	-------
> + *  0-6		Metric value from enum P4_PEBS_METRIC (optional)
> + *  7-11	Reserved
> + * 12-31	Bits 12-31 of CCCR register (Intel SDM Vol 3)
> + * 32-56	Bits  0-24 of ESCR register (Intel SDM Vol 3)
> + * 57-62	Event key from enum P4_EVENTS
> + *    63	We use it to track event migration between HT threads
>   *
>   * note that this is NOT the addresses of respective
>   * ESCR and CCCR but rather an only packed value should
> @@ -206,6 +214,21 @@ static inline u32 p4_default_escr_conf(i
>  	return escr;
>  }
>  
> +#endif /* __KERNEL__ */
> +
> +/*
> + * RAW events specification
> + *
> + * Bits		Meaning
> + * -----	-------
> + *  0-6		Metric value from enum P4_PEBS_METRIC (if needed)
> + *  7-11	Reserved, set to 0
> + * 12-31	Bits 12-31 of CCCR register (Intel SDM Vol 3)
> + * 32-56	Bits  0-24 of ESCR register (Intel SDM Vol 3)
> + * 57-62	Event key from enum P4_EVENTS
> + *    63	Reserved, set to 0
> + */
> +
>  /*
>   * This are the events which should be used in "Event Select"
>   * field of ESCR register, they are like unique keys which allow
> @@ -261,6 +284,8 @@ enum P4_EVENTS {
>  	P4_EVENT_INSTR_COMPLETED,
>  };
>  
> +#ifdef __KERNEL__
> +
>  #define P4_OPCODE(event)		event##_OPCODE
>  #define P4_OPCODE_ESEL(opcode)		((opcode & 0x00ff) >> 0)
>  #define P4_OPCODE_EVNT(opcode)		((opcode & 0xff00) >> 8)
> @@ -780,6 +805,8 @@ enum P4_ESCR_EMASKS {
>  
>  #define p4_config_pebs_has(v, mask)	(p4_config_unpack_pebs(v) & (mask))
>  
> +#endif /* __KERNEL__ */
> +
>  enum P4_PEBS_METRIC {
>  	P4_PEBS_METRIC__none,
>  


