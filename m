Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1GRVUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:20:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36587 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1GRVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:20:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=HjrH7k2DFE78I+Q5DOKdo/31rYueHq3nBHiQEBneURWkE6QgcEB4ksPpI/wk0lmCe
	Osq3QXXWQTWaRcd2m+ZrA==
Date: Mon, 18 Jul 2011 14:19:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1107181407060.3530@sister.anvils>
References: <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com> <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk> <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
 <20110718020818.GW11013@ZenIV.linux.org.uk> <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com> <CA+55aFxKRw8NxcHKzsSeCX3ud6eDrcQvAX+LMQOUT4p5TPLp5g@mail.gmail.com> <alpine.LSU.2.00.1107181135170.2722@sister.anvils>
 <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com> <20110718194703.GI11013@ZenIV.linux.org.uk> <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1603776959-1311023996=:3530"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1603776959-1311023996=:3530
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 18 Jul 2011, Linus Torvalds wrote:
> On Mon, Jul 18, 2011 at 12:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote=
:
> >
> > Huh? =A0We do __d_drop() in there, and do that before we start messing
> > with ->d_inode.
>=20
> Hmm. Yes, looking at it, the ordering all seems correct. But then what
> did Hugh see at all?
>=20
> The inode thing he got from d_inode is re-verified by
> __d_lookup_rcu(). So if inode is NULL, that means that the other CPU
> has done dentry_iput(), which means that __d_drop has already
> happened, which means that the dentry has been removed from the hash
> list *and* the count has been incremented.

__d_lookup_rcu() is being careful about *inode, yes.

But I'd forgotten it was even setting it: doesn't that setting get
overridden later by the more careless *inode =3D path->d_entry->d_inode
at the head of __follow_mount_rcu()'s loop?

Perhaps that line just needs to be moved to the tail of the loop?

Hugh
--8323584-1603776959-1311023996=:3530--
