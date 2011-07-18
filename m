Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1GRWny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:43:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1GRWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:43:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=kMYS/ZBIMZjSb3XufD99RGu71CcriuIMvT9QDjHcye4jJNOKyiQ7iasyNiYkawSE/
	JuNE+8dI62LwtlAcuh3Gg==
Date: Mon, 18 Jul 2011 15:43:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1107181533590.3909@sister.anvils>
References: <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com> <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk> <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
 <20110718020818.GW11013@ZenIV.linux.org.uk> <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com> <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com> <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com> <20110718194703.GI11013@ZenIV.linux.org.uk> <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com> <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
 <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Linus Torvalds wrote:
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

Yes, that looks like THE right fix to me, making others irrelevant.
But I haven't tested it either, won't begin to do so until tonight.
And I fear I won't notice if there's any silly little bug in there,
which forces every fast RCU lookup to go the slow way instead!

Inlined for the benefit of wider scrutiny:

 fs/namei.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 5c867dd1c0b3..b9cd558a00be 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -938,11 +938,12 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 {
 	for (;;) {
 		struct vfsmount *mounted;
+		unsigned int seq;
+
 		/*
 		 * Don't forget we might have a non-mountpoint managed dentry
 		 * that wants to block transit.
 		 */
-		*inode = path->dentry->d_inode;
 		if (unlikely(managed_dentry_might_block(path->dentry)))
 			return false;
 
@@ -952,9 +953,25 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		mounted = __lookup_mnt(path->mnt, path->dentry, 1);
 		if (!mounted)
 			break;
+		seq = read_seqcount_begin(&mounted->mnt_root->d_seq);
+
+		/*
+		 * The memory barrier in read_seqcount_begin() is sufficient,
+		 * so we can use __read_seqcount_retry() to check the prev
+		 * sequence numbers.
+		 */
+		if (!__read_seqcount_retry(&path->dentry->d_seq, nd->seq))
+			return false;
 		path->mnt = mounted;
 		path->dentry = mounted->mnt_root;
-		nd->seq = read_seqcount_begin(&path->dentry->d_seq);
+		nd->seq = seq;
+
+		/*
+		 * Update the inode too. We don't need to re-check the
+		 * dentry sequence number here after this d_inode read,
+		 * because a mount-point is always pinned.
+		 */
+		*inode = path->dentry->d_inode;
 	}
 	return true;
 }
