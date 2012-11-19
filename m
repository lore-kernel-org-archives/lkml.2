Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2KSOvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:51:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2KSOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:51:46 -0500
Date: Mon, 19 Nov 2012 15:51:40 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121119145140.GA20532@quack.suse.cz>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873906vumh.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-11-12 17:56:22, OGAWA Hirofumi wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> > Hi,
> >
> > In 169ebd90131b2ffca74bb2dbe7eeacd39fb83714 commit, writeback doesn't
> > __iget()/iput() anymore.
> >
> > This means nobody moves the inode to lru list. I.e.
> >
> > 	new_inode()
> > 	dirty_inode()
> > 	iput_final()
> > 		/* keep inode without adding lru */
> > 	flush indoes
> >         /* clean inode is not on lru */
> >
> > I noticed this situation in my FS though, I think the same bug is on all
> > FSes of linus tree too, after this commit.
> >
> > Am I missing the something?
> 
> This seems to be reproducible by the following,
> 
> #!/bin/sh
> 
> for i in $(seq -w 1000); do
> 	for j in $(seq -w 1000); do
>         	for k in $(seq -w 1000); do
>                 	mkdir -p $i/$j
>                         echo $i/$j/$k > $i/$j/$k
>                         echo 2 > /proc/sys/vm/drop_caches
>                 done
>         done
> done
> 
> Some inodes never be reclaimed, and ls -l frees those inodes (stat(2)
> does iget/iput).
  So looking into the code I agree we won't put inode into the LRU when it
is dirty or under writeback and after writeback is done it won't happen
either. That's certainly a bug. But I have hard time reproducing your
results because on my kernels even dcache doesn't get shrunk thus inodes
are pinned in memory by it. Not sure what's going on yet but I'll
investigate. Thanks for report!

								Honza
  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
