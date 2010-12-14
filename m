Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab0LNKhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:37:36 -0500
Received: from mail-wy0-f194.google.com ([74.125.82.194]:50350 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab0LNKhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QhY+UFXwi7RXFDn6rh2n9zKx2GhKNKz8mcX4/FqrokDTY4nek/f7zSLeFLYRDQ9hpt
         bEMWLKOWER4Yu0lIXMub/XlMOwrm1HNzHgfnITDih0ytYCZKDDNcWJ5+96KC1sKU1GeS
         rlQLxVWW5xIoWFun/z3dSffZRYW22IyRMrwvc=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=UVOQb15EdpfSeD+Qh8x779pJpsSCTyGvf-gxG@mail.gmail.com>
References: <201012130128.31243.rjw@sisk.pl>
	<201012130131.24970.rjw@sisk.pl>
	<AANLkTi=UVOQb15EdpfSeD+Qh8x779pJpsSCTyGvf-gxG@mail.gmail.com>
Date: Tue, 14 Dec 2010 18:37:16 +0800
Message-ID: <AANLkTim+UoR+GeEK8T1_jgie3gwq6Pdt_=sRiSf8qx6K@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/4] PM: Remove redundant checks from core device
 resume routines
From: Ming Lei <tom.leiming@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/13 Linus Torvalds <torvalds@linux-foundation.org>:
> So I really like this series not only because it implements what I
> suggested, but also because each patch seems to remove more lines than
> it adds. That's always nice, and much too unusual.
>
> But in this one, I really think you should simplify/clarify things further:
>
> On Sun, Dec 12, 2010 at 4:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> +++ linux-2.6/drivers/base/power/main.c
>> @@ -485,20 +485,17 @@ void dpm_resume_noirq(pm_message_t state
>>        transition_started = false;
>>        while (!list_empty(&dpm_noirq_list)) {
>>                struct device *dev = to_device(dpm_noirq_list.next);
>> +               int error;
>>
>>                get_device(dev);
>> -               if (dev->power.status > DPM_OFF) {
>> -                       int error;
>> -
>> -                       dev->power.status = DPM_OFF;
>> -                       mutex_unlock(&dpm_list_mtx);
>> +               dev->power.status = DPM_OFF;
>> +               mutex_unlock(&dpm_list_mtx);
>
> I think you should move the device to the dpm_suspended list _here_,
> before dropping the mutex. That way the power.status thing matches the
> list.
>
> So then you'd just remove the crazy conditional "if it's still on a
> list, move it to the right list" thing, and these two lines:
>
>>                if (!list_empty(&dev->power.entry))
>>                        list_move_tail(&dev->power.entry, &dpm_suspended_list);
>
> Would just be that plain
>
>        list_move_tail(&dev->power.entry, &dpm_suspended_list);
>
> before you even drop the lock. That look much simpler, and the list
> movement seems a lot more obvious, no?
>
> If an unregister event (or whatever) happens while you had the mutex
> unlocked, it will just remove it from the new list (the one that
> matches the power state). So no need for that whole complexity with
> "what happens with the list if somebody removed the device while we
> were busy suspending/resuming it".
>
> Or am I missing something?
>
> (And same comment for that other identical case in dpm_complete())

Seems it may apply in other cases(dpm_prepare/dpm_suspend
/dpm_suspend_noirq) too?

thanks,
-- 
Lei Ming
