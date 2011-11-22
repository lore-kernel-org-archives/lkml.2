Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1KVPta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:49:30 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46820 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757408Ab1KVPtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:49:12 -0500
X-Sasl-enc: 7HlITCMkcofjV8F+v97rTtcs5T+YRN0WhF5Nu1xe7ByD 1321976950
Date: Tue, 22 Nov 2011 07:49:00 -0800
From: Greg KH <greg@kroah.com>
To: Mike Turquette <mturquette@ti.com>
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
Message-ID: <20111122154900.GB18954@kroah.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321926047-14211-6-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:40:47PM -0800, Mike Turquette wrote:
> Introduces kobject support for the common struct clk, exports per-clk
> data via read-only callbacks and models the clk tree topology in sysfs.
> 
> Also adds support for generating the clk tree in clk_init and migrating
> nodes when input sources are switches in clk_set_parent.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>

Thanks Arnd for pointing me at this.

> +#define MAX_STRING_LENGTH	32

Why?

> +static struct kobject *clk_kobj;
> +LIST_HEAD(kobj_list);

Um, no, please NEVER use raw kobjects, you should be using struct device
instead.  Please change the code to do that.

> +static ssize_t clk_show(struct kobject *kobj, struct attribute *attr,
> +		char *buf)
> +{
> +	struct clk *clk;
> +	struct clk_attribute *clk_attr;
> +	ssize_t ret = -EINVAL;
> +
> +	clk = container_of(kobj, struct clk, kobj);
> +	clk_attr = container_of(attr, struct clk_attribute, attr);
> +
> +	if (!clk || !clk_attr)
> +		goto out;
> +
> +	/* we don't do any locking for debug operations */
> +
> +	/* refcount++ */
> +	kobject_get(&clk->kobj);
> +
> +	if (clk_attr->show)
> +		ret = clk_attr->show(clk, buf);
> +	else
> +		ret = -EIO;
> +
> +	/* refcount-- */
> +	kobject_put(&clk->kobj);

Why in the world would you be incrementing and decrementing the
reference count of the kobject in the show function?  What are you
trying to protect here that is not already protected by the core?


> +static void clk_release(struct kobject *kobj)
> +{
> +	struct clk *clk;
> +
> +	clk = container_of(kobj, struct clk, kobj);
> +
> +	complete(&clk->kobj_unregister);
> +}

Look Ma, a memory leak!

> +static struct kobj_type clk_ktype = {
> +	.sysfs_ops	= &clk_ops,
> +	.default_attrs	= clk_default_attrs,
> +	.release	= clk_release,
> +};
> +
> +int clk_kobj_add(struct clk *clk)
> +{
> +	if (IS_ERR(clk))
> +		return -EINVAL;
> +
> +	/*
> +	 * Some kobject trickery!
> +	 *
> +	 * We want to (ab)use the kobject infrastructure to track our
> +	 * tree topology for us, specifically the root clocks (which are
> +	 * otherwise not remembered in a global list).
> +	 * Unfortunately we might not be able to allocate memory yet
> +	 * when this path is hit.  This pretty much rules out anything
> +	 * that looks or smells like kobject_add, since there are
> +	 * allocations for kobject->name and a dependency on sysfs being
> +	 * initialized.
> +	 *
> +	 * To get around this we initialize the kobjects and (ab)use
> +	 * struct kobject's list_head member, "entry".  Later on we walk
> +	 * this list in clk_sysfs_tree_create() to make proper
> +	 * kobject_add calls once it is safe to do so.
> +	 *
> +	 * FIXME - this is starting to smell alot like clkdev (i.e.
> +	 * tracking the clocks in a list)

Ah, comments like this warm my heart.

Come on, no abusing the kobject code please, if have problems with how
the kernel core works, and it doesn't do things you want it to, then why
not change it to work properly for you, or at the least, ASK ME!!!

> +	 */
> +
> +	kobject_init(&clk->kobj, &clk_ktype);
> +	list_add_tail(&clk->kobj.entry, &kobj_list);

Yeah, no kobject lists for you, sorry, DO NOT DO THIS!

> +static int __init clk_sysfs_init(void)
> +{
> +	struct list_head *tmp;
> +
> +	clk_kobj = kobject_create_and_add("clk", NULL);
> +
> +	WARN_ON(!clk_kobj);

Why?  What is this helping with?

Please rewrite to use 'struct device'.

thanks,

greg k-h
