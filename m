Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0EQT6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:58:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62812 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0EQT6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:58:39 -0400
Date: Mon, 17 May 2010 12:56:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 2/2] x86/mrst: add more timer config options
Message-Id: <20100517125619.a0e123cd.randy.dunlap@oracle.com>
In-Reply-To: <1274124183-23431-3-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274124183-23431-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1274124183-23431-3-git-send-email-jacob.jun.pan@linux.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BF19FC4.006F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 May 2010 12:23:03 -0700 Jacob Pan wrote:

> Always-on local APIC timer (ARAT) has been introduced to Medfield, along
> with the platform APB timers we have more timer configuration options
> between Moorestown and Medfield.
> 
> This patch adds run-time detection of avaiable timer features so that
> we can treat Medfield as a variant of Moorestown and set up the optimal
> timer options for each platform. i.e.
> 
> Medfield: per cpu always-on local APIC timer
> Moorestown: per cpu APB timer
> 
> Manual override is possible via cmdline option x86_mrst_timer.

which is documented where??

> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/include/asm/apb_timer.h |    2 +-
>  arch/x86/include/asm/mrst.h      |    1 +
>  arch/x86/kernel/apb_timer.c      |   18 ++++++-----
>  arch/x86/kernel/mrst.c           |   64 ++++++++++++++++++++++++++++++++-----
>  4 files changed, 67 insertions(+), 18 deletions(-)

> diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
> index f1ccabd..87c5c7d 100644
> --- a/arch/x86/kernel/mrst.c
> +++ b/arch/x86/kernel/mrst.c
> @@ -25,6 +25,29 @@
>  #include <asm/i8259.h>
>  #include <asm/apb_timer.h>
>  
> +/**

Don't use /** since this is not a kernel-doc comment block.

> + * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
> + * cmdline option x86_mrst_timer can be used to override the configuration
> + * to prefer one or the other.
> + * at runtime, there are basically three timer configurations:
> + * 1. per cpu apbt clock only
> + * 2. per cpu always-on lapic clocks only, this is Penwell/Medfield only
> + * 3. per cpu lapic clock (C3STOP) and one apbt clock, with broadcast.
> + *
> + * by default (without cmdline option), platform code first detects cpu type
> + * to see if we are on lincroft or penwell, then set up both lapic or apbt
> + * clocks accordingly.
> + * i.e. by default, medfield uses configuration #2, moorestown uses #1.
> + * config #3 is supported but not recommended on medfield.
> + *
> + * rating and feature summary:
> + * lapic (with C3STOP) --------- 100
> + * apbt (always-on) ------------ 110
> + * lapic (always-on,ARAT) ------ 150
> + */
> +
> +int mrst_timer_options __cpuinitdata;
> +
>  static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
>  static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
>  int sfi_mtimer_num;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
