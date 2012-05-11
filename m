Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005Ab2EKNz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:55:57 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60054 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab2EKNzz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:55:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120511122719.GA3960@opensource.wolfsonmicro.com>
References: <1336733724.5950.3.camel@sw-eng-lt-dc-vm2>
	<20120511122719.GA3960@opensource.wolfsonmicro.com>
Date: Fri, 11 May 2012 15:55:54 +0200
Message-ID: <CAEqHmAtm4-TkdmLSc-HUPMo_Fyw4WK+d6Xj=X9z1m4kK1A0oJw@mail.gmail.com>
Subject: Re: [PATCH] regmap: Add support for register paging
From: dd diasemi <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>,
        gg@slimlogic.co.uk, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 1:27 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, May 11, 2012 at 12:55:24PM +0200, Krystian Garbaciak wrote:
>
> In terms of framework I think this is broadly OK, though it'd probably
> be clearer and easier to understand all round if it were unconditional;
> right now the diff is pretty hard to read so I may have missed some
> issues and I'm also reluctant to add any additional combinations of
> build options that aren't actually needed.
I did some rearrangement in the code, like splitting functions into
halves, so it is hard to read it from the patch. However, I have not
changed present functionality and if paging is not initialised, regmap
behaves the same way as before.
I will prepare patch without compilation flag, as it is not so important.

> One other fun thing which just occurred to me is that I've got a bunch
> of chips which have several independantly paged regions.  I'm not sure
> that's really worth handling here, though.
I have more advanced solution, which actually makes register mapping
split into virtual address ranges. This may solve many problems,
including giving capability to support several indirect register
ranges at once.
Let me know, what you think about this API?

Kind Regards,
Krystian
---
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a90abb6..13f31f4 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -20,6 +20,7 @@ struct device;
 struct i2c_client;
 struct spi_device;
 struct regmap;
+struct regmap_range;

 /* An enum of all the supported cache types */
 enum regcache_type {
@@ -50,6 +51,9 @@ struct reg_default {
  * @pad_bits: Number of bits of padding between register and value.
  * @val_bits: Number of bits in a register value, mandatory.
  *
+ * @ranges: Array of virtual address range descriptors.
+ * @num_ranges: Descriptor array size.
+ *
  * @writeable_reg: Optional callback returning true if the register
  *                 can be written to.
  * @readable_reg: Optional callback returning true if the register
@@ -81,6 +85,9 @@ struct regmap_config {
 	int pad_bits;
 	int val_bits;

+	struct regmap_range *ranges;
+	unsigned int num_ranges;
+
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
@@ -97,6 +104,35 @@ struct regmap_config {
 	u8 write_flag_mask;
 };

+/**
+ * Descriptors for virtual address range.
+ * Indirect or paged registers, can be defined with one or more descriptors.
+ * Registers not defined in such descriptor are accessed directly.
+ *
+ * @base_reg: Register address of first register in virtual address range.
+ * @num_regs: Number of registers asigned to this range.
+ *
+ * @translate_reg: Function that passes page number and physical
register number
+ *                 matching virtual_reg.
+ *
+ * @page_sel_reg: Register to update selected page in (available on any page).
+ * @page_sel_shift: Bit mask for page selector access inside the register.
+ * @page_sel_mask: Bit shift for page selector access inside the register.
+ */
+struct regmap_range {
+	/* Registers in virtual address range */
+	unsigned int base_reg;
+	unsigned int num_regs;
+
+	/* Registers translation handler */
+	int (*translate_reg)(struct device *dev, unsigned int virtual_reg,
+			     unsigned int *page, unsigned int *reg);
+
+	/* Description of page selector */
+	unsigned int page_sel_reg;
+	int page_sel_shift;
+};
+
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
 			       size_t count);
 typedef int (*regmap_hw_gather_write)(struct device *dev,
