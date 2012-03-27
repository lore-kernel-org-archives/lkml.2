Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2C0VZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:25:50 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30143 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2C0VZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:25:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6662"; a="176329080"
Message-ID: <4F723059.9070003@codeaurora.org>
Date: Tue, 27 Mar 2012 14:25:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 6/6] PM / Sleep: Mitigate race between the freezer and
 request_firmware()
References: <201203032122.36745.chunkeey@googlemail.com> <201203260004.55956.rjw@sisk.pl> <4F70B261.7060402@codeaurora.org> <201203262206.08989.rjw@sisk.pl>
In-Reply-To: <201203262206.08989.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/12 13:06, Rafael J. Wysocki wrote:
> On Monday, March 26, 2012, Stephen Boyd wrote:
>> On 03/25/12 15:04, Rafael J. Wysocki wrote:
>>> Index: linux/kernel/power/process.c
>>> ===================================================================
>>> --- linux.orig/kernel/power/process.c
>>> +++ linux/kernel/power/process.c
>>> @@ -135,6 +135,7 @@ int freeze_processes(void)
>>>  	error = try_to_freeze_tasks(true);
>>>  	if (!error) {
>>>  		printk("done.");
>>> +		__usermodehelper_reset(UMH_DISABLED);
>>>  		oom_killer_disable();
>>>  	}
>>>  	printk("\n");
>> nitpick: This doesn't seem to be doing a reset, more like a set. Perhaps
>> this function should be called __usermodehelper_set()?
> Yes, you are right.  I changed that before, but somehow managed to send an old
> patch.  The new version follows.

Looks good. Thanks.

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Sleep: Mitigate race between the freezer and request_firmware()
>
> There is a race condition between the freezer and request_firmware()
> such that if request_firmware() is run on one CPU and
> freeze_processes() is run on another CPU and usermodehelper_disable()
> called by it succeeds to grab umhelper_sem for writing before
> usermodehelper_read_trylock() called from request_firmware()
> acquires it for reading, the request_firmware() will fail and
> trigger a WARN_ON() complaining that it was called at a wrong time.
> However, in fact, it wasn't called at a wrong time and
> freeze_processes() simply happened to be executed simultaneously.
>
> To avoid this race, at least in some cases, modify
> usermodehelper_read_trylock() so that it doesn't fail if the
> freezing of tasks has just started and hasn't been completed yet.
> Instead, during the freezing of tasks, it will try to freeze the
> task that has called it so that it can wait until user space is
> thawed without triggering the scary warning.
>
> For this purpose, change usermodehelper_disabled so that it can
> take three different values, UMH_ENABLED (0), UMH_FREEZING and
> UMH_DISABLED.  The first one means that usermode helpers are
> enabled, the last one means "hard disable" (i.e. the system is not
> ready for usermode helpers to be used) and the second one
> is reserved for the freezer.  Namely, when freeze_processes() is
> started, it sets usermodehelper_disabled to UMH_FREEZING which
> tells usermodehelper_read_trylock() that it shouldn't fail just
> yet and should call try_to_freeze() if woken up and cannot
> return immediately.  This way all freezable tasks that happen
> to call request_firmware() right before freeze_processes() is
> started and lose the race for umhelper_sem with it will be
> frozen and will sleep until thaw_processes() unsets
> usermodehelper_disabled.  [For the non-freezable callers of
> request_firmware() the race for umhelper_sem against
> freeze_processes() is unfortunately unavoidable.]

Reported-by: Stephen Boyd <sboyd@codeaurora.org>

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

