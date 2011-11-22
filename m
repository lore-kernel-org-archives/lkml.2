Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1KVR6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:58:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40374 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1KVR6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:58:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111122154900.GB18954@kroah.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org> <20111122154900.GB18954@kroah.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 22 Nov 2011 09:57:41 -0800
Message-ID: <CAPtuhThPQtWwihE8aGru55k87oV7QOr=O836TTJ+=30d6dtVhA@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
To: Greg KH <greg@kroah.com>
Cc: Mike Turquette <mturquette@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 7:49 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Nov 21, 2011 at 05:40:47PM -0800, Mike Turquette wrote:
>> Introduces kobject support for the common struct clk, exports per-clk
>> data via read-only callbacks and models the clk tree topology in sysfs.
>>
>> Also adds support for generating the clk tree in clk_init and migrating
>> nodes when input sources are switches in clk_set_parent.
>>
>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
>
> Thanks Arnd for pointing me at this.
>
>> +#define MAX_STRING_LENGTH    32
>
> Why?

Copy paste from other implementations.  What do you recommend?

>
>> +static struct kobject *clk_kobj;
>> +LIST_HEAD(kobj_list);
>
> Um, no, please NEVER use raw kobjects, you should be using struct device
> instead.  Please change the code to do that.

Today the clk tree doesn't create a struct device for each clk, which
I assume would be necessary to do what you're talking about.  Is that
right?

Maybe that will be necessary with the device tree stuff anyways... any
feedback from Sascha or Grant on that?

>
>> +static ssize_t clk_show(struct kobject *kobj, struct attribute *attr,
>> +             char *buf)
>> +{
>> +     struct clk *clk;
>> +     struct clk_attribute *clk_attr;
>> +     ssize_t ret = -EINVAL;
>> +
>> +     clk = container_of(kobj, struct clk, kobj);
>> +     clk_attr = container_of(attr, struct clk_attribute, attr);
>> +
>> +     if (!clk || !clk_attr)
>> +             goto out;
>> +
>> +     /* we don't do any locking for debug operations */
>> +
>> +     /* refcount++ */
>> +     kobject_get(&clk->kobj);
>> +
>> +     if (clk_attr->show)
>> +             ret = clk_attr->show(clk, buf);
>> +     else
>> +             ret = -EIO;
>> +
>> +     /* refcount-- */
>> +     kobject_put(&clk->kobj);
>
> Why in the world would you be incrementing and decrementing the
> reference count of the kobject in the show function?  What are you
> trying to protect here that is not already protected by the core?

Will remove in v4.

>
>
>> +static void clk_release(struct kobject *kobj)
>> +{
>> +     struct clk *clk;
>> +
>> +     clk = container_of(kobj, struct clk, kobj);
>> +
>> +     complete(&clk->kobj_unregister);
>> +}
>
> Look Ma, a memory leak!

Oops.  Will fix in V4.

>
>> +static struct kobj_type clk_ktype = {
>> +     .sysfs_ops      = &clk_ops,
>> +     .default_attrs  = clk_default_attrs,
>> +     .release        = clk_release,
>> +};
>> +
>> +int clk_kobj_add(struct clk *clk)
>> +{
>> +     if (IS_ERR(clk))
>> +             return -EINVAL;
>> +
>> +     /*
>> +      * Some kobject trickery!
>> +      *
>> +      * We want to (ab)use the kobject infrastructure to track our
>> +      * tree topology for us, specifically the root clocks (which are
>> +      * otherwise not remembered in a global list).
>> +      * Unfortunately we might not be able to allocate memory yet
>> +      * when this path is hit.  This pretty much rules out anything
>> +      * that looks or smells like kobject_add, since there are
>> +      * allocations for kobject->name and a dependency on sysfs being
>> +      * initialized.
>> +      *
>> +      * To get around this we initialize the kobjects and (ab)use
>> +      * struct kobject's list_head member, "entry".  Later on we walk
>> +      * this list in clk_sysfs_tree_create() to make proper
>> +      * kobject_add calls once it is safe to do so.
>> +      *
>> +      * FIXME - this is starting to smell alot like clkdev (i.e.
>> +      * tracking the clocks in a list)
>
> Ah, comments like this warm my heart.
>
> Come on, no abusing the kobject code please, if have problems with how
> the kernel core works, and it doesn't do things you want it to, then why
> not change it to work properly for you, or at the least, ASK ME!!!

Ok, I'm asking you now.  There are two ways to solve this problem:

1) have kobject core create the lists linking the objects but defer
allocations and any interactions with sysfs until later in the boot
sequence, OR

2) my code can create a list of clks (the same way that clkdev does)
and defer kobject/sysfs stuff until later, which walks the list made
during early-boot

#1 is most closely aligned with the code I have here, #2 presents
challenges that I haven't really though through.  I know that OMAP
uses the clk framework VERY early in it's boot sequence, but as long
as the per-clk data is properly initialized then it should be OK.

What do you think?

Regards,
Mike
