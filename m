Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2EMSOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:14:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48451 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab2EMSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:14:16 -0400
Date: Sun, 13 May 2012 20:14:09 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: otg: twl4030-usb: Don't power down phy when it
 is in-use by charger.
Message-ID: <20120513181409.GB2641@andi>
Mail-Followup-To: NeilBrown <neilb@suse.de>,
	Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
	Anton Vorontsov <cbou@mail.ru>,
	David Woodhouse <dwmw2@infradead.org>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20120508213518.2844.95446.stgit@notabene.brown>
 <20120508214040.2844.81364.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508214040.2844.81364.stgit@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 09, 2012 at 07:40:40AM +1000, NeilBrown wrote:
> @@ -388,10 +388,16 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
>  					(PHY_CLK_CTRL_CLOCKGATING_EN |
>  						PHY_CLK_CTRL_CLK32K_EN));
>  	} else {
> -		__twl4030_phy_power(twl, 0);
>  		regulator_disable(twl->usb1v5);
>  		regulator_disable(twl->usb1v8);
>  		regulator_disable(twl->usb3v1);
> +		if (!regulator_is_enabled(twl->usb3v1))
> +			/* no-one else is requesting this
> +			 * so it is OK to power-down the
> +			 * phy.  Sometimes a charger might
> +			 * hold the regulator active.
> +			 */
> +			__twl4030_phy_power(twl, 0);
>  	}

Usually a regulator line is shared by more than one device and
regulator_is_enable() returns true if at least one of these
devices is holding the regulator. This means that here the check
will not work if this is your case.

Andi
