Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0HNAy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:54:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41062 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab0HNAy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=DpB3UKSNAMySm2z2InjMKOPlCdzeAfcXlb3rR/P64+SAsZF2DfQOt7NciqTJEwluUF
         wmNhFgKYwKSxIdMKGQXlOb9z0teLyHtXK/h/bDrb3W2YRP0qXVxdiZQrkP8rkSo/GqCK
         Dhc08U4MLeWwNBBu1M3qYXpv1//ng829SudNQ=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
Date: Fri, 13 Aug 2010 17:54:49 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.33.6-147.2.4.fc13.x86_64; KDE/4.4.5; x86_64; ; )
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org> <20100813024912.GA2661@core.coreip.homeip.net> <4C65BF99.9030601@codeaurora.org>
In-Reply-To: <4C65BF99.9030601@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008131754.49488.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 13, 2010 02:56:41 pm Neil Leeder wrote:
> On 8/12/2010 10:49 PM, Dmitry Torokhov wrote:
> > On Thu, Aug 12, 2010 at 01:58:18PM -0400, Neil Leeder wrote:
> > Actually, since this is not a new touchpad but simply a PS/2 interface
> > it should be implemented as a serio driver, not input device driver.
> 
> Dmitri,
> 
> Thanks for supplying that serio driver. I just have a couple of questions.
> 
> Even though the interface on the wpce775x EC happens to be a PS/2
> interface, this is completely hidden by the firmware on that device. To
> the linux driver it looks like a dedicated i2c connection directly to
> the touchpad. You can't substitute any other device on that PS/2
> interface without rewriting the firmware in the EC - it's not a generic
> interface.  A manufacturer could even move the touchpad from the PS/2
> interface to say GPIOs, re-write the firmware and the linux driver
> couldn't tell the difference.

Hmm, according to the following diagram from  Nuvoton trhe chip does in
fact has a distinct PS/2 interface (3 of them actually):

http://www.nuvoton.com/NuvotonMOSS/Community/ProductInfo.aspx?tp_GUID=d2a1e761-c93d-4bf0-b292-acb80b38cfaf

Also it is not a simple coincidence that to enable device you send 0xf4
to it (which is PSMOUSE_CMD_ENABLE - standard PS/2 command). This tends
to suggest that interface is not actually hidden and that the device
(touchpad) could be replaced with other kinds of devices.

Anyway, please try the driver (you  may need to hardcode the IRQ trigger
type for now) and see if psmouse is able to talk to the touchpad. If it
is then serio is the proper solution.

> Does that change the rationale for using a
> serio driver?
> 
> If the request to use a serio driver is still valid, then it seems that
> the workqueue from the interrupt handler sends each byte of data
> received over i2c in a separate serio_interrupt() call to the touchpad
> driver. Touchpad data comes in 3-byte packets, so the touchpad driver
> will have to re-assemble the packet from 3 separate interrupts. Is that
> the intended use?

Yes, serio ports are byte-oriented devices. psmouse and atkbd drivers should
be able to work with such data.

Thanks.

-- 
Dmitry
