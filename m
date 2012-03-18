Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2CRI1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 04:27:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49622 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2CRI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 04:26:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6652"; a="171186770"
Message-ID: <4F659C41.70701@codeaurora.org>
Date: Sun, 18 Mar 2012 01:26:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper
 is not yet available
References: <201203032122.36745.chunkeey@googlemail.com> <201203150034.08863.rjw@sisk.pl> <4F612C05.8010301@codeaurora.org> <201203150111.05724.rjw@sisk.pl> <4F63FB59.9010104@codeaurora.org> <CA+55aFyUAiVpueCTe2rDMZxcDkoQ=gYM+-Qmu0KG2SPTV4B+zA@mail.gmail.com>
In-Reply-To: <CA+55aFyUAiVpueCTe2rDMZxcDkoQ=gYM+-Qmu0KG2SPTV4B+zA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/2012 10:51 PM, Linus Torvalds wrote:
> On Fri, Mar 16, 2012 at 7:47 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> -       if (WARN_ON(usermodehelper_is_disabled())) {
>> +       if (is_sleep_task()) {
>>                dev_err(device, "firmware: %s will not be loaded\n", name);
> Stop these idiotic games already!
>
> It's very simple: you cannot load firmware while the system is not
> readt. Your moronic "let's change the test to something else" is
> entirely and utterly misguided and totally misses the point.
>
> It's not about sleeping, and it's not about anything even *remotely*
> about that. Stop the idiocy already.
>
> How hard is it to understand? How many times do people have to tell you?
>
> That warning is very much valid during bootup, and that warning has
> been *seen* during bootup. For example, try to compile in most
> wireless drivers as non-modular, and that warning *has* to trigger.

Ok. I like where nowait() is going in the other part of the thread but
I'm still confused about when request_firmware() is correct to use. It
seems that the function is inherently racy with freezing. Does every
user of request_firmware() need to synchronize with freezing?

For example, if one CPU is in the middle of a driver probe that makes a
request_firmware() call and another CPU is starting to suspend we will
have a race between usermodehelpers being disabled and the
request_firmware() call acquiring the usermodehelper rwsem. If the
suspending CPU wins the race it will disable usermodehelpers and the
request_firmware() call will return -EBUSY and warn.

CPU0                           CPU1
driver_probe()                 suspend_prepare()
  ...                            usermodehelper_disable()
  _request_firmware()              down_write(&umhelper_sem)
                                   usermodehelper_disabled = 1
                                   up_write(&umhelper_sem)
    down_read(&umhelper_sem)       ....
    WARN_ON(...)                   freeze_processes()
    <freeze>                       


Hopefully I'm missing something here? This is all theoretical right now
as I haven't actually seen any of this in practice.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

