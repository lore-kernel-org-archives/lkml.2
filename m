Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2EHPNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:13:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57093 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab2EHPNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:13:54 -0400
Message-ID: <4FA937C0.7080202@zytor.com>
Date: Tue, 08 May 2012 08:12:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific
 CPUs
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com> <1336485790-30902-5-git-send-email-alex.shi@intel.com>
In-Reply-To: <1336485790-30902-5-git-send-email-alex.shi@intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 07:03 AM, Alex Shi wrote:
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -610,6 +610,35 @@ void intel_tlb_lookup(const unsigned char desc)
>  	}
>  }
>  
> +void intel_tlb_flushall_factor_set(struct cpuinfo_x86 *c)
> +{
> +	switch (c->x86_model) {
> +	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
> +		tlb_flushall_factor = 0;
> +		break;
> +	case 26: /* 45 nm nehalem, "Bloomfield" */
> +	case 30: /* 45 nm nehalem, "Lynnfield" */
> +	case 37: /* 32 nm nehalem, "Clarkdale" */
> +	case 44: /* 32 nm nehalem, "Gulftown" */
> +	case 46: /* 45 nm nehalem-ex, "Beckton" */
> +		tlb_flushall_factor = 64;
> +		break;
> +	case 42: /* SandyBridge */
> +	case 45: /* SandyBridge, "Romely-EP" */
> +		tlb_flushall_factor = 32;
> +		break;
> +	case 28: /* Atom */
> +	case 47: /* 32 nm Xeon E7 */
> +	case 14: /* 65 nm core solo/duo, "Yonah" */
> +	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
> +	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
> +	case 29: /* six-core 45 nm xeon "Dunnington" */
> +
> +	default:
> +		tlb_flushall_factor = 0;
> +	}
> +}
> +

This uses x86_model without qualifying it x86 (family), however that is
meaningless.  All the CPUs you are dealing with above have c->x86 == 6,
but you need to handle others correctly (even if that just means
defaulting it to zero.)

One way to do that is to do:

switch ((c->x86 << 8) + c->x86_model) {

... and use numbers like 0x62d instead of 45.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

