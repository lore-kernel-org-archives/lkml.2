Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab2AJKFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:05:42 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38988 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2AJKFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:05:40 -0500
MIME-Version: 1.0
X-Originating-IP: [94.21.63.111]
In-Reply-To: <CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
	<20120109171639.GA9359@infradead.org>
	<20120109173010.GX23916@ZenIV.linux.org.uk>
	<CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
	<20120109205907.GE4198@dastard>
	<CA+55aFxN+Yh_M=P8cVbGcuHGo+PgcXm1bOFAJQ-5_euqU9LOww@mail.gmail.com>
	<20120110013434.GA23916@ZenIV.linux.org.uk>
	<CA+55aFzGe6sG0QotpqGpmNJ-HXqMxR5ocmXzvO2wdN_-MnARfA@mail.gmail.com>
Date: Tue, 10 Jan 2012 11:05:39 +0100
Message-ID: <CAJfpegu6BrLbmMSbf0QnKRe5rq0HgZYtYBEW8F+qehZC9GpQ8w@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 3:02 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 9, 2012 at 5:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> Dave Chinner (1):
>>      dcache: use a dispose list in select_parent
>
> Hmm. Should this also have been marked for stable? I'm assuming that
> the possible deadlock (strictly speaking it's a livelock, I guess?)

I tested Dave's patch and the bug can still be easily reproduced.

And that's to be expected, as the intermediate "being on the lru"
state that Dave's patch eliminates doesn't play a fundamental part in
the mechanism of the livelock.  It does eliminate one trylock, but
that's not the one critical to this bug (removing it is a very good
idea anyway).

The critical trylock here is the one in dentry_kill() which tries to
lock the parent.  That is basically guaranteed to fail if there are
more then one instances of shrink_dcache_parent() running on the same
dentry, because select_parent() holds that parent lock for a
relatively long time.

With Dave's patch the livelock becomes like this (basically the same
as without the patch):

1 - CPU0: select_parent(P) finds C and puts it on dispose list, returns 1

2 - CPU1: select_parent(P) locks P->d_lock

3 - CPU0: shrink_dentry_list() locks C->d_lock
   dentry_kill(C) tries to lock P->d_lock but fails, unlocks C->d_lock

4 - CPU1: select_parent(P) locks C->d_lock,
         moves C from dispose list being processed on CPU0 to new
dispose list, returns 1

5 - CPU0: shrink_dentry_list() finds dispose list empty, returns

6 - Goto 2 with CPU0 and CPU1 switched

Thanks,
MIklos
