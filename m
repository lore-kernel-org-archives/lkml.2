Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2KEJvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:51:47 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36387 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab2KEJvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:51:45 -0500
MIME-Version: 1.0
In-Reply-To: <20121104205459.GA777@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-9-git-send-email-benjamin.tissoires@gmail.com>
	<20121029221905.GA15537@polaris.bitmath.org>
	<CAN+gG=ESZLHneinkc6kdkazRBfsGP70GaBPfV=jLhnTtZMVrKQ@mail.gmail.com>
	<20121031185332.GA1745@polaris.bitmath.org>
	<CAN+gG=E1DOPrxw4PDNVRDf-cPd7qaq5Sbgo2WC5cApTNn8t9Yg@mail.gmail.com>
	<20121104205459.GA777@polaris.bitmath.org>
Date: Mon, 5 Nov 2012 10:51:43 +0100
Message-ID: <CAN+gG=HkrszRt=TMT-A470yMgkc561tj5opSBV--4O0tvxBpzg@mail.gmail.com>
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

On Sun, Nov 4, 2012 at 9:54 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> The goal of this patch is to implement in a reliable way Win 8
>> multitouch protocol (to avoid quirking many devices). Thanks to the
>> precision they made in the specification, I think it is feasible:
>> they add the dynamic part that were missing in Win 7 spec:
>> """
>> When sending data in hybrid or parallel mode, a contact that is
>> delivered in one report must be delivered in all subsequent reports
>> until it is lifted off the screen. If time is needed to adequate
>> determine if the contact was lifted off the surface, the device must
>> report the last known position of the contact and then deliver the
>> “UP” state of the contact in a subsequent report. Devices should not
>> send a report without the information for that contact while trying to
>> determine its current state.
>> """
>
> The text seems to say that devices are not required to send touch
> state information in a separate frame, but if the device needs time to
> determine the touch state, the touch properties should stay the same
> during that time.

Yes and no:
- yes, if the device needs time to determine the "up" state, it should
send at every frame the last known properties.
- no, I never said that the information should be split in separate
frames: I think you are confused by the serial protocol. I'm talking
here about the parallel or the hybrid one.

>
>> Thus, the quirk ALWAYS_VALID fits very well with win 8 devices (the
>> device has to send the touch until it is lifted and out of range, and
>> the device must send the 'up' state).
>
> One could simply add another quirk which fits the win8 case exactly
> instead. No need to change the existing one.

I never changed the existing one. The quirk ALWAYS_VALID means that
whatever the device sends, the information are valid. The fact is that
the serial protocol can be handled with this quirk (otherwise, we
would have called this quirk SERIAL, and not ALWAYS_VALID). So the Win
8 case doesn't need a new quirk, the ALWAYS_VALID fits.

>
>> The problem lies that some devices may reuse contact id 0 within the
>> frame for the end of the report (my Win8 device doesn't has this kind
>> of problem):
>>
>> With the following hid usages:
>> I -> contact Id
>> T -> tip switch
>> X, Y -> X, Y
>> S -> scan time
>> C -> contact count
>>
>> a friendly device would report:
>>
>> I:1 T:1 X:125 X:130 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:0 C:01
>> I:1 T:1 X:130 X:135 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:1 C:01
>> I:1 T:1 X:135 X:140 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:2 C:01
>> I:1 T:1 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:3 C:01
>> I:1 T:0 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:4 C:01
>>
>> *but*, I've already seen win 7 devices, that do send:
>>
>> I:0 T:1 X:125 X:130 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:0 C:01
>> I:0 T:1 X:130 X:135 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:1 C:01
>> I:0 T:1 X:135 X:140 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:2 C:01
>> I:0 T:1 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:3 C:01
>> I:0 T:0 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:4 C:01
>
> I see, more brain-damaged usage. :-) Still, there seems to be a
> simpler way to distinguish this case: if there are more than one touch
> with the same id in the frame, use the one with T=1.

sigh... the problem in your sentence is there: "with the same id in the frame".
This forces me to introduce the function input_mt_is_used in mt.h...

>
>> The difference lies in the first bit, contact id is 0.
>>
>> So, the quirk always valid is not sufficient because the second touch
>> in the frame will override the values of the first (the valid one).
>>
>> As Microsoft says that "the device must report the last known position
>> of the contact and then deliver the “UP” state of the contact", so we
>> can safely discard the second touch because X and Y do not match the
>> current state of the valid touch.
>>
>> Then, as exposed in the "How to Design and Test Multitouch Hardware
>> Solutions for Windows 8" document here:
>> http://msdn.microsoft.com/en-us/library/windows/hardware/hh872968.aspx
>> when the device attempt the certification, if the "up" is not valid,
>> the error "Last move location different" raises, which, I hope will
>> prevent the device to get the certification.
>
> I think it would be too fragile to rely on this assumption. Hopefully
> the suggestion above will work equally well.

I'm not sure it is fragile, because otherwise that means that the
certification is worthless.
But anyway, your solution is valid too, so I'll implement it.

Cheers,
Benjamin

>
> Thanks,
> Henrik
