Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab2HVQyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:54:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44451 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225Ab2HVQym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:54:42 -0400
MIME-Version: 1.0
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13EA1BDA9@DBDE01.ent.ti.com>
References: <1345617039-27469-1-git-send-email-anilkumar@ti.com>
 <201208220748.39106.arnd@arndb.de> <CAK-9PRBy0PCQ4XAVZzQpWv5rnT8A9f6F=qxT=pJEaioN7RN_5w@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA1B975@DBDE01.ent.ti.com>
 <CAK-9PRBDpxtrxZWL_x9Uz--GMWDN5anyB_fuKtLrvZcLoRR+FQ@mail.gmail.com> <331ABD5ECB02734CA317220B2BBEABC13EA1BDA9@DBDE01.ent.ti.com>
From: Chinmay V S <cvs268@gmail.com>
Date: Wed, 22 Aug 2012 22:24:10 +0530
Message-ID: <CAK-9PRD6FH=5g0SrVcw+81Witpo8zRfvnsmGaePaA4swjHWkSw@mail.gmail.com>
Subject: Re: [PATCH v2] lis3lv02d: Add STMicroelectronics lis331dlh digital accelerometer
To: "AnilKumar, Chimata" <anilkumar@ti.com>, carmine.iascone@st.com
Cc: Arnd Bergmann <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Look at this application note which talks about the outdata values
> for 2G range (page 12/31) http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/APPLICATION_NOTE/CD00215823.pdf

Had been through the application note earlier. The table5 (on page 12)
that you refer to, does NOT contradict either 12/16bit, as in all the
examples the lower 4 bits are zero. So i don't see how one can assume
from these examples that for +/-2G they one should consider 12/16bits.
A nice side-effect of using 12|13|14bits for +/-2|4|8G is that the
values returned by the driver are in mG in all the 3 modes.

> Corresponding to the 4G and 8G I got the details form older
> patches (SHIFT_ADJ_4G and SHIFT_ADJ_8G).
> http://driverdev.linuxdriverproject.org/pipermail/devel/2010-November/009685.html
>
> We can easily interpret number of bits for 4G and 8G from 2G
> information.

Going through the code of this driver i can see what you are talking
about. Depending on the full-scale-range the device is being
configured for, the number of bits used to represent acceleration in
the driver is changed.

Again judging from the code, the driver is always returning
acceleration at a constant accuracy i.e. 1mG in all the 3 modes
(+/-2|4|8G)i.e.
+/-2G is mode means value can be anywhere from +/-2048mG,
(requiring 12bits.)
+/-4G in the range of +/-4096mG, requiring 13bits.
+/-8G i.e. +/-8192mG, requiring 14bits.

Was this done...

a. ...because LIS331DLH's theoretical MAX accuracy is ~1mG
If yes, then using 12bits is fine.

-OR-

b. ...so that the driver will report values at a constant
scale(i.e.mG) regardless of the mode?
If yes, then maybe we could consider using the additional bits to
obtain the maximum possible accuracy the LIS331DLH supports rather
than choosing to discard the LSBits.

(Can anyone please confirm the above?)

Going through the datasheet of LIS331DLH,
http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LITERATURE/DATASHEET/CD00213470.pdf
we see that accuracy/sensitivity of the device as per Table 2.1
(page9/38) is 1|2|4mG in +/-2|4|8Gmodes respectively. It is mentioned
in the footnotes that the readings were taken at 12bit resolution(a
point in favour of using 12bits ourselves). But its is still NOT clear
whether the accuracy/sensitivity are the LIS331DLH's physical limits
or whether they stem from the fact that ONLY 12bits were used during
the rating tests.

I hope i'm not being too much of a PIA. My sole intention is to see
that we do NOT unintentionally lose track of the device capabilities
in the midst of all these driver iterations. Thank you for your
patience.

PS: One more nitpick
> LIS3331DLH spec says 1LSBs(...)
LIS3331DLH --> LIS331DLH

-- 
regards
ChinmayVS
