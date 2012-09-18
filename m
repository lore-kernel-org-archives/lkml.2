Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab2IRP5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 11:57:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61755 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab2IRP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 11:57:08 -0400
MIME-Version: 1.0
In-Reply-To: <87obl3z8jn.fsf@tucsk.pomaz.szeredi.hu>
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu> <20120917203946.GV13973@ZenIV.linux.org.uk>
 <CA+55aFxeghUVxiFS=P+ck_BCnOuMm=HFAkqTBccxJoubk96afQ@mail.gmail.com> <87obl3z8jn.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Sep 2012 08:56:46 -0700
X-Google-Sender-Auth: HT01D-ncgswzf7GejcbARNkZDg8
Message-ID: <CA+55aFxJKQMjGm00kBpj30twj1w60Mx4C0mXTJtHiJPOpu-iMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: dcache: fix deadlock in tree traversal
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 7:53 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Yes, with the test cases that IBM were using it is DCACHE_DISCONNECTED
> case that triggers the double-lock.  Trond was misusing
> DCACHE_DISCONNECTED and this made the failure in try_to_ascend() much
> more likely (and bogus).  But there is a case, which is triggered rarely
> if ever, when try_to_ascend() failure with rename_lock held is perfectly
> valid.

Ok. The whole DCACHE_DISCONNECTED logic there is clearly bogus and
results in endless loops if that case then ever triggers, but you fix
that in the second patch.

HOWEVER. Why introduce that new DCACHE_KILLED flag at all? Wouldn't it
be much better to just check whether the dentry is hashed instead of
introducing a new flag for this case? Couldn't we just check for
"d_unhashed()"?

Anyway, I don't hate the 2/2 thing, but these are clearly related, and
I'd like to understand why we had that odd DCACHE_DISCONNECTED test in
the first place when there *seems* to be more straightforward
approaches to it?

              Linus
