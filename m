Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2CAUif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:38:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab2CAUid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:38:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 8/8] ARM: tegra: HACK: remove set_irq_flags() from driver
Date: Thu, 1 Mar 2012 20:38:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <1330630010-11241-1-git-send-email-alan@signal11.us> <1330630010-11241-9-git-send-email-alan@signal11.us> <74CDBE0F657A3D45AFBB94109FB122FF17BE86173C@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE86173C@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203012038.28062.arnd@arndb.de>
X-Provags-ID: V02:K0:Ix79wlxnicNIYHHKCf78/ghucEIXQ7V+UnmoFBq8gGN
 lLGdgRVnpKI6oVJiLcCcS0fLsHkF+LBbD0POn8KLAfO6kaiFVb
 37TYXXHqfaX8gTshhfFDEqrDyy1lCPm9PT43GYYKtWB9r7ujr6
 j+J2sjCqnJ4LK0HkUNeSmhGhcFJt2cqjDdiclBPJHiamYVXvwt
 ENs4OpiLyMrcR6MtmCxj5zPkHkfDuaVv0JMZgzEe747+vnICX+
 YB+MPZXAGOiiog08ucFC8SL9sH3bEOuO1/uIW85SwROE0UWfAD
 oGt1yupn8y6lESxXMvchbcUEM95l2R6Uyy8BK3YadfH/mflmOG
 em604KYfy9Qduw4romeg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Stephen Warren wrote:
> 
> Alan Ott wrote at Thursday, March 01, 2012 12:27 PM:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The driver should not call set_irq_flags itself, and
> 
> Probably true in this case.
> 
> > cannot do this from a loadable module.
> 
> I hope that's not true; grep'ing the entire of drivers/ shows a bunch
> of drivers calling this function, and many look like they'd be reasonable
> as module.

The drivers that I can see using it are for the most part implementing
irq controllers by themselves, which is different from merely using an
interrupt.

There are three exceptions today:

arnd@klappe2:~/linux-arm$ git grep -l set_irq_flags  drivers/ | xargs grep -L irq_chip
drivers/tty/serial/serial_ks8695.c
drivers/tty/serial/sirfsoc_uart.c
drivers/usb/host/ehci-tegra.c

> From what little I understand of this, any irq_chip is going to call
> that function after setting up any child/cascaded IRQs, and I assume
> that irq_chips can be in modules.

But the function is not exported. I guess if we want to allow
irq_chips in loadable modules, we could export it, but I don't see
how it could ever have worked so far.
 
> > Remove the call for now, which might break the driver
> > but at least lets the kernel link again.
> 
> The driver appears to work fine with this removed. At least, on Tegra20
> Harmony, I was able to modprobe ehci-hcd and then use the USB Ethernet
> controller for DHCP and SSH.

Ok, maybe it was the right fix after all then and it just needs a proper
change description ;-)

	Arnd
