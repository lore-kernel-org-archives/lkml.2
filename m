Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1K2KBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:01:18 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:56256 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab1K2KBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:01:16 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAA2r1E5tg6dK/2dsb2JhbABDqnOBBoFyAQEBAwEBAiQTHCMQCAMOOBQUEQMhE4gFAga3RhKLDASSM4IgiQ2JBg
Date: Tue, 29 Nov 2011 10:56:43 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] watchdog: fix nowayout setting in s3c2410_wdt
Message-ID: <20111129095643.GH23376@infomag.iguana.be>
References: <4ed026d9.TvJLr8ihQ2VtvqPD%marc.vertes@sigfox.com> <20111126102915.GA7517@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111126102915.GA7517@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> > Set nowayout flag in probe function, otherwise option is useless.
> > 
> > Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
> 
> Similar as
> 
> http://www.spinics.net/lists/linux-watchdog/msg00704.html
> 
> which depends on
> 
> http://www.spinics.net/lists/linux-watchdog/msg00703.html
> 
> which has the advantage that it can be used for static initialization.

Hmm, I was more thinking about a wrapper function like the following:

diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 111843f..d8ef9b2 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -53,6 +53,8 @@ struct watchdog_info {
 
 #ifdef __KERNEL__
 
+#include <linux/bitops.h>
+
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 #define WATCHDOG_NOWAYOUT	1
 #else
@@ -122,6 +124,13 @@ struct watchdog_device {
 #define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
 };
 
+/* Use the following function to set the nowayout feature */
+static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
+{
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
+}
+
 /* Use the following functions to manipulate watchdog driver specific data */
 static inline void watchdog_set_drvdata(struct watchdog_device *wdd, void *data)
 {

but: .status = WATCHDOG_NOWAYOUT_INIT_STATUS, is also a nice one to have.

I propose to add both options and to document them in the documentation.
Objections anyone?

Kind regards,
Wim.

