Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab1GRSUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 14:20:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43777 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1GRSUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 14:20:35 -0400
Date: Mon, 18 Jul 2011 19:20:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110718182030.GF11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk>
 <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils>
 <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
 <20110718020818.GW11013@ZenIV.linux.org.uk>
 <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
 <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:11:40AM -0700, Linus Torvalds wrote:

> Also, looking at that whole mount-point traversal sequence, it looks
> like __follow_mount_rcu() will happily totally ignore the old sequence
> number when it replaces it with the mount-point sequence number. So it
> looks to me that we have a case where we miss the sequence number
> check that can happen with a positive dentry too!
> 
> No?
> 
> So I think that whenever we change "nd->seq", we should always heck
> the previous sequence number first (the way do_lookup() itself does
> for the *normal* traversal case). Otherwise we will have traversed the
> mount-point without ever having checked the previous sequence number.
> 
> Something like the (untested) attached patch.
> 
> Comments? This mount-point case is independent of the negative dentry
> issue, and probably never really an issue in practice, but...

->mnt_mountpoint and ->mnt_root are both pinned (and protected by
vfsmount_lock, while we are at it).  If it manages to get stale,
we have worse problems...
