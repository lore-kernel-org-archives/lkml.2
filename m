Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0JFEEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:04:44 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:51642 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab0JFEEm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:04:42 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "lars@metafoo.de" <lars@metafoo.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "philipp.zabel@gmail.com" <philipp.zabel@gmail.com>,
        "robert.jarzmik@free.fr" <robert.jarzmik@free.fr>,
        "marek.vasut@gmail.com" <marek.vasut@gmail.com>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "bgat@billgatliff.com" <bgat@billgatliff.com>
Date: Wed, 6 Oct 2010 06:03:28 +0200
Subject: RE: [PATCHv2 1/7] pwm: Add pwm core driver
Thread-Topic: [PATCHv2 1/7] pwm: Add pwm core driver
Thread-Index: Actkw3w1SgqXjbnfTqqZX+0p07yYpQARYhow
Message-ID: <F45880696056844FA6A73F415B568C6953571D4F05@EXDCVYMBSTM006.EQ1STM.local>
References: <1286280002-1636-1-git-send-email-arun.murthy@stericsson.com>
	<1286280002-1636-2-git-send-email-arun.murthy@stericsson.com>
 <20101005122225.6dda30ff.akpm@linux-foundation.org>
In-Reply-To: <20101005122225.6dda30ff.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 5 Oct 2010 17:29:56 +0530
> Arun Murthy <arun.murthy@stericsson.com> wrote:
> 
> > The existing pwm based led and backlight driver makes use of the
> > pwm(include/linux/pwm.h). So all the board specific pwm drivers will
> > be exposing the same set of function name as in include/linux/pwm.h.
> > Consder a platform with multi Soc or having more than one pwm module,
> in
> > such a case, there exists more than one pwm driver for a platform.
> Each
> > of these pwm drivers export the same set of function and hence leads
> to
> > re-declaration build error.
> >
> > In order to overcome this issue all the pwm drivers must register to
> > some core pwm driver with function pointers for pwm operations (i.e
> > pwm_config, pwm_enable, pwm_disable).
> >
> > The clients of pwm device will have to call pwm_request, wherein
> > they will get the pointer to struct pwm_ops. This structure include
> > function pointers for pwm_config, pwm_enable and pwm_disable.
> >
> 
> Have we worked out who will be merging this work, if it gets merged?
I request Samuel to merge this through MFD tree.

> 
> >
> > ...
> >
> > +struct pwm_dev_info {
> > +	struct pwm_device *pwm_dev;
> > +	struct list_head list;
> > +};
> > +static struct pwm_dev_info *di;
> 
> We could just do
> 
> 	static struct pwm_dev_info {
> 		...
> 	} *di;
> 
> > +DECLARE_RWSEM(pwm_list_lock);
> 
> This can/should be static.
> 
> > +void __deprecated pwm_free(struct pwm_device *pwm)
> > +{
> > +}
> 
> Why are we adding a new function and already deprecating it?
> 
> Probably this was already addressed in earlier review, but I'm asking
> again, because there's no comment explaining the reasons.  Lesson
> learned, please add a comment.
> 
> Oh, I see that pwm_free() already exists.  This patch adds a new copy
> and doesn't remove the old function.  Does this all actually work?
> 
> It still needs a comment explaining why it's deprecated.
The existing pwm drivers make use of this function and now I am in the process
of developing a new pwm core driver and align the existing pwm drivers with
this core driver. I was able to align all the existing pwm drivers except the
jz4740 pwm driver in mips. So in order to retain the support for this mips, I
have deprecated this function. This will be removed once jz4740 pwm driver is
aligned with pwm core driver.
Will add the same comments in code.

> > +	struct pwm_dev_info *pwm;
> > +
> > +	down_write(&pwm_list_lock);
> > +	pwm = kzalloc(sizeof(struct pwm_dev_info), GFP_KERNEL);
> > +	if (!pwm) {
> > +		up_write(&pwm_list_lock);
> > +		return -ENOMEM;
> > +	}
> 
> The allocation attempt can be moved outside the lock, making the code
> faster, cleaner and shorter.
Will correct this in v3 patch.

> > +	up_write(&pwm_list_lock);
> > +	return -ENOENT;
> > +}
> > +EXPORT_SYMBOL(pwm_device_unregister);
> > +
> > +struct pwm_device *pwm_request(int pwm_id, const char *name)
> > +{
> > +	struct pwm_dev_info *pwm;
> > +	struct list_head *pos;
> > +
> > +	down_read(&pwm_list_lock);
> > +	list_for_each(pos, &di->list) {
> > +		pwm = list_entry(pos, struct pwm_dev_info, list);
> > +		if ((!strcmp(pwm->pwm_dev->pops->name, name)) &&
> > +				(pwm->pwm_dev->pwm_id == pwm_id)) {
> > +			up_read(&pwm_list_lock);
> > +			return pwm->pwm_dev;
> > +		}
> > +	}
> > +	up_read(&pwm_list_lock);
> > +	return ERR_PTR(-ENOENT);
> > +}
> > +EXPORT_SYMBOL(pwm_request);
> 
> We have a new kernel-wide exported-to-modules formal API.  We prefer
> that such things be fully documented, please.  kerneldoc is a suitable
> way but please avoid falling into the kerneldoc trap of filling out
> fields with obvious boilerplate and not actually telling people
> anything interesting or useful.
Sure, Will document this as part of v3 patch.

> 
> > +static int __init pwm_init(void)
> > +{
> > +	struct pwm_dev_info *pwm;
> > +
> > +	pwm = kzalloc(sizeof(struct pwm_dev_info), GFP_KERNEL);
> > +	if (!pwm)
> > +		return -ENOMEM;
> > +	INIT_LIST_HEAD(&pwm->list);
> > +	di = pwm;
> > +	return 0;
> > +}
> 
> OK, this looks wrong.
> 
> AFACIT you've created a dummy pwm_dev_info as a singleton, kernel-wide
> anchor for a list of all pwm_dev_info's.  So this "anchor" pwm_dev_info
> never actually gets used for anything.
> 
> The way to do this is to remove `di' altogether and instead use a
> singleton, kernel-wide list_head as the anchor for all the
> dynamically-allocated pwm_dev_info's.
OK, will implement this in v3 patch.

> 
> > +subsys_initcall(pwm_init);
> > +
> > +static void __exit pwm_exit(void)
> > +{
> > +	kfree(di);
> > +}
> > +
> > +module_exit(pwm_exit);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Arun R Murthy");
> > +MODULE_ALIAS("core:pwm");
> > +MODULE_DESCRIPTION("Core pwm driver");
> > diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> > index 7c77575..6e7da1f 100644
> > --- a/include/linux/pwm.h
> > +++ b/include/linux/pwm.h
> > @@ -3,6 +3,13 @@
> >
> >  struct pwm_device;
> >
> > +struct pwm_ops {
> > +	int (*pwm_config)(struct pwm_device *pwm, int duty_ns, int
> period_ns);
> > +	int (*pwm_enable)(struct pwm_device *pwm);
> > +	int (*pwm_disable)(struct pwm_device *pwm);
> > +	char *name;
> > +};
> 
> This also should be documented.
Sure, will take up this in v3 patch.

> 
> >
> > ...
> >
> 
> I suggest that you work on Kevin's comments before making any code
> changes though.
This pwm driver also supports the Davinci pwm driver as suggested by Kelvin.

Thanks and Regards,
Arun R Murthy
------------
