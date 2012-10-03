Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2JCQNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:13:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36388 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2JCQNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:13:31 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gabor Juhos <juhosg@openwrt.org>, Hauke Mehrtens <hauke@hauke-m.de>,
        Kelvin Cheung <keguang.zhang@gmail.com>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/25] USB: ehci: allow need_io_watchdog to be passed to ehci-platform driver
Date: Wed, 03 Oct 2012 18:12:29 +0200
Message-ID: <16671283.xyEuvTui2M@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1210031154400.1441-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1210031154400.1441-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2012 12:01:22 Alan Stern wrote:
> On Wed, 3 Oct 2012, Florian Fainelli wrote:
> 
> > And convert all the existing users of ehci-platform to specify a correct
> > need_io_watchdog value.
> 
> IMO (and I realize that not everybody agrees), the patch description 
> should not be considered an extension of the patch title, as though the 
> title were the first sentence and the description the remainder of the 
> same paragraph.  Descriptions should stand on their own and be 
> comprehensible even to somebody who hasn't read the title.
> 
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> > ---
> >  arch/mips/ath79/dev-usb.c             |    2 ++
> >  arch/mips/loongson1/common/platform.c |    1 +
> >  arch/mips/netlogic/xlr/platform.c     |    1 +
> >  drivers/usb/host/bcma-hcd.c           |    1 +
> >  drivers/usb/host/ehci-platform.c      |    1 +
> >  drivers/usb/host/ssb-hcd.c            |    1 +
> >  include/linux/usb/ehci_pdriver.h      |    3 +++
> >  7 files changed, 10 insertions(+)
> 
> More importantly...  Nearly every driver will have need_io_watchdog
> set.  Only a few of them explicitly turn it off.  The approach you're 
> using puts an extra burden on most of the drivers.
> 
> > diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-
platform.c
> > index 764e010..08d5dec 100644
> > --- a/drivers/usb/host/ehci-platform.c
> > +++ b/drivers/usb/host/ehci-platform.c
> > @@ -32,6 +32,7 @@ static int ehci_platform_reset(struct usb_hcd *hcd)
> >  	ehci->has_synopsys_hc_bug = pdata->has_synopsys_hc_bug;
> >  	ehci->big_endian_desc = pdata->big_endian_desc;
> >  	ehci->big_endian_mmio = pdata->big_endian_mmio;
> > +	ehci->need_io_watchdog = pdata->need_io_watchdog;
> 
> > --- a/include/linux/usb/ehci_pdriver.h
> > +++ b/include/linux/usb/ehci_pdriver.h
> > @@ -29,6 +29,8 @@
> >   *			initialization.
> >   * @port_power_off:	set to 1 if the controller needs to be powered down
> >   *			after initialization.
> > + * @need_io_watchdog:	set to 1 if the controller needs the I/O 
watchdog to
> > + *			run.
> 
> Instead, how about adding a no_io_watchdog flag?  Then after 
> ehci-platform.c calls ehci_setup(), it can see whether to turn off 
> ehci->need_io_watchdog.

Sounds good, you are right,  this also greatly reduces the chances to miss one 
user of this "feature".

> 
> This way, most of this patch would become unnecessary.
> 
> Alan Stern
> 
