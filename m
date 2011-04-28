Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1D1Je1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:34:27 -0400
Received: from smtp.nokia.com ([147.243.1.47]:31640 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1D1JeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:34:25 -0400
Message-ID: <4DB9348D.7000501@nokia.com>
Date: Thu, 28 Apr 2011 12:34:05 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.18) Gecko/20110320 SeaMonkey/2.0.13
MIME-Version: 1.0
To: "Jokiniemi Kalle (Nokia-SD/Tampere)" <kalle.jokiniemi@nokia.com>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "svarbatov@mm-sol.com" <svarbatov@mm-sol.com>,
        "saaguirre@ti.com" <saaguirre@ti.com>,
        "grosikopulos@mm-sol.com" <grosikopulos@mm-sol.com>,
        "Zutshi Vimarsh (Nokia-SD/Helsinki)" <vimarsh.zutshi@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Regulator state after regulator_get
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
In-Reply-To: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jokiniemi Kalle (Nokia-SD/Tampere) wrote:
> Hello regulator FW and OMAP3 ISP fellows,
> 
> I'm currently optimizing power management for Nokia N900 MeeGo DE release,
> and found an issue with how regulators are handled at boot.
> 
> The N900 uses VAUX2 regulator in OMAP3430 to power the CSIb IO complex
> that is used by the camera. While implementing regulator FW support to
> handle this regulator in the camera driver I noticed a problem with the
> regulator init sequence:
> 
> If the device driver using the regulator does not enable and disable the
> regulator after regulator_get, the regulator is left in the state that it was
> after bootloader. In case of N900 this is a problem as the regulator is left
> on to leak current. Of course there is the option to let regulator FW disable
> all unused regulators, but this will break the N900 functionality, as the
> regulator handling is not in place for many drivers. 
> 
> I found couple of solutions to this:
> 1. reset all regulators that have users (regulator_get is called on them) with
> a regulator_enable/disable cycle within the regulator FW.
> 2. enable/disable the specific vdds_csib regulator in the omap3isp driver
> to reset this one specific regulator to disabled state.
> 
> So, please share comments on which approach is more appropriate to take?
> Or maybe there is option 3?
> 
> Here are example code for the two options (based on .37 kernel, will update
> on top of appropriate tree once right solution is agreed):
> 
> Option1:
> 
> If a consumer device of a regulator gets a regulator, but
> does not enable/disable it during probe, the regulator may
> be left active from boot, even though it is not needed. If
> it were needed it would be enabled by the consumer device.
> 
> So reset the regulator on first regulator_get call to make
> sure that any regulator that has users is not left active
> needlessly.

I'm not an expert in the regulator framework, but I'd think that one
should be able to assume a regulator is in a sane state after boot. The
fact that the regulator is enabled when it has no users should likely be
fixed in the boot loader. Is that an option?

Does the problem exist in other boards beyond N900?

Another alternative to the first option you proposed could be to add a
flags field to regulator_consumer_supply, and use a flag to recognise
regulators which need to be disabled during initialisation. The flag
could be set by using a new macro e.g. REGULATOR_SUPPLY_NASTY() when
defining the regulator.

Just my 0,05 euros. ;-)

Cc Laurent Pinchart.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
