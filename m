Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2FRGmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:42:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:59983 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab2FRGmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:42:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166838076"
Message-ID: <4FDECDDC.6050403@linux.intel.com>
Date: Mon, 18 Jun 2012 14:42:36 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmp patch to fix hotplug issue in CMCI storm
References: <alpine.LFD.2.02.1206080940360.3086@ionos> <1339681786-8418-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1206141554290.3086@ionos> <4FDADB74.3060701@linux.intel.com> <alpine.LFD.2.02.1206151122140.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206151122140.3086@ionos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>
> So according to your explanation that would cause the cmci vector to
> be broadcasted to CPU0 as well. Now that would cause the counter to
> get a bogus increment, right ?
>
> So instead of hacking insane crap into the code, we have simply to do
> the obvious Right Thing:
>
> Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -119,6 +119,9 @@ static bool cmci_storm_detect(void)
>   	unsigned long ts = __this_cpu_read(cmci_time_stamp);
>   	unsigned long now = jiffies;
>
> +	if (__this_cpu_read(cmci_storm_state) != CMCI_STORM_NONE)
> +		return true;
> +
>   	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) {
>   		cnt++;
>   	} else {
>
> That will prevent damage under all circumstances, cpu hotplug
> included.
>
> But that's too simple and comprehensible I fear.
>

Oh, yes, your suggestion can simplify my logic, but not all. Obviously,
when hotplug is happened, it can be considered quitting CMCI storm in
another way, so the corresponding counter and status should be
decreased from that path. And in my original patch, I defined three
status:

enum {
	CMCI_STORM_HCPU_NONE,
	CMCI_STORM_HCPU_ACTIVE,
	CMCI_STORM_HCPU_SUBSIDED,
};

I use CMCI_STORM_HCPU_SUBSIDED to descirbe stalled CPU in hotplug
progressI to stop CMCI enable during whole hotplog status, but
according to your suggestion, now the CMCI_STORM_HCPU_SUBSIDED can
be removed (FIXME: because CMCI can be enabled, if CPU offline and
then online again during CMCI storm, it will enter CMCI storm status
right now. It can simplify the logic, but a little bit performance
degradation).

I will send the 2nd patch based on previous 5 patches in a separate
mail.
