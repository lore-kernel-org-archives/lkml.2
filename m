Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774Ab2CBBCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:02:15 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50830 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab2CBBCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:02:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.83.42 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <m2ipinq16x.fsf@firstfloor.org>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
 <m2ipinq16x.fsf@firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2012 17:01:52 -0800
X-Google-Sender-Auth: rLDOGDUolt7pwX0oqoOVpIVBL3Y
Message-ID: <CA+55aFw=wwGD=QLmQgfGm+oZR3UyvKBmXdXj+SJtK6pipCe45A@mail.gmail.com>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS
 'namehash' implementation?
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 4:46 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> There should be generally better modern general hash algorithms around,
> like murmur, cityhash or snoopy. Perhaps even the fnv we have in tree,
> but it's somewhat dated by know.
>
> They all have larger code, but if it's really that hot it would be worth
> it.

The quality of our hash function really doesn't seem to be the issue.
In fact, my (other - I've done both cache-hot and cache-cold) profiles
seem to indicate that the only access that ever matters is the first
one (ie the read from the hash table, not the following of the
chains).

I have a dim memory of us playing with the hash function itself long
long ago, and what made a difference was using the right bits from the
"parent" pointer, not the hash of the name itself. That's especially
true since many filenames are really just in the 3-8 character length
thing, so creating a 32-bit hash from that is not going to have lots
of collisions.

We basically have "two hashes": we have the full 32-bit "hash number"
that we compute over the filename (and also compare at lookup time
before we do a name compare), and then we have the "bucket number"
which is the actual hash chain number.

The bucket number is generate from both the filename hash number and
the parent pointer, and then we try to mix bits around with that
GOLDEN_RATIO_PRIME thing. And last time this was an issue, it was the
"mixing bits around" that made a difference to proper bucket use. See
commit 99effef9544e: "[PATCH] dentry and inode cache hash algorithm
performance changes." in the historical BK import by Thomas.

                         Linus
