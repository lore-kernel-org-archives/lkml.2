Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab2HNWJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 18:09:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2HNWJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 18:09:31 -0400
Date: Wed, 15 Aug 2012 00:09:27 +0200
From: Jan Kara <jack@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Sasha Levin <levinsasha928@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Kamal Mostafa <kamal@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Dann Frazier <dann.frazier@canonical.com>,
        Massimo Morana <massimo.morana@canonical.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org
Subject: Re: mq: INFO: possible circular locking dependency detected
Message-ID: <20120814220927.GN7122@quack.suse.cz>
References: <501D0093.2090108@gmail.com>
 <20120805170856.GC8954@localhost>
 <20120807050412.GA23960@localhost>
 <20120807063955.GX23464@ZenIV.linux.org.uk>
 <20120808071738.GA20090@localhost>
 <20120808075439.GA20645@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808075439.GA20645@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-08-12 15:54:39, Wu Fengguang wrote:
> On Wed, Aug 08, 2012 at 03:17:38PM +0800, Fengguang Wu wrote:
> > On Tue, Aug 07, 2012 at 07:39:55AM +0100, Al Viro wrote:
> > > On Tue, Aug 07, 2012 at 01:04:12PM +0800, Fengguang Wu wrote:
> > > 
> > > > FYI, here is a different back trace on that commit.
> > > > 
> > > > [    3.255043] ======================================================
> > > > [    3.255052] [ INFO: possible circular locking dependency detected ]
> > > > [    3.255052] 3.5.0-rc6-bisect-00355-geb04c28 #4 Not tainted         
> > > > [    3.255052] -------------------------------------------------------
> > > > [    3.255052] init/1 is trying to acquire lock:
> > > > [    3.255052]  (&mm->mmap_sem){++++++}, at: [<ffffffff81180d00>] might_fault+0x70/0xe0
> > > > [    3.255052]
> > > > [    3.255052] but task is already holding lock:
> > > > [    3.255052]  (&sb->s_type->i_mutex_key){+.+.+.}, at: [<ffffffff811d191e>] vfs_readdir+0x6e/0x130
> > > 
> > > Do you see any similar with the _next_ commit?
> > 
> > Stress tests show that the next commit is free from both the "circular
> > locking dependency" issues.
> 
> Sorry.. but this still remains for commit 5d37e9e6("fs: Skip atime
> update on frozen filesystem"):
>
> [  175.588560] [ INFO: possible circular locking dependency detected ]
> [  175.588560] 3.5.0-rc6-bisect-00356-g5d37e9e6 #46 Not tainted
> [  175.588560] -------------------------------------------------------
> [  175.588560] trinity-child0/493 is trying to acquire lock:
> [  175.588560]  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff811cc4fe>] vfs_unlink+0x6e/0x1d0
> [  175.588560] 
> [  175.588560] but task is already holding lock:
> [  175.588560]  (sb_writers#11){.+.+.+}, at: [<ffffffff811e40af>] mnt_want_write+0x2f/0x90
> [  175.588560] 
> [  175.588560] which lock already depends on the new lock.
  OK, this is a theoretical deadlock since mqueue (virtual) filesystem cannot
really be frozen. But we should convert the mqueue code to deal with new
lock ordering of i_mutex and mnt_want_write() anyway to make lockdep happy
if anything... That file somehow escaped my conversion efforts. I'll send a
fix tomorrow.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
