Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0LXLKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:10:31 -0500
Received: from fallback2.mail.ru ([94.100.176.87]:60762 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0LXLKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:10:30 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Dec 2010 06:10:30 EST
Date: Fri, 24 Dec 2010 14:04:58 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] BKL removal follow-up
Message-ID: <20101224110458.GA18894@maclin>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
 <AANLkTi=qvOHwgsbaCO6_Eu2Uik7MP5=C64+WW8R-RR8B@mail.gmail.com>
 <20101122151723.GA8732@elliptictech.com>
 <201012212354.06895.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012212354.06895.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:54:06PM +0100, Arnd Bergmann wrote:
> On Monday 22 November 2010 16:17:23 Nick Bowler wrote:
> > On 2010-11-21 09:45 -0800, Linus Torvalds wrote:
> > > Yes, I'd be ok with UDF doing a "select BKL" along with a "default n"
> > > for BKL itself.
> > > 
> > > I think UDF currently is the only sane reason to have BKL enabled any
> > > more, and yes, it would probably make it easier to configure things.
> > 
> > UFS (which I use) also relies on BKL.
> 
> Would you mind running a kernel with this patch and lockdep enabled then?
> 
> It's quite likely that this doesn't work, but the easiest way to find
> out is to just try it if you don't understand the code. I can't see anything
> in the code that relies on the release-on-sleep semantics and there
> are no obvious recursive lock_kernel() calls.
> 

I see one without looking at code (am I missed something?). See below.

> @@ -922,22 +922,22 @@ void ufs_evict_inode(struct inode * inode)
>  	if (want_delete) {
>  		loff_t old_i_size;
>  		/*UFS_I(inode)->i_dtime = CURRENT_TIME;*/
> -		lock_kernel();
> +		lock_ufs();

lock
>  		mark_inode_dirty(inode);
>  		ufs_update_inode(inode, IS_SYNC(inode));
>  		old_i_size = inode->i_size;
>  		inode->i_size = 0;
>  		if (inode->i_blocks && ufs_truncate(inode, old_i_size))
call truncate with lock
>  			ufs_warning(inode->i_sb, __func__, "ufs_truncate failed\n");
> -		unlock_kernel();
> +		unlock_ufs();
>  	}

> diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
> index a58f915..9f22d00 100644
> --- a/fs/ufs/truncate.c
> +++ b/fs/ufs/truncate.c
> @@ -467,7 +467,7 @@ int ufs_truncate(struct inode *inode, loff_t old_i_size)
>  
>  	block_truncate_page(inode->i_mapping, inode->i_size, ufs_getfrag_block);
>  
> -	lock_kernel();
> +	lock_ufs();
call lock again

-- 
/Evgeniy

