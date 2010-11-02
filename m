Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0KBARP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:17:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51261 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab0KBARN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uqPxloeWHGJcnRjLI/xCBsYwNEteLh2Se7Ocs1qC2FfP8niE1XGyL3lEs/cyF1ZOJ4
         UOL6zY3oVdlbYLsVetUxoiaxu2puzLie8RKKSeL+KrWUz0kczyjZXowesjXzUAwA82ds
         akrOtncOe2dnrh4mUy58+KYvZemFgXVKlJw8s=
MIME-Version: 1.0
In-Reply-To: <20101101234630.GA12106@electric-eye.fr.zoreil.com>
References: <AANLkTimZvwdY8Q+=iGMC2MhPt_Vow38a0SE9g4ij-cRe@mail.gmail.com>
	<20101101234630.GA12106@electric-eye.fr.zoreil.com>
Date: Tue, 2 Nov 2010 00:17:13 +0000
Message-ID: <AANLkTinzQGzsUGgzrhFo8eS1_OcnkVDOXRuc1C=0nMx=@mail.gmail.com>
Subject: Re: [2.6.37-rc1, patch v2] r8169: fix sleeping while holding spinlock...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francois,

On 1 November 2010 23:46, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Daniel J Blueman <daniel.blueman@gmail.com> :
>> Recent changes to the r8169 driver cause it to call
>> device_set_wakeup_enable under spinlock, which may sleep.
>
> The change is fine but the description is misleading : the r8169
> driver has been issuing device_set_wakeup_enable under spinlock since
> october 2008. device_set_wakeup_enable did not sleep until recently
> (see f2dc0d1809ab7e0147c7e4ac837be1682f706538 for instance).

Good catch; I also find that only the gainfar is the other driver
needing fixing; I'll follow up with this.

Patch with updated description for David:

As device_set_wakeup_enable can now sleep, move the call to outside
the critical section.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index d88ce9f..894e7c7 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -846,10 +846,10 @@ static int rtl8169_set_wol(struct net_device
*dev, struct ethtool_wolinfo *wol)
 	else
 		tp->features &= ~RTL_FEATURE_WOL;
 	__rtl8169_set_wol(tp, wol->wolopts);
-	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
-
 	spin_unlock_irq(&tp->lock);

+	device_set_wakeup_enable(&tp->pci_dev->dev, wol->wolopts);
+
 	return 0;
 }

-- 
Daniel J Blueman
