Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3AILLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:11:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42648 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3AILLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:11:09 -0500
Date: Wed, 9 Jan 2013 11:10:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface
Message-ID: <20130109111055.GG3931@n2100.arm.linux.org.uk>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301081259.29839.arnd@arndb.de> <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com> <201301091035.23206.arnd@arndb.de> <20130109104414.GF3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109104414.GF3931@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 10:44:14AM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 09, 2013 at 10:35:22AM +0000, Arnd Bergmann wrote:
> > On Wednesday 09 January 2013, Alexandre Courbot wrote:
> > > On Tue, Jan 8, 2013 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > Please avoid the use of IS_ERR_OR_NULL(), especially on interfaces you
> > > > introduce yourself. AFAICT, gpiod_get cannot return NULL, so you
> > > > should not check for that.
> > > 
> > > Sure - you sound like IS_ERR_OR_NULL() is generally considered evil,
> > 
> > Correct.
> > 
> > > may I ask why this is the case?
> > 
> > It's very hard to get right: either you are interested in the error code,
> > and then you don't have one in some cases, or you don't care but have
> > to check for it anyway. When you define a function, just make it clear
> > what the expected return values are, either NULL for error or a negative
> > ERR_PTR value, but not both.
> 
> Indeed, and any code which does this:
> 
> 	if (IS_ERR_OR_NULL(ptr))
> 		return PTR_ERR(ptr);
> 
> is buggy because on NULL it returns 0, which is generally accepted as being
> "success".

                oh = omap_hwmod_lookup(oh_name);
                if (!oh) {

        oh = omap_hwmod_lookup(oh_name);
        if (IS_ERR_OR_NULL(oh)) {

Does this function return NULL on errors or an errno-encoded-pointer on
errors?

        d = debugfs_create_dir("pm_debug", NULL);
        if (IS_ERR_OR_NULL(d))
                return PTR_ERR(d);

Well, covered above.  NULL is success here.

        err = gpio_request(en_vdd_1v05, "EN_VDD_1V05");
        if (err) {
                pr_err("%s: gpio_request failed: %d\n", __func__, err);
                return err;
        }

        gpio_direction_output(en_vdd_1v05, 1);

        regulator = regulator_get(NULL, "vdd_ldo0,vddio_pex_clk");
        if (IS_ERR_OR_NULL(regulator)) {
                pr_err("%s: regulator_get failed: %d\n", __func__,
                       (int)PTR_ERR(regulator));
                goto err_reg;
        }
...
err_reg:
        gpio_free(en_vdd_1v05);

        return err;
}

So 'err' here is never set.  when IS_ERR_OR_NULL evaluates true.
Setting 'err' to PTR_ERR(regulator) is not correct because a NULL return
sets 'err' to zero.  Same here:

        /* create property id */
        ret = ipp_create_id(&ctx->prop_idr, &ctx->prop_lock, c_node,
                &property->prop_id);
        if (ret) {
                DRM_ERROR("failed to create id.\n");
                goto err_clear;
        }
...
        c_node->start_work = ipp_create_cmd_work();
        if (IS_ERR_OR_NULL(c_node->start_work)) {
                DRM_ERROR("failed to create start work.\n");
                goto err_clear;
        }
        c_node->stop_work = ipp_create_cmd_work();
        if (IS_ERR_OR_NULL(c_node->stop_work)) {
                DRM_ERROR("failed to create stop work.\n");
                goto err_free_start;
        }
        c_node->event_work = ipp_create_event_work();
        if (IS_ERR_OR_NULL(c_node->event_work)) {
                DRM_ERROR("failed to create event work.\n");
                goto err_free_stop;
        }

We also have it cropping up as a way to 'verify' function arguments
are correct:

int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
                          struct gpd_timing_data *td)
{
        if (IS_ERR_OR_NULL(genpd) || IS_ERR_OR_NULL(dev))
                return -EINVAL;

And then we have this beauty in USB code:

        if (!IS_ERR_OR_NULL(udc->transceiver))
                (void) otg_set_peripheral(udc->transceiver->otg, NULL);
        else
                pullup_disable(udc);
...
        seq_printf(s,
                "UDC rev %d.%d, fifo mode %d, gadget %s\n"
                "hmc %d, transceiver %s\n",
                tmp >> 4, tmp & 0xf,
                fifo_mode,
                udc->driver ? udc->driver->driver.name : "(none)",
                HMC,
                udc->transceiver
                        ? udc->transceiver->label
                        : (cpu_is_omap1710()
                                ? "external" : "(none)"));

If udc->transceiver were to be an error code, the above will segfault or
access memory at the top of memory space.

These are just a few of the issues I've picked out at random from grepping
the kernel source for IS_ERR_OR_NULL().  Yes, there's some valid use cases
but the above are all horrid, buggy or down right wrong, and I wouldn't be
at all surprised if that was all too common.
