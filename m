Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab2GLAqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:46:55 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:41533 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753328Ab2GLAqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:46:51 -0400
Date: Wed, 11 Jul 2012 17:46:44 -0700
From: Mike Turquette <mturquette@ti.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [GIT PULL] DT clk binding support for 3.6
Message-ID: <20120712004644.GH2772@gmail.com>
References: <4FF86BD9.3050805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF86BD9.3050805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120707-12:03, Rob Herring wrote:
> Mike,
> 
> Please pull DT clk binding and highbank clk support for 3.6. The only
> real change from 3.5 pull request is returning error values rather than
> NULL to align with the rest of the clk framework. There's been a little
> discussion but otherwise has been quiet.
> 

Hi Rob,

I agree that these patches have seen enough time on the list.  I did
find one problem in testing: the high bank clock registration function
writes to clk_hb->hw.init which is marked const.  I fixed it up in the
below patch.  That fix is now squashed into into the final patch in your
series on the clk-next branch.  Let me know if you have any objections.

Regards,
Mike

diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 2f61065..52fecad 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -277,7 +277,7 @@ static __init struct clk *hb_clk_init(struct device_node *node, const struct clk
 	struct hb_clk *hb_clk;
 	const char *clk_name = node->name;
 	const char *parent_name;
-	struct clk_init_data init_data;
+	struct clk_init_data init;
 	int rc;
 
 	rc = of_property_read_u32(node, "reg", &reg);
@@ -292,13 +292,14 @@ static __init struct clk *hb_clk_init(struct device_node *node, const struct clk
 
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
-	hb_clk->hw.init = &init_data;
-	hb_clk->hw.init->name = clk_name;
-	hb_clk->hw.init->num_parents = 1;
+	init.name = clk_name;
+	init.ops = ops;
+	init.flags = 0;
 	parent_name = of_clk_get_parent_name(node, 0);
-	hb_clk->hw.init->parent_names = &parent_name;
-	hb_clk->hw.init->ops = ops;
-	hb_clk->hw.init->flags = 0;
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	hb_clk->hw.init = &init;
 
 	clk = clk_register(NULL, &hb_clk->hw);
 	if (WARN_ON(IS_ERR(clk))) {


> Rob
> 
> The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:
> 
>   Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
> 
> are available in the git repository at:
> 
>   git://sources.calxeda.com/kernel/linux.git clk-for-3.6
> 
> for you to fetch changes up to 39a8e38a03823c3acaec02c6d7c551e268cb2139:
> 
>   clk: add highbank clock support (2012-07-01 17:04:45 -0500)
> 
> ----------------------------------------------------------------
> Grant Likely (2):
>       clk: add DT clock binding support
>       clk: add DT fixed-clock binding support
> 
> Rob Herring (2):
>       dt: add clock binding doc to primecell bindings
>       clk: add highbank clock support
> 
>  .../devicetree/bindings/arm/primecell.txt          |    6 +
>  .../devicetree/bindings/clock/calxeda.txt          |   17 +
>  .../devicetree/bindings/clock/clock-bindings.txt   |  117 +++++++
>  .../devicetree/bindings/clock/fixed-clock.txt      |   21 ++
>  arch/arm/Kconfig                                   |    1 +
>  arch/arm/boot/dts/highbank.dts                     |   91 +++++-
>  arch/arm/mach-highbank/Makefile                    |    2 +-
>  arch/arm/mach-highbank/clock.c                     |   62 ----
>  arch/arm/mach-highbank/highbank.c                  |    7 +
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/clk-fixed-rate.c                       |   23 ++
>  drivers/clk/clk-highbank.c                         |  345
> ++++++++++++++++++++
>  drivers/clk/clk.c                                  |  140 ++++++++
>  drivers/clk/clkdev.c                               |   77 +++++
>  include/linux/clk-provider.h                       |   16 +
>  include/linux/clk.h                                |   19 ++
>  16 files changed, 881 insertions(+), 64 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/calxeda.txt
>  create mode 100644
> Documentation/devicetree/bindings/clock/clock-bindings.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt
>  delete mode 100644 arch/arm/mach-highbank/clock.c
>  create mode 100644 drivers/clk/clk-highbank.c
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
