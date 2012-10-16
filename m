Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2JPWMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:12:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:24740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab2JPWM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:12:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,595,1344236400"; 
   d="scan'208";a="236014090"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
Subject: RE: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for suspend
 or hibernate
Thread-Topic: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for
 suspend or hibernate
Thread-Index: AQHNqJme/Qw6Fjvfd02W7L5t8fGuVJe7UXUAgACSvQCAALOPAIAAA5yA///kHbA=
Date: Tue, 16 Oct 2012 22:12:27 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122030B18671@ORSMSX105.amr.corp.intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <10020874.9eDCB3ZAkx@vostro.rjw.lan> <507CF216.3010507@linux.vnet.ibm.com>
 <1586487.pWfqEJ2K11@vostro.rjw.lan> <507D8BBD.3010306@linux.vnet.ibm.com>
In-Reply-To: <507D8BBD.3010306@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9GMCaF0000813

> On 10/16/2012 09:47 PM, Rafael J. Wysocki wrote:
> > On Tuesday 16 of October 2012 11:05:18 Srivatsa S. Bhat wrote:
> >> On 10/16/2012 02:20 AM, Rafael J. Wysocki wrote:
> >>> On Friday 12 of October 2012 09:09:42 Fenghua Yu wrote:
> >>>> From: Fenghua Yu <fenghua.yu@intel.com>
> >>>>
> >>>> +
> >>>> +/*
> >>>> + * When bsp_check() is called in hibernate and suspend, cpu
> hotplug
> >>>> + * is disabled already. So it's unnessary to handle race
> condition between
> >>>> + * cpumask query and cpu hotplug.
> >>>> + */
> >>>> +static int bsp_check(void)
> >>>> +{
> >>>> +	if (cpumask_first(cpu_online_mask) != 0) {
> >>>> +		pr_warn("CPU0 is offline.\n");
> >>>> +		return -ENODEV;
> >>>> +	}
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static int bsp_pm_callback(struct notifier_block *nb, unsigned
> long action,
> >>>> +			   void *ptr)
> >>>> +{
> >>>> +	int ret = 0;
> >>>> +
> >>>> +	switch (action) {
> >>>> +	case PM_SUSPEND_PREPARE:
> >>>> +	case PM_HIBERNATION_PREPARE:
> >>>> +		ret = bsp_check();
> >>>> +		break;
> >>>> +	default:
> >>>> +		break;
> >>>> +	}
> >>>> +	return notifier_from_errno(ret);
> >>>> +}
> >>>> +
> >>>
> >>> I wonder if there's anything preventing CPU0 from becoming offline
> after you've
> >>> done this check and before user space is frozen?
> >>>
> >>
> >> Hi Rafael,
> >>
> >> bsp_pm_callback runs as a low priority notifier callback,
> specifically with lower
> >> priority than the cpu_hotplug_pm_callback (as mentioned in the
> comment below).
> >> And cpu_hotplug_pm_callback disables regular CPU hotplug (till the
> suspend/resume
> >> sequence is complete).. So there is no chance for CPU0 to become
> offline after that.
> >>
> >> Or, are you thinking of some other scenario where CPU0 can go
> offline?
> >
> > No, that should be fine technically, but designs relying on notifier
> priority
> > for correctness are kind of fragile.
> >
> 
> Hmm.. I agree.
> 
> > Would it be possible to make cpu_hotplug_pm_callback() do the BSP
> online check?
> >
> 
> Good idea! I think that could be done quite easily. And while doing
> that, it would
> be good to rethink what to do in patch 12/12 (Debug CPU0 hotplug) to
> fix the bug I
> pointed out in my other mail.

Why is this design relying on notifier priority fragile? I don't get it.

The priority in pm_notifier() is in a well designed API. This code just
follows the API to assign lower priority for bsp_pm_callback than
cpu_hotplug_pm_callback. Unless your justification is that the API of
pm_notifier() is fragile, I think this patch should be ok.

It's not a good idea to move bsp_pm_callback() into
cpu_hotplug_pm_callback(). There is no architecture specific hook to
call x86 bsp specific hotplug in cpu_hotplug_pm_callback(). Moving
bsp_pm_callback() into cpu_hotplug_pm_callback() is hacking while 
this patch follows well defined API and has better coding.

Thanks.

-Fenghua 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
