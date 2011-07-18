Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1GRUZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:25:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab1GRUZK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:25:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110718194703.GI11013@ZenIV.linux.org.uk>
References: <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
 <alpine.LSU.2.00.1107181135170.2722@sister.anvils> <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
 <20110718194703.GI11013@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jul 2011 13:24:47 -0700
Message-ID: <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 12:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Huh?  We do __d_drop() in there, and do that before we start messing
> with ->d_inode.

Hmm. Yes, looking at it, the ordering all seems correct. But then what
did Hugh see at all?

The inode thing he got from d_inode is re-verified by
__d_lookup_rcu(). So if inode is NULL, that means that the other CPU
has done dentry_iput(), which means that __d_drop has already
happened, which means that the dentry has been removed from the hash
list *and* the count has been incremented.

So just judging by Hugh's thing, something is wrong there. Some
missing barrier, perhaps. But write_seqcount_barrier() does seem to
have the write barrier, and the __d_lookup_rcu() read barrier check is
using the proper "full" read barrier too.

So in order for __d_lookup_rcu() to return a NULL inode, we have the
following requirements:
 - it needs to find the dentry (duh)
 - the dentry sequence count gets read (proper read barrier after this)
 - the dentry must still look hashed
 - the dentry->d_inode must be NULL
 - and the dentry sequence count gets re-read (proper read barrier
before this) and must match.

And right now I don't see how that can happen, exactly because
__d_lookup_rcu does the sequence point check. But that's what Hugh's
patch depends on: seeing a NULL d_inode race.

If we see d_inode being NULL, that means that the first sequence
number read must happen *after* we've set d_inode to NULL in
dentry_iput(), which happens *after* we've done the sequence number
increment. That part is fine: that means that the sequence numbers
will match (because both of them are the "later" one). No
inconsistency so far. d_inode being NULL is perfectly compatible with
no sequence number change, and that was what I thought was a bug in
this area at first.

But if the first sequence number read (the read_seqcount_begin() in
__d_lookup_rcu()) sees the later sequence number, that means that
__d_drop has already happened, and it should *also* see the
dentry->d_hash.pprev = NULL; that happened in __d_drop before the
dentry_rcuwalk_barrier(). We have both the read barrier in the
read_seqcount_begin() and the write barrier in the
dentry_rcuwalk_barrier() to guarantee that.

But if the __d_lookup_rcu() sees that, then the d_unhashed() should
have seen the NULL pprev pointer, and not ever returned the dentry,
because that __d_lookup_rcu() loop does

                if (d_unhashed(dentry))
                        continue;

after reading the sequence count.

So how could Hugh's NULL inode ever happen in the first place? Even
with the current sources? It all looks solid to me now that I look at
all the details.

                           Linus
