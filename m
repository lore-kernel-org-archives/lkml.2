Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0DNUw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:52:29 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:49854 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab0DNUw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:52:27 -0400
Subject: Re: [PATCH 2/2] [RFC] Remove BKL from fs/locks.c
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1271277384-7627-2-git-send-email-arnd@arndb.de>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de>
	 <1271277384-7627-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 16:52:14 -0400
Message-ID: <1271278334.3159.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 10 msgs/h 1 sum rcpts/h 10 sum msgs/h 1 total rcpts 57 max rcpts/h 12 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 88573C40A6D8356F6D5C5003EDC606AAB692A291
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 22 max/h 4 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 22:36 +0200, Arnd Bergmann wrote: 
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> I've taken a patch originally written by Matthew Wilcox and
> ported it to the current version. It seems that there were
> originally concerns that this breaks NFS, but since Trond
> has recently removed the BKL from NFS, my naive assumption
> would be that it's all good now, despite not having tried to
> understand what it does.

Hi Arnd,

We still need to fix up the bits in NFS that dereference inode->i_flock.
On the client side, those are mainly the bits that deal with lock
recovery when the NFS server has rebooted or restarted.

AFAICS, there are two places in the NFSv4 client that need to be changed
to call lock_flocks(): nfs_delegation_claim_locks(), and
nfs4_reclaim_locks(). In both cases, the replacement is trivial.

For NFSv3, I think we are already safe, since AFAICS the host->h_rwsem
already provides exclusion between file locking and lock recovery
attempts. I think we should therefore be able to immediately remove the
BKL in fs/lockd/clntlock.c:reclaimer().

I'm not as sure about how sensitive the NFS server is to the switch from
BKL -> lock_flocks(). Perhaps Bruce can comment...

Cheers
  Trond

