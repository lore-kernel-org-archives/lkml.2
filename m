Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0EPRhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 13:37:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54392 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0EPRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 13:37:31 -0400
Date: Sun, 16 May 2010 18:37:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: ERR_PTR and PTR_ERR
Message-ID: <20100516173729.GE31073@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1005161055580.6573@ask.diku.dk>
 <Pine.LNX.4.64.1005161104520.6573@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005161104520.6573@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 11:05:23AM +0200, Julia Lawall wrote:
> On Sun, 16 May 2010, Julia Lawall wrote:
> 
> > I see a number of occurrences of code like the following:
> > 
> >  	if (IS_ERR(alg))
> > 		return ERR_PTR(PTR_ERR(alg));
> > 
> > Is there any reason why the second line couldn't just be return alg?
> 
> Hmm, never mind.  It seems to address a type problem.

More idiomatic way to deal with that is ERR_CAST(); see e.g. ext2_lookup() for
use case:
	...
	inode = NULL;
	if (ino) {
		inode = ext2_iget(dir->i_sb, ino);
		if (unlikely(IS_ERR(inode))) {
			if (PTR_ERR(inode) == -ESTALE) {
				ext2_error(dir->i_sb, __func__,
						"deleted inode referenced: %lu",
						(unsigned long) ino);
				return ERR_PTR(-EIO);
			} else {
				return ERR_CAST(inode);
			}
		}
	}
	return d_splice_alias(inode, dentry);

