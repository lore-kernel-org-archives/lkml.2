Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927Ab2KBOST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:18:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55543 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762889Ab2KBOSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <20121031185332.GA1745@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-9-git-send-email-benjamin.tissoires@gmail.com>
	<20121029221905.GA15537@polaris.bitmath.org>
	<CAN+gG=ESZLHneinkc6kdkazRBfsGP70GaBPfV=jLhnTtZMVrKQ@mail.gmail.com>
	<20121031185332.GA1745@polaris.bitmath.org>
Date: Fri, 2 Nov 2012 15:18:15 +0100
Message-ID: <CAN+gG=E1DOPrxw4PDNVRDf-cPd7qaq5Sbgo2WC5cApTNn8t9Yg@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] HID: hid-multitouch: fix Win 8 protocol
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Wed, Oct 31, 2012 at 7:53 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> On Mon, Oct 29, 2012 at 11:19 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > On Fri, Oct 26, 2012 at 10:44:24AM +0200, Benjamin Tissoires wrote:
>> >> Win 8 specification is much more precise than the Win 7 one.
>> >> Moreover devices that need to take certification must be submitted
>> >> to Microsoft.
>> >>
>> >> The result is a better protocol support and we can rely on that to
>> >> skip all the messy tests we used to do.
>> >>
>> >> The protocol specify the fact that each valid touch must be reported
>> >> within a frame, and that the release touch coordinate must be the
>> >> same than the last known touch.
>> >> So we can use the always_valid quirk and dismiss reports when we
>> >> touch coordiante do not follow this rule.
>> >>
>> >> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> >> ---
>> >>  drivers/hid/hid-multitouch.c | 16 ++++++++++++++--
>> >>  1 file changed, 14 insertions(+), 2 deletions(-)
>> >
>> > Why do we need this patch?
>>
>> This patch prevents a corner case where the device use contactID 0 for
>> it's first reported touch.
>> Once you got the invalid touches, most of the time, contactID will be
>> 0, x, y, and other fields too. So this ensures to avoid conflict
>> between valid values and garbage values. The problem lies in the fact
>> that we don't have the whole overview of the frame (with the contact
>> count) to decide which contacts are good and which are not.
>
> I am sorry, but your explanation did not make me any wiser. :-) Are

Sorry, for that. Let's try with other words.

> you saying that touch state changes and touch property changes are
> mutually exclusive? For all win8 devices, or just for the serial
> protocol ones? For what devices is the current implementation a
> problem?

The goal of this patch is to implement in a reliable way Win 8
multitouch protocol (to avoid quirking many devices). Thanks to the
precision they made in the specification, I think it is feasible:
they add the dynamic part that were missing in Win 7 spec:
"""
When sending data in hybrid or parallel mode, a contact that is
delivered in one report must be delivered in all subsequent reports
until it is lifted off the screen. If time is needed to adequate
determine if the contact was lifted off the surface, the device must
report the last known position of the contact and then deliver the
“UP” state of the contact in a subsequent report. Devices should not
send a report without the information for that contact while trying to
determine its current state.
"""

Thus, the quirk ALWAYS_VALID fits very well with win 8 devices (the
device has to send the touch until it is lifted and out of range, and
the device must send the 'up' state).

The problem lies that some devices may reuse contact id 0 within the
frame for the end of the report (my Win8 device doesn't has this kind
of problem):

With the following hid usages:
I -> contact Id
T -> tip switch
X, Y -> X, Y
S -> scan time
C -> contact count

a friendly device would report:

I:1 T:1 X:125 X:130 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:0 C:01
I:1 T:1 X:130 X:135 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:1 C:01
I:1 T:1 X:135 X:140 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:2 C:01
I:1 T:1 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:3 C:01
I:1 T:0 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:4 C:01

*but*, I've already seen win 7 devices, that do send:

I:0 T:1 X:125 X:130 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:0 C:01
I:0 T:1 X:130 X:135 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:1 C:01
I:0 T:1 X:135 X:140 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:2 C:01
I:0 T:1 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:3 C:01
I:0 T:0 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:4 C:01

The difference lies in the first bit, contact id is 0.

So, the quirk always valid is not sufficient because the second touch
in the frame will override the values of the first (the valid one).

As Microsoft says that "the device must report the last known position
of the contact and then deliver the “UP” state of the contact", so we
can safely discard the second touch because X and Y do not match the
current state of the valid touch.

Then, as exposed in the "How to Design and Test Multitouch Hardware
Solutions for Windows 8" document here:
http://msdn.microsoft.com/en-us/library/windows/hardware/hh872968.aspx
when the device attempt the certification, if the "up" is not valid,
the error "Last move location different" raises, which, I hope will
prevent the device to get the certification.

I hope it is clearer now.

>
> I am asking because this looks more like a device quirk than anything
> else.

and yes, it looks like a quirk, we could make the "Last move location
different" presented like a quirk, but it is only followed by win 8
devices (or it is by luck).

Cheers,
Benjamin


>
> Thanks,
> Henrik
