Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2A3XY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:24:56 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:52245 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2A3XYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:24:55 -0500
Message-ID: <4F2726AC.5000808@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 04:54:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Nigel Cunningham <nigel@tuxonice.net>, Pavel Machek <pavel@ucw.cz>,
        Martin@lichtvoll.de, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
References: <201201281445.49377.rjw@sisk.pl> <4F257395.9070804@linux.vnet.ibm.com> <201201292053.31053.rjw@sisk.pl>
In-Reply-To: <201201292053.31053.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12013013-7014-0000-0000-0000007F572C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 01:23 AM, Rafael J. Wysocki wrote:

> On Sunday, January 29, 2012, Srivatsa S. Bhat wrote:

[...]

>>> Index: linux/kernel/power/suspend.c
>>> ===================================================================
>>> --- linux.orig/kernel/power/suspend.c
>>> +++ linux/kernel/power/suspend.c
>>> @@ -29,6 +29,48 @@
>>>
>>>  #include "power.h"
>>>
>>> +#ifdef CONFIG_SUSPEND_FREEZER
>>> +
>>> +static inline int suspend_freeze_processes(void)
>>> +{
>>> +	int error;
>>> +
>>> +	error = freeze_processes();
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	error = freeze_supers();
>>> +	if (error) {
>>> +		thaw_processes();
>>> +		return error;
>>> +	}
>>> +
>>> +	error = freeze_kernel_threads();
>>> +	if (error)
>>> +		thaw_supers();
>>> +
>>
>>
>> If freezing of kernel threads fails, freeze_kernel_threads() calls
>> thaw_processes(), which means, even userspace processes get thawed.
>> So, there would be a time-window in which userspace is thawed but the
>> filesystems are still frozen. That is not very desirable right?
> 
> No, it is not.  I overlooked that, thanks!
> 
>> If that is right, then modifying freeze_kernel_threads() to call
>> thaw_kernel_threads() instead of thaw_processes() would fix it
>> (and of course, we would need to explicitly call thaw_processes
>> above).
>>
>> BTW, after your patch posted at https://lkml.org/lkml/2012/1/27/501,
>> I very much wanted to write a patch to convert the semantics of
>> freeze/thaw to something like:
>>
>> freeze_processes() calls thaw_processes on error.
>> //Both touch only userspace processes.
>>
>> freeze_kernel_threads() calls thaw_kernel_threads() on error.
>> //Both touch only kernel threads.
>>
>> Of course, such a patch would need to do a lot of fixing up at several
>> places, but IMHO, it would really help make the overall code more logical
>> and easier to understand.
>>
>> I can write it up and post it soon, but then you'll have to rebase
>> your patch (this one) on top of that. What do you say?
> 
> Please do that, it wouldn't be any problem for me to rebase the $subject
> patch.
> 


Hi Rafael,
I have posted the patchset (v2) at https://lkml.org/lkml/2012/1/30/530

 

Regards,
Srivatsa S. Bhat

