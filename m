Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2IQWKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 18:10:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59972 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab2IQWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 18:10:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120917203946.GV13973@ZenIV.linux.org.uk>
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu> <20120917203946.GV13973@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Sep 2012 15:09:39 -0700
X-Google-Sender-Auth: TaJE2N-xH3yqCTialqaW2TF53ys
Message-ID: <CA+55aFxeghUVxiFS=P+ck_BCnOuMm=HFAkqTBccxJoubk96afQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] vfs: dcache: fix deadlock in tree traversal
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        Trond.Myklebust@netapp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 1:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Egads...  The problem is real and analysis, AFAICS, is correct, but result
> is extremely ugly ;-/

Agreed.

The problem (or at least one *part* of the problem) is that the "goto
rename_retry" case is done for two different entities entirely:

 - the "try_to_ascend()" failure path, which can happen even when
renamelock is held for writing.

 - the "if we weren't write-locked before, and the read-lock failed"
case (which obviously cannot happen if we already held things for
writing)

That said, I'm not sure why/how that try_to_ascend() could even fail
when we're holding things locked. I guess it's the DCACHE_DISCONNECTED
case that triggers.

So I'll ignore this series for now, hoping that Al will send a nicer
version. Al, Miklos, please make sure this issue doesn't get dropped
by mistake.

            Linus
