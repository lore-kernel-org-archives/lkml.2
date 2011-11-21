Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1KUIWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 03:22:54 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43180 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1KUIWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 03:22:50 -0500
Message-ID: <4ECA0A50.7030502@linux.vnet.ibm.com>
Date: Mon, 21 Nov 2011 13:52:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Chen Gong <gong.chen@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@ucw.cz, lenb@kernel.org,
        ak@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] PM/Memory-hotplug: Avoid task freezing failures
References: <20111117083042.11419.19871.stgit@srivatsabhat.in.ibm.com> <201111192257.19763.rjw@sisk.pl> <4EC8984E.30005@linux.vnet.ibm.com> <201111201124.17528.rjw@sisk.pl> <4EC9D557.9090008@linux.vnet.ibm.com> <4ECA03DF.4000402@linux.intel.com>
In-Reply-To: <4ECA03DF.4000402@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112022-9264-0000-0000-0000003D62D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 01:25 PM, Chen Gong wrote:
> [...]
>>
>> Actually, I think I have a better idea based on a key observation:
>> We are trying to acquire pm_mutex here. And if we block due to this,
>> we are *100% sure* that we are not going to run as long as hibernation
>> sequence is running, since hibernation releases pm_mutex only at the
>> very end, when everything is done.
>> And this means, this task is going to be blocked for much more longer
>> than what the freezer intends to achieve. Which means, freezing and
>> thawing doesn't really make a difference to this task!
>>
>> So, let's just ask the freezer to skip freezing us!! And everything
>> will be just fine!
>>
>> Something like:
>>
>> void lock_system_sleep(void)
>> {
>>     /* simplified freezer_do_not_count() */
>>     current->flags |= PF_FREEZER_SKIP;
>>
>>     mutex_lock(&pm_mutex);
>>
>> }
>>
>> void unlock_system_sleep(void)
>> {
>>     mutex_unlock(&pm_mutex);
>>
>>     /* simplified freezer_count() */
>>     current->flags&= ~PF_FREEZER_SKIP;
>>
>> }
>>
>> We probably don't want the restriction that freezer_do_not_count() and
>> freezer_count() work only for userspace tasks. So I have open coded
>> the relevant parts of those functions here.
>>
> 
> This new design looks clean and better than old one. I just curious how do
> you design your test environment? e.g. when hibernating is in progress,
> try to online some memories and wait for hibernation fails or succeeds?
> 

Hi Chen,

Thanks a lot for taking a look!

As I have indicated earlier in some of my mails, I am more concerned about
the API lock_system_sleep() than memory hotplug, because it is this *API*
that is buggy, not memory-hotplug. And going further, any other code planning
to use this API will be problematic. So our focus here, is to fix this *API*.

So, to test this API, I have written a kernel module that calls
lock_system_sleep() in its init code. Then I load/unload that module wildly
in a loop and simultaneously run hibernation tests using the 'pm_test'
framework. It is to be also noted that, the issue here is only with the initial
steps of hibernation, namely, related to freezer. Hence, pm_test framework
fits pretty well to debug these freezer issues. (And in fact, I have found that
this method is quite effective to test whether my patch fixes the issue or not.)

Thanks,
Srivatsa S. Bhat

