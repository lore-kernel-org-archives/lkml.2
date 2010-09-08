Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab0IHHEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 03:04:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab0IHHEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 03:04:39 -0400
Date: Wed, 8 Sep 2010 17:04:28 +1000
From: Neil Brown <neilb@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100908170428.08372cce@notabene>
In-Reply-To: <20100906192128.GA4760@merkur.ravnborg.org>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
	<20100905190139.GA3163@merkur.ravnborg.org>
	<20100905192335.GA8140@albatros>
	<20100905203908.GA3228@merkur.ravnborg.org>
	<20100906152931.1d4a1d07@notabene>
	<20100906192128.GA4760@merkur.ravnborg.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 21:21:28 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> > Comments?
> 
> Looks better but can still use a few improvements.
> See below.

Thanks for your review and comments....


> 
> 	Sam
> > 
> > Thanks,
> > NeilBrown
> > 
> > commit e4062735c8f7233923df5858ed20f1278f3ee669
> > Author: NeilBrown <neilb@suse.de>
> > Date:   Mon Sep 6 14:10:08 2010 +1000
> > 
> >     md: tidy up device searches in read_balance.
> >     
> >     We have a pre-increment side-effect in the arg to a macro:
> >       rcu_dereference
> >     
> >     This is poor form and triggers a warning.  Rather than just fix that,
> >     take the opportunity to re-write the code it make it more readable.
> >     
> >     Reported-by: Kulikov Vasiliy <segooon@gmail.com>
> >     Signed-off-by: NeilBrown <neilb@suse.de>
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index ad83a4d..e29e13f 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -420,11 +420,13 @@ static void raid1_end_write_request(struct bio *bio, int error)
> >  static int read_balance(conf_t *conf, r1bio_t *r1_bio)
> >  {
> >  	const sector_t this_sector = r1_bio->sector;
> > -	int new_disk = conf->last_used, disk = new_disk;
> > -	int wonly_disk = -1;
> > +	int new_disk = -1;
> > +	int start_disk;
> > +	int i;
> >  	const int sectors = r1_bio->sectors;
> >  	sector_t new_distance, current_distance;
> >  	mdk_rdev_t *rdev;
> > +	int choose_first;
> 
> To increase readability the general recommendation is:
> 1) Sort variable definitions with the longest first.
> 2) Do not assing variables when they are defined, do that on a separate line
>    below the variable definitions.
>    With one empty line after variable definitions.
> 

I'm don't really agree with this.  I think declaring related variables
together is much more important that sorting them by length.  I guess it is a
very subjective thing.
And I think initialising at the point of declaration is often a good idea,
though not always.

I've moved 'sectors' up near 'this_sector' but nothing else.




