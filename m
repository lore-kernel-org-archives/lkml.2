Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2KDUtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 15:49:41 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:51142 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab2KDUtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 15:49:40 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqR7ANjTllBV5h1yPGdsb2JhbABEhS5pvBcCgQcZAQEBAR8ZDSeCHgEBBAEjBAsBIyMFCwgDGgImAgIUJQoGARMuA4dmCgemapFdFIEMjCiDYjJhA5V6gR2EXo06gVoH
X-IronPort-AV: E=Sophos;i="4.80,711,1344204000"; 
   d="scan'208";a="219263409"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 4 Nov 2012 21:54:59 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/11] HID: hid-multitouch: fix Win 8 protocol
Message-ID: <20121104205459.GA777@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-9-git-send-email-benjamin.tissoires@gmail.com>
 <20121029221905.GA15537@polaris.bitmath.org>
 <CAN+gG=ESZLHneinkc6kdkazRBfsGP70GaBPfV=jLhnTtZMVrKQ@mail.gmail.com>
 <20121031185332.GA1745@polaris.bitmath.org>
 <CAN+gG=E1DOPrxw4PDNVRDf-cPd7qaq5Sbgo2WC5cApTNn8t9Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+gG=E1DOPrxw4PDNVRDf-cPd7qaq5Sbgo2WC5cApTNn8t9Yg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> The goal of this patch is to implement in a reliable way Win 8
> multitouch protocol (to avoid quirking many devices). Thanks to the
> precision they made in the specification, I think it is feasible:
> they add the dynamic part that were missing in Win 7 spec:
> """
> When sending data in hybrid or parallel mode, a contact that is
> delivered in one report must be delivered in all subsequent reports
> until it is lifted off the screen. If time is needed to adequate
> determine if the contact was lifted off the surface, the device must
> report the last known position of the contact and then deliver the
> “UP” state of the contact in a subsequent report. Devices should not
> send a report without the information for that contact while trying to
> determine its current state.
> """

The text seems to say that devices are not required to send touch
state information in a separate frame, but if the device needs time to
determine the touch state, the touch properties should stay the same
during that time.

> Thus, the quirk ALWAYS_VALID fits very well with win 8 devices (the
> device has to send the touch until it is lifted and out of range, and
> the device must send the 'up' state).

One could simply add another quirk which fits the win8 case exactly
instead. No need to change the existing one.

> The problem lies that some devices may reuse contact id 0 within the
> frame for the end of the report (my Win8 device doesn't has this kind
> of problem):
> 
> With the following hid usages:
> I -> contact Id
> T -> tip switch
> X, Y -> X, Y
> S -> scan time
> C -> contact count
> 
> a friendly device would report:
> 
> I:1 T:1 X:125 X:130 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:0 C:01
> I:1 T:1 X:130 X:135 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:1 C:01
> I:1 T:1 X:135 X:140 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:2 C:01
> I:1 T:1 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:3 C:01
> I:1 T:0 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:4 C:01
> 
> *but*, I've already seen win 7 devices, that do send:
> 
> I:0 T:1 X:125 X:130 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:0 C:01
> I:0 T:1 X:130 X:135 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:1 C:01
> I:0 T:1 X:135 X:140 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:2 C:01
> I:0 T:1 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:3 C:01
> I:0 T:0 X:140 X:145 Y:750 Y:755 I:0 T:0 X:0 X:0 Y:0 Y:0 S:4 C:01

I see, more brain-damaged usage. :-) Still, there seems to be a
simpler way to distinguish this case: if there are more than one touch
with the same id in the frame, use the one with T=1.

> The difference lies in the first bit, contact id is 0.
> 
> So, the quirk always valid is not sufficient because the second touch
> in the frame will override the values of the first (the valid one).
> 
> As Microsoft says that "the device must report the last known position
> of the contact and then deliver the “UP” state of the contact", so we
> can safely discard the second touch because X and Y do not match the
> current state of the valid touch.
> 
> Then, as exposed in the "How to Design and Test Multitouch Hardware
> Solutions for Windows 8" document here:
> http://msdn.microsoft.com/en-us/library/windows/hardware/hh872968.aspx
> when the device attempt the certification, if the "up" is not valid,
> the error "Last move location different" raises, which, I hope will
> prevent the device to get the certification.

I think it would be too fragile to rely on this assumption. Hopefully
the suggestion above will work equally well.

Thanks,
Henrik
