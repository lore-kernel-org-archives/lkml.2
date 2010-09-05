Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0IETBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 15:01:43 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42521 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab0IETBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 15:01:41 -0400
Date: Sun, 5 Sep 2010 21:01:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100905190139.GA3163@merkur.ravnborg.org>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283711539-7123-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 10:32:18PM +0400, Kulikov Vasiliy wrote:
> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> rcu_dereference() is macro, so it might use its argument twice.
> Argument must not has side effects.
> 
> It was found by compiler warning:
> drivers/md/raid1.c: In function ‘read_balance’:
> drivers/md/raid1.c:445: warning: operation on ‘new_disk’ may be undefined
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  drivers/md/raid1.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ad83a4d..12194df 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -442,7 +442,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
>  		     r1_bio->bios[new_disk] == IO_BLOCKED ||
>  		     !rdev || !test_bit(In_sync, &rdev->flags)
>  			     || test_bit(WriteMostly, &rdev->flags);
> -		     rdev = rcu_dereference(conf->mirrors[++new_disk].rdev)) {
> +		     rdev = rcu_dereference(conf->mirrors[new_disk].rdev)) {
>  
>  			if (rdev && test_bit(In_sync, &rdev->flags) &&
>  				r1_bio->bios[new_disk] != IO_BLOCKED)
> @@ -452,6 +452,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
>  				new_disk = wonly_disk;
>  				break;
>  			}
> +			new_disk++;
>  		}
>  		goto rb_out;

This change looks wrong.
In the original implementation new_disk is incremented and
then we do the array lookup.
With your implementation it looks like we increment it after
the array lookup.

	Sam
