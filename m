Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338Ab0HLPuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:50:12 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:33554 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760259Ab0HLPuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:50:09 -0400
Subject: Re: [PATCH] nfs: lookupcache coherence bugs in WCC update path
 (revised)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8762zgmmer.fsf@patl.com>
References: <87lj8ckb1e.fsf@patl.com>  <8762zgmmer.fsf@patl.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 11:49:55 -0400
Message-ID: <1281628195.2873.12.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 5 sum msgs/h 1 total rcpts 827 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: DF4D03E5B1420C4C3C78B4C2E1BF4B6B8B22B503
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 318 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 22:26 -0700, Patrick J. LoPresti wrote:
> (Well, crud.  I screwed up the previous diff and was missing a
> close-curly.  This version actually compiles...)
> 
> This patch fixes some coherence bugs in the NFS "dentry lookup cache".
> 
> The NFS dentry lookup cache provides the nfs_force_lookup_revalidate()
> call to invalidate all cached dentries associated with an inode.  In
> general, the NFS client uses the ctime and mtime in the inode to detect
> when changes are made on the server.
> 
> Therefore, to maintain cache coherence, nfs_force_lookup_revalidate()
> must be called whenever the ctime or mtime of a directory inode is
> updated with fresh data from the server.  There are a few spots in
> nfs_wcc_update_inode() where this rule is violated, making it possible
> for the lookup cache to return arbitrarily stale data.
> 
> This actually bit me in practice.  I have an application where a
> negative dentry results in -ENOENT for a file that was created 30+
> minutes earlier (despite the "noac" mount option).  Unfortunately I
> cannot share my test case, but I believe the following simple patch is
> "obviously correct", and I can confirm that it fixes my issue.

This looks less than obviously correct to me. The wcc case is invoked
when the ctime/mtime/.... change is known to have occurred due to a file
creation/unlink/... from this client. It is a weak cache consistency
case.

If your client is seeing ENOENT after it created the file itself, then
the problem isn't cache coherency, but a bug in the file creation code.

Cheers
  Trond


