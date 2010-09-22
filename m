Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0IVPHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:07:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab0IVPHm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <4C99B4F3.6070403@fusionio.com>
References: <4C99B4F3.6070403@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Sep 2010 08:06:40 -0700
Message-ID: <AANLkTi=KGhG6jbAuFngw3p_rsJu944Kn+UUhYkhZ0vLA@mail.gmail.com>
Subject: Re: [GIT PULL] block fixes for 2.6.36-rc5
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaah. This is just _incredibly_ ugly:

On Wed, Sep 22, 2010 at 12:49 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> -       /* Add group onto cgroup list */
> -       sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> -       cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
> +       /*
> +        * Add group onto cgroup list. It might happen that bdi->dev is
> +        * not initiliazed yet. Initialize this new group without major
> +        * and minor info and this info will be filled in once a new thread
> +        * comes for IO. See code above.
> +        */
> +       if (bdi->dev) {
> +               sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +               cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
>                                        MKDEV(major, minor));
> +       } else
> +               cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
> +                                       0);
> +

and quite frankly, anything that does that kind of thing is total
sh*t. Not only is the sscanf() just broken (really? figuring out
things from some internal string? Using dev_t in this time and age for
kernel internal stuff?) to begin with, but if you have to then do it
conditionally, for chrissake do it _cleanly_.

Make a small helper function that does "get me the dev_t of this
'dev'", and make that one do

   static unsigned int device_dev_t(struct device *dev)
   {
      unsigned int major = 0, minor = 0;

      if (dev)
         sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);

      return MKDEV(major, minor);
   }

and then just have a single 'cfq_blkiocg_add_blkio_group()' there.

But more seriously, why the hell does anything internal to cfq use a
'dev_t' in the first place? Why isn't that 'struct blkio_group' using
a pointer to the 'struct device' or something like that instead (or
the pointer to the queue, or whatever)? It's just damn wrong to use
dev_t in this day and age, and the fact that you need to make it up
using sscanf() should have clued people into that fact.

I hate seeing obvious crap-workarounds this late in an -rc.

                            Linus
