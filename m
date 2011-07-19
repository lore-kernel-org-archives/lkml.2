Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1GSXwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:52:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38074 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1GSXwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:52:19 -0400
Date: Wed, 20 Jul 2011 00:52:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, neilb@suse.de
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110719235215.GS11013@ZenIV.linux.org.uk>
References: <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk>
 <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
 <20110719234550.GR11013@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719234550.GR11013@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 12:45:51AM +0100, Al Viro wrote:

> You know what...  I doubt that you want to mess with ->d_seq checks here.
> It's definitely not Hugh's bug (unless he has bindings somewhere odd) and
> both ->mnt_mountpoint and ->mnt_root are pinned (and we are holding
> vfsmount_lock anyway).  *inode assignment too early is a real bug, indeed,
> and we want to assign nd->seq if we cross mountpoint as both versions do,
> but check just before that is, in the best case, BUG_ON() fodder.  We'd
> just found a vfsmount with ->mnt_mountpoint equal to path->dentry; it *can't*
> be stale, or we have a really nasty problem anyway.

Kudos to neilb for spotting the pointless check, BTW; and no, his theory
that it might be needed since we could race with umount() is wrong - due to
vfsmount_lock being held.
