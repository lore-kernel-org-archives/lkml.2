Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0IQU5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:57:12 -0400
Received: from www.tglx.de ([62.245.132.106]:46239 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0IQU5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:57:11 -0400
Date: Fri, 17 Sep 2010 22:57:05 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
Message-ID: <20100917205705.GD2522@local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <m1eicw892p.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:36:50PM +0200, Thomas Gleixner wrote:
> On Tue, 14 Sep 2010, Eric W. Biederman wrote:
> 
> > 
> > register_chrdev limits uio devices to 256 minor numbers which causes
> > problems on one system I have with 384+ uio devices.  So instead set
> > UIO_MAX_DEVICES to the maximum number of minors and use
> > alloc_chrdev_region to reserve the uio minors.
> > 
> > The final result is that the code works the same but the uio driver now
> > supports any minor the idr allocator comes up with.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> One minor nit:
> 
> > +	result = alloc_chrdev_region(&uio_dev, 0, UIO_MAX_DEVICES, name);
> > +	if (result)
> > +		goto out;
> 
>   		return result;

Well, ok... Greg, can you fix this when you take the patch into your tree?

> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> 
> > +
> > +	result = -ENOMEM;
> > +	cdev = cdev_alloc();
> > +	if (!cdev)
> > +		goto out_unregister;
> > +
> > +	cdev->owner = THIS_MODULE;
> > +	cdev->ops = &uio_fops;
> > +	kobject_set_name(&cdev->kobj, "%s", name);
> > +
> > +	result = cdev_add(cdev, uio_dev, UIO_MAX_DEVICES);
> > +	if (result)
> > +		goto out_put;
> > +
> > +	uio_major = MAJOR(uio_dev);
> > +	uio_cdev = cdev;
> > +	result = 0;
> > +out:
> > +	return result;
> > +out_put:
> > +	kobject_put(&cdev->kobj);
> > +out_unregister:
> > +	unregister_chrdev_region(uio_dev, UIO_MAX_DEVICES);
> > +	goto out;
> >  }
> >  
> >  static void uio_major_cleanup(void)
> >  {
> > -	unregister_chrdev(uio_major, "uio");
> > +	unregister_chrdev_region(MKDEV(uio_major, 0), UIO_MAX_DEVICES);
> > +	cdev_del(uio_cdev);
> >  }
> >  
> >  static int init_uio_class(void)
> > -- 
> > 1.7.2.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
