Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1GRTEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:04:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1GRTE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:04:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=dOZMfnDx1TI0GFZLbVhfE1P1ZxkgEoP0J26aVUFGjLrsYfZDKrGwmdRJcAoKUIhwj
	Q+0Ac/VGd85B2KL5sjqwA==
Date: Mon, 18 Jul 2011 12:04:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils> <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com> <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk> <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk> <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Linus Torvalds wrote:
> On Sun, Jul 17, 2011 at 11:31 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Now, I do agree that maybe that case simply should check the dentry
> > sequence count. I wish all cases did. Hugh patch did that. But the
> > reason I dislike Hugh's patch is that when I say "I wish they all
> > did", I mean that I dislike the special casing. And Hugh's patch just
> > adds *more* special casing for that NULL entry - I'd wish we just
> > always did it regardless of whether it was NULL or not.
> 
> Btw, looking at that, I think Hugh's patch is wrong. It does
> 
>   if (!read_seqcount_retry(&dentry->d_seq, nd->seq))
> 
> but that's after we've done the __follow_mount_rcu() that may actually
> have changed "nd->seq" to the mount-point inode (and has changed
> path->dentry to match it).

Yes, my patch is wrong there.  I started out with
	if (!read_seqcount_retry(&dentry->d_seq, seq);
but seeing __follow_mount_rcu() updates inode and nd->seq, I changed to
	if (!read_seqcount_retry(&dentry->d_seq, nd->seq);
missing the obvious, that it's changing path->dentry when it updates nd->seq.

> 
> Now, it only does it if inode is NULL, so I guess it doesn't matter,
> but it's the kind of inconsistency that I think is really dangerous,
> because it basically compares incompatible sequence numbers.

Yes, it's simply wrong.

> 
> Also, looking at that whole mount-point traversal sequence, it looks
> like __follow_mount_rcu() will happily totally ignore the old sequence
> number when it replaces it with the mount-point sequence number. So it
> looks to me that we have a case where we miss the sequence number
> check that can happen with a positive dentry too!

Al has commented on that.  I'd feel more confident with a patch like
yours, and corrected final check in mine (if we used mine at all)
	if (!read_seqcount_retry(&path->dentry->d_seq, nd->seq);
but ignore me, I'm easily confused by mounts ;)

Hugh
