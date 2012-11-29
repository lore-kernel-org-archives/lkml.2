Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2K2Ghu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:37:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44945 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2K2Ght (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:37:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121129063043.GJ4939@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
 <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com> <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com> <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
 <20121129062519.GI4939@ZenIV.linux.org.uk> <20121129063043.GJ4939@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 22:37:27 -0800
X-Google-Sender-Auth: uScnX1nBuB6JdGPbbyt0lSgv_B8
Message-ID: <CA+55aFwL9-yOfCHskXyiCJ3YKB0MgaOJ5-XrvWBtH+URCowfcg@mail.gmail.com>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Note that sync_blockdev() a few lines prior to that is good only if we
> have no other processes doing write(2) (or dirtying the mmapped pages,
> for that matter).  The window isn't too wide, but...

So with Mikulas' patches, the write actually would block (at write
level) due to the locking. The mmap'ed patches may be around and
flushed, but the logic to not allow currently *active* mmaps (with the
rather nasty random -EBUSY return value) should mean that there is no
race.

Or rather, there's a race, but it results in that EBUSY thing.

With my simplfied locking, the sync_blockdev() is right before (not a
few lines prior) to the kill_bdev(), and in a perfect world they'd
actually be one single operation ("write back and invalidate pages
with the wrong block-size"). But they aren't.

                Linus
