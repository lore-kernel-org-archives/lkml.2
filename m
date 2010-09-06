Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0IFLF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:05:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:37844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab0IFLFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:05:53 -0400
Date: Mon, 6 Sep 2010 21:05:43 +1000
From: Neil Brown <neilb@suse.de>
To: wharms@bfs.de
Cc: Sam Ravnborg <sam@ravnborg.org>, Kulikov Vasiliy <segooon@gmail.com>,
        kernel-janitors@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100906210543.34c2dbad@notabene>
In-Reply-To: <4C849BA4.1080106@bfs.de>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
	<20100905190139.GA3163@merkur.ravnborg.org>
	<20100905192335.GA8140@albatros>
	<20100905203908.GA3228@merkur.ravnborg.org>
	<20100906152931.1d4a1d07@notabene>
	<4C849BA4.1080106@bfs.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010 09:43:32 +0200
walter harms <wharms@bfs.de> wrote:

> 
> 
> Neil Brown schrieb: 
> > I've taken the opportunity to substantially re-write that code.
> > 
> > Comments?
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
> 
> 
> perhaps you can drop the else when you init with
> choose_first = 0;
> start_disk = conf->last_used;

Perhaps.  Though given the 'retry' loop it isn't obvious that would do the
right thing.
I think I'll keep this bit as-is.  I think it helps see to two cases more
clearly.



> > +		if (r1_bio->bios[disk] == IO_BLOCKED
> > +		    || !(rdev = rcu_dereference(conf->mirrors[disk].rdev))
> > +		    || !test_bit(In_sync, &rdev->flags))
> > +			continue;
> 
> i think it is more readable to use:
> 
>   rdev = rcu_dereference(conf->mirrors[disk].rdev);
>   if ()
> 

I think assignments inside 'if' statements have their place, but it seems
that this is far from universal.  I've made this change, thanks.

> 
> 
> > +		if (test_bit(WriteMostly, &rdev->flags)) {
> > +			new_disk = disk;
> > +			continue;
> >  		}
> > +		new_disk = disk;
> > +		break;
> >  	}
> 
> to improve readability:
> 
> 	new_disk = disk;
> 	if ( ! test_bit(WriteMostly, &rdev->flags) )
> 		break;

Yes, that is a distinct improvement.  I've made that change too.

Thanks a lot for your review!!

NeilBrown

