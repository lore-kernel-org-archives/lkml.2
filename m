Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2JRFbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:31:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60669 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2JRFbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:31:17 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Hunter, Jon" <jon-hunter@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: discrepancy while save and restore of debounce registers
Thread-Topic: discrepancy while save and restore of debounce registers
Thread-Index: Ac2sLoK1QcZgBYyrRUCfh4cWp+znkwAT3A2AABu2CfA=
Date: Thu, 18 Oct 2012 05:31:11 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EAAA89B@DBDE01.ent.ti.com>
References: <1BAFE6F6C881BF42822005164F1491C33EAA9A7C@DBDE01.ent.ti.com>
 <507F1F21.8040206@ti.com>
In-Reply-To: <507F1F21.8040206@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {F2C0EDA5-58C2-4A8C-873E-D0D7CA435328}
x-cr-hashedpuzzle: +IQ= EMCO GTl+ NC8V Qrfe Zbbz fPA9 f3vU jfuq k+xB tins
 vCr3 w0tU 7Jpb AA1uUQ==
 ABI9Eg==;5;ZwByAGEAbgB0AC4AbABpAGsAZQBsAHkAQABzAGUAYwByAGUAdABsAGEAYgAuAGMAYQA7AGwAaQBuAHUAeAAtAGEAcgBtAC0AawBlAHIAbgBlAGwAQABsAGkAcwB0AHMALgBpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG8AbQBhAHAAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAbwBuAHkAQABhAHQAbwBtAGkAZABlAC4AYwBvAG0A;Sosha1_v1;7;{F2C0EDA5-58C2-4A8C-873E-D0D7CA435328};ZwB1AHIAdQByAGEAagBhAC4AaABlAGIAYgBhAHIAQAB0AGkALgBjAG8AbQA=;Thu,
 18 Oct 2012 05:30:51
 GMT;UgBFADoAIABkAGkAcwBjAHIAZQBwAGEAbgBjAHkAIAB3AGgAaQBsAGUAIABzAGEAdgBlACAAYQBuAGQAIAByAGUAcwB0AG8AcgBlACAAbwBmACAAZABlAGIAbwB1AG4AYwBlACAAcgBlAGcAaQBzAHQAZQByAHMA
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon,

On Thu, Oct 18, 2012 at 02:42:01, Hunter, Jon wrote:
> Hi Gururaja,
> 
> On 10/17/2012 01:13 AM, Hebbar, Gururaja wrote:
> > Hi,
> > 
> > I came across a peculiar issue while updating GPIO debounce registers on
> > OMAP platform.
> > 
> > According to mainline commit ae547354a8ed59f19b57f7e1de9c7816edfc3537
> > 
> > gpio/omap: save and restore debounce registers
> > 
> > GPIO debounce registers need to be saved and restored for proper functioning
> > of driver.
> > 
> > ...
> > @@ -1363,6 +1369,12 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
> >         __raw_writel(bank->context.fallingdetect,
> >                                 bank->base + bank->regs->fallingdetect);
> >         __raw_writel(bank->context.dataout, bank->base + bank->regs->dataout);
> > +       if (bank->dbck_enable_mask) {
> > +               __raw_writel(bank->context.debounce, bank->base +
> > +                                       bank->regs->debounce);
> > +               __raw_writel(bank->context.debounce_en,
> > +                                       bank->base + bank->regs->debounce_en);
> > +       }
> >  }
> > 
> > 
> > Due to copy/paste of this commit into my local tree, I missed the check for 
> > bank->dbck_enable_mask, and directly restored the saved value from context.
> > 
> > After this, I saw random crashes when accessing different registers (sometimes
> > its OE register and sometime its DATAOUT register). 
> > 
> > These crashes were seen across 2nd and subsequent suspend/resume.
> > 
> > My doubt/questions are
> > 1. Why should debounce registers be updated only when it's accessed previously?
> 
> If debounce is not being used by any of the gpios, then there is no need
> to restore them as there are no bits set. So this makes sense and saves
> a couple register writes.

What I want to know is that other than saving register writes, is there any
other important stuff that specifies this requirement.

> 
> > 2. What is the relation between updating debounce registers and crash seen on
> > others registers? 
> 
> This I am not sure about. I gave this a quick try on my omap3430 beagle
> board, but I did not see any side-effects from doing this. However, if
> you are always restoring the debounce context regardless of whether
> debounce is being used, then you could be writing bad values to the
> debounce registers as the context variables bank->context.debouce and
> bank->context.debouce_en may not initialised. So that is bad. However,
> that said I am still not sure how this could cause a crash.
> 
> Can you share more details on ...

Sorry for missing below details in first post.

> 1. The OMAP platform you are using?

I was trying this on TI AM335x platform (repo below). On AM335x EVM board

http://arago-project.org/git/projects/?p=linux-am33x.git;a=shortlog;
h=refs/heads/v3.2-staging

> 2. What linux distro/environment you are using?

Arago AM335x PSP release (linux 3.2 + am335x patch-set)

> 3. If there are any specific steps to reproduce this 100% of the time?

On top of this tree, try suspend/resume using "echo mem > /syspower/state"

> 
> Cheers
> Jon
> 


Regards, 
Gururaja
