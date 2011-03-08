Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1CHSSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:18:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:60615 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab1CHSSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:18:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,285,1297065600"; 
   d="scan'208";a="665159344"
Date: Tue, 8 Mar 2011 10:18:11 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
Message-ID: <20110308101811.00000eab@unknown>
In-Reply-To: <20110308035759.GI2868@balbir.in.ibm.com>
References: <20110216031831.571628191@google.com>
	<20110224161111.7d83a884@jacob-laptop>
	<AANLkTi=i-fgng0Pa2JDSy8RgqRs2mo2vc2CKbx12-=Ri@mail.gmail.com>
	<20110225050646.2828709c@jacob-laptop>
	<20110308035759.GI2868@balbir.in.ibm.com>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Tue, 8 Mar 2011 09:27:59 +0530 Balbir Singh wrote:
>* jacob pan <jacob.jun.pan@linux.intel.com> [2011-02-25 05:06:46]:
>
>> On Fri, 25 Feb 2011 02:03:54 -0800
>> Paul Turner <pjt@google.com> wrote:
>> 
>> > On Thu, Feb 24, 2011 at 4:11 PM, jacob pan
>> > <jacob.jun.pan@linux.intel.com> wrote:
>> > > On Tue, 15 Feb 2011 19:18:31 -0800
>> > > Paul Turner <pjt@google.com> wrote:
>> > >
>> > >> Hi all,
>> > >>
>> > >> Please find attached v4 of CFS bandwidth control; while this rebase
>> > >> against some of the latest SCHED_NORMAL code is new, the features
>> > >> and methodology are fairly mature at this point and have proved
>> > >> both effective and stable for several workloads.
>> > >>
>> > >> As always, all comments/feedback welcome.
>> > >>
>> > >
>> > > Hi Paul,
>> > >
>> > > Your patches provide a very useful but slightly different feature
>> > > for what we need to manage idle time in order to save power. What we
>> > > need is kind of a quota/period in terms of idle time. I have been
>> > > playing with your patches and noticed that when the cgroup cpu usage
>> > > exceeds the quota the effect of throttling is similar to what I have
>> > > been trying to do with freezer subsystem. i.e. freeze and thaw at
>> > > given period and percentage runtime.
>> > > https://lkml.org/lkml/2011/2/15/314
>> > >
>> > > Have you thought about adding such feature (please see detailed
>> > > description in the link above) to your patches?
>> > >
>> > 
>> > So reading the description it seems like rooting everything in a
>> > 'freezer' container and then setting up a quota of
>> > 
>> > (1 - frozen_percentage)  * nr_cpus * frozen_period * sec_to_usec
>> > 
>> I guess you meant frozen_percentage is less than 1, i.e. 90 is .90. my
>> code treat 90 as 90. just a clarification.
>> > on a period of
>> > 
>> > frozen_period * sec_to_usec
>> > 
>> > Would provide the same functionality.  Is there other unduplicated
>> > functionality beyond this?
>> Do you mean the same functionality as your patch? Not really, since my
>> approach will stop the tasks based on hard time slices. But seems your
>> patch will allow them to run if they don't exceed the quota. Am i
>> missing something?
>> That is the only functionality difference i know.
>> 
>> Like the reviewer of freezer patch pointed out, it is a more logical
>> fit to implement such feature in scheduler/yours in stead of freezer. So
>> i am wondering if your patch can be expended to include limiting quota
>> on real time.
>>
>
>Do you mean sched rt group controller? Have you looked at
>cpu.rt_runtime_us and cpu.rt_perioud_us?
> 
>> I did a comparison study between CFS BW and freezer patch on skype with
>> identical quota setting as you pointed out earlier. Both use 2 sec
>> period and .2 sec quota (10%). Skype typically uses 5% of the CPU on my
>> system when placing a call(below cfs quota) and it wakes up every 100ms
>> to do some quick checks. Then I run skype in cpu then freezer cgroup
>> (with all its children). Here is my result based on timechart and
>> powertop.
>> 
>> patch name	wakeups		skype call?
>> ------------------------------------------------------------------
>> CFS BW		10/sec		yes
>> freezer		1/sec		no
>>
>
>Is this good or bad for CFS BW?
In terms of power saving for this particular use case, it is bad for
CFS BW. Since I am trying use cgroup to manage applications that are
not written with power saving in mind. CFS BW does not prevent
unnecessary wake-ups from these apps., therefore the system consumes
more power than the case where freezer duty cycling patch is used.
In my use case, as soon as skype is switched to the UI foreground, it
will be moved to another cgroup where enough quota will be given to
allow it place calls. Therefore, not being able to make calls while
being throttled is not a concern.

For mobile devices, often have just one app in the foreground. So
throttling background apps may not impact user experience but still can
save power.

Since CFS BW patch has the period and quota concept on BW control, that
is why I am asking if it is worth extending CFS BW patch to have a idle
time quota. Perhaps adding another parameter to allow limitting the idle
time in parallel to cfs_quota.

Rafael (CCed) wants to get an opinion from the scheduler folks before
considering the freezer patch.

Thanks,

Jacob
