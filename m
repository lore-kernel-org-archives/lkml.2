Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2JVWaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:30:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2JVWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:30:13 -0400
Date: Mon, 22 Oct 2012 15:30:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] lp855x_bl: use generic PWM functions
Message-Id: <20121022153012.253a6954.akpm@linux-foundation.org>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F641791BB@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F6417916D@DQHE02.ent.ti.com>
	<20121019082107.GA20659@avionic-0098.mockup.avionic-design.de>
	<A874F61F95741C4A9BA573A70FE3998F641791BB@DQHE02.ent.ti.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 08:45:14 +0000
"Kim, Milo" <Milo.Kim@ti.com> wrote:

> > Generally this looks good. Obviously you'll need to update any users of
> > this driver as well. It might make sense to include those changes in
> > this patch to avoid interim build failures.
> 
> Thanks for your review.
> So far no usages for this driver in the mainline.
> I've tested it in my own development environment instead.
> 
> > Other than that I have just one smaller comment below.
> > 
> > > +	pwm_config(lp->pwm, duty, period);
> > > +	duty == 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);
> > 
> > This is really ugly and should be written explicitly:
> > 
> > 	if (duty == 0)
> > 		pwm_disable(lp->pwm);
> > 	else
> > 		pwm_enable(lp->pwm);
> 
> Oh, I prefer using '?' to if-sentence because it looks clear to me.
> But if it's difficult to read/understand, I'll fix it.
> I'd like to have others' opinion.
> 

Hey, it's better than

	(*(duty ? pwm_enable : pwm_disable))(lp->pwm);

!


But yes, the original code is unusual and I think most kernel people
would have to stare at it for a bit longer than necessary to see
exactly what it's doing.

--- a/drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -139,7 +139,10 @@ static void lp855x_pwm_ctrl(struct lp855
 	}
 
 	pwm_config(lp->pwm, duty, period);
-	duty == 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);
+	if (duty)
+		pwm_enable(lp->pwm);
+	else
+		pwm_disable(lp->pwm);
 }
 
 static int lp855x_bl_update_status(struct backlight_device *bl)

