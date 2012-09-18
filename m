Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab2IROwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:52:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62700 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213Ab2IROwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:52:09 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com
Subject: Re: [PATCH 1/2] vfs: dcache: fix deadlock in tree traversal
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
	<20120917203946.GV13973@ZenIV.linux.org.uk>
	<CA+55aFxeghUVxiFS=P+ck_BCnOuMm=HFAkqTBccxJoubk96afQ@mail.gmail.com>
Date: Tue, 18 Sep 2012 16:53:48 +0200
In-Reply-To: <CA+55aFxeghUVxiFS=P+ck_BCnOuMm=HFAkqTBccxJoubk96afQ@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 17 Sep 2012 15:09:39 -0700")
Message-ID: <87obl3z8jn.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Sep 17, 2012 at 1:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Egads...  The problem is real and analysis, AFAICS, is correct, but result
>> is extremely ugly ;-/
>
> Agreed.
>
> The problem (or at least one *part* of the problem) is that the "goto
> rename_retry" case is done for two different entities entirely:
>
>  - the "try_to_ascend()" failure path, which can happen even when
> renamelock is held for writing.
>
>  - the "if we weren't write-locked before, and the read-lock failed"
> case (which obviously cannot happen if we already held things for
> writing)
>
> That said, I'm not sure why/how that try_to_ascend() could even fail
> when we're holding things locked. I guess it's the DCACHE_DISCONNECTED
> case that triggers.

Yes, with the test cases that IBM were using it is DCACHE_DISCONNECTED
case that triggers the double-lock.  Trond was misusing
DCACHE_DISCONNECTED and this made the failure in try_to_ascend() much
more likely (and bogus).  But there is a case, which is triggered rarely
if ever, when try_to_ascend() failure with rename_lock held is perfectly
valid.

try_to_ascend() does an ellaborate locking dance that aims to ensure
that child remains valid after having ascended to parent.  It nees a
valid child because it needs the next sibling to continue tree
traversal.  If the child becomes invalid (final dput()) then the whole
tree traversal needs to be restarted since we don't know where we left
off. So we basically do

 1. take the RCU lock
 2. unlock child
 3. lock parent
 4. check whether child has been freed, if yes restart traversal
 5. release RCU
 6. find next sibling (child->d_child.next)
 7. lock new child

It is step 4. that needs the RCU guarantees so we can check child's
dentry flag (DCACHE_DISCONNECTED flag presently).  After that d_lock on
parent will protect "child" from going away (d_kill or d_move) and we
can get hold of the next sibling.

Thanks,
Miklos

