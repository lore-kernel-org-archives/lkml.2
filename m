Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0H0Ohg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:37:36 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:32346
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752234Ab0H0Ohc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:37:32 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275dhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7TF08-01-4FN-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 16:31:21 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH V2 3/4] oprofile: Abstract the perf-events backend
Message-ID: <20100827143121.GN22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
 <fe3e173aaa85f4cd73ea4b5abca50976fc40a01f.1282848651.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fe3e173aaa85f4cd73ea4b5abca50976fc40a01f.1282848651.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.10 15:09:18, Matt Fleming wrote:
> Move the perf-events backend from arch/arm/oprofile into
> drivers/oprofile so that the code can be shared between architectures.
> 
> This allows each architecture to maintain only a single copy of the
> PMU accessor functions instead of one for both perf and OProfile. It
> also becomes possible for other architectures to delete much of their
> OProfile code in favour of the common code now available in
> drivers/oprofile/oprofile_perf.c.
> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> ---
>  arch/arm/oprofile/Makefile       |    4 +
>  arch/arm/oprofile/common.c       |  215 +++-----------------------------------
>  drivers/oprofile/oprofile_perf.c |  209 ++++++++++++++++++++++++++++++++++++
>  include/linux/oprofile.h         |   12 ++
>  4 files changed, 242 insertions(+), 198 deletions(-)
>  create mode 100644 drivers/oprofile/oprofile_perf.c
> 
> diff --git a/arch/arm/oprofile/Makefile b/arch/arm/oprofile/Makefile
> index e666eaf..038d7af 100644
> --- a/arch/arm/oprofile/Makefile
> +++ b/arch/arm/oprofile/Makefile
> @@ -6,4 +6,8 @@ DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
>                 oprofilefs.o oprofile_stats.o \
>                 timer_int.o )
> 
> +ifeq ($(CONFIG_HW_PERF_EVENTS), y)
> +DRIVER_OBJS += $(addprefix ../../../drivers/oprofile/, oprofile_perf.o)
> +endif

You use CONFIG_HW_PERF_EVENTS while CONFIG_PERF_EVENTS in oprofile.h.

> +
>  oprofile-y                             := $(DRIVER_OBJS) common.o

> diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
> index 5171639..99e0323 100644
> --- a/include/linux/oprofile.h
> +++ b/include/linux/oprofile.h
> @@ -185,4 +185,16 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val);
>  int oprofile_add_data64(struct op_entry *entry, u64 val);
>  int oprofile_write_commit(struct op_entry *entry);
> 
> +/* Oprofile perf wrapper functions. */
> +
> +#ifdef CONFIG_PERF_EVENTS
> +int oprofile_perf_init(void);
> +void oprofile_perf_exit(void);
> +int oprofile_perf_setup(void);
> +int oprofile_perf_start(void);
> +void oprofile_perf_stop(void);
> +int oprofile_perf_create_files(struct super_block *sb, struct dentry *root);
> +void oprofile_perf_set_num_counters(int num_counters);
> +#endif /* CONFIG_PERF_EVENTS */

We need empty function stubs for all this functions for the
!CONFIG_PERF_EVENTS case returning -ENODEV or so. Otherwise
compliation will fail for it.

For arm this does not happen because of #ifdefs, but for sh.

Again, please first change the code and then move it without
functional changes, one patch each.

Thanks,

-Robert

> +
>  #endif /* OPROFILE_H */
> --
> 1.7.1
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

