Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2EHPIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:08:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:48822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2EHPIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:08:34 -0400
Message-ID: <1336489685.16236.48.camel@twins>
Subject: Re: [PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific
 CPUs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 17:08:05 +0200
In-Reply-To: <1336485790-30902-5-git-send-email-alex.shi@intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
	 <1336485790-30902-5-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 22:03 +0800, Alex Shi wrote:
> +void intel_tlb_flushall_factor_set(struct cpuinfo_x86 *c)
> +{
> +       switch (c->x86_model) {
> +       case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
> +               tlb_flushall_factor = 0;
> +               break;

Why isn't this is the bottom list of core chips?

> +       case 26: /* 45 nm nehalem, "Bloomfield" */
> +       case 30: /* 45 nm nehalem, "Lynnfield" */
> +       case 37: /* 32 nm nehalem, "Clarkdale" */
> +       case 44: /* 32 nm nehalem, "Gulftown" */
> +       case 46: /* 45 nm nehalem-ex, "Beckton" */
> +               tlb_flushall_factor = 64;
> +               break;
> +       case 42: /* SandyBridge */
> +       case 45: /* SandyBridge, "Romely-EP" */
> +               tlb_flushall_factor = 32;
> +               break;
> +       case 28: /* Atom */
> +       case 47: /* 32 nm Xeon E7 */

This is a wsm-ex, right? Why isn't it listed with the other nehalems?

> +       case 14: /* 65 nm core solo/duo, "Yonah" */
> +       case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
> +       case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
> +       case 29: /* six-core 45 nm xeon "Dunnington" */

So never use invlpg for Atom/Core/Core2?

> +       default:
> +               tlb_flushall_factor = 0;
> +       }
> +}


> @@ -364,7 +363,8 @@ flush_all:
>                         act_entries = tlb_entries > mm->total_vm ?
>                                         mm->total_vm : tlb_entries;
>  
> +                       if ((end - start)/PAGE_SIZE >
> +                                       act_entries/tlb_flushall_factor) 

You're doing an actual full division, wouldn't a shift be better?
