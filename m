Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0L0Lvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 06:51:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37943 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab0L0Lvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 06:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V4xJ4zx7Ak2h3V1FNu4ht5yWNbmjyjta57H/3fmO32NufE+nYB86YXwikJGv8aNciR
         n265/4tRSBhVVgVm9nKF1wmwEsL1EUEMHaWr3BwCZHVS+ae7QKM7XbfrxZItfDtBRFlg
         CSsDrXRbhbzcqyueKr4FrRgynBg9GI/yEu7Yg=
MIME-Version: 1.0
In-Reply-To: <41EFD7A46E18724CAB128DAD00733480193D2AE61C@shsmsx502.ccr.corp.intel.com>
References: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
	<41EFD7A46E18724CAB128DAD00733480193D2AE61C@shsmsx502.ccr.corp.intel.com>
Date: Mon, 27 Dec 2010 12:51:32 +0100
Message-ID: <AANLkTinYWODS785AefQ7hV+urPkAn1+En-fZEaFQygLG@mail.gmail.com>
Subject: Re: [RFC] sdhci: use ios->clock to know when sdhci is idle
From: Pierre Tardy <tardyp@gmail.com>
To: "Yuan, Hang" <hang.yuan@intel.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Gao, Yunpeng" <yunpeng.gao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 8:02 AM, Yuan, Hang <hang.yuan@intel.com> wrote:
> Just have a question why not let sdio card driver call pm_runtime_get/put instead of host
> controller driver itself?
Because sdio card maintain its own power via runtime_pm, and sdhci
wants to manage its power more independantly, and go suspended more
often than the sdio card. A wifi sdio card would be active when
background scanning for network. During that time, the sdio bus is
completly inactive (for full-mac wifi device), and sdhci can go
suspended during that time.
Lowest SoC platform state can be achieved during that time.

> This patch may suspend host controller without cooperation of sdio card driver. But suspending
> host controller will change controller's registers and then impact sdio card. I think it's
> safer to suspend host controller according to sdio card driver's notification following runtime
> PM framework.
The sdhci must suspend itself without impacting the sdio card.

> Another question is why to call pm_runtime_get/put when ios-clock changes? Is it based on
> Linus Walleij's aggressive clock gating framework patch? Linus' patch doesn't gate SDIO cards.
runtime_suspend of sdhci should *not* gate the sdio card. It should
only gate the sdhci.
An sdio bus inactive does not mean that the sdio card is inactive.
(think wifi Idle, bluetooth idle, ethernet idle)

We need to suspend the sdhci as soon as the sdio bus is inactive,
which is what clock gating framework is trying to detect. It does not
do usage counting via runtime_pm because it is generic enough to allow
clock gating *and* power gating.

Regards,
Pierre
