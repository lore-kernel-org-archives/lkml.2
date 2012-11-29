Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2K2SXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:23:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab2K2SXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:23:53 -0500
Date: Thu, 29 Nov 2012 13:23:01 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
In-Reply-To: <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1211291319370.25003@file.rdu.redhat.com>
References: <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk> <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Nov 2012, Linus Torvalds wrote:

> On Wed, Nov 28, 2012 at 2:01 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > This sounds sensible. I'm sending this patch.
> 
> This looks much better.
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
> 
> No RCU grace period crap, no expedited mess, no nothing.
> 
>                       Linus

Yes.

If you remove that percpu rw lock, you also need to rewrite direct i/o 
code.

In theory, block device direct i/o doesn't need buffer block size at all. 
But in practice, it shares a lot of code with filesystem direct i/o, it 
reads the block size multiple times and it crashes if it changes.

Mikulas
