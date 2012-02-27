Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2B0WRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:17:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43878 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2B0WQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:16:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ddaney.cavm@gmail.com designates 10.236.185.42 as permitted sender) smtp.mail=ddaney.cavm@gmail.com; dkim=pass header.i=ddaney.cavm@gmail.com
Message-ID: <4F4C00D7.2030708@gmail.com>
Date: Mon, 27 Feb 2012 14:16:55 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
 -v5
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>	<1328055439-9441-1-git-send-email-venki@google.com>	<4F4BFBEB.8080800@gmail.com> <20120227140746.61f5fba9.akpm@linux-foundation.org>
In-Reply-To: <20120227140746.61f5fba9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 02:07 PM, Andrew Morton wrote:
> On Mon, 27 Feb 2012 13:55:55 -0800
> David Daney<ddaney.cavm@gmail.com>  wrote:
>
>> On 01/31/2012 04:17 PM, Venkatesh Pallipadi wrote:
>>> Kernel's notion of possible cpus (from include/linux/cpumask.h)
>>>    *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
>>>
>>>    *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>>>    *  that it is possible might ever be plugged in at anytime during the
>>>    *  life of that system boot.
>>>
>>>    #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
>>>
>>> and on x86 cpumask_weight() calls hweight64 and hweight64 (on older kernels
>>> and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.
>>>
>>> i.e, We needlessly go through this mask based calculation everytime
>>> num_possible_cpus() is called.
>>>
>>> The problem is there with cpu_online_mask() as well, which is fixed value at
>>> boot time in !CONFIG_HOTPLUG_CPU case and should not change that often even
>>> in HOTPLUG case.
>>>
>>> Though most of the callers of these two routines are init time (with few
>>> exceptions of runtime calls), it is cleaner to use variables
>>> and not go through this repeated mask based calculation.
>>>
>>> Signed-off-by: Venkatesh Pallipadi<venki@google.com>
>>> Acked-by: Srivatsa S. Bhat<srivatsa.bhat@linux.vnet.ibm.com>
>>> Acked-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>
>> How is it that this patch got merged to linux-next before all the
>> cleanup patches for nr_online_cpus?
>
> <spends five minutes searching mailing list archives>
>
> I for one do not have a clue what patches the term "cleanup patches for
> nr_online_cpus" refers to.  Patches have names - please use them!
>

Sorry about that.  I was a little hasty:

   From:	Venkatesh Pallipadi <venki@google.com>
   Subject: [PATCH 0/3] Cleanup raw handling of online/possible map
   Date:	Tue, 14 Feb 2012 14:49:41 -0800
   Message-Id: <1329259784-20592-1-git-send-email-venki@google.com>

I don't really know a better way to refer to them.

David Daney



>>    From the looks of your follow-on patches it would seem that all MIPS,
>> hexagon, and um are now broken.
>>
>> I know for a fact that MIPS doesn't boot because of this.
>
> I shall drop
> cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus.patch.
>
> That patch was sent as a single standalone patch and the changelog had
> no mention of any needed preparatory patches.  If resending, please
> send *all* patches in a single sequence-numbered series.  We know how
> to do this.

It is possible that Venkatesh did not know about the breakage when the 
original patch was sent
