Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966141Ab2B2Xgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:36:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33520 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028Ab2B2Xgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:36:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.85.35 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Feb 2012 15:36:09 -0800
X-Google-Sender-Auth: Pig_exhkaJCEwLRGgsz-JgZ7K3U
Message-ID: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
Subject: .. anybody know of any filesystems that depend on the exact VFS
 'namehash' implementation?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm doing my normal profiling ("empty kernel build" is my favorite
one), and link_path_walk() and __d_lookup_rcu() remain some of the
hottest kernel functions due to their per-character loops.

I can improve __d_lookup_rcu() on my machine by what appears to be
around 15% by doing things a "unsigned long" at a time (it would be an
option that only works on little-endian and with cheap unaligned
accesses, although the big-endian modifications should be pretty
trivial).

Sure, that optimization would have to be disabled if you do
DEBUG_PAGEALLOC, because it might opportunistically access bytes past
the end of the string, but it does seem to be a very reasonable and
easy thing to do apart from that small detail, and the numbers do look
good.

Basically, dentry_cmp() just becomes

        /* Little-endian with fast unaligned accesses? */
        unsigned long a,b,mask;

        if (scount != tcount)
                return 1;

        for (;;) {
                a = *(unsigned long *)cs;
                b = *(unsigned long *)ct;
                if (tcount < sizeof(unsigned long))
                        break;
                if (a != b)
                        return 1;
                cs += sizeof(unsigned long);
                ct += sizeof(unsigned long);
                tcount -= sizeof(unsigned long);
                if (!tcount)
                        return 0;
        }
        mask = ~(~0ul << tcount*8);
        return !!((a ^ b) & mask);

for that case, and gcc generates good code for it.

However, doing the same thing for link_path_walk() would require that
we actually change the hash function we use internally in the VFS
layer, and while I think that shouldn't really be a problem, I worry
that some filesystem might actually use the hash we generate and save
it somewhere on disk (rather than only use it for the hashed lookup
itself).

Computing the hash one long-word at a time is trivial if we just
change what the hash is. Finding the terminating NUL or '/' characters
that involves some big constants (0x2f2f2f2f2f2f2f2f,
0x0101010101010101 and 0x8080808080808080 but seems similarly fairly
easy. But if filesystems actually depend on our current hash
algorithm, the word-at-a-time model falls apart.

Anybody? I think we've kept the namehash unchanged since very early
on, so I could imagine that somebody has grown to think that it's
"stable". As far as I can tell, the current hash function goes back to
2.4.2 (just over ten years ago).

                       Linus
