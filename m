Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1GRTJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:09:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab1GRTI7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:08:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110718182030.GF11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com> <20110718182030.GF11013@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jul 2011 12:08:04 -0700
Message-ID: <CA+55aFw+RwscYUocP0WYWTU=F+Udx+AsjMA0i63-D-y3iZKCTQ@mail.gmail.com>
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

On Mon, Jul 18, 2011 at 11:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> ->mnt_mountpoint and ->mnt_root are both pinned (and protected by
> vfsmount_lock, while we are at it).  If it manages to get stale,
> we have worse problems...

I'm not worried about the inode itself being stale as much as the
*name* being stale, ie the whole "what happens if dentry->d_name is
being changed concurrently with lookup" issue.

But I do agree that it's very unlikely to actually cause problems.
People just don't move mount points around, and the race would seem to
be ridiculously hard to ever hit even if you tried to create some
totally artificial load that does nothing but rename mount-points ;)

That said, the reason I think we should do this is that (a) it's
really cheap to check the sequence numbers and (b) we should just make
it a rule that whenever you set up the next sequence number for
lookup, you should check the previous one (and do it in the right
order - you need to check the previous one *after* you've done the
read_seqcont_begin() for the next one, so that the sequence number
checks always "overlap").

So the patch is essentially a free "fix things to follow the general rules".

But I think I'm on the same page with Hugh that at this point none of
these issues are even remotely recent, they are basically impossible
to hit, and the fixes are likely potentially more dangerous than the
bugs they fix, so I'll release 3.0 without them and just apply the
fixes (and cc stable) afterwards.

                                 Linus
