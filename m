Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0GZWdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:33:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab0GZWdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:33:43 -0400
Date: Mon, 26 Jul 2010 15:32:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jon Povey <jon.povey@racelogic.co.uk>
Subject: Re: [PATCH] gpio: remove spurious gpio_unexport debug error.
Message-Id: <20100726153236.ead96c88.akpm@linux-foundation.org>
In-Reply-To: <20100723045807.GA14875@pengutronix.de>
References: <1279832758-25442-1-git-send-email-gbean@codeaurora.org>
	<20100723045807.GA14875@pengutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 06:58:07 +0200
Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:

> Hello,
> 
> On Thu, Jul 22, 2010 at 02:05:58PM -0700, Gregory Bean wrote:
> > Make gpio_unexport generate success instead of an -EINVAL
> > if asked to unexport a line which is not exported, because
> > the only result of that condition is a pr_debug
> > which complains of what is really a harmless no-op:
> > when an unexported gpio is unexported again, nothing happens.
> > That's not a failure, just a trivial border case.
> > Since gpio_free calls gpio_unexport unconditionally
> > and exported gpio lines are uncommon, most calls to
> > gpio_free with debug flags enabled generate -EINVAL
> > warnings in the log, causing unnecessary stress.
> I noticed that a few days ago, too.  Just didn't come around to fix it
> myself.
>  
> > Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> Acked-by: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> 

Jon got there first ;)



Subject: gpio: fix spurious printk when freeing a gpio


From: Jon Povey <jon.povey@racelogic.co.uk>

When freeing a gpio that has not been exported, gpio_unexport() prints a
debug message when it should just fall through silently.

Example spurious message:

	gpio_unexport: gpio0 status -22

Signed-off-by: Jon Povey <jon.povey@racelogic.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpio-fix-spurious-printk-when-freeing-a-gpio drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-fix-spurious-printk-when-freeing-a-gpio
+++ a/drivers/gpio/gpiolib.c
@@ -893,10 +893,12 @@ EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_
 void gpio_unexport(unsigned gpio)
 {
 	struct gpio_desc	*desc;
-	int			status = -EINVAL;
+	int			status = 0;
 
-	if (!gpio_is_valid(gpio))
+	if (!gpio_is_valid(gpio)) {
+		status = -EINVAL;
 		goto done;
+	}
 
 	mutex_lock(&sysfs_lock);
 
@@ -911,7 +913,6 @@ void gpio_unexport(unsigned gpio)
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
 			device_unregister(dev);
-			status = 0;
 		} else
 			status = -ENODEV;
 	}
_

