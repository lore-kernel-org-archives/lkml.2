Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab3AIRMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:12:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42959 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3AIRMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:12:19 -0500
Date: Wed, 9 Jan 2013 17:12:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] Proposed removal of IS_ERR_OR_NULL() (was: Re: [PATCH
	1/4] gpiolib: introduce descriptor-based GPIO interface)
Message-ID: <20130109171206.GQ3931@n2100.arm.linux.org.uk>
References: <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com> <201301091035.23206.arnd@arndb.de> <20130109104414.GF3931@n2100.arm.linux.org.uk> <20130109111055.GG3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301090932400.6300@xanadu.home> <20130109150427.GL3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301091020580.6300@xanadu.home> <20130109155154.GN3931@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1301091058070.6300@xanadu.home> <20130109162145.GO3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109162145.GO3931@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 04:21:45PM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 09, 2013 at 11:09:23AM -0500, Nicolas Pitre wrote:
> > On Wed, 9 Jan 2013, Russell King - ARM Linux wrote:
> > 
> > > On Wed, Jan 09, 2013 at 10:27:53AM -0500, Nicolas Pitre wrote:
> > > > Anyone with good coccinelle skills around to deal with the users?
> > > 
> > > I'm not sure that's a solution.
> > 
> > Well, I was thinking that coccinelle could handle the majority of the 
> > 354 users when the "fix" is obvious enough to be automated.
> > 
> > That said, if we want people to fix their code, it is probably necessary 
> > to merge your patch right away so the warnings are actually being seen, 
> > and revert it right before the final v3.8 release if the remaining 
> > warnings are still too numerous.  Repeat with next cycle.
> 
> Well, this is what I currently have for arch/arm thus far, and ooh look,
> we save some lines of code too.

Actually, the OMAP dmtimer.c code needs a few more fixes while we're
reviewing this stuff...  This latest patch leaves three files in
arch/arm still using IS_ERR_OR_NULL() as they do seem to want to
legitimately check for error pointers _and_ NULL.

I'm restricting the patch below to just those cases where it's wrong
in arch/arm.

The omap_device.c changes probably also deserve some explanation.  As
far as I can see, if we have an 'od' then 'od->pdev' _must_ already
be valid (pdev is passed into omap_device_alloc() which creates the
'od' - and the passed pdev better be checked _before_ it's passed in.)
It also appears that oh->od will _never_ be an error pointer value -
apart from tracing the paths creating that, there is some evidence for
this with tests elsewhere just for NULL here.  And lastly
omap_hwmod_lookup() is documented to _only_ return NULL on error, and
review of it confirms that.

Other stuff.
- soc_device_register() returns error-pointer values only.  Nothing
  allows it to return NULL.
- soc_device_to_device() merely translates the type of the pointer
  and has no failure value - plus code paths make use of this pointer
  outside of the IS_ERR_OR_NULL() check, so it better be valid.
- debugfs interfaces return NULL on error.  Everything else should be
  considered valid.  (Yes, it returns ERR_PTR(-ENODEV) when it's
  unconfigured, but that's to make it _look_ like a valid pointer to
  prevent these paths from erroring out unnecessarily.)
- pwrdm_can_ever_lose_context() is only ever calls from the GPIO code,
  and the source of the passed pointer is defined to only ever be a
  valid pointer or NULL.
- regulator API, errors are valid error pointers.  NULL means regulator
  API not available.  Whether it's right that board-harmony-pcie.c
  should not proceed without the regulator API is debatable, but the
  current code is just fscked.
- clk_get_sys/clk_get - I've been over that many times, I don't need to
  restate it yet again.

 arch/arm/mach-integrator/integrator_ap.c |    6 ++----
 arch/arm/mach-integrator/integrator_cp.c |    7 ++-----
 arch/arm/mach-omap2/omap_device.c        |   11 ++++-------
 arch/arm/mach-omap2/pm-debug.c           |    6 +++---
 arch/arm/mach-omap2/powerdomain.c        |    2 +-
 arch/arm/mach-tegra/board-harmony-pcie.c |    6 +++---
 arch/arm/mach-tegra/tegra2_emc.c         |    2 +-
 arch/arm/mach-ux500/cpu.c                |    5 ++---
 arch/arm/plat-omap/dmtimer.c             |   10 +++++-----
 9 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 11e2a41..61225e1 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -540,16 +540,14 @@ static void __init ap_init_of(void)
 					   'A' + (ap_sc_id & 0x0f));
 
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR_OR_NULL(soc_dev)) {
+	if (IS_ERR(soc_dev)) {
 		kfree(soc_dev_attr->revision);
 		kfree(soc_dev_attr);
 		return;
 	}
 
 	parent = soc_device_to_device(soc_dev);
-
-	if (!IS_ERR_OR_NULL(parent))
-		integrator_init_sysfs(parent, ap_sc_id);
+	integrator_init_sysfs(parent, ap_sc_id);
 
 	of_platform_populate(root, of_default_bus_match_table,
 			ap_auxdata_lookup, parent);
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 7322838..6016189 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -364,17 +364,14 @@ static void __init intcp_init_of(void)
 					   'A' + (intcp_sc_id & 0x0f));
 
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR_OR_NULL(soc_dev)) {
+	if (IS_ERR(soc_dev)) {
 		kfree(soc_dev_attr->revision);
 		kfree(soc_dev_attr);
 		return;
 	}
 
 	parent = soc_device_to_device(soc_dev);
-
-	if (!IS_ERR_OR_NULL(parent))
-		integrator_init_sysfs(parent, intcp_sc_id);
-
+	integrator_init_sysfs(parent, intcp_sc_id);
 	of_platform_populate(root, of_default_bus_match_table,
 			intcp_auxdata_lookup, parent);
 }
diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index e065daa..fabb32d 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -1157,20 +1157,17 @@ struct device *omap_device_get_by_hwmod_name(const char *oh_name)
 	}
 
 	oh = omap_hwmod_lookup(oh_name);
-	if (IS_ERR_OR_NULL(oh)) {
+	if (!oh) {
 		WARN(1, "%s: no hwmod for %s\n", __func__,
 			oh_name);
-		return ERR_PTR(oh ? PTR_ERR(oh) : -ENODEV);
+		return -ENODEV;
 	}
-	if (IS_ERR_OR_NULL(oh->od)) {
+	if (!oh->od) {
 		WARN(1, "%s: no omap_device for %s\n", __func__,
 			oh_name);
-		return ERR_PTR(oh->od ? PTR_ERR(oh->od) : -ENODEV);
+		return -ENODEV;
 	}
 
-	if (IS_ERR_OR_NULL(oh->od->pdev))
-		return ERR_PTR(oh->od->pdev ? PTR_ERR(oh->od->pdev) : -ENODEV);
-
 	return &oh->od->pdev->dev;
 }
 EXPORT_SYMBOL(omap_device_get_by_hwmod_name);
diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
index e2c291f..548547e 100644
--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -219,7 +219,7 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *dir)
 		return 0;
 
 	d = debugfs_create_dir(pwrdm->name, (struct dentry *)dir);
-	if (!(IS_ERR_OR_NULL(d)))
+	if (d)
 		(void) debugfs_create_file("suspend", S_IRUGO|S_IWUSR, d,
 			(void *)pwrdm, &pwrdm_suspend_fops);
 
@@ -263,8 +263,8 @@ static int __init pm_dbg_init(void)
 		return 0;
 
 	d = debugfs_create_dir("pm_debug", NULL);
-	if (IS_ERR_OR_NULL(d))
-		return PTR_ERR(d);
+	if (!d)
+		return -EINVAL;
 
 	(void) debugfs_create_file("count", S_IRUGO,
 		d, (void *)DEBUG_FILE_COUNTERS, &debug_fops);
diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index dea62a9..36a6918 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -1054,7 +1054,7 @@ bool pwrdm_can_ever_lose_context(struct powerdomain *pwrdm)
 {
 	int i;
 
-	if (IS_ERR_OR_NULL(pwrdm)) {
+	if (!pwrdm) {
 		pr_debug("powerdomain: %s: invalid powerdomain pointer\n",
 			 __func__);
 		return 1;
diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
index 3cdc1bb..6d29e6a 100644
--- a/arch/arm/mach-tegra/board-harmony-pcie.c
+++ b/arch/arm/mach-tegra/board-harmony-pcie.c
@@ -56,9 +56,9 @@ int __init harmony_pcie_init(void)
 	gpio_direction_output(en_vdd_1v05, 1);
 
 	regulator = regulator_get(NULL, "vdd_ldo0,vddio_pex_clk");
-	if (IS_ERR_OR_NULL(regulator)) {
-		pr_err("%s: regulator_get failed: %d\n", __func__,
-		       (int)PTR_ERR(regulator));
+	if (IS_ERR(regulator)) {
+		err = PTR_ERR(regulator);
+		pr_err("%s: regulator_get failed: %d\n", __func__, err);
 		goto err_reg;
 	}
 
diff --git a/arch/arm/mach-tegra/tegra2_emc.c b/arch/arm/mach-tegra/tegra2_emc.c
index 837c7b9..844c8d2 100644
--- a/arch/arm/mach-tegra/tegra2_emc.c
+++ b/arch/arm/mach-tegra/tegra2_emc.c
@@ -276,7 +276,7 @@ static struct tegra_emc_pdata __devinit *tegra_emc_fill_pdata(struct platform_de
 	int i;
 
 	WARN_ON(pdev->dev.platform_data);
-	BUG_ON(IS_ERR_OR_NULL(c));
+	BUG_ON(IS_ERR(c));
 
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	pdata->tables = devm_kzalloc(&pdev->dev, sizeof(*pdata->tables),
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index 721e7b4..a480266 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -145,14 +145,13 @@ struct device * __init ux500_soc_device_init(const char *soc_id)
 	soc_info_populate(soc_dev_attr, soc_id);
 
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR_OR_NULL(soc_dev)) {
+	if (IS_ERR(soc_dev)) {
 	        kfree(soc_dev_attr);
 		return NULL;
 	}
 
 	parent = soc_device_to_device(soc_dev);
-	if (!IS_ERR_OR_NULL(parent))
-		device_create_file(parent, &ux500_soc_attr);
+	device_create_file(parent, &ux500_soc_attr);
 
 	return parent;
 }
diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index d51b75b..d0fe4c3a 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -140,8 +140,7 @@ static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
 	 */
 	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET)) {
 		timer->fclk = clk_get(&timer->pdev->dev, "fck");
-		if (WARN_ON_ONCE(IS_ERR_OR_NULL(timer->fclk))) {
-			timer->fclk = NULL;
+		if (WARN_ON_ONCE(IS_ERR(timer->fclk))) {
 			dev_err(&timer->pdev->dev, ": No fclk handle.\n");
 			return -EINVAL;
 		}
@@ -373,7 +372,7 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_modify_idlect_mask);
 
 struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
 {
-	if (timer)
+	if (timer && !IS_ERR(timer->fclk))
 		return timer->fclk;
 	return NULL;
 }
@@ -482,7 +481,7 @@ int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source)
 	if (pdata && pdata->set_timer_src)
 		return pdata->set_timer_src(timer->pdev, source);
 
-	if (!timer->fclk)
+	if (IS_ERR(timer->fclk))
 		return -EINVAL;
 
 	switch (source) {
@@ -500,7 +499,7 @@ int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source)
 	}
 
 	parent = clk_get(&timer->pdev->dev, parent_name);
-	if (IS_ERR_OR_NULL(parent)) {
+	if (IS_ERR(parent)) {
 		pr_err("%s: %s not found\n", __func__, parent_name);
 		return -EINVAL;
 	}
@@ -808,6 +807,7 @@ static int __devinit omap_dm_timer_probe(struct platform_device *pdev)
 		return  -ENOMEM;
 	}
 
+	timer->fclk = ERR_PTR(-ENODEV);
 	timer->io_base = devm_request_and_ioremap(dev, mem);
 	if (!timer->io_base) {
 		dev_err(dev, "%s: region already claimed.\n", __func__);

