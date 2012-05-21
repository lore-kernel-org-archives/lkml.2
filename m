Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2EULiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:38:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61615 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2EULit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:38:49 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.15.47]
In-Reply-To: <CAK=WgbY8RpOfZT5qNtFKOHoE5TD9s7JeqGvXadaXoZ6a7m0r4Q@mail.gmail.com>
References: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYisX2A-DHZy6-AhFFTR3QuxJ0OcVaz+JcpzJOwxT3eWA@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C10579232F20847B@EXDCVYMBSTM005.EQ1STM.local> <CAK=WgbY8RpOfZT5qNtFKOHoE5TD9s7JeqGvXadaXoZ6a7m0r4Q@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 21 May 2012 14:38:28 +0300
Message-ID: <CAK=WgbaUuCNS_cuk5-VNBXUT+op5m_BxfnwNoT=CtE86zPLt+A@mail.gmail.com>
Subject: Re: Remoteproc adaptations for ST-Ericsson modems
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 6:44 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> It sounds like we may have a race there

Can you please check if the below helps ? this will also protects
against premature invocation of rproc_get_by_name().

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remotepro
index 40e2b2d..3d93d9c 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1139,6 +1139,9 @@ int rproc_boot(struct rproc *rproc)
                return -EINVAL;
        }

+       /* if asynchronoush fw loading is underway, wait */
+       wait_for_completion(&rproc->firmware_loading_complete);
+
        dev = rproc->dev;

        ret = mutex_lock_interruptible(&rproc->lock);
