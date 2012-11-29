Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2K2Sq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:46:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50587 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2K2Sq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:46:27 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1211291319370.25003@file.rdu.redhat.com>
References: <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk> <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com> <Pine.LNX.4.64.1211291319370.25003@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 10:46:06 -0800
X-Google-Sender-Auth: i3GxHNEhkCjWeB826pPJ2S-t5v8
Message-ID: <CA+55aFzpKH2FkU+9hdhZ5L9n8Mqr1vNO3Tdjmu1n+WmcHG1sNg@mail.gmail.com>
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

On Thu, Nov 29, 2012 at 10:23 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> If you remove that percpu rw lock, you also need to rewrite direct i/o
> code.
>
> In theory, block device direct i/o doesn't need buffer block size at all.
> But in practice, it shares a lot of code with filesystem direct i/o, it
> reads the block size multiple times and it crashes if it changes.

If it's a filesystem, then the size will never change while it is mounted.

So only the direct-block-device case needs to be worried about, no?

And that uses __generic_file_aio_write() and friends, which in turn
use the readpage/writepage functions.

So for block devices, it should be sufficient to make
readpage/writepage (with the writing obviously having all the
"write_begin/write_end/fullpage" variants) be safe as far as I can
see.

                 Linus
