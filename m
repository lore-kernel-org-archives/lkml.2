Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0KSVLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:11:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:46564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0KSVLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:11:42 -0500
Date: Fri, 19 Nov 2010 12:57:09 -0800
From: Greg KH <gregkh@suse.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: core: do not put noninitialized devices
Message-ID: <20101119205709.GA17531@suse.de>
References: <1290192100-11451-1-git-send-email-segoon@openwall.com>
 <20101119190242.GA14328@suse.de>
 <20101119191424.GA12273@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119191424.GA12273@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 10:14:25PM +0300, Vasiliy Kulikov wrote:
> Hi Greg,
> 
> On Fri, Nov 19, 2010 at 11:02 -0800, Greg KH wrote:
> > On Fri, Nov 19, 2010 at 09:41:40PM +0300, Vasiliy Kulikov wrote:
> > > If kobject_set_name_vargs() fails then put_device() frees
> > > device with zero kobj->state_initialized.  This leads to WARN().
> > 
> > Have you seen this happen?
> 
> No, I've just analized the code.  Without device_initialize() ->kobj is
> not initialized:
> 
> 	kobject_init(&dev->kobj, &device_ktype) calls
> 
> 	kobject_init_internal(kobj) calls
> 
> 	kobj->state_initialized = 1;
> 
> kobject_put() calls WARN if state_initialized == 0:
> 
>     void kobject_put(struct kobject *kobj)
>     {
>         if (kobj) {
>             if (!kobj->state_initialized)
>                 WARN(1, KERN_WARNING "kobject: '%s' (%p): is not "
>                        "initialized, yet kobject_put() is being "
>                        "called.\n", kobject_name(kobj), kobj);
> 
> 
> I got the stack dump with similar code:
> 
>     struct device *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>     put_device(dev);

Sure, that's illegal code, and we want to warn about that.  So I would
say, if an error happens, we want to see this message so the code should
stay as-is.

thanks,

greg k-h
