Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2D3ASh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 20:18:37 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:46547 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2D3ASg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 20:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <201204292346.43473.rjw@sisk.pl>
References: <CAMLZHHTM6fojwcPAeyL07hz9U=7uNnxnwxm4kWY_-ffOtHm=vQ@mail.gmail.com>
	<201204292346.43473.rjw@sisk.pl>
Date: Sun, 29 Apr 2012 18:18:35 -0600
X-Google-Sender-Auth: _aDSp3UCkMcZyN_GGqEdiqr2LW4
Message-ID: <CAMLZHHS6JmERa-3YEXw1JOorCiQhqb5-Y2_i8U4kce1V0JZbfQ@mail.gmail.com>
Subject: Re: Hang while loading firmware when going into suspend
From: Daniel Drake <dsd@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 3:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, April 26, 2012, Daniel Drake wrote:
>> Hi,
>>
>> I can easily reproduce a hang related to loading firmware
>> (asynchronously) while going into suspend.
>>
>> This is running on kernel 3.3.3.
>>
>> I run:
>>
>> echo mem > /sys/power/state; echo mem > /sys/power/state
>>
>> i.e. I tell the system to suspend, and when I wake it up it will go
>> very quickly into suspend again.
>>
>> After waking up, it will start to re-detect the libertas SDIO wifi
>> card which was completely powered down during suspend.
>> This triggers a firmware loading sequence.
>> However, the system then immediately goes into suspend, and at this
>> point the system becomes unhappy.
>
> Is this a new bug or did we do that before too?

It's hard to say. Now that drivers aren't allowed to load firmware
from probe(), we've had to convert libertas to use asynchronous
firmware loading, which has moved things around quite a bit, and we're
only now getting wide testing on the new libertas-async-firmware code.

> OK, so the system suspends eventually?

Yes - exactly two minutes after starting to suspend.

>> Sidenote:
>> There is a driver race in the current libertas code - in the above
>> situation it will attempt to call the driver suspend routine even if
>> probe hasn't finished (i.e. async firmware loading still underway). I
>> have that solved locally in the tests above - the suspend routine will
>> detect that probing/firmware loading is still ongoing and wait for
>> that to complete before asking the hardware to suspend. However, in
>> testing this change, I am facing the above issue with the firmware
>> loader behaving badly when going into suspend.
>
> That looks like a bug in the driver, to be honest.  I'll have a look at it
> in the next few days.

A libertas driver bug, you mean?
Yes, it is definitely a bug that libertas suspend routine will not
wait for any ongoing firmware loading before trying to do
suspend-related  stuff with that device.
However, I have that solved locally. The suspend routine is now hooked
up to behave properly. Now what I'm facing is problems with (described
in the above mail) is what happens when firmware is being loaded and
the system starts to suspend - i.e. a problem on a very generic basis,
as far as I can see.

Thanks,
Daniel
