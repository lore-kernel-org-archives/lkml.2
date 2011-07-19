Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab1GSXp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:45:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46713 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1GSXp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:45:56 -0400
Date: Wed, 20 Jul 2011 00:45:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110719234550.GR11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
 <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk>
 <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 02:42:51PM -0700, Linus Torvalds wrote:
> On Mon, Jul 18, 2011 at 2:19 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > __d_lookup_rcu() is being careful about *inode, yes.
> >
> > But I'd forgotten it was even setting it: doesn't that setting get
> > overridden later by the more careless *inode = path->d_entry->d_inode
> > at the head of __follow_mount_rcu()'s loop?
> >
> > Perhaps that line just needs to be moved to the tail of the loop?
> 
> Ahh. Bingo. Yes, I think you found it.
> 
> I don't think it should touch that *inode value in
> __follow_mount_rcu() unless we actually followed a mount, exactly
> because it will overwrite the thing that we were so careful about in
> __d_lookup_rcu().
> 
> So how about this patch that replaces the earlier mount-point sequence
> number one. The only difference is (as you mention) to just do the
> *inode update at the end of the loop, so that we don't overwrite the
> valid inode data with a non-checked one when we don't do anything.
> 
> Untested. But this should make my propised change to fs/dcache.c be
> irrelevant, because whether we clear d_inode or not, the existing
> sequence number checks will catch it. Agreed?

You know what...  I doubt that you want to mess with ->d_seq checks here.
It's definitely not Hugh's bug (unless he has bindings somewhere odd) and
both ->mnt_mountpoint and ->mnt_root are pinned (and we are holding
vfsmount_lock anyway).  *inode assignment too early is a real bug, indeed,
and we want to assign nd->seq if we cross mountpoint as both versions do,
but check just before that is, in the best case, BUG_ON() fodder.  We'd
just found a vfsmount with ->mnt_mountpoint equal to path->dentry; it *can't*
be stale, or we have a really nasty problem anyway.
