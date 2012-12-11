Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2LKUvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:51:18 -0500
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:43708 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753389Ab2LKUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:51:17 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3] Enable A20 using KBC for some MSI laptops to fix S3 resume
Date: Tue, 11 Dec 2012 21:50:38 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201210261056.44225.zary@gsystems.sk> <201212112129.13248.linux@rainbow-software.org> <50C7995E.7060301@zytor.com>
In-Reply-To: <50C7995E.7060301@zytor.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212112150.38410.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2012 21:36:46 H. Peter Anvin wrote:
> On 12/11/2012 12:29 PM, Ondrej Zary wrote:
> > Something like this? (It works.)
>
> Something like that.  We need to make sure we send the proper sequence,
> though, or it might break some SMM firmware...

Could you please create proper patch? You're the x86 expert (and I'm not).

I've read that 0xd1 command with 0xdf data is often used to enable A20. But I 
don't know when this must be done or what else needs to be done for the SMM 
to not break.

> > diff --git a/drivers/input/serio/i8042-x86ia64io.h
> > b/drivers/input/serio/i8042-x86ia64io.h index d6cc77a..0807ac7 100644
> > --- a/drivers/input/serio/i8042-x86ia64io.h
> > +++ b/drivers/input/serio/i8042-x86ia64io.h
> > @@ -921,6 +921,7 @@ static int __init i8042_platform_init(void)
> >  	int retval;
> >
> >  #ifdef CONFIG_X86
> > +	u8 a20_on = 0xdf;
> >  	/* Just return if pre-detection shows no i8042 controller exist */
> >  	if (!x86_platform.i8042_detect())
> >  		return -ENODEV;
> > @@ -960,6 +961,13 @@ static int __init i8042_platform_init(void)
> >
> >  	if (dmi_check_system(i8042_dmi_dritek_table))
> >  		i8042_dritek = true;
> > +
> > +	/*
> > +	 * A20 was already enabled during early kernel init. But some buggy
> > +	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
> > +	 * resume from S3. So we do it here and hope that nothing breaks.
> > +	 */
> > +	i8042_command(&a20_on, 0x10d1);
> >  #endif /* CONFIG_X86 */
> >
> >  	return retval;


-- 
Ondrej Zary
