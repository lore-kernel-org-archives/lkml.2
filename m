Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1FTP4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:56:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab1FTP4a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <20110619235147.GQ11521@ZenIV.linux.org.uk>
References: <20110619235147.GQ11521@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Jun 2011 08:55:38 -0700
Message-ID: <BANLkTimdPT2dbTToTHGVzJr=f3xPKT9tZw@mail.gmail.com>
Subject: Re: [RFC] get_write_access()/deny_write_access() without inode->i_lock
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 4:51 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        I'm seriously tempted to throw away i_lock uses in
> {get,deny}_write_access(), as in the patch below.  The question is, how
> badly will it suck on various architectures?  I'd expect it to be not
> worse than the current version, but...

It might be worse, because doing a read-before-write can turn a single
cache operation ("get for write") into multiple cache operations ("get
for read" followed by "make exclusive").

We had that exact issue with some other users of the "read + cmpxchg" model.

The way we fixed it before was to simply omit the read, and turn that
into a "guess".

In other words, I'd suggest you get rid of the "atomic_read()"
entirely, and just assume that the write counter was zero to begin
with. Even if that is a wrong assumption (and it probably isn't all
that wrong), it can actually be more efficient to essentiall go
through the loop twice: the first time yoou use the cmpxchg as just an
odd way to do a read. It basically bcomes a read-with-write-intent,
and solves the cacheline issue.

At that point, it's likely faster in pretty much all cases except for
UP (where the spinlocks just go away, and "cmpxchg" is slower than
normal code).

                  Linus