> >  
> >  	rcu_read_lock();
> >  	/*
> > @@ -435,54 +437,35 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
> >   retry:
> >  	if (conf->mddev->recovery_cp < MaxSector &&
> >  	    (this_sector + sectors >= conf->next_resync)) {
> > -		/* Choose the first operational device, for consistancy */
> > -		new_disk = 0;
> > -
> > -		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
> > -		     r1_bio->bios[new_disk] == IO_BLOCKED ||
> > -		     !rdev || !test_bit(In_sync, &rdev->flags)
> > -			     || test_bit(WriteMostly, &rdev->flags);
> > -		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
> > -
> > -			if (rdev && test_bit(In_sync, &rdev->flags) &&
> > -				r1_bio->bios[new_disk] != IO_BLOCKED)
> > -				wonly_disk = new_disk;
> > -
> > -			if (new_disk == conf->raid_disks - 1) {
> > -				new_disk = wonly_disk;
> > -				break;
> > -			}
> > -		}
> > -		goto rb_out;
> > +		choose_first = 1;
> > +		start_disk = 0;
> > +	} else {
> > +		choose_first = 0;
> > +		start_disk = conf->last_used;
> >  	}
> >  
> > -
> >  	/* make sure the disk is operational */
> > -	for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
> > -	     r1_bio->bios[new_disk] == IO_BLOCKED ||
> > -	     !rdev || !test_bit(In_sync, &rdev->flags) ||
> > -		     test_bit(WriteMostly, &rdev->flags);
> > -	     rdev = rcu_dereference(conf->mirrors[new_disk].rdev)) {
> > -
> > -		if (rdev && test_bit(In_sync, &rdev->flags) &&
> > -		    r1_bio->bios[new_disk] != IO_BLOCKED)
> > -			wonly_disk = new_disk;
> > -
> > -		if (new_disk <= 0)
> > -			new_disk = conf->raid_disks;
> > -		new_disk--;
> > -		if (new_disk == disk) {
> > -			new_disk = wonly_disk;
> > -			break;
> > +	for (i = 0 ; i < conf->raid_disks ; i++) {
> > +		int disk = start_disk + i;
> > +		if (disk >= conf->raid_disks)
> > +			disk -= conf->raid_disks;
> 1) Please comment on the purpose of the for loop

That would be the comment "make sure the disk is operational" ??

> 2) See comments above aboyt variable definitions

Still disagree - sorry.

> 
> > +
> > +		if (r1_bio->bios[disk] == IO_BLOCKED
> > +		    || !(rdev = rcu_dereference(conf->mirrors[disk].rdev))
> > +		    || !test_bit(In_sync, &rdev->flags))
> The rather complex expression - which includes a well hidden assignment -
> is repeated a few lines later.
> Please use a helper function and do not use such hidden assignments.

I've moved the assignment out but I don't agree that a helper function is
needed.
Once must balance the total complexity of the function (which should be kept
low) against the cost of having to go look at a separate piece of code to see
what a helper function actually does.

In this case I think that separating this code out would be 'hiding' rather
than 'abstraction'.


> 
> 
> > +			continue;
> > +
> > +		if (test_bit(WriteMostly, &rdev->flags)) {
> > +			new_disk = disk;
> > +			continue;
> >  		}
> > +		new_disk = disk;
> > +		break;
> >  	}
> >  
> > @@ -491,20 +474,20 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
> >  	if (this_sector == conf->mirrors[new_disk].head_position)
> >  		goto rb_out;
> >  
> > -	current_distance = abs(this_sector - conf->mirrors[disk].head_position);
> > +	current_distance = abs(this_sector 
> > +			       - conf->mirrors[new_disk].head_position);
> >  
> > -	/* Find the disk whose head is closest */
> > +	/* look for a better disk - i.e. head is closer */
> > +	start_disk = new_disk;
> > +	for (i = 1; i < conf->raid_disks; i++) {
> > +		int disk = start_disk + 1;
> > +		if (disk >= conf->raid_disks)
> > +			disk -= conf->raid_disks;
> See comments about for loop above.
> I also cannot see why we suddenly start with 1 where the other
> almost identical for loop starts with 0?
> If I wonder then someone else will wonder too => comment please.

Before we were finding a working disk.
Now were a finding a better disk.
First is an absolute statement that needs to consider every device,
second is comparative and only needs to consider every other device (... uhm,
that doesn't sound right - I don't mean every second device, I mean every
device that isn't this one).

Suggestions on a comment that would make that clearer?


> 
> >  
> > -	do {
> > -		if (disk <= 0)
> > -			disk = conf->raid_disks;
> > -		disk--;
> > -
> > -		rdev = rcu_dereference(conf->mirrors[disk].rdev);
> > -
> > -		if (!rdev || r1_bio->bios[disk] == IO_BLOCKED ||
> > -		    !test_bit(In_sync, &rdev->flags) ||
> > -		    test_bit(WriteMostly, &rdev->flags))
> > +		if (r1_bio->bios[disk] == IO_BLOCKED
> > +		    || !(rdev = rcu_dereference(conf->mirrors[disk].rdev))
> > +		    || !test_bit(In_sync, &rdev->flags)
> > +		    || test_bit(WriteMostly, &rdev->flags))
> >  			continue;
> Here the complex expression is repeated - at least almost identical.

The 'almost' is key.
There are two if conditions that are similar but different.  And only two.
Factoring parts out would still leave one of them a little complex and would
split the task of understanding the condition over two separate parts of
program text.
I don't think the benefits of a function out-weigh the costs.

Thanks,
NeilBrown



> 
> >  
> >  		if (!atomic_read(&rdev->nr_pending)) {
> > @@ -516,11 +499,9 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
> >  			current_distance = new_distance;
> >  			new_disk = disk;
> >  		}
> > -	} while (disk != conf->last_used);
> > +	}
> >  
> >   rb_out:
> > -
> > -
> >  	if (new_disk >= 0) {
> >  		rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
> >  		if (!rdev)
> > 
> 
> 	Sam

