Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1JZIUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 04:20:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:14711 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab1JZIU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 04:20:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,408,1315206000"; 
   d="scan'208";a="30240538"
From: Andi Kleen <andi@firstfloor.org>
To: Eial Czerwacki <eial@scalemp.com>
Cc: linux-kernel@vger.kernel.org,
        "Shai Fultheim \(Shai\@ScaleMP.com\)" <Shai@scalemp.com>
Subject: Re: [PATCH] APICID: Avoid false sharing on the read mostly x86_cpu_to_apicid
References: <4EA66960.7050907@scalemp.com>
	<9B14D1490DDECA4E974F6B9FC9EBAB3140CD274367@VMBX108.ihostexchange.net>
	<4EA6A265.1080506@scalemp.com>
Date: Wed, 26 Oct 2011 01:20:26 -0700
In-Reply-To: <4EA6A265.1080506@scalemp.com> (Eial Czerwacki's message of "Tue,
	25 Oct 2011 13:49:57 +0200")
Message-ID: <m2fwigw4dx.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eial Czerwacki <eial@scalemp.com> writes:

> ===================================================================
> --- a/arch/x86/include/asm/smp.h	2010-06-01 09:56:03.000000000 -0700
> +++ b/arch/x86/include/asm/smp.h	2010-06-02 15:59:21.000000000 -0700
> @@ -36,7 +36,8 @@ static inline struct cpumask *cpu_core_m
>   	return per_cpu(cpu_core_map, cpu);
>   }
>
> -DECLARE_EARLY_PER_CPU(u16, x86_cpu_to_apicid);
> +extern u16 x86_cpu_to_apicid[NR_CPUS];

That's a big waste of memory. On a CONFIG_MAX_SMP kernel compiled for
4096 CPUs you're wasting 8k now on smaller systems. The per cpu
data only allocates what is needed.

NR_CPUS is usually a bad idea and it 

Perhaps need a __read_mostly cache line padded per CPU section instead
for cases like this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
