Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1JHJux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 05:50:53 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56717 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab1JHJuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 05:50:52 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-21-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-21-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 17:50:31 +0800
Message-ID: <CAMPhdO8ke1M2aFAqzfmFB-MWj6m5JsCYC_zYBC=iSX1L6kWwTw@mail.gmail.com>
Subject: Re: [PATCH 20/26] ARM: pxa: select FB_PXA on saar and tevorevb
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The saar and tevorevb platforms call pxafb_smart_flush from board
> code, and that function is defined in the framebuffer code, so it
> cannot be disabled.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-pxa/Kconfig |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
> index bb310d0..cd94f2f 100644
> --- a/arch/arm/mach-pxa/Kconfig
> +++ b/arch/arm/mach-pxa/Kconfig
> @@ -61,11 +61,15 @@ config MACH_TAVOREVB
>        bool "PXA930 Evaluation Board (aka TavorEVB)"
>        select PXA3xx
>        select CPU_PXA930
> +       select FB_PXA
> +       select FB
>
>  config MACH_SAAR
>        bool "PXA930 Handheld Platform (aka SAAR)"
>        select PXA3xx
>        select CPU_PXA930
> +       select FB_PXA
> +       select FB

Hi Arnd,

The option really matters is FB_PXA_SMARTPANEL, which adds support
for the display driver to control an external "smart" LCD panel. And how
about the patch below to fix this - as normal, make empty functions
when not enabled?

diff --git a/arch/arm/mach-pxa/include/mach/pxafb.h
b/arch/arm/mach-pxa/include/mach/pxafb.h
index 01a45ac..486b4c5 100644
--- a/arch/arm/mach-pxa/include/mach/pxafb.h
+++ b/arch/arm/mach-pxa/include/mach/pxafb.h
@@ -158,5 +158,18 @@ struct pxafb_mach_info {
 void pxa_set_fb_info(struct device *, struct pxafb_mach_info *);
 unsigned long pxafb_get_hsync_time(struct device *dev);

+#ifdef CONFIG_FB_PXA_SMARTPANEL
 extern int pxafb_smart_queue(struct fb_info *info, uint16_t *cmds, int);
 extern int pxafb_smart_flush(struct fb_info *info);
+#else
+static inline int pxafb_smart_queue(struct fb_info *info,
+				    uint16_t *cmds, int n)
+{
+	return 0;
+}
+
+static inline int pxafb_smart_flush(struct fb_info *info)
+{
+	return 0;
+}
+#endif
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 0f4e8c9..389530b 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -1309,16 +1309,6 @@ static int pxafb_smart_init(struct pxafb_info *fbi)
 	return 0;
 }
 #else
-int pxafb_smart_queue(struct fb_info *info, uint16_t *cmds, int n_cmds)
-{
-	return 0;
-}
-
-int pxafb_smart_flush(struct fb_info *info)
-{
-	return 0;
-}
-
 static inline int pxafb_smart_init(struct pxafb_info *fbi) { return 0; }
 #endif /* CONFIG_FB_PXA_SMARTPANEL */
