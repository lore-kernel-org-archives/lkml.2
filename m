Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab2K2WhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:37:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2K2Wg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:36:59 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
References: <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
 <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <20121128194314.GF4939@ZenIV.linux.org.uk> <Pine.LNX.4.64.1211281630150.5283@file.rdu.redhat.com>
 <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny> <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny> <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny> <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Nov 2012 14:36:38 -0800
X-Google-Sender-Auth: xYb3Vb6LEq_kXo0DQFUpVj5Zojs
Message-ID: <CA+55aFwoM3wje+XS60=kE3eVndWQD6szfgYa9MyfSp=itdr9Vg@mail.gmail.com>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
To: Chris Mason <chris.mason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 2:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But you're right. The direct-IO code really *is* violating that, and
> knows that get_block() ends up being defined in i_blkbits regardless
> of b_size.

It turns out fs/ioctl.c does the same - it fills in the buffer head
with some random bh->b_size too. I think it's not even a power of two
in that case.

And I guess it's understandable - they don't actually *use* the
buffer, they just want the offset. So the b_size field really is just
random crap to the users of the get_block interfaces, since they've
never cared before.

Ugh, this was definitely a dark and disgusting underbelly of the VFS
layer. We've not had to really touch it for a *looong* time..

               Linus
