Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0FXPWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:22:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38924 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab0FXPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=pnHs2t6mKj/eyszdCtwpRayDom5IKlh86jie2b9igFYL8U0S8rPBYn651TYy7BrNqq
         XEt8kkzPG0vW+UkErZPZKKqMEmF8+vqch8zTC7e62UdboLUrx2WWaOMTEtViK9NQb6Sc
         BzTequLf5L+yROV4vh8j3++rvQXy4CVyQRuqg=
References: <Pine.LNX.4.44L0.1006220952290.1631-100000@iolanthe.rowland.org> <201006222159.28081.rjw__37084.1419128284$1277237903$gmane$org@sisk.pl> <4C2368C8.7020708@mit.edu> <201006241648.46448.rjw@sisk.pl>
Message-Id: <5CBFA89B-B49D-4FEC-A8DC-2F7E672542EF@gmail.com>
From: Andy Lutomirski <amluto@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <201006241648.46448.rjw@sisk.pl>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [update] Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Date: Thu, 24 Jun 2010 11:21:54 -0400
Cc: Andy Lutomirski <luto@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
       mark gross <640e9920@gmail.com>, Neil Brown <neilb@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Arve@smtp1.linux-foundation.org" <Arve@smtp1.linux-foundation.org>,
       Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Jun 24, 2010, at 10:48 AM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, June 24, 2010, Andy Lutomirski wrote:
>> Rafael J. Wysocki wrote:
>>> On Tuesday, June 22, 2010, Rafael J. Wysocki wrote:
>>>> On Tuesday, June 22, 2010, Alan Stern wrote:
>>>>> On Tue, 22 Jun 2010, Rafael J. Wysocki wrote:
>>> ...
>>>>>> So, even if we can say when the kernel has finished processing  
>>>>>> the event
>>>>>> (although that would be complicated in the PCIe case above), I  
>>>>>> don't think
>>>>>> it's generally possible to ensure that the entire processing of  
>>>>>> a wakeup event
>>>>>> has been completed.  This leads to the question whether or not  
>>>>>> it is worth
>>>>>> trying to detect the ending of the processing of a wakeup event.
>>>>> As Arve pointed out, in some cases it definitely is worthwhile  
>>>>> (the
>>>>> gpio keypad matrix example).  In other cases there may be no  
>>>>> reasonable
>>>>> way to tell.  That doesn't mean we have to give up entirely.
>>>> Well, I'm not sure, because that really depends on the hardware  
>>>> and bus in
>>>> question.  The necessary condition seems to be that the event be  
>>>> detected
>>>> and handled entirely by the same functional unit (eg. a device  
>>>> driver) within
>>>> the kernel and such that it is able to detect whether or not user  
>>>> space has
>>>> acquired the event information.  That doesn't seem to be a common  
>>>> case to me.
>>>
>>> Anyway, below's an update that addresses this particular case.
>>>
>>> It adds two more functions, pm_wakeup_begin() and pm_wakeup_end()
>>> that play similar roles to suspend_block() and suspend_unblock(),  
>>> but they
>>> don't operate on suspend blocker objects.  Instead, the first of  
>>> them increases
>>> a counter of events in progress and the other one decreases this  
>>> counter.
>>> Together they have the same effect as pm_wakeup_event(), but the  
>>> counter
>>> of wakeup events in progress they operate on is also checked by
>>> pm_check_wakeup_events().
>>>
>>> Thus there are two ways kernel subsystems can signal wakeup  
>>> events.  First,
>>> if the event is not explicitly handed over to user space and  
>>> "instantaneous",
>>> they can simply call pm_wakeup_event() and be done with it.   
>>> Second, if the
>>> event is going to be delivered to user space, the subsystem that  
>>> processes
>>> the event can call pm_wakeup_begin() right when the event is  
>>> detected and
>>> pm_wakeup_end() when it's been handed over to user space.
>>
>> How does userspace handle this without races?  (I don't see an  
>> example
>> in a driver that talks to userspace in your code...)
>>
>> For example, if I push a button on my keyboard, the driver calls
>> pm_wakeup_begin().  Then userspace reads the key from the evdev  
>> device
>> and tells the userspace suspend manager not to go to sleep.
>>
>> But there's a race: the keyboard driver (or input subsystem) could  
>> call
>> pm_wakeup_end() before the userspace program has a chance to tell the
>> suspend manager not to sleep.
>
> That basically is what /sys/power/wakeup_count is for.  The power  
> manager is
> supposed to first read from it (that will block if there are any  
> events in
> progress in the last, recently posted, version of the patch), obtain  
> ACKs from
> user space event consumers known to it, then write to
> /sys/power/wakeup_count (that will fail if there were any wakeup  
> events in the
> meantime) and write to /sys/power/state only if that was successful.

That sounds a good deal more complicated than the poll, block suspend,  
read, unblock approach, but I guess that as long as both work, the  
kernel doesn't really have to care.


>
> Rafael
