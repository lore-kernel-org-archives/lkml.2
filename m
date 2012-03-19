Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2CSGcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:32:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57415 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab2CSGcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:32:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6653"; a="173602524"
Message-ID: <4F66D2E8.2090906@codeaurora.org>
Date: Sun, 18 Mar 2012 23:32:08 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <201203032122.36745.chunkeey@googlemail.com> <CA+55aFyUAiVpueCTe2rDMZxcDkoQ=gYM+-Qmu0KG2SPTV4B+zA@mail.gmail.com> <4F659C41.70701@codeaurora.org> <201203181301.19048.rjw@sisk.pl>
In-Reply-To: <201203181301.19048.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/2012 5:01 AM, Rafael J. Wysocki wrote:
> On Sunday, March 18, 2012, Stephen Boyd wrote:
>
>> Ok. I like where nowait() is going in the other part of the thread but
>> I'm still confused about when request_firmware() is correct to use. It
>> seems that the function is inherently racy with freezing. Does every
>> user of request_firmware() need to synchronize with freezing?
>>
>> For example, if one CPU is in the middle of a driver probe that makes a
>> request_firmware() call and another CPU is starting to suspend we will
>> have a race between usermodehelpers being disabled and the
>> request_firmware() call acquiring the usermodehelper rwsem. If the
>> suspending CPU wins the race it will disable usermodehelpers and the
>> request_firmware() call will return -EBUSY and warn.
> Yes, it will.

That sounds wrong then, no? Why don't we have request_firmware() do a
read_lock on the usermodehelpers sem and then have suspend do a write
lock, disable usermodehelpers, wait for any users  to finish, freeze
processes and then unlock the write lock? That way we don't hit a case
where request_firmware() races with suspend, and we don't have to change
the warning or conditional.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

