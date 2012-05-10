Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2EJP6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:58:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56817 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2EJP6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:58:17 -0400
Date: Thu, 10 May 2012 17:58:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] x86/tlb_info: get last level TLB entry number of
 CPU
Message-ID: <20120510155802.GF32700@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-3-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336626013-28413-3-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 01:00:08PM +0800, Alex Shi wrote:
> For 4KB pages, x86 CPU has 2 or 1 level TLB, first level is data TLB and
> instruction TLB, second level is shared TLB for both data and instructions.
> 
> For hupe page TLB, usually there is just one level and seperated by 2MB/4MB
> and 1GB.
> 
> Although each levels TLB size is important for performance tuning, but for
> genernal and rude optimizing, last level TLB entry number is suitable. And
> in fact, last level TLB always has the biggest entry number.
> 
> This patch will get the biggest TLB entry number and use it in furture TLB
> optimizing.
> 
> For all kinds of x86 vendor friendly, vendor specific code was moved to its
> specific files.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  arch/x86/include/asm/processor.h |   11 +++
>  arch/x86/kernel/cpu/common.c     |   21 ++++++
>  arch/x86/kernel/cpu/cpu.h        |    9 +++
>  arch/x86/kernel/cpu/intel.c      |  141 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 182 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 4fa7dcc..797faca 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -61,6 +61,17 @@ static inline void *current_text_addr(void)
>  # define ARCH_MIN_MMSTRUCT_ALIGN	0
>  #endif
>  
> +enum tlb_infos {
> +	ENTRIES,
> +	NR_INFO
> +};
> +
> +extern u16 __read_mostly tlb_lli_4k[NR_INFO];
> +extern u16 __read_mostly tlb_lli_2m[NR_INFO];
> +extern u16 __read_mostly tlb_lli_4m[NR_INFO];
> +extern u16 __read_mostly tlb_lld_4k[NR_INFO];
> +extern u16 __read_mostly tlb_lld_2m[NR_INFO];
> +extern u16 __read_mostly tlb_lld_4m[NR_INFO];

Btw, we're only using the tlb_ll[id]_4k arrays in flush_tlb_range and do
not touch 2m or 4m entries. Do you have any future plans for those or
can they simply be removed?

Besides, those arrays contain only the entries count per TLB size. Maybe
turn them into simple variables?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
