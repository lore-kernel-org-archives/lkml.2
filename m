Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2GBUjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:39:36 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41308 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2GBUje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:39:34 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Thread-Topic: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Thread-Index: AQHNV7W6AEZudwRw/0ypJsN183sp8JcWCWKAgADELICAAB3sAA==
Date: Mon, 2 Jul 2012 20:39:28 +0000
Message-ID: <1341261568.3319.7.camel@dabdike>
References: <20120701172012.078559139@decadent.org.uk>
	 <4FF14957.3040007@redhat.com>
	 <CA+55aFyRTXqSvf9m08gbHCB0WhVF14Y6J2-AiFGiuTStq0Jr6Q@mail.gmail.com>
In-Reply-To: <CA+55aFyRTXqSvf9m08gbHCB0WhVF14Y6J2-AiFGiuTStq0Jr6Q@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [194.186.187.194]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AC73CCCAC89764EBBD7F29EBA180AEA@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q62Ke0Zo011266

On Mon, 2012-07-02 at 11:52 -0700, Linus Torvalds wrote:
> On Mon, Jul 2, 2012 at 12:10 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> >
> > So since 3.2 already tries READ_CAPACITY(10) first, this patch is
> > not needed. It does not harm either, and if the scsi level reporting
> > change ever finds its way into 3.2 stable (which it should not
> > IMHO), then this patch will be needed.
> 
> Yeah, it should definitely not make it into stable. In fact, I'd
> rather remove it from mainline too. The whole idea to do
> READ_CAPACITY_16 by default was moronic.
> 
> James? Why does the SCSI subsystem always do these idiotic defaults?
> We *know* that devices are buggy. Sure, USB storage tends to be
> buggier than most, but the whole idea of "let's use the new way of
> reporting that gets almost no testing" is just wrong.

It's not idiotic.  It's, unfortunately, required by the standard to
check for protection capable devices.  It's been this way for three
years or so.  Martin Petersen did extensive testing of devices when we
changed it and doing RC16 first is hedged around by claiming support not
only for SCSI_3 but also for SBC_2 in your INQUIRY data.

The problem seems to be that when all the testing was done, USB was
still always returning SCSI_2 in the inquiry data, but this got changed
to allow pass through of the actual vendor information.

> I don't think the USB layer should have needed to work around this. I
> don't think there should be a "try_10b" flag at all. I think the SCSI
> code should just *never* do the 16b version unless it has done the 10b
> version first and determined that the size doesn't fit.

If we did that, we'd regress on all the enterprise class drives with DIF
and DIX.

> And the code already had that logic got the read_10b case. The whole
> logic to do 16b by default was crap. It *used* to at least only do it
> for disks that were marked as having "protection", now it wants to do
> it for anything that should be able to handle it. Which is bogus. The
> whole "let's assume devices get it right" mindset is broken.
> 
> The mindset should be "let's assume devices are buggy, and be careful".

It still is, that's why we did extensive testing three years ago before
changing it.

If you have a solution that doesn't break all the enterprise devices but
works better for USB, I'm listening.  I think the best thing might be to
whitelist the scsi revision pass through in USB, so only the UAS devices
which really, really claim to know what they're doing advertise advanced
features.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
