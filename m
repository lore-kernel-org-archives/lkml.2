Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0IEUjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 16:39:11 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50794 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0IEUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 16:39:10 -0400
Date: Sun, 5 Sep 2010 22:39:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100905203908.GA3228@merkur.ravnborg.org>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com> <20100905190139.GA3163@merkur.ravnborg.org> <20100905192335.GA8140@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100905192335.GA8140@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 11:23:35PM +0400, Kulikov Vasiliy wrote:
> On Sun, Sep 05, 2010 at 21:01 +0200, Sam Ravnborg wrote:
> > On Sun, Sep 05, 2010 at 10:32:18PM +0400, Kulikov Vasiliy wrote:
> > > From: Vasiliy Kulikov <segooon@gmail.com>
> > > 
> > > rcu_dereference() is macro, so it might use its argument twice.
> > > Argument must not has side effects.
> > > 
> > > It was found by compiler warning:
> > > drivers/md/raid1.c: In function ‘read_balance’:
> > > drivers/md/raid1.c:445: warning: operation on ‘new_disk’ may be undefined
> > 
> > This change looks wrong.
> > In the original implementation new_disk is incremented and
> > then we do the array lookup.
> > With your implementation it looks like we increment it after
> > the array lookup.
> 
> No, the original code increments new_disk and then dereferences mirrors.
> 
> The full code:
> 
> 		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
> 		     r1_bio->bios[new_disk] == IO_BLOCKED ||
> 		     !rdev || !test_bit(In_sync, &rdev->flags)
> 			     || test_bit(WriteMostly, &rdev->flags);
> 		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
> 
> 			if (rdev && test_bit(In_sync, &rdev->flags) &&
> 				r1_bio->bios[new_disk] != IO_BLOCKED)
> 				wonly_disk = new_disk;
> 
> 			if (new_disk == conf->raid_disks - 1) {
> 				new_disk = wonly_disk;
> 				break;
> 			}
> 		}
> 
>     so,
> 
>     for (a; b; c = f(++g)) {
>        ...
>     } 

Thanks - that explains it.
This code really screams for a helper function but thats another matter.

	Sam
