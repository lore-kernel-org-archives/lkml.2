Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0IBS2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:28:42 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:44392 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0IBS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:28:40 -0400
MIME-Version: 1.0
Date: Thu, 02 Sep 2010 13:28:39 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: <tom.leiming@gmail.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Felipe Balbi <felipe.balbi@nokia.com>, Anand Gadiyar <gadiyar@ti.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] USB: otg: twl4030: fix phy initialization
In-Reply-To: <1283443098-15262-1-git-send-email-tom.leiming@gmail.com>
References: <1283443098-15262-1-git-send-email-tom.leiming@gmail.com>
Message-ID: <ee6a42fe148f72518d475ff3838fc32a@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu,  2 Sep 2010 23:58:18 +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> Commit 461c317705eca5cac09a360f488715927fd0a927(into 2.6.36-v3)
> is put forward to power down phy if no usb cable is connected,
> but does introduce the two issues below:
> 
> 1), phy is not into work state if usb cable is connected
> with PC during poweron, so musb device mode is not usable
> in such case, follows the reasons:

I'm pretty sure I verified both cases.

> 	-twl4030_phy_resume is not called, so
> 		regulators are not enabled
> 		i2c access are not enabled
> 		usb mode not configurated
> 
> 2), The kernel warings[1] of regulators 'unbalanced disables'
> is caused if poweron without usb cable connected
> with PC or b-device.
> 
> This patch fixes the two issues above:
> 	-power down phy only if no usb cable is connected with PC
> and b-device
> 	-do phy initialization(via __twl4030_phy_resume) if usb cable
> is connected with PC(vbus event) or another b-device(ID event) in
> twl4030_usb_probe.
> 
> This patch is verified OK on Beagle board either connected with
> usb cable or not when poweron.

I kinda doubt it, would have to test it myself, but I'm without
enough gear to test it again.

> [1]. warnings of 'unbalanced disables' of regulators.
> [root@OMAP3EVM /]# dmesg
> ------------[ cut here ]------------
> WARNING: at drivers/regulator/core.c:1357
_regulator_disable+0x38/0x128()

this should not have been caused by that patch, though.


> Cc: Felipe Balbi <felipe.balbi@nokia.com>

this email doesn't exist anymore... I'm yet to subscribe the new one,
for now keep this one in Cc, sorry for that.

> diff --git a/drivers/usb/otg/twl4030-usb.c
b/drivers/usb/otg/twl4030-usb.c
> index 05aaac1..df6381f 100644
> --- a/drivers/usb/otg/twl4030-usb.c
> +++ b/drivers/usb/otg/twl4030-usb.c
> @@ -347,11 +347,22 @@ static void twl4030_i2c_access(struct twl4030_usb
> *twl, int on)
>  	}
>  }
>  
> -static void twl4030_phy_power(struct twl4030_usb *twl, int on)
> +static void __twl4030_phy_power(struct twl4030_usb *twl, int on)
>  {
> +	u8 old_pwr = twl4030_usb_read(twl, PHY_PWR_CTRL);
>  	u8 pwr;
>  
> -	pwr = twl4030_usb_read(twl, PHY_PWR_CTRL);
> +	if (on)
> +		pwr = old_pwr & ~PHY_PWR_PHYPWD;
> +	else
> +		pwr = old_pwr | PHY_PWR_PHYPWD;
> +
> +	if (pwr != old_pwr)
> +		WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);

writing 1 if register is one won't cause any problems, you're just
wasting a variable.

