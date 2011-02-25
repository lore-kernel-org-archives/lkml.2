Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1BYNGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 08:06:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:15241 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1BYNGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 08:06:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,224,1297065600"; 
   d="scan'208";a="713222141"
Date: Fri, 25 Feb 2011 05:06:46 -0800
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
Message-ID: <20110225050646.2828709c@jacob-laptop>
In-Reply-To: <AANLkTi=i-fgng0Pa2JDSy8RgqRs2mo2vc2CKbx12-=Ri@mail.gmail.com>
References: <20110216031831.571628191@google.com>
	<20110224161111.7d83a884@jacob-laptop>
	<AANLkTi=i-fgng0Pa2JDSy8RgqRs2mo2vc2CKbx12-=Ri@mail.gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011 02:03:54 -0800
Paul Turner <pjt@google.com> wrote:

> On Thu, Feb 24, 2011 at 4:11 PM, jacob pan
> <jacob.jun.pan@linux.intel.com> wrote:
> > On Tue, 15 Feb 2011 19:18:31 -0800
> > Paul Turner <pjt@google.com> wrote:
> >
> >> Hi all,
> >>
> >> Please find attached v4 of CFS bandwidth control; while this rebase
> >> against some of the latest SCHED_NORMAL code is new, the features
> >> and methodology are fairly mature at this point and have proved
> >> both effective and stable for several workloads.
> >>
> >> As always, all comments/feedback welcome.
> >>
> >
> > Hi Paul,
> >
> > Your patches provide a very useful but slightly different feature
> > for what we need to manage idle time in order to save power. What we
> > need is kind of a quota/period in terms of idle time. I have been
> > playing with your patches and noticed that when the cgroup cpu usage
> > exceeds the quota the effect of throttling is similar to what I have
> > been trying to do with freezer subsystem. i.e. freeze and thaw at
> > given period and percentage runtime.
> > https://lkml.org/lkml/2011/2/15/314
> >
> > Have you thought about adding such feature (please see detailed
> > description in the link above) to your patches?
> >
> 
> So reading the description it seems like rooting everything in a
> 'freezer' container and then setting up a quota of
> 
> (1 - frozen_percentage)  * nr_cpus * frozen_period * sec_to_usec
> 
I guess you meant frozen_percentage is less than 1, i.e. 90 is .90. my
code treat 90 as 90. just a clarification.
> on a period of
> 
> frozen_period * sec_to_usec
> 
> Would provide the same functionality.  Is there other unduplicated
> functionality beyond this?
Do you mean the same functionality as your patch? Not really, since my
approach will stop the tasks based on hard time slices. But seems your
patch will allow them to run if they don't exceed the quota. Am i
missing something?
That is the only functionality difference i know.

Like the reviewer of freezer patch pointed out, it is a more logical
fit to implement such feature in scheduler/yours in stead of freezer. So
i am wondering if your patch can be expended to include limiting quota
on real time.

I did a comparison study between CFS BW and freezer patch on skype with
identical quota setting as you pointed out earlier. Both use 2 sec
period and .2 sec quota (10%). Skype typically uses 5% of the CPU on my
system when placing a call(below cfs quota) and it wakes up every 100ms
to do some quick checks. Then I run skype in cpu then freezer cgroup
(with all its children). Here is my result based on timechart and
powertop.

patch name	wakeups		skype call?
------------------------------------------------------------------
CFS BW		10/sec		yes
freezer		1/sec		no

Skype might not be the best example to illustrate the real usage of the
feature, but we are targeting mobile device where they are mostly off or
often have only one application allowed in foreground. So we want to
reduce wakeups coming from the tasks that are not in the foreground.

> One thing that does seem undesirable about your approach is (as it
> seems to be described) threads will not be able to take advantage of
> naturally occurring idle cycles and will incur a potential performance
> penalty even at use << frozen_percentage.
> 
> e.g. From your post
> 
>        |  |<-- 90% frozen -     ->|  |
> |  | ____|  |________________x_|  |__________________|  |_____
> 
>         |<---- 5 seconds     ---->|
> 
> 
> Suppose no threads active until the wake up at x, suppose there is an
> accompanying 1 second of work for that thread to do.  That execution
> time will be dilated to ~1.5 seconds (as it will span the 0.5 seconds
> the freezer will stall for).  But the true usage for this period is
> ~20% <<< 90%
I agree my approach does not consider the natural cycle. But I am not
sure if a thread can wake up at x when FROZEN.
