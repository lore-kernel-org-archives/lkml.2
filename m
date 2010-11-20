Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0KTJBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 04:01:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43017 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0KTJBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 04:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E3h+IdAu+2ku2FTPjoj4cwyDXLcuUF5/vgfNEAY0tb5wwURzh8fIdHWzG3Lf1MflOO
         6oUXDyik4wmpstBaDFkR0NZLB39s1bElUWoIKrw04R5KbSqKdFwJBKXg+R7p/r3BKkgs
         OnbN5z/j1tXOyGfNY3xc99cLOuooYn+WxlY9o=
Date: Sat, 20 Nov 2010 12:00:59 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: core: do not put noninitialized devices
Message-ID: <20101120090058.GA4263@albatros>
References: <1290192100-11451-1-git-send-email-segoon@openwall.com>
 <20101119190242.GA14328@suse.de>
 <20101119191424.GA12273@albatros>
 <20101119205709.GA17531@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119205709.GA17531@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 12:57 -0800, Greg KH wrote:
> On Fri, Nov 19, 2010 at 10:14:25PM +0300, Vasiliy Kulikov wrote:
> > kobject_put() calls WARN if state_initialized == 0:
> > 
> >     void kobject_put(struct kobject *kobj)
> >     {
> >         if (kobj) {
> >             if (!kobj->state_initialized)
> >                 WARN(1, KERN_WARNING "kobject: '%s' (%p): is not "
> >                        "initialized, yet kobject_put() is being "
> >                        "called.\n", kobject_name(kobj), kobj);
> > 
> > 
> > I got the stack dump with similar code:
> > 
> >     struct device *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> >     put_device(dev);
> 
> Sure, that's illegal code,

You might misunderstood me, see this part of device_create_vargs():

struct device *device_create_vargs(...)
{
    ...
	dev = kzalloc(sizeof(*dev), GFP_KERNEL); <<<
	if (!dev)
        ...

	dev->devt = devt;
	dev->class = class;
	dev->parent = parent;
	dev->release = device_create_release;
	dev_set_drvdata(dev, drvdata);

	retval = kobject_set_name_vargs(&dev->kobj, fmt, args); <<<
	if (retval)
		goto error; <<<
    ...

error:
	put_device(dev); <<<
    ...
}

It is device_create_vargs()'s mistake, not the caller.

> and we want to warn about that.  So I would
> say, if an error happens, we want to see this message so the code should
> stay as-is.

If you mean "if memomy allocation for name fails then we want to see
message about allocation failure" then maybe use pr_err("No mem for device
name\n") instead of confusing "kobject is not initialized, yet kobject_put()
is being called"?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
