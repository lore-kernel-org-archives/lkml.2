Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2KHKeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:34:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2KHKd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:33:59 -0500
Date: Thu, 8 Nov 2012 11:33:53 +0100
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH] pwm: lpc32xx - Fix the PWM polarity
Message-ID: <20121108113353.4fdbb25c@avionic-0020.adnet.avionic-design.de>
In-Reply-To: <509B80A7.1060700@antcom.de>
References: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de>
	<1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de>
	<509B80A7.1060700@antcom.de>
Organization: Avionic Design
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:DGE5tKOJrn0mzhhXWpj3OS1jFsydrx6BOyn2y+3U/NP
 PMxN0i4cQtd8ew7ayUtOM4l3yuocvT9pchCjS6lksWmgk7S9WV
 GGhnT++BV1ZHaf32+uqQX80SHl9sXi4s9i5pdfmUB64quI57Tl
 VDdIuLPvU1DgoaEjBPl45LeeNsbvXYhH+cvwnO7XaGiNimsZE6
 8WhNAxu4AJnhqlqdQK4TK01qHOPyh2IRqAPB22x1Ji9BvlAxVX
 tOpuRA6Av5e9xB5pymmlreU1s8yc6mGjNmpGpQV56qRpub8zK3
 WgBJ2qJF+MgBOtPGDGc367Dw+xoSRb70DBGQTq/Bv1faKGhcpG
 7BYmKeMyPQ4dmOTuouMQ6GOCKdPNJPyeualGECf2eA46kBbNpt
 utoY2w5d7t+MnEVqPl0jr24KC6qloRgDEM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2012 10:51:35 +0100
Roland Stigge <stigge@antcom.de> wrote:

> On 07/11/12 16:25, Alban Bedel wrote:
> > Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> > ---
> >  drivers/pwm/pwm-lpc32xx.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> > index adb87f0..0dc278d 100644
> > --- a/drivers/pwm/pwm-lpc32xx.c
> > +++ b/drivers/pwm/pwm-lpc32xx.c
> > @@ -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> >  
> >  	c = 256 * duty_ns;
> >  	do_div(c, period_ns);
> > -	duty_cycles = c;
> > +	if (c == 0)
> > +		c = 256;
> > +	if (c > 255)
> > +		c = 255;
> > +	duty_cycles = 256 - c;
> 
> Except for the range check (for the original c > 255), this results in:
> 
> 	duty_cycles = 256 - c
> 
> except for (c == 0) where
> 
> 	duty_cycles = 1

No it lead to duty_cycles = 0

> which actually is
> 
> 	duty_cycles = (256 - c) - 255
> 
> (think with the original c)
> 
> i.e. nearly a polarity inversion in the case of (c == 0).
> 
> Why is the case (c == 0) so special here? Maybe you can document this,
> if it is really intended?

It is intended, the formular for duty value in the register is:

duty = (256 - 256*duty_ns/period_ns) % 256

But the code avoid the modulo by clamping '256*duty_ns/period_ns' to 1-256.

Perhaps something like:

if (c > 255)
	c = 255;
duty_cycles = (256 - c) % 256;

would be easier to understand.

Alban
