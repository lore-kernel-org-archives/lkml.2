Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0IVIxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:53:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56918 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0IVIxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <20100921224947.GA20183@kroah.com>
References: <1284900889-24369-1-git-send-email-segooon@gmail.com>
 <20100921152031.30365b3f.akpm@linux-foundation.org> <20100921224947.GA20183@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 22 Sep 2010 10:53:21 +0200
Message-ID: <AANLkTimQWtQTBe3RBSbYd7vM4Y+SckkoBDbO8E+SwtJj@mail.gmail.com>
Subject: Re: [PATCH 04/14] memstick: core: fix device_register() error handling
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Dan Carpenter <error27@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 00:49, Greg KH <greg@kroah.com> wrote:

>  int device_register(struct device *dev)
>  {
> +       int retval;
> +
>        device_initialize(dev);
> -       return device_add(dev);
> +       retval = device_add(dev);
> +       if (retval)
> +               put_device(dev);
> +       return retval;
>  }

> Kay, what am I missing here, why can't we just do this?  Hm, the
> side-affect might be that if device_register() fails, NO ONE had better
> touch that device again, as it might have just been freed from the
> system.  I wonder if that will cause problems...

That looks right, besides that there might be callers already doing
this. Which needs to be checked.

I never liked this pretty useless "convenience API", which just wraps
two simple functions and the first one can never fail anyway.

We better remove that device_register() stuff entirely in the long
run, it's not doing any good. At the kobject level we killed the same
stuff already long ago.

Kay
