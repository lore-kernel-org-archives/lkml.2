Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288Ab0JIOn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 10:43:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0JIOn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 10:43:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Date: Sat, 9 Oct 2010 16:43:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, "linux-main" <linux-kernel@vger.kernel.org>,
        "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com> <201010091311.26335.arnd@arndb.de> <AANLkTimDd10oj=rruYcB=qTaWWMAJvSCQAJNi+nQqzp7@mail.gmail.com>
In-Reply-To: <AANLkTimDd10oj=rruYcB=qTaWWMAJvSCQAJNi+nQqzp7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010091643.25065.arnd@arndb.de>
X-Provags-ID: V02:K0:124jwgB2XYmOiR13F4SUal8MJcpLEoMObjRuDvUFC07
 xC2y6cfWFwNJPDqnojR8ggVmoApAGDg+Lv44O7paxSr2fXyAMy
 Z5HjORUj/I4UVrRCOe4QoWeZbdSVG99eaAxfx8gYhtrAZZK2gv
 uq6LkEL+Xfsg4jQny1sK45blIAMByElkk6m7z7M1/4CtteTE6h
 ZZJCZIlE/LmQnw6LVh3Eg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 October 2010 13:59:45 Felipe Contreras wrote:
> I know of tidspbridge, in my original mail I listed some links, one
> which mentions: sh_mobile_ceu_camera, maybe i.MX31 users of the
> mx3_camera driver: pcm037 and mx31moboard.
>
> http://article.gmane.org/gmane.linux.ports.sh.devel/8560

sh_mobile_ceu_camera looks fine on mainline. It only remaps
the mmio registers, so no problem there. No arm platform even
declares the device, so the report must be with an external tree.

The mx3_camera driver also looks fine, there is only one ioremap
in there, which is completely sane.
 
> From the looks of it, PowerVR SGX seems like it will be broken too:
> http://meego.gitorious.org/meego-os-base/kernel-source/trees/master/patches

Not our problem, they already have a forked kernel tree with broken
drivers, they can fix it themselves or submit an acceptable driver
upstream if they want people to care about not breaking it.

> But my guess is that most of the issues would be found after releasing
> .36, and of course the current issues cannot possibly be fixed in that
> time-frame.

My guess is that tidspbridge is the only driver that someone (i.e. you)
cares about being broken more than it already is in the mainline kernel. :-)

How about the patch below?

	Arnd
---
staging/tidspbridge: add memory consistency to TODO list

This driver uses ioremap on regular memory to get an uncached mapping,
which causes problems on ARMv6 and higher due to aliasing with the
cached linar kernel mapping.

Make sure this gets fixed before the driver graduates from staging.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/staging/tidspbridge/TODO b/drivers/staging/tidspbridge/TODO
index 54f4a29..187363f 100644
--- a/drivers/staging/tidspbridge/TODO
+++ b/drivers/staging/tidspbridge/TODO
@@ -13,6 +13,7 @@
 * Audit and clean up header files folder
 * Use kernel coding style
 * checkpatch.pl fixes
+* allocate ext_mem_pool from consistent memory instead of using ioremap
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com>
 and Omar Ramirez Luna <omar.ramirez@ti.com>.
