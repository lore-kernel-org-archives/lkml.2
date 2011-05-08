Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1EHP7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:59:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1EHP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:59:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH][WAS:bcmai, axi] bcma: add Broadcom specific AMBA bus driver
Date: Sun, 8 May 2011 17:59:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        George Kashperko <george@znau.edu.ua>,
        Russell King <rmk@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?utf-8?q?B=C3=BCsch?= <mb@bu3sch.de>,
        Arend van Spriel <arend@broadcom.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com> <201105081647.22091.arnd@arndb.de> <BANLkTimhOCL7O1ERqUKkH_4sgq5xNYJZRg@mail.gmail.com>
In-Reply-To: <BANLkTimhOCL7O1ERqUKkH_4sgq5xNYJZRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105081759.03032.arnd@arndb.de>
X-Provags-ID: V02:K0:RFgEwBxvDSSR1ulS+wEbU+NcvNVXi1D0JoWsnl3+qoS
 eeVRmpKXIvPOSx5vgmVaNNH5xxh2ncJ1uVz4I3uuOk2+qZcs4y
 hzA/4fCIkk2TGtNXD3Rl3AqyRbmaYo141CFKBEMaSMG83sq/W8
 wSvJvgoPD9wf7PycED4O/oV7dy3lBg0HuTvszyW0ZbFQBGzFpm
 LNLZlT94RKSfr/oJVqNXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 May 2011 16:59:55 Rafał Miłecki wrote:
> 2011/5/8 Arnd Bergmann <arnd@arndb.de>:
> >> >> diff --git a/drivers/bcma/TODO b/drivers/bcma/TODO
> >> >> new file mode 100644
> >> >> index 0000000..45eadc9
> >> >> --- /dev/null
> >> >> +++ b/drivers/bcma/TODO
> >> >> @@ -0,0 +1,3 @@
> >> >> +- Interrupts
> >> >> +- Defines for PCI core driver
> >> >> +- Convert bcma_bus->cores into linked list
> >> >
> >> > The last item doesn't make sense to me. Since you are using the regular
> >> > driver model, you can simply iterate over all child devices of any
> >> > dev.
> >>
> >> It's about optimization. Right now bcma_bus->cores is static array, we
> >> probably never will use all entries.
> >
> > Oh, I see. You should probably have neither of them. Instead allocate
> > the devices dynamically as you find them and do a device_register,
> > which will add the device into linked list.
> 
> As I said, and wrote: TODO.

Well, I think getting this part right is essential before the
patch can get merged.

> > Maybe you didn't understand what I said: This should be
> >
> > struct bcma_device {
> >     struct bcma_bus *bus;
> >     struct bcma_device_id id;
> >     struct device dev;
> >     u8 core_index;
> >
> >     u32 addr;
> >     u32 wrap;
> >
> >     void *drvdata;
> > };
> >
> > Here, bcma_device is the device, no need to follow pointers
> > around. It's how all bus_types work, you should just do the same.
> 
> We can not use static "struct device", see Greg's comments in:
> [RFC][PATCH V3] axi: add AXI bus driver
> (not to mention we would have unused "struct device" in ChipCommon's
> and PCI's "struct bcma_device").

Please reread what Greg explained, it's actually the same as what
I said here: Don't make the device static (you already don't),
don't put the device structure as a member in the bus structure
(as discussed above). Make the device a member of bcma_device,
so you get proper reference counting for it, in the way that
Greg explained.

	Arnd
