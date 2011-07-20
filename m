Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1GTAri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 20:47:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395Ab1GTArh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 20:47:37 -0400
Date: Wed, 20 Jul 2011 10:47:21 +1000
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110720104721.03a2a2f0@notabene.brown>
In-Reply-To: <20110719235515.GT11013@ZenIV.linux.org.uk>
References: <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
	<CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
	<alpine.LSU.2.00.1107181135170.2722@sister.anvils>
	<CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
	<20110718194703.GI11013@ZenIV.linux.org.uk>
	<CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
	<alpine.LSU.2.00.1107181407060.3530@sister.anvils>
	<CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
	<20110719234550.GR11013@ZenIV.linux.org.uk>
	<20110719235215.GS11013@ZenIV.linux.org.uk>
	<20110719235515.GT11013@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011 00:55:15 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Wed, Jul 20, 2011 at 12:52:16AM +0100, Al Viro wrote:
> > On Wed, Jul 20, 2011 at 12:45:51AM +0100, Al Viro wrote:
> > 
> > > You know what...  I doubt that you want to mess with ->d_seq checks here.
> > > It's definitely not Hugh's bug (unless he has bindings somewhere odd) and
> > > both ->mnt_mountpoint and ->mnt_root are pinned (and we are holding
> > > vfsmount_lock anyway).  *inode assignment too early is a real bug, indeed,
> > > and we want to assign nd->seq if we cross mountpoint as both versions do,
> > > but check just before that is, in the best case, BUG_ON() fodder.  We'd
> > > just found a vfsmount with ->mnt_mountpoint equal to path->dentry; it *can't*
> > > be stale, or we have a really nasty problem anyway.
> > 
> > Kudos to neilb for spotting the pointless check, BTW; and no, his theory
> > that it might be needed since we could race with umount() is wrong - due to
> > vfsmount_lock being held.

Thanks.. but that patch seems to introduce an unused variable "seq".

NeilBrown


> 
> Updated, pushed.  Please, pull from the usual place (
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
> ).
> 
> Shortlog:
> Al Viro (1):
>       Fix cifs_get_root()
> 
> Linus Torvalds (1):
>       vfs: fix race in rcu lookup of pruned dentry
> 
> Diffstat:
>  fs/cifs/cifsfs.c |  100 +++++++++++++++--------------------------------------
>  fs/namei.c       |   10 +++++-
>  2 files changed, 38 insertions(+), 72 deletions(-)

