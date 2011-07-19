Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1GSCIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 22:08:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1GSCIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 22:08:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=vEkTJjqAHdAbRyRvIuzUQaoMlDU6rYopZpDFcdRgfs3QzCKM/72ZXlvG5cagjTYx7
	PAXxyZ9MV3ZNUGXZJmk2g==
Date: Mon, 18 Jul 2011 19:07:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <20110718234012.GL11013@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.1107181903350.23830@sister.anvils>
References: <alpine.LSU.2.00.1107181135170.2722@sister.anvils> <CA+55aFycZL9zAE_Qvq9LM=HpugiDuKSjdRhKG1zi=H4LnNvhVQ@mail.gmail.com> <20110718194703.GI11013@ZenIV.linux.org.uk> <CA+55aFzCeXOs9Rj5U5mMWqMZpv+jM14O2VnpFCodMJzaB1hPEg@mail.gmail.com>
 <alpine.LSU.2.00.1107181407060.3530@sister.anvils> <CA+55aFxq1KZycxXCwLARv0WOYG_-aim=e9kt=eLcNuymmeoyiA@mail.gmail.com> <alpine.LSU.2.00.1107181533590.3909@sister.anvils> <20110718231738.GJ11013@ZenIV.linux.org.uk> <20110718232114.GK11013@ZenIV.linux.org.uk>
 <CA+55aFzAK52MZXs1ZAdJhnKgnO8OnzUggvS67VUP4mgiYHi5kQ@mail.gmail.com> <20110718234012.GL11013@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011, Al Viro wrote:
> On Mon, Jul 18, 2011 at 04:27:53PM -0700, Linus Torvalds wrote:
> > On Mon, Jul 18, 2011 at 4:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Linus, are you OK with me slapping your s-o-b on it?
> > 
> > Yup.
> > 
> > And it feels so right that I think we should just do it for 3.0.

It looked sane, but in fact was insane.  Enough testing for now,
I say it's good to go, if you fold in this small adjustment...

[PATCH] fix sense of __read_seqcount_retry test

Hah, good thing I hacked something in to check we're going the quick
way: __read_seqcount_retry() returns *true* when a retry is needed.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.0-git+/fs/namei.c	2011-07-18 18:31:36.273731128 -0700
+++ linux/fs/namei.c	2011-07-18 18:32:35.158022444 -0700
@@ -960,7 +960,7 @@ static bool __follow_mount_rcu(struct na
 		 * so we can use __read_seqcount_retry() to check the prev
 		 * sequence numbers.
 		 */
-		if (!__read_seqcount_retry(&path->dentry->d_seq, nd->seq))
+		if (__read_seqcount_retry(&path->dentry->d_seq, nd->seq))
 			return false;
 		path->mnt = mounted;
 		path->dentry = mounted->mnt_root;
