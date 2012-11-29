Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2K2TCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:02:41 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55396 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab2K2TCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:02:39 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
References: <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk> <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 11:02:17 -0800
X-Google-Sender-Auth: UbKbXkNQ34ndJ4QwZOFyAfu4QQ4
Message-ID: <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 9:19 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think I'll apply this for 3.7 (since it's too late to do anything
> fancier), and then for 3.8 I will rip out all the locking entirely,
> because looking at the fs/buffer.c patch I wrote up, it's all totally
> unnecessary.
>
> Adding a ACCESS_ONCE() to the read of the i_blkbits value (when
> creating new buffers) simply makes the whole locking thing pointless.
> Just make the page lock protect the block size, and make it per-page,
> and we're done.

There's a 'block-dev' branch in my git tree, if you guys want to play
around with it.

It actually reverts fs/block-dev.c back to the 3.6 state (except for
some whitespace damage that I refused to re-introduce), so that part
of the changes should be pretty safe and well tested.

The fs/buffer.c changes, of course, are new. It's largely the same
patch I already sent out, with a small helper function to simplify it,
and to keep the whole ACCESS_ONCE() thing in just a single place.

That branch may be re-based in case I get reports or acks or whatever,
so don't rely on it (or if you do, please let me know, and I'll stop
editing it).

The fact that I could just revert the fs/block-dev.c part to a known
state makes me wonder if this might be safe for 3.7 after all (the
fs/buffer.c changes all *look* safe). That way we'd not have to worry
about any new semantics (whether they be EBUSY or any possible locking
slowdowns or RT issues). But I'll think about it, and it would be good
for people to double-check my fs/buffer.c stuff.

Mikulas, does that pass your testing?

               Linus
