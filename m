Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0LHOv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:51:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0LHOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:51:56 -0500
Date: Wed, 8 Dec 2010 15:50:37 +0100
From: Christian Glindkamp <christian.glindkamp@taskit.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Igor Plyatov <plyatov@gmail.com>, linux@arm.linux.org.uk,
        costa.antonior@gmail.com, linux-kernel@vger.kernel.org,
        Ryan Mallon <ryan@bluewatersys.com>, plagnioj@jcrosoft.com,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] mach-at91: Support for gms board added
Message-ID: <20101208145037.GA16435@taskit.de>
References: <1291732927-9429-1-git-send-email-plyatov@gmail.com>
 <4CFE90CA.9050004@bluewatersys.com>
 <4CFF47A0.8010208@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFF47A0.8010208@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IUKE6No5OZ5822CbMBSfUQOkCo69oii4ZVea7pSDzDO
 /ZCQpW7V0CLPj5/Wc2/uGiDfANsiBJApb5iXbSCb/FKuyI9MS1
 /mxIODivyK4j18fOfRv+DVHGRppnF28PYeHJW/n05s4IDbmkYw
 1m+TFF7t9x1IY6I4f1kKS004WSJQVOFE6gkG99h3DmXTstwdVP
 vR6m5YVdsFXX6LCVvuphw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-08 09:53, Nicolas Ferre wrote:
> Hi Igor,
> 
> Le 07/12/2010 20:53, Ryan Mallon :
> > On 12/08/2010 03:42 AM, Igor Plyatov wrote:
> >> * The gms is a board from GeoSIG Ltd company.
> >>   It is based on the Stamp9G20 module from Taskit company.
> >> * This is a second version of the patch with adjustments according
> >>   to comments from Ryan Mallon.
> >> * This patch made for Linux 2.6.37-rc5.
> 
> First thank you for submitting this board support.
> 
> >> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> >> ---
> 
> [..]
> 
> > Couple more comments below.
> > Looking at this a bit more closely, the Stamp9G20 is a system on module
> > (SoM) board. The MACH_STAMP9G20 option supports the Stamp9G20 on
> > taskits's evaluation board and the MACH_PCONTROL_G20 option supports it
> > on the PControl carrier board. There is a reasonable amount of code
> > replication in each of the board files for the UARTs, NAND, MMC, etc.
> > 
> > Would it be better to have MACH_STAMPG20/board-stamp-9g20.c contain the
> > core support for the Stamp9G20 module and then each of the carrier board
> > files contain only the setup/devices found on the carrier board?
> 
> I have exactly the same feeling as Ryan. We should make sure 
> to factorize as much code as possible for maintenance reasons.
> 
> If you need to distinguish between board features, you can 
> pass information in system_rev as implemented in this 
> board merging commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6e016f19d393fbe4e040bee8155b03b840fa689
> 

I don't think system_rev is such a good idea for carrier boards from
different vendors. Somebody would have to control the assigned numbers.

This is what I would do:
1. Refactor board-stamp9g20.c have three board init functions:
- portuxg20_board_init for PortuxG20 SBC (MACH_PORTUXG20)

- stamp9g20_board_init only containing the functions used on the
  Stamp9G20 alone

- stamp9g20evb_board_init calling stamp9g20_board_init and adding
  functionality of the evaluation board (MACH_STAMP9G20)

2. Modify board-pcontrol-g20.c to use stamp9g20_board_init

This would still duplicate the UART config (there is not much to share,
only the DBGU would be configured on all boards), but share NAND, MMC,
1-wire. Everything else can't be shared as it is carrier board specific.

The gms board would then have to have its own machine number and call
stamp9g20_board_init.

Kind regards,
Christian Glindkamp
