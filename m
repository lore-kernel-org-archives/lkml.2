Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0JSL2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:28:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49967 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab0JSL2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:28:34 -0400
Date: Tue, 19 Oct 2010 14:28:17 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019112817.GK31170@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
 <1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
 <20101019081855.GI12470@legolas.emea.dhcp.ti.com>
 <AANLkTi=8=M+egdo5o6nyMOaCyMCLaZdwJF3WKFwZnbd4@mail.gmail.com>
 <20101019090149.GC31170@legolas.emea.dhcp.ti.com>
 <AANLkTimCqZsJ6eY2zk0hJNhkYJDPbYnviiZ4gadnf-bB@mail.gmail.com>
 <20101019101229.GG31170@legolas.emea.dhcp.ti.com>
 <AANLkTikmc1DmHZuhySM1gourjETsaXoCvgfqk7p-b6aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTikmc1DmHZuhySM1gourjETsaXoCvgfqk7p-b6aQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 05:52:10AM -0500, Felipe Contreras wrote:
>I see, but is it possible that in a board you have the two? If not,

Yes. N900 is one of them :-) It has twl4030-usb for VBUS/ID (id isn't
used) and isp1707 for data lines. It's insane but it's becoming more and
more common to see a HW with two transceivers.

>there must be a way to find the correct transceiver based on the
>configuration. If yes, then there must be a way to select a sensible
>one by default, rather than not having any.

True, but currently that's not the case. We needed a real usb
transceiver "class" (or something else) where you have something like:

struct usb_xceiv {
	struct list_head	head;
	struct device		dev;
	unsigned		capabilities;
	...
};

then you define a transceiver with:

struct usb_xceiv twl4030_usb {
	.name		= "twl4030-usb",
	.capabilities	= USB_XCEIV_CAP_VBUS
		| USB_XCEIV_CAP_DETECT_CHARGER
		| USB_XCEIV_CAP_DATA
		| USB_XCEIV_CAP_WHATEVER_BOARD_NEEDS,
	...
};

capabilities will also be board-specific in most cases, so you could
bring that from platform_data. Currently there's no such thing and I'm
too busy with musb/ehci/ohci/UDC Class to start that.

BTW, this also means the otg_transceiver is a mis-name as a transceiver
is needed in any connection is isn't TLL (transceiver-less link), so you
have usb transceiver in host-only and gadget-only configurations too.

If nobody starts the usb_xceiv class, I'll do it at some point and while
doing that drivers/usb/otg will be renamed to drivers/usb/xceiv together
with all structures and headers. Drivers/usb/otg will hold real otg
peculiarities.

>This way, for example it would be possible to get rid of some lines in
>a minimal n900_defconfig (used in MeeGo[1]), and eventually hopefully
>get rid of all of them (except CONFIG_SND_OMAP_SOC_RX51=y).

true, it would also allow you to have one binary for all your products
:-) althought not so optimal, it's good to ease development/testing.

-- 
balbi