> +static void twl4030_phy_power(struct twl4030_usb *twl, int on)
> +{
>  	if (on) {
>  		regulator_enable(twl->usb3v1);
>  		regulator_enable(twl->usb1v8);
> @@ -365,15 +376,13 @@ static void twl4030_phy_power(struct twl4030_usb
> *twl, int on)
>  		twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0,
>  							VUSB_DEDICATED2);
>  		regulator_enable(twl->usb1v5);
> -		pwr &= ~PHY_PWR_PHYPWD;
> -		WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
> +		__twl4030_phy_power(twl, 1);
>  		twl4030_usb_write(twl, PHY_CLK_CTRL,
>  				  twl4030_usb_read(twl, PHY_CLK_CTRL) |
>  					(PHY_CLK_CTRL_CLOCKGATING_EN |
>  						PHY_CLK_CTRL_CLK32K_EN));
>  	} else  {
> -		pwr |= PHY_PWR_PHYPWD;
> -		WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
> +		__twl4030_phy_power(twl, 0);
>  		regulator_disable(twl->usb1v5);
>  		regulator_disable(twl->usb1v8);
>  		regulator_disable(twl->usb3v1);
> @@ -387,19 +396,25 @@ static void twl4030_phy_suspend(struct twl4030_usb
> *twl, int controller_off)
>  
>  	twl4030_phy_power(twl, 0);
>  	twl->asleep = 1;
> +	dev_dbg(twl->dev, "%s\n", __func__);

this is noise.

>  }
>  
> -static void twl4030_phy_resume(struct twl4030_usb *twl)
> +static void __twl4030_phy_resume(struct twl4030_usb *twl)
>  {
> -	if (!twl->asleep)
> -		return;
> -
>  	twl4030_phy_power(twl, 1);
>  	twl4030_i2c_access(twl, 1);
>  	twl4030_usb_set_mode(twl, twl->usb_mode);
>  	if (twl->usb_mode == T2_USB_MODE_ULPI)
>  		twl4030_i2c_access(twl, 0);
> +}
> +
> +static void twl4030_phy_resume(struct twl4030_usb *twl)
> +{
> +	if (!twl->asleep)
> +		return;
> +	__twl4030_phy_resume(twl);
>  	twl->asleep = 0;
> +	dev_dbg(twl->dev, "%s\n", __func__);

this is noise.

> @@ -502,6 +517,26 @@ static irqreturn_t twl4030_usb_irq(int irq, void
> *_twl)
>  	return IRQ_HANDLED;
>  }
>  
> +static void twl4030_usb_phy_init(struct twl4030_usb *twl)
> +{
> +	int status;
> +
> +	status = twl4030_usb_linkstat(twl);
> +	if (status >= 0) {
> +		if (status == USB_EVENT_NONE) {
> +			__twl4030_phy_power(twl, 0);
> +			twl->asleep = 1;
> +		} else {
> +			__twl4030_phy_resume(twl);

this might break people who are using charger detection, although I
would have to revisit some code to be sure.

> +			twl->asleep = 0;
> +		}
> +
> +		blocking_notifier_call_chain(&twl->otg.notifier, status,
> +				twl->otg.gadget);
> +	}
> +	sysfs_notify(&twl->dev->kobj, NULL, "vbus");

thís should only be called from IRQ handler and is duplicating
code.

> @@ -550,7 +585,6 @@ static int __devinit twl4030_usb_probe(struct
> platform_device *pdev)
>  	struct twl4030_usb_data *pdata = pdev->dev.platform_data;
>  	struct twl4030_usb	*twl;
>  	int			status, err;
> -	u8			pwr;
>  
>  	if (!pdata) {
>  		dev_dbg(&pdev->dev, "platform_data not available\n");
> @@ -569,10 +603,7 @@ static int __devinit twl4030_usb_probe(struct
> platform_device *pdev)
>  	twl->otg.set_peripheral	= twl4030_set_peripheral;
>  	twl->otg.set_suspend	= twl4030_set_suspend;
>  	twl->usb_mode		= pdata->usb_mode;
> -
> -	pwr = twl4030_usb_read(twl, PHY_PWR_CTRL);
> -
> -	twl->asleep		= (pwr & PHY_PWR_PHYPWD);
> +	twl->asleep = 1;

and now you're lying to the driver again. What happens if
bootloader has put transceiver to sleep ??

> @@ -610,15 +641,10 @@ static int __devinit twl4030_usb_probe(struct
> platform_device *pdev)
>  		return status;
>  	}
>  
> -	/* The IRQ handler just handles changes from the previous states
> -	 * of the ID and VBUS pins ... in probe() we must initialize that
> -	 * previous state.  The easy way:  fake an IRQ.
> -	 *
> -	 * REVISIT:  a real IRQ might have happened already, if PREEMPT is
> -	 * enabled.  Else the IRQ may not yet be configured or enabled,
> -	 * because of scheduling delays.
> +	/* Power down phy or make it work according to
> +	 * current link state.

if you're changing the comment you might as well fix the comment style.

>  	 */
> -	twl4030_usb_irq(twl->irq, twl);
> +	twl4030_usb_phy_init(twl);

now I see, this doesn't care about that flag, so why even setting
it above ??

-- 
balbi
