Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0KWRkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:40:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51102 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0KWRkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lqxJb9gIVl4Ewt/jBTVoi6y0dt1d466FEFD28TWDxEUDev5Zvfmtap8KsjRYscrM5c
         waDexxGlnFAmCnv9UaLkd9UGPxgGF4xewa79p8TPwR76hGqKFTBa8VmJn996wzMFEG6Y
         Fj31tG0JDLINczXVbM617QP5WSdLW5ihAbNJs=
MIME-Version: 1.0
In-Reply-To: <20101122075554.GA27300@core.coreip.homeip.net>
References: <1290126335-12430-1-git-send-email-pingc@wacom.com>
	<20101122075554.GA27300@core.coreip.homeip.net>
Date: Tue, 23 Nov 2010 09:40:19 -0800
Message-ID: <AANLkTinVYUrD2a+6Z3K0nUze12ZoSc5N0AtR0xB=AjOa@mail.gmail.com>
Subject: Re: [PATCH] Add BTN_TOOL_BUTTONS to input.h
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 11:55 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Ping,
>
> On Thu, Nov 18, 2010 at 04:25:35PM -0800, Ping Cheng wrote:
>> We "borrowed" BTN_TOOL_FINGER from input/mouse to pass tablet
>> buttons to the user land. This has not been an issue since
>> tablet was not considered as a mouse replacement. With the
>> introduction of hybrid digitizer and touch devices, the tool
>> type is causing confusion. A new tool type is due for the
>> well-being of future input device drivers.
>>
>
> I am sorry but I do not understand the reasoning behind
> BTN_TOOL_BUTTONS.

Don't be sorry, Dmitry. Your statement is fair since:

1.  I did not explain it clearly;
2.  You do not have the physical device (Intuos series) to test with.

I'll explain it again by refering back to the code to see if I can
make it clear or not. The code I am going to refer to is under the
Linus tree at git.kernel.org.

> The BTN_TOOL_* were introduced to indicate to the userspace tool that is
> currently touching the surface of the device. Buttons are expected to be
> always present and can change their state regardless of what tool is
> being used at the moment. I.e. The full hardware state (between
> EV_SYN/SYN_REPORT) could be, for example,
>
> Pen at 10,20, BTN_0, and BTN_2 (ABS_X 10, ABS_Y 20, BTN_TOOL_PEN, BTN_0,
> BTN_2) or
>
> Lens at 20,15 and BTN_1 (ABS_X 20, ABS_Y 15, BTN_TOOL_LENS, BTN_1).
>
> As you can see BTN_* events can accompany either BTN_TOOL_LENS or
> BTN_TOOL_PEN or any other BTN_TOOL_*.

You are right. The tablet buttons can go with one of those other
BTN_TOOL_s _if_ they do not define the same event types (BTN_s) as the
tablet buttons.

The new Bamboo MT code sends both BTN_LEFT and BTN_RIGHT events for
Tablet Buttons (refer to line 905 and 908 of wacom_wac.c). However,
BTN_LEFT and BTN_RIGHT are also sent by BTN_TOOL_MOUSE/LENS tool
(refer to wacom_wac.c line 622 to 665).

If we remove BTN_TOOL_FINGER without a BTN_TOOL-something to replace
it, the two LEFT and RIGHT buttons will have a hard time to tell the
user land if they are from the MOUSE/LENS or the Tablet Buttons. The
worst case could be the LEFT/RIGHT sent later overwrites the earlier
ones.

We could do some guesswork in the user land to figure out which
LEFT/RIGHT belongs to which BTN_TOOL_ if the above scenario does not
happen. But, it would be much cheaper and more reliable if we can tell
the user land where those LEFT and RIGHT come from. This is the whole
purpose of the kernel driver, isn't it?

Ping
