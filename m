Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2IRQZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:25:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65330 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2IRQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:25:27 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com
Subject: Re: [PATCH 1/2] vfs: dcache: fix deadlock in tree traversal
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
	<20120917203946.GV13973@ZenIV.linux.org.uk>
	<CA+55aFxeghUVxiFS=P+ck_BCnOuMm=HFAkqTBccxJoubk96afQ@mail.gmail.com>
	<87obl3z8jn.fsf@tucsk.pomaz.szeredi.hu>
	<CA+55aFxJKQMjGm00kBpj30twj1w60Mx4C0mXTJtHiJPOpu-iMA@mail.gmail.com>
Date: Tue, 18 Sep 2012 18:27:02 +0200
In-Reply-To: <CA+55aFxJKQMjGm00kBpj30twj1w60Mx4C0mXTJtHiJPOpu-iMA@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 18 Sep 2012 08:56:46 -0700")
Message-ID: <87haqvz489.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Sep 18, 2012 at 7:53 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> Yes, with the test cases that IBM were using it is DCACHE_DISCONNECTED
>> case that triggers the double-lock.  Trond was misusing
>> DCACHE_DISCONNECTED and this made the failure in try_to_ascend() much
>> more likely (and bogus).  But there is a case, which is triggered rarely
>> if ever, when try_to_ascend() failure with rename_lock held is perfectly
>> valid.
>
> Ok. The whole DCACHE_DISCONNECTED logic there is clearly bogus and
> results in endless loops if that case then ever triggers, but you fix
> that in the second patch.
>
> HOWEVER. Why introduce that new DCACHE_KILLED flag at all? Wouldn't it
> be much better to just check whether the dentry is hashed instead of
> introducing a new flag for this case? Couldn't we just check for
> "d_unhashed()"?

Not good, because an unhashed dentry can stay around and that would mean
that we'd need to restart the walk until the last ref to the dentry is
dropped (which can be an arbitrary long time).

Look at commit c83ce989.  Before that patch try_to_ascend() was using
old->d_parent != NULL (implicit in the "new != old->d_parent" test) to
test for the dentry being killed.  I think we need to keep that logic,
and using a dentry flag for that looks simple enough.

Thanks,
Miklos
