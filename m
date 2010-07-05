Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab0GEFNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 01:13:05 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:43676 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750912Ab0GEFND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 01:13:03 -0400
X-Greylist: delayed 95947 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2010 01:13:03 EDT
Subject: Re: [PATCH] omfs: fix memory leak
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: me@bobcopeland.com
Cc: linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100704113711.GA15067@hash.localnet>
References: <1278210828.27014.2.camel@cowboy>
	 <20100704113711.GA15067@hash.localnet>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 01:12:39 -0400
Message-ID: <1278306759.3811.24.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-04 at 07:37 -0400, me@bobcopeland.com wrote:
> On Sat, Jul 03, 2010 at 10:33:48PM -0400, Davidlohr Bueso wrote:
> > Hi,
> > 
> > In omfs_fill_super(), when returning on error, sbi is not being freed.
> > 
> > Thanks,
> > Davidlohr.
> 
> Hi Davidlohr,
> 
> I don't think this is right:
> 
> fill_super:
>   err = omfs_fill_super()
>   if (err)
>      deactivate_locked_super(sb)
>         kill_sb()
>           generic_shutdown_super()
>             sop->put_super()
>   ...
>   omfs_put_super()
>     kfree(sbi->s_imap);
>     kfree(sbi);
> 
> So your change would cause a crash at the first kfree in omfs_put_super().
> 
> It looks fine to me as-is, or am I missing something?

Thanks for the reply, Bob. Please bare with me, as I am learning about
the VFS workings. To my knowledge this would happen:

a user tries to mount a omfs partition:
	omfs_get_sb() -> omfs_fill_super()

If omfs_fill_super() fails, in this case 'ret' being a non 0 value, the
mount will not be completed, hence the previously allocated 'sbi'
variable will not be freed.

Isn't put_super() called to free data when things run "normally", like
for unmounting? So this function does two things:

kfree(sbi->s_imap)
kfree(sbi)

However, in omfs_get_imap() 'sbi->s_imap' is freed upon failure, so
wouldn't this also crash on the first kfree in omfs_put_super()?
Wouldn't this be the same for freeing sbi upon failure in
omfs_fill_super()?

Now, the patch I sent is compile-tested only, so it might crash it. I
will test it properly.

If what I just said is complete nonsense, please enlighten me.

Thanks,
Davidlohr

> 
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  fs/omfs/inode.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
> > index 089839a..253846e 100644
> > --- a/fs/omfs/inode.c
> > +++ b/fs/omfs/inode.c
> > @@ -523,12 +523,14 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
> >  	}
> >  	printk(KERN_DEBUG "omfs: Mounted volume %s\n", omfs_rb->r_name);
> >  
> > -	ret = 0;
> > +	ret = 0; /* success */
> >  out_brelse_bh2:
> >  	brelse(bh2);
> >  out_brelse_bh:
> >  	brelse(bh);
> >  end:
> > +	if (ret != 0)
> > +		kfree(sbi);
> >  	return ret;
> >  }
> 


