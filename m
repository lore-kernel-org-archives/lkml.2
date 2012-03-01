Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965541Ab2CAROg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:14:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40749 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab2CAROf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:14:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.85.35 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301165726.GF23916@ZenIV.linux.org.uk>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
 <20120301165726.GF23916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2012 09:14:13 -0800
X-Google-Sender-Auth: mtaVNwRfHzO8IuGlIRNHS5IxknY
Message-ID: <CA+55aFzxWifxyFSpQfuztmOiyBQpYfiM560DWXoooZ8j8p3fYw@mail.gmail.com>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS
 'namehash' implementation?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 8:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> As long as full_name_hash() is still around, any such filesystem is welcome
> to use it for ->d_hash() and STFU.

Well, I'd make full_name_hash() match the new hash model, so no, they
couldn't use that. They'd have to actually implement the old hash, and
make it "their hash".

Also note that the hash model would have to become dependent on config
options: doing things a word at a time really only works well on
architectures that have fast unaligned accesses, and even on those
archtiectures it really doesn't work if you enable
CONFIG_DEBUG_PAGE_ALLOC.

> Note that there are places like this one (in btrfs_real_readdir())
>                        q.name = name_ptr;
>                        q.len = name_len;
>                        q.hash = full_name_hash(q.name, q.len);
>                        tmp = d_lookup(filp->f_dentry, &q);
> and they _will_ need to be updated if we switch the default.

I don't agree that it will need to be updated - I was planning on just
updating full_name_hash() to always match. That part is easy and
obvious.

So this I don't have any issue with. It's only if you actually save
the default VFS hash to disk (or network), since it will change
between reboots or between different machines.

> I'd be more
> worried about that kind of breakage, TBH, than anything leaking hash
> on disk without bothering to calculate it manually (if nothing else,
> finn_name_hash() is not endian-neutral, so any such place is buggy for
> another reason already).

No, full_name_hash() is perfectly endian-safe - currently. It does
everything one character at a time, and it acts as if it was all done
in 32 bits (even if it internally looks like it is calculating hashes
in "unsigned long" - the math is all stable in 32 bits and at the end
it is truncated down).

Now, of course, any disk respresentation would have to store the value
in some particular endianness, but that's no different from any other
number that FS would store.

But if I actually go ahead and do a word-at-a-time hash thing, that
hash value really fundamentally will depend on endianness. But since
it will depend on config options and on architecture details too,
that's the least of the problems with using that for anything
"stable". The new hash would literally only be useful *inside* the
kernel, and really only for looking up names on the hash lists.

                  Linus
