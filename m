Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2CASc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:32:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54466 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab2CASc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:32:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.50.203.66 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
In-Reply-To: <4F4C00D7.2030708@gmail.com>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
	<4F4BFBEB.8080800@gmail.com>
	<20120227140746.61f5fba9.akpm@linux-foundation.org>
	<4F4C00D7.2030708@gmail.com>
Date: Thu, 1 Mar 2012 10:32:25 -0800
Message-ID: <CABeCy1Y_QxbuGfTKE7mBFT_Aq2pPZm+9iA3tiVbb6qA1WwvY_A@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v5
From: Venki Pallipadi <venki@google.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 2:16 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 02/27/2012 02:07 PM, Andrew Morton wrote:
>>
>> On Mon, 27 Feb 2012 13:55:55 -0800
>> David Daney<ddaney.cavm@gmail.com>  wrote:
>>
>>> On 01/31/2012 04:17 PM, Venkatesh Pallipadi wrote:
>>>>
>>>> Kernel's notion of possible cpus (from include/linux/cpumask.h)
>>>>   *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
>>>>
>>>>   *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>>>>   *  that it is possible might ever be plugged in at anytime during the
>>>>   *  life of that system boot.
>>>>
>>>>   #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
>>>>
>>>> and on x86 cpumask_weight() calls hweight64 and hweight64 (on older
>>>> kernels
>>>> and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.
>>>>
>>>> i.e, We needlessly go through this mask based calculation everytime
>>>> num_possible_cpus() is called.
>>>>
>>>> The problem is there with cpu_online_mask() as well, which is fixed
>>>> value at
>>>> boot time in !CONFIG_HOTPLUG_CPU case and should not change that often
>>>> even
>>>> in HOTPLUG case.
>>>>
>>>> Though most of the callers of these two routines are init time (with few
>>>> exceptions of runtime calls), it is cleaner to use variables
>>>> and not go through this repeated mask based calculation.
>>>>
>>>> Signed-off-by: Venkatesh Pallipadi<venki@google.com>
>>>> Acked-by: Srivatsa S. Bhat<srivatsa.bhat@linux.vnet.ibm.com>
>>>> Acked-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>>
>>>
>>> How is it that this patch got merged to linux-next before all the
>>> cleanup patches for nr_online_cpus?
>>
>>
>> <spends five minutes searching mailing list archives>
>>
>> I for one do not have a clue what patches the term "cleanup patches for
>> nr_online_cpus" refers to.  Patches have names - please use them!
>>
>
> Sorry about that.  I was a little hasty:
>
>  From: Venkatesh Pallipadi <venki@google.com>
>  Subject: [PATCH 0/3] Cleanup raw handling of online/possible map
>  Date: Tue, 14 Feb 2012 14:49:41 -0800
>  Message-Id: <1329259784-20592-1-git-send-email-venki@google.com>
>
> I don't really know a better way to refer to them.
>
> David Daney
>
>
>
>
>>>   From the looks of your follow-on patches it would seem that all MIPS,
>>> hexagon, and um are now broken.
>>>
>>> I know for a fact that MIPS doesn't boot because of this.
>>
>>
>> I shall drop
>> cpumask-avoid-mask-based-num_possible_cpus-and-num_online_cpus.patch.
>>
>> That patch was sent as a single standalone patch and the changelog had
>> no mention of any needed preparatory patches.  If resending, please
>> send *all* patches in a single sequence-numbered series.  We know how
>> to do this.
>
>
> It is possible that Venkatesh did not know about the breakage when the
> original patch was sent

Sorry about all the confusion with this change. The long story goes
something like this:

Yes. The problems with this patch "Avoid mask based num_possible_cpus
and num_online_cpus"
were uncovered after it went into mm. First report was on ia64 here
https://lkml.org/lkml/2012/2/13/327

And there were potential problems in other archs as well. Srivatsa and
I sent out a bunch of cleanups
https://lkml.org/lkml/2012/2/14/355
https://lkml.org/lkml/2012/2/14/380

Rusty followed up with a superset of these cleanups
https://lkml.org/lkml/2012/2/15/4

I asked Rusty to pick up my original patch as the last patch in his series.
https://lkml.org/lkml/2012/2/15/516

That's all the happenings that I remember. I am not sure what the
status of Rusty's or my cleanup patches is right now. I am looking at
various trees now trying to find these cleanup patches. I can resubmit
this particular change once the cleanups have made through.

Thanks,
Venki
