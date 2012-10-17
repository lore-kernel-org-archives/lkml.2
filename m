Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2JQFPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:15:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50288 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab2JQFPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:15:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for suspend or hibernate
Date: Wed, 17 Oct 2012 07:18:59 +0200
Message-ID: <35538834.Boc5416YXf@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122030B18671@ORSMSX105.amr.corp.intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com> <507D8BBD.3010306@linux.vnet.ibm.com> <3E5A0FA7E9CA944F9D5414FEC6C7122030B18671@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 of October 2012 22:12:27 Yu, Fenghua wrote:
> > On 10/16/2012 09:47 PM, Rafael J. Wysocki wrote:
> > > On Tuesday 16 of October 2012 11:05:18 Srivatsa S. Bhat wrote:
> > >> On 10/16/2012 02:20 AM, Rafael J. Wysocki wrote:
> > >>> On Friday 12 of October 2012 09:09:42 Fenghua Yu wrote:
> > >>>> From: Fenghua Yu <fenghua.yu@intel.com>
> > >>>>
> > >>>> +
> > >>>> +/*
> > >>>> + * When bsp_check() is called in hibernate and suspend, cpu
> > hotplug
> > >>>> + * is disabled already. So it's unnessary to handle race
> > condition between
> > >>>> + * cpumask query and cpu hotplug.
> > >>>> + */
> > >>>> +static int bsp_check(void)
> > >>>> +{
> > >>>> +	if (cpumask_first(cpu_online_mask) != 0) {
> > >>>> +		pr_warn("CPU0 is offline.\n");
> > >>>> +		return -ENODEV;
> > >>>> +	}
> > >>>> +
> > >>>> +	return 0;
> > >>>> +}
> > >>>> +
> > >>>> +static int bsp_pm_callback(struct notifier_block *nb, unsigned
> > long action,
> > >>>> +			   void *ptr)
> > >>>> +{
> > >>>> +	int ret = 0;
> > >>>> +
> > >>>> +	switch (action) {
> > >>>> +	case PM_SUSPEND_PREPARE:
> > >>>> +	case PM_HIBERNATION_PREPARE:
> > >>>> +		ret = bsp_check();
> > >>>> +		break;
> > >>>> +	default:
> > >>>> +		break;
> > >>>> +	}
> > >>>> +	return notifier_from_errno(ret);
> > >>>> +}
> > >>>> +
> > >>>
> > >>> I wonder if there's anything preventing CPU0 from becoming offline
> > after you've
> > >>> done this check and before user space is frozen?
> > >>>
> > >>
> > >> Hi Rafael,
> > >>
> > >> bsp_pm_callback runs as a low priority notifier callback,
> > specifically with lower
> > >> priority than the cpu_hotplug_pm_callback (as mentioned in the
> > comment below).
> > >> And cpu_hotplug_pm_callback disables regular CPU hotplug (till the
> > suspend/resume
> > >> sequence is complete).. So there is no chance for CPU0 to become
> > offline after that.
> > >>
> > >> Or, are you thinking of some other scenario where CPU0 can go
> > offline?
> > >
> > > No, that should be fine technically, but designs relying on notifier
> > priority
> > > for correctness are kind of fragile.
> > >
> > 
> > Hmm.. I agree.
> > 
> > > Would it be possible to make cpu_hotplug_pm_callback() do the BSP
> > online check?
> > >
> > 
> > Good idea! I think that could be done quite easily. And while doing
> > that, it would
> > be good to rethink what to do in patch 12/12 (Debug CPU0 hotplug) to
> > fix the bug I
> > pointed out in my other mail.
> 
> Why is this design relying on notifier priority fragile? I don't get it.

Because things like this are often overlooked by people trying to optimize
stuff and the fact that you have to add a comment explaining that dependency
only means that it is not exactly straightforward.

Moreover, you should also add a corresponding comment in the other notifier
indicating that its priority should be higher than the priority of the
new thing and explaining why.

> The priority in pm_notifier() is in a well designed API. This code just
> follows the API to assign lower priority for bsp_pm_callback than
> cpu_hotplug_pm_callback. Unless your justification is that the API of
> pm_notifier() is fragile, I think this patch should be ok.

I really think that notifiers are fragile in general and this particular
one is no exception.

> It's not a good idea to move bsp_pm_callback() into
> cpu_hotplug_pm_callback(). There is no architecture specific hook to
> call x86 bsp specific hotplug in cpu_hotplug_pm_callback(). Moving
> bsp_pm_callback() into cpu_hotplug_pm_callback() is hacking while 
> this patch follows well defined API and has better coding.

I'm not sure it is better coding.  You really want one piece of code
to always follow another piece of code and the best way to ensure
that is to execute them both explicitly in sequence.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
