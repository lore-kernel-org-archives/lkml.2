Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2EVHtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:49:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54104 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2EVHty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:49:54 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.15.47]
In-Reply-To: <CAJK669bMZ1FKJbG6nh_rpm6EELAPDXQgxzck0JqtJ16TFf-bmA@mail.gmail.com>
References: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYisX2A-DHZy6-AhFFTR3QuxJ0OcVaz+JcpzJOwxT3eWA@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C10579232F20847B@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbY8RpOfZT5qNtFKOHoE5TD9s7JeqGvXadaXoZ6a7m0r4Q@mail.gmail.com>
 <CAK=WgbaUuCNS_cuk5-VNBXUT+op5m_BxfnwNoT=CtE86zPLt+A@mail.gmail.com> <CAJK669bMZ1FKJbG6nh_rpm6EELAPDXQgxzck0JqtJ16TFf-bmA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 22 May 2012 10:49:33 +0300
Message-ID: <CAK=Wgbaj4a86pCTkZ1WCSWUyXA-kx3JY0EjkyWeKMxcEXFws_Q@mail.gmail.com>
Subject: Re: Remoteproc adaptations for ST-Ericsson modems
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 6:21 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
> Sure this works for me. If you like you can add:
> Tested-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Sure, thanks!

> But, are you sure you don't want to do use wait_for_completion_timeout()
> so you don't risk to block the clients if firmware loading fails?

Good point. And if we're at it, I'll also use the _interruptible_ variant, see:

>From 2f2994b0159c400af53f3ec74c79574bb58a84d0 Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 21 May 2012 14:55:47 +0300
Subject: [PATCH 2/3] remoteproc: block premature rproc booting

When an rproc instance is registered, remoteproc asynchronously
loads its firmware in order to tell which vdevs it supports.

Later on those vdevs are registered, and when probed, their drivers
usually trigger powering on of the remote processor.

OTOH, non-standard scenarios might involve early invocation of
rproc_boot even before the asynchronous fw loading has completed.

We're not sure we really want to support those scenarios, but right
now we do (e.g. via rproc_get_by_name), so let's simply fix this race
by blocking those premature rproc_boot() flows until the async fw
loading is completed.

Reported-and-tested-by: Sjur Brandeland <sjur.brandeland@stericsson.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c
b/drivers/remoteproc/remoteproc_core.c
index 40e2b2d..464ea4f 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1141,6 +1141,18 @@ int rproc_boot(struct rproc *rproc)

 	dev = rproc->dev;

+	/*
+	 * if asynchronoush fw loading is underway, wait up to 65 secs
+	 * (just a bit more than the firmware request's timeout)
+	 */
+	ret = wait_for_completion_interruptible_timeout(
+					&rproc->firmware_loading_complete,
+					msecs_to_jiffies(65000));
+	if (ret <= 0) {
+		dev_err(dev, "async fw loading isn't complete: %d\n", ret);
+		return ret ? ret : -ETIMEDOUT;
+	}
+
 	ret = mutex_lock_interruptible(&rproc->lock);
 	if (ret) {
 		dev_err(dev, "can't lock rproc %s: %d\n", rproc->name, ret);
-- 
1.7.5.4
