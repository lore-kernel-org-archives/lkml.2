Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1AYWVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:21:10 -0500
Received: from smtp-out.google.com ([74.125.121.67]:3124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1AYWVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:21:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GXaliGYZp/nMR6OozKx3V+BgpiW+FVrWw/aHtjeXSGOWfC0tFlIU33+9n61ZbLeKcB
         eB7lvYnI4/Ui+rgDPGdg==
MIME-Version: 1.0
In-Reply-To: <4D3F4699.60809@garzik.org>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
	<20110125002439.12637.8515.stgit@mike.mtv.corp.google.com>
	<20110125020658.GA3481@kroah.com>
	<AANLkTinLoDN_6zG56J7V154jrRc-K+BzAHFO3qS_r8J0@mail.gmail.com>
	<4D3F4275.50709@garzik.org>
	<AANLkTim4fG0-F0+E-DHa4=XGdk1rFbRA68nvt9bfURiK@mail.gmail.com>
	<4D3F4699.60809@garzik.org>
Date: Tue, 25 Jan 2011 14:21:03 -0800
Message-ID: <AANLkTinUmB003g3Cb0yUXf7LeTvc=BMWN6MGcGJW0QrJ@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] Add oops notification chain.
From: Aaron Durbin <adurbin@google.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mike Waychison <mikew@google.com>, Greg KH <greg@kroah.com>,
        torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 1:54 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 01/25/2011 04:43 PM, Aaron Durbin wrote:
>>
>> On Tue, Jan 25, 2011 at 1:36 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>>>
>>> On 01/25/2011 03:01 PM, Mike Waychison wrote:
>>>>
>>>> On Mon, Jan 24, 2011 at 6:06 PM, Greg KH<greg@kroah.com>    wrote:
>>>>>
>>>>> On Mon, Jan 24, 2011 at 04:24:39PM -0800, Mike Waychison wrote:
>>>>>>
>>>>>> From: Aaron Durbin<adurbin@google.com>
>>>>>>
>>>>>> Later firmware patches in this series would like to be able to be
>>>>>> notified whenever an oops occurs on the system, so that it can be
>>>>>> recorded in the boot log.
>>>>>>
>>>>>> This patch introduces a notifier_block called "oops_notifier_list"
>>>>>> so that drivers can register to get called whenever an Oops is
>>>>>> triggered.
>>>>>
>>>>> But we already have a panic notifier list.  Why create a new one?
>>>>> What's wrong with the existing one that doesn't work properly for you?
>>>>
>>>> AFAICT, the panic notifier list doesn't get called on oops.
>>>
>>> Have you tried playing with panic_on_oops ?
>>
>> Yes. We actually run in that setup. However, oops != panic. They are 2
>> distinct events. Sometimes we panic without the oops under certain
>> situations. That is why it is desirable to have 2 distinct events.
>
> That's a circular statement:  They are distinct events, so it is desirable
> that they be distinct events?

I'm sorry. I should have described which events I was talking about.
They are 2 distinct events in the kernel, and we would look like them
that way in our non-volatile event log as well. As you are very much
aware panic() can be called from outside of the oops path; seeing a
panic doesn't imply an oops (likewise if panic on oops isn't set).

>
> Set a flag, a la oops_in_progress (unfortunately name, as it's called during
> a panic too).  Call it...  oops_really_in_progress.  Then will the panic
> notifier list suffice?

It would only appear to work as long as panic on oops isn't set. As I
mentioned in the previous email we do run with that on, but I think it
is desirable to keep the 2 paths distinct -- thus the separate
notifier chain.

That being said, we could probably add code to distinguish the
difference between the 4 states of oops_in_progress and
oops_really_in_progress and call the panic notifier list at
oops_enter(). I'm not sure why that would be more desirable than an
explicit notification mechanism for oops though.

As Mike talked about it might be more desirable to actually pass a
reason field that indicates the appropriate kernel event. However, the
naming of some of the variables becomes less clear. Maybe name it
panic_oops_notifier_list? That way there would only be a single
notifier chain.

-Aaron
