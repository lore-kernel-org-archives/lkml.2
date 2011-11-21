Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab1KUHz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 02:55:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:53008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1KUHzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 02:55:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78261740"
Message-ID: <4ECA03DF.4000402@linux.intel.com>
Date: Mon, 21 Nov 2011 15:55:11 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <201111192257.19763.rjw@sisk.pl> <4EC8984E.30005@linux.vnet.ibm.com> <201111201124.17528.rjw@sisk.pl> <4EC9D557.9090008@linux.vnet.ibm.com>
In-Reply-To: <4EC9D557.9090008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>
> Actually, I think I have a better idea based on a key observation:
> We are trying to acquire pm_mutex here. And if we block due to this,
> we are *100% sure* that we are not going to run as long as hibernation
> sequence is running, since hibernation releases pm_mutex only at the
> very end, when everything is done.
> And this means, this task is going to be blocked for much more longer
> than what the freezer intends to achieve. Which means, freezing and
> thawing doesn't really make a difference to this task!
>
> So, let's just ask the freezer to skip freezing us!! And everything
> will be just fine!
>
> Something like:
>
> void lock_system_sleep(void)
> {
> 	/* simplified freezer_do_not_count() */
> 	current->flags |= PF_FREEZER_SKIP;
>
> 	mutex_lock(&pm_mutex);
>
> }
>
> void unlock_system_sleep(void)
> {
> 	mutex_unlock(&pm_mutex);
>
> 	/* simplified freezer_count() */
> 	current->flags&= ~PF_FREEZER_SKIP;
>
> }
>
> We probably don't want the restriction that freezer_do_not_count() and
> freezer_count() work only for userspace tasks. So I have open coded
> the relevant parts of those functions here.
>

This new design looks clean and better than old one. I just curious how do
you design your test environment? e.g. when hibernating is in progress,
try to online some memories and wait for hibernation fails or succeeds?
