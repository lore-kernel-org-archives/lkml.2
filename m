Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2JRGwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:52:24 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41542 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2JRGwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:52:22 -0400
Message-ID: <507FA6D9.7080800@linux.vnet.ibm.com>
Date: Thu, 18 Oct 2012 12:21:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
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
Subject: Re: [PATCH v9 05/12] x86, hotplug, suspend: Online CPU0 for suspend
 or hibernate
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com> <35538834.Boc5416YXf@vostro.rjw.lan> <3E5A0FA7E9CA944F9D5414FEC6C7122030B1A8BC@ORSMSX105.amr.corp.intel.com> <4821251.PVP3SGWCqy@vostro.rjw.lan>
In-Reply-To: <4821251.PVP3SGWCqy@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101806-5816-0000-0000-000004F25200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 12:03 PM, Rafael J. Wysocki wrote:
> On Wednesday 17 of October 2012 17:39:48 Yu, Fenghua wrote:
>>>>> On Tuesday, October 16, 2012 10:19 PM Rafael J. Wysocki wrote:
>>> On Tuesday 16 of October 2012 22:12:27 Yu, Fenghua wrote:
>>>>> On 10/16/2012 09:47 PM, Rafael J. Wysocki wrote:
>>>>>> On Tuesday 16 of October 2012 11:05:18 Srivatsa S. Bhat wrote:
>>>>>>> On 10/16/2012 02:20 AM, Rafael J. Wysocki wrote:
>>>>>>>> On Friday 12 of October 2012 09:09:42 Fenghua Yu wrote:
>>>>>>>>> From: Fenghua Yu <fenghua.yu@intel.com>
>>>>> fix the bug I
>>>>> pointed out in my other mail.
>>> Because things like this are often overlooked by people trying to
>>> optimize
>>> stuff and the fact that you have to add a comment explaining that
>>> dependency
>>> only means that it is not exactly straightforward.
>>
>> If people try to optimize pm notifier, they really need to know
>> pm_notifier() API and its priority. If they ignore the priority, they will
>> screw up kernel no matter how many comments in it.
>>
>>>
>>> Moreover, you should also add a corresponding comment in the other
>>> notifier
>>> indicating that its priority should be higher than the priority of the
>>> new thing and explaining why.
>>
>> The comment in the patch explains this very clearly. I don't think it's
>> necessary to add comments in other notifiers.
>>
>> If adding comments in other notifiers each time when you add a new notifier,
>> will you add 10 more comments in all other notifiers if you add 10 new notifiers?
> 
> Well, if there are strict ordering requirements regarding them, then those
> requirements should be documented in both places.  Otherwise, if somebody looks
> at cpu_hotplug_pm_callback() alone, for example, he/she may not even realize
> that it has to be strictly ordered with respect to bsp_pm_callback().
> 

Right, either we could put comments at both places or set up #defines for
their priorities in a common header file or some such and comment about it there,
like what is done in include/linux/cpu.h for example. But atleast one of these
*has* to be done; just commenting at one place is too risky for code-maintenance.

> Of course, you can argue that people should know what they are doing, but
> then reality is that it's quite easy to overlook things like that.
>

Yep.
 
>> I would think when people try to change notifier priority, they should
>> know what they are going to do and search the notifiers and see the comments.
>>
>> BTW, the other notifier is in generic code. Adding a paranoid comment in
>> it doesn't seem to be worth. The comment in this patch code is very clear
>> already.
> 
> The problem is that it is generally difficult to find all subsystems that
> have registered notifiers in a given chain and figuring out dependencies
> between them is highly problematic.  That's why I'm saying this is a fragile
> design - because it is so easy to break accidentally (and that's already
> happened in CPU hotplug, so I'm not making that up).

True..
 
Regards,
Srivatsa S. Bhat

> 
>>> I really think that notifiers are fragile in general and this
>>> particular
>>> one is no exception.
>>
>> If we think pm_notifier API is fragile, we need to fix the API instead of
>> leaving it there and not allowing people to use it because it's suspected
>> fragile.
> 
> Because it is use by the existing code which generally works and may be
> broken while attempting to "fix" the API.
> 
>> It's simply not realistic to tell people not to use the API each
>> time in code review while in the meantime the API and its priority are staying
>> in kernel to allow people to use it.
> 
> I don't quite agree.  It sometimes is not worth changing code that's been
> around for a while already, because it's been tested in multiple configurations
> and changing it may cause things to break, although we may not like the APIs
> used by that code.  That doesn't necessarily mean, however, that adding new
> code using those APIs is always a good idea.
> 
> In this particular case I just wondered if we could avoid adding more code
> that would use an API having known problems.  The answer seems to be that
> it would cost some additional complexity that might not be worth it.  This
> is a good answer, but you might have given it to me directly. :-)
> 

