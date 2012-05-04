Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2EDJgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 05:36:01 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59627 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427Ab2EDJgA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 05:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120430214718.GB4414@opensource.wolfsonmicro.com>
References: <CAEqHmAstczdi2seTHFE0-jLK9fJaKosHjJyo4AJ7E9UKYBrVsg@mail.gmail.com>
	<20120430214718.GB4414@opensource.wolfsonmicro.com>
Date: Fri, 4 May 2012 11:35:58 +0200
Message-ID: <CAEqHmAsyJntRMqX+7NbQN0OmDXz6ZGh0LzAMp5KB=-cAMgpsJA@mail.gmail.com>
Subject: Re: Linux 3.4-rc2 register mapping and paging on I2C device.
From: dd diasemi <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:47 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Apr 30, 2012 at 06:31:37PM +0100, dd diasemi wrote:
>
>> 3. Update regmap API to enable support for register page switching.
>
> Clearly this is the most sensible option.  Open coding this in all the
> drivers that need it is going to lead to a lot of duplicated effort.

Below you can find my proposition of API for regmap paging support. It
is sufficient for my driver needs.
If you are OK with this proposition or you find any issues with it, let me know.

Kind Regards,
Krystian

---
diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 0f6c7fb..590d72c 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -16,3 +16,6 @@ config REGMAP_SPI

 config REGMAP_IRQ
        bool
+
+config REGMAP_PAGING
+       bool
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a90abb6..81a11c1 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -50,6 +50,15 @@ struct reg_default {
  * @pad_bits: Number of bits of padding between register and value.
  * @val_bits: Number of bits in a register value, mandatory.
  *
+ * @page_bits: Number of bits of register page number. These are the top-most
+ *             bits exdending register address. These bits will be written
+ *             to page register, for page switch.
+ * @page_reg: Page register used for page update (available for any page).
+ * @page_shift: Formatting bit shift for page number, made prior to write to
+ *              page register.
+ * @nonpageable_reg: Optional callback returning true if the register
+ *                  needs NO page switching (eg. page is irrelevant).
+ *
  * @writeable_reg: Optional callback returning true if the register
  *                 can be written to.
  * @readable_reg: Optional callback returning true if the register
@@ -81,6 +90,13 @@ struct regmap_config {
        int pad_bits;
        int val_bits;

+#ifdef CONFIG_REGMAP_PAGING
+       int page_bits;
+       int page_shift;
+       unsigned int page_reg;
+       bool (*nonpageable_reg)(struct device *dev, unsigned int reg);
+#endif
+
        bool (*writeable_reg)(struct device *dev, unsigned int reg);
        bool (*readable_reg)(struct device *dev, unsigned int reg);
        bool (*volatile_reg)(struct device *dev, unsigned int reg);
