Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1GRTe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:34:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627Ab1GRTeZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com> <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jul 2011 12:33:28 -0700
Message-ID: <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 12:04 PM, Hugh Dickins <hughd@google.com> wrote:
>
> Al has commented on that.  I'd feel more confident with a patch like
> yours, and corrected final check in mine (if we used mine at all)
>        if (!read_seqcount_retry(&path->dentry->d_seq, nd->seq);
> but ignore me, I'm easily confused by mounts ;)

No, I do think I want to do it. So for post-3.0 (likely today ;), my
current plan is to have three commits in this area:

 - the one-liner removal of d_inode = NULL in d_kill (but I'll add a comment)

 - the patch to properly do that dentry sequence number switch-over
across the mount-point traversal

 - And possibly *some* version of your patch.

However, I'm actually looking at __d_lookup_rcu(), and it does the proper

    if (read_seqcount_retry(&dentry->d_seq, *seq))
        goto seqretry;

*after* having pulled the inode pointer out of "dentry->d_inode". So
I'm not actually seeing how the inode pointer could be stale at all
right now, because we do seem to have the sequence number check there!

Which just makes me suspect that it's *another* case of bug in the
dentry_kill() sequence. I think the dentry_rcuwalk_barrier() thing is
crap: it doesn't *cover* the d_inode change with the write lock, it
just puts that "barrier" there, which is bogus. You can get a
successful read of the changed inode without ever failing the read
lock sequence!

                                 Linus
