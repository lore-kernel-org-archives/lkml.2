Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1DUONA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:13:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57422 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1DUOM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:12:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Arend van Spriel" <arend@broadcom.com>
Subject: Re: [PATCH] drivers: brcmaxi: provide amba axi functionality in separate module
Date: Thu, 21 Apr 2011 16:12:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: zajec5@gmail.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        b43-dev@lists.infradead.org, "George Kashperko" <george@znau.edu.ua>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Andy Botting" <andy@andybotting.com>, "Greg KH" <greg@kroah.com>,
        "Michael Buesch" <m@bues.ch>
References: <1303331669-31293-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1303331669-31293-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201104211612.49805.arnd@arndb.de>
X-Provags-ID: V02:K0:3ri1URJju4IHQasLaOs9/4N2iljLrk6x/03do28qWpm
 lW+WaoR9pzN175a3LgRPCsknMf3wP/8qQPRYNXDVl0FU+bpBYN
 Tc3P0/Pdz4b7/CFMYd3IW/GdmYEQ60UAjSZAGNwpeufsoZWoDW
 dRNdLM1G5BFBdCCcYUXV6h8eYNUrQ6m99ktQC1hdsC3brE5cbv
 vAwNxBG5q2PsC3gvmZyow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 April 2011, Arend van Spriel wrote:
> The open-source community is looking for a library which will detect
> cores in a chip using axi backplane. Another proposal has been
> sent by Rafał Miłecki, which registers detected cores in the linux
> device tree to be claimed by device drivers. This implies cores will
> always provide a system function to the kernel which is indepent from
> other cores and have very loose or no coupling. If this is not true,
> exceptions need to be added in the device registration process. This
> means knowledge of specific devices from specific vendors is sitting
> in a bus driver. Whether the exceptions are rarely or likely is a
> pending question.

Hi Arend,

I have two very general comments about this:

> To feed the discussion this implementation takes a different approach.
> A calling entity (being a pci device driver, or SoC initialization
> sequence) registers a table with core identities and a callback function.
> It then starts the scan and for each detected core with a callback
> function it does the call providing the core information. Apart from
> that it provides some basic operations on the core.
> 
> It has been tested using the brcmsmac driver (in drivers/staging/brcm80211).

The API split between PCI and non-PCI devices appears to be
unhelpful. Can't you abstract the interface so that a user
would apply the exact same interfaces in both cases, and handle
the differences internally?

> +/* Core Codes */
> +#define	NODEV_CORE_ID		0x700	/* Invalid coreid */
> +#define	CC_CORE_ID		0x800	/* chipcommon core */
> +#define	ILINE20_CORE_ID		0x801	/* iline20 core */
> +#define	SRAM_CORE_ID		0x802	/* sram core */
> +#define	SDRAM_CORE_ID		0x803	/* sdram core */
> +#define	PCI_CORE_ID		0x804	/* pci core */
> +#define	MIPS_CORE_ID		0x805	/* mips core */
> +#define	ENET_CORE_ID		0x806	/* enet mac core */
> +#define	CODEC_CORE_ID		0x807	/* v90 codec core */
> +#define	USB_CORE_ID		0x808	/* usb 1.1 host/device core */
> +#define	ADSL_CORE_ID		0x809	/* ADSL core */
> +#define	ILINE100_CORE_ID	0x80a	/* iline100 core */
> +#define	IPSEC_CORE_ID		0x80b	/* ipsec core */
> +#define	UTOPIA_CORE_ID		0x80c	/* utopia core */
> +#define	PCMCIA_CORE_ID		0x80d	/* pcmcia core */
> +#define	SOCRAM_CORE_ID		0x80e	/* internal memory core */
> +#define	MEMC_CORE_ID		0x80f	/* memc sdram core */
> +#define	OFDM_CORE_ID		0x810	/* OFDM phy core */
> ...

This list to me is a strong hint that the cores behind the AXI bridge
should normally be actual devices in Linux, i.e. the approach that
Rafał suggested.  The vast majority of these is something that in Linux
would be operated by a device driver. The exceptions that I can see
are CPU cores and bus bridges, both of which we typically also represent
as devices in the flattened device tree, even though they typically
don't have a Linux driver attached to them.

	Arnd
