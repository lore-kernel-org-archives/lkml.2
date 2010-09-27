Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab0I0UTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:19:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39328 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760154Ab0I0UTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:19:11 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.86.31]
In-Reply-To: <20100927194408.GG11086@tuxdriver.com>
References: <20100927154408.55a28127.sfr@canb.auug.org.au> <AANLkTinHk82jM7Ztwb1aB1xb-hSLeg5Hb07mhYCaeszi@mail.gmail.com>
 <20100927180412.GD11086@tuxdriver.com> <20100927.111818.149846920.davem@davemloft.net>
 <20100927182546.GE11086@tuxdriver.com> <AANLkTi=YHhRWFix1QDuEnRW7r_UaNtp6KSL9uLdUzdqM@mail.gmail.com>
 <20100927184445.GF11086@tuxdriver.com> <AANLkTi=2KqQb+gvuigxb+-tSzawx7=q3HtnkkE6t_4XF@mail.gmail.com>
 <AANLkTim9nHmhNLmECnYk-OHYmyk96tz65kd=ybz24M3Y@mail.gmail.com> <20100927194408.GG11086@tuxdriver.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 27 Sep 2010 22:18:47 +0200
Message-ID: <AANLkTinefL3iNreFiP6z3dw08tunpAs7y6s3AzB_n=Jc@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (net tree related)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
        netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 9:44 PM, John W. Linville
<linville@tuxdriver.com> wrote:
>> On Mon, Sep 27, 2010 at 9:01 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> >> CONFIG_MACH_OMAP_ZOOM2=y
>> >> CONFIG_WL12XX_PLATFORM_DATA=n
>>
>> That's a good point (it's a separate issue); we need to have a select there.
>>
>> I'll send a patch.
>
> No, maybe you don't need it -- the bool line by itself means there
> is no menu item.  So the default y does the job of selecting it all
> the time (which kinda sucks for non-OMAP)...

The default y will kick in only if WL1271_SDIO is selected:

>> > config WL12XX_PLATFORM_DATA
>> >        bool
>> >        depends on WL1271_SDIO != n
>> >        default y

But if we don't select this driver at all, we better have something like:

diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 95deae3..51e4ba9 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -32,7 +32,20 @@ struct wl12xx_platform_data {
 	int board_ref_clock;
 };

+#ifdef CONFIG_WL12XX_PLATFORM_DATA
+
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
+
+#else
+
+static inline int wl12xx_set_platform_data(const struct
+						wl12xx_platform_data *data)
+{
+	return -ENOSYS;
+}
+
+#endif
+
 const struct wl12xx_platform_data *wl12xx_get_platform_data(void);

 #endif

It's better than forcing a select - if we don't need the driver, we
don't need this piece of code too.

I'll give this a spin tomorrow and send it over nicely.

> Can't we do this?  It seems to work (i.e. the symbols from
> wl12xx_platform_data.o end-up in built-in.o).

Yes, this one looks good !

Thanks a lot, John.


>
> From d8ddd0ebe8ae3791ba9c76a506bfcdd60be40f5b Mon Sep 17 00:00:00 2001
> From: John W. Linville <linville@tuxdriver.com>
> Date: Mon, 27 Sep 2010 14:00:51 -0400
> Subject: [PATCH] wl12xx: fix separate-object-folder builds
>
> Make this go away (happens when building with a separate object
> directory):
>
> Assembler messages:
> Fatal error: can't create drivers/net/wireless/wl12xx/.tmp_wl12xx_platform_data.o: No such file or directory
> drivers/net/wireless/wl12xx/wl12xx_platform_data.c: In function 'wl12xx_get_platform_data':
> drivers/net/wireless/wl12xx/wl12xx_platform_data.c:28: error: cannot open drivers/net/wireless/wl12xx/.tmp_wl12xx_platform_data.gcno
> drivers/net/wireless/wl12xx/wl12xx_platform_data.c:28: confused by earlier errors, bailing out
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/net/wireless/Makefile        |    3 +--
>  drivers/net/wireless/wl12xx/Makefile |    3 +++
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index 85af697..a13a602 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -50,7 +50,6 @@ obj-$(CONFIG_ATH_COMMON)      += ath/
>  obj-$(CONFIG_MAC80211_HWSIM)   += mac80211_hwsim.o
>
>  obj-$(CONFIG_WL12XX)   += wl12xx/
> -# small builtin driver bit
> -obj-$(CONFIG_WL12XX_PLATFORM_DATA)     += wl12xx/wl12xx_platform_data.o
> +obj-$(CONFIG_WL12XX_PLATFORM_DATA)     += wl12xx/
>
>  obj-$(CONFIG_IWM)      += iwmc3200wifi/
> diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
> index 078b439..0d334d6 100644
> --- a/drivers/net/wireless/wl12xx/Makefile
> +++ b/drivers/net/wireless/wl12xx/Makefile
> @@ -16,3 +16,6 @@ wl1271-$(CONFIG_NL80211_TESTMODE)     += wl1271_testmode.o
>  obj-$(CONFIG_WL1271)   += wl1271.o
>  obj-$(CONFIG_WL1271_SPI)       += wl1271_spi.o
>  obj-$(CONFIG_WL1271_SDIO)      += wl1271_sdio.o
> +
> +# small builtin driver bit
> +obj-$(CONFIG_WL12XX_PLATFORM_DATA)     += wl12xx_platform_data.o
> --
> 1.7.2.3
>
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
