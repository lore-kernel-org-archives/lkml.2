Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398Ab2FHPqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:46:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:16703 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab2FHPqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:46:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162926148"
Date: Sat, 9 Jun 2012 00:45:35 +0900
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120608154535.GA887@localhost>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
 <20120608150736.GF21080@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608150736.GF21080@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 05:07:36PM +0200, Jan Kara wrote:
> On Fri 08-06-12 10:36:13, Ted Tso wrote:
> > 
> > I can reproduce this fairly easily by using ext4 w/o a journal, running
> > under KVM with 1024megs memory, with fsstress (xfstests #13):

Good catch, thanks!

>   Argh, I wonder how come I didn't hit this. Does attached patch fix the
> problem?

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 8d2fb8c..41a3ccf 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -664,6 +664,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  			/* Wait for I_SYNC. This function drops i_lock... */
>  			inode_sleep_on_writeback(inode);
>  			/* Inode may be gone, start again */
> +			spin_lock(&wb->list_lock);
>  			continue;
>  		}

That looks like the fix. So I pushed it to writeback-for-next.
Thanks for the quick fixing!

I'm yet to setup and run xfstests regularly, so as to catch such kind
of problems earlier in future.

Thanks,
Fengguang
