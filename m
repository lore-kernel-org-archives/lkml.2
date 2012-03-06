Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031418Ab2CFVOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:14:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39221 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031315Ab2CFVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:14:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of avagin@gmail.com designates 10.204.156.206 as permitted sender) smtp.mail=avagin@gmail.com; dkim=pass header.i=avagin@gmail.com
Message-ID: <4F567E1C.80003@gmail.com>
Date: Wed, 07 Mar 2012 01:14:04 +0400
From: "avagin@gmail.com" <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Andrew Vagin <avagin@openvz.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum
References: <CAPXgP10GRZ6Y3+dtNSw5zQMaM9FnSBBfLrCJmQ948gA3tALtfw@mail.gmail.com> <1331064368-55675-1-git-send-email-avagin@openvz.org> <CAPXgP10qwPn2-QeyPpDy3GiEqvU6jB-wVuUOUXwcGBvOWOUA1Q@mail.gmail.com>
In-Reply-To: <CAPXgP10qwPn2-QeyPpDy3GiEqvU6jB-wVuUOUXwcGBvOWOUA1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 01:03 AM, Kay Sievers wrote:
> On Tue, Mar 6, 2012 at 21:06, Andrew Vagin<avagin@openvz.org>  wrote:
>>
>> The queue handling in the udev daemon assumes that the events are
>> ordered.
>>
>> Before this patch uevent_seqnum is incremented under sequence_lock,
>> than an event is send uner uevent_sock_mutex. I want to say that code
>> contained a window between incrementing seqnum and sending an event.
>>
>> This patch locks uevent_sock_mutex before incrementing uevent_seqnum.
>
> I think we can remove the spin_lock(&sequence_lock); entirely now, right?

I thought about that too. sequence_lock is used when CONFIG_NET isn't 
defined. I've looked on this code one more time and we may leave only 
uevent_sock_mutex and use it even when CONFIG_NET isn't defined.
Thanks for the comment.

Greg, do you have other objections about this patch?

>
> Also the section with:
>    seq = ++uevent_seqnum;
> can just be:
>    add_uevent_var(env, "SEQNUM=%llu", (unsigned long long) ++uevent_seqnum);
> right?
>
> And the:
>    mutex_lock(&uevent_sock_mutex);
> can just move outside of the _NET ifdef and we always use the mutex
> instead of the spinlock?
>
> That could look much simpler than the current code, I think.
>
> Thanks,
> Kay

