Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2JQS3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:29:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:30821 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab2JQS3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:29:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,602,1344236400"; 
   d="scan'208";a="207293471"
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
Thread-Index: AQHNqJme/Qw6Fjvfd02W7L5t8fGuVJe7UXUAgACSvQCAAfJfUA==
Date: Wed, 17 Oct 2012 18:29:12 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122030B1A8DC@ORSMSX105.amr.corp.intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
 <1350058189-6769-6-git-send-email-fenghua.yu@intel.com>
 <10020874.9eDCB3ZAkx@vostro.rjw.lan> <507CF216.3010507@linux.vnet.ibm.com>
In-Reply-To: <507CF216.3010507@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9HITIEE006460

> From: Srivatsa S. Bhat [mailto:srivatsa.bhat@linux.vnet.ibm.com]
> On 10/16/2012 02:20 AM, Rafael J. Wysocki wrote:
> > On Friday 12 of October 2012 09:09:42 Fenghua Yu wrote:
> >> From: Fenghua Yu <fenghua.yu@intel.com>
> >>
> >> Because x86 BIOS requires CPU0 to resume from sleep, suspend or
> hibernate can't
> >> be executed if CPU0 is detected offline. To make suspend or
> hibernate and
> >> further resume succeed, CPU0 must be online.
> >>
> >> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> >> ---
> >>  arch/x86/power/cpu.c |   44
> ++++++++++++++++++++++++++++++++++++++++++++
> >>  1 files changed, 44 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> >> index 218cdb1..adde775 100644
> >> --- a/arch/x86/power/cpu.c
> >> +++ b/arch/x86/power/cpu.c
> >> @@ -237,3 +237,47 @@ void restore_processor_state(void)
> >>  #ifdef CONFIG_X86_32
> >>  EXPORT_SYMBOL(restore_processor_state);
> >>  #endif
> >> +
> >> +/*
> >> + * When bsp_check() is called in hibernate and suspend, cpu hotplug
> >> + * is disabled already. So it's unnessary to handle race condition
> between
> >> + * cpumask query and cpu hotplug.
> >> + */
> >> +static int bsp_check(void)
> >> +{
> >> +	if (cpumask_first(cpu_online_mask) != 0) {
> >> +		pr_warn("CPU0 is offline.\n");
> >> +		return -ENODEV;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int bsp_pm_callback(struct notifier_block *nb, unsigned long
> action,
> >> +			   void *ptr)
> >> +{
> >> +	int ret = 0;
> >> +
> >> +	switch (action) {
> >> +	case PM_SUSPEND_PREPARE:
> >> +	case PM_HIBERNATION_PREPARE:
> >> +		ret = bsp_check();
> >> +		break;
> >> +	default:
> >> +		break;
> >> +	}
> >> +	return notifier_from_errno(ret);
> >> +}
> >> +
> >
> > I wonder if there's anything preventing CPU0 from becoming offline
> after you've
> > done this check and before user space is frozen?
> >
> 
> Hi Rafael,
> 
> bsp_pm_callback runs as a low priority notifier callback, specifically
> with lower
> priority than the cpu_hotplug_pm_callback (as mentioned in the comment
> below).
> And cpu_hotplug_pm_callback disables regular CPU hotplug (till the
> suspend/resume
> sequence is complete).. So there is no chance for CPU0 to become
> offline after that.

Bhat is right here. There is no functionality issue here.

bsp_check() is protected by cpu_hotplug_disable which is set before
bsp_pm_callback and cleared after it. There is no chance for CPU0
to be offline after that.

Thanks.

-Fenghua


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
