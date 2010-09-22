Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0IVPYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:24:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33110 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab0IVPYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:24:44 -0400
Message-ID: <4C9A1FB7.4070308@fusionio.com>
Date: Wed, 22 Sep 2010 17:24:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block fixes for 2.6.36-rc5
References: <4C99B4F3.6070403@fusionio.com> <AANLkTi=KGhG6jbAuFngw3p_rsJu944Kn+UUhYkhZ0vLA@mail.gmail.com>
In-Reply-To: <AANLkTi=KGhG6jbAuFngw3p_rsJu944Kn+UUhYkhZ0vLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-22 17:06, Linus Torvalds wrote:
> Gaah. This is just _incredibly_ ugly:
> 
> On Wed, Sep 22, 2010 at 12:49 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> -       /* Add group onto cgroup list */
>> -       sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>> -       cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
>> +       /*
>> +        * Add group onto cgroup list. It might happen that bdi->dev is
>> +        * not initiliazed yet. Initialize this new group without major
>> +        * and minor info and this info will be filled in once a new thread
>> +        * comes for IO. See code above.
>> +        */
>> +       if (bdi->dev) {
>> +               sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>> +               cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
>>                                        MKDEV(major, minor));
>> +       } else
>> +               cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
>> +                                       0);
>> +
> 
> and quite frankly, anything that does that kind of thing is total
> sh*t. Not only is the sscanf() just broken (really? figuring out
> things from some internal string? Using dev_t in this time and age for
> kernel internal stuff?) to begin with, but if you have to then do it
> conditionally, for chrissake do it _cleanly_.
> 
> Make a small helper function that does "get me the dev_t of this
> 'dev'", and make that one do
> 
>    static unsigned int device_dev_t(struct device *dev)
>    {
>       unsigned int major = 0, minor = 0;
> 
>       if (dev)
>          sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> 
>       return MKDEV(major, minor);
>    }
> 
> and then just have a single 'cfq_blkiocg_add_blkio_group()' there.
> 
> But more seriously, why the hell does anything internal to cfq use a
> 'dev_t' in the first place? Why isn't that 'struct blkio_group' using
> a pointer to the 'struct device' or something like that instead (or
> the pointer to the queue, or whatever)? It's just damn wrong to use
> dev_t in this day and age, and the fact that you need to make it up
> using sscanf() should have clued people into that fact.
> 
> I hate seeing obvious crap-workarounds this late in an -rc.

I don't think anybody will disagree. The major problem here is that we
still have some drivers using multiple devices per queue, one of them
will be gone for .37 at least and I hope we can get mtd blk converted
too. When that happens, we can place a dev in the queue and get rid of
this hack and similar hacks on double bdi etc registrations.

So we can put some makeup on the corpse like you describe, or we can
just live with this until we can kill off abominations like this for
2.6.37.

-- 
Jens Axboe

