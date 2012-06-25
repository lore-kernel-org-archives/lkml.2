Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2FYJYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:24:21 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:48611 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2FYJYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:24:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9wHMTYoxVqj3Ls3Y7NEwgL4Y=XnxGFzyxfy4bseMR_Hhzp7Q@mail.gmail.com>
References: <CAK9wHMS_P+y+NmvVVrH+nNOb=KPi3rEgJOWEcRcKf3mTkxjDPA@mail.gmail.com>
	<Pine.LNX.4.44L0.1206211025060.1164-100000@iolanthe.rowland.org>
	<CAK9wHMTYoxVqj3Ls3Y7NEwgL4Y=XnxGFzyxfy4bseMR_Hhzp7Q@mail.gmail.com>
Date: Mon, 25 Jun 2012 17:24:18 +0800
Message-ID: <CAK9wHMSp+h9dMjZivV=Y42D1JjvZCC9vCqa4HDBV7osYek70AQ@mail.gmail.com>
Subject: Re: pm runtime and system suspend resume
From: chao xie <xiechao.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/22 chao xie <xiechao.linux@gmail.com>:
> 2012/6/21 Alan Stern <stern@rowland.harvard.edu>:
>> On Thu, 21 Jun 2012, chao xie wrote:
>>
>>> I check the code, __device_suspend will invoke dev->pm_domain->ops
>>> first if dev->pm_domain is not NULL.
>>> Taking "suspend" as esample, i can do the following things in the
>>> dev->pm_domain->ops->suspend
>>> 1. invoke dev->driver->pm->suspend for suspending the device
>>> 2. do what we do in dev->pm_domain->ops->runtime_suspend for
>>> suspending the surrounded logic, for example, shutdown the phy or
>>> clocks.
>>> So is above implementation fine?
>>
>> Yes, that sounds like it will work.  Watch out for the case where your
>> device is already runtime-suspended when a system suspend occurs.
>>
>> Have you read section 6 in Documentation/power/runtime_pm.txt?  It is
>> related to your question.
>>
> I will read the document. Thanks very much.
>
>> Alan Stern
>>

There is no more question about runtime_idle and runtime_suspend
as i understand that runtime_idle indicates that the device is idle,
clock may be off, no function there, runtime_suspend means that the
device my be power off, and making it rework may need some
initialization work.
So in the scenario, for USB, there are some clocks relates to it and
there is a phy attached to it.
When phy is powered off, it need to be initialized again, and it will
take some time.
So in the driver, when there is no action, we will call
pm_runtime_put, and it will shut off the clocks, for
pm_runtime_put_sync_suspend, it will shut off the phy to save more
power.
Then how do we call pm_runtime_put_sync_suspend if it already calls
pm_runtime_put? Do we need do call pm_runtime_get before call
pm_runtime_put_sync_suspend because the usage_count is not 0?
