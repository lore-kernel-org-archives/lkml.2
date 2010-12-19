Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0LSRGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 12:06:49 -0500
Received: from science.horizon.com ([71.41.210.146]:37276 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756226Ab0LSRGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 12:06:48 -0500
Date: 19 Dec 2010 12:06:46 -0500
Message-ID: <20101219170646.482.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, npiggin@gmail.com
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Cc: bharrosh@panasas.com, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikwUEBd1Ez75pQ7gw7ShZitwQOQcH6CvCdJV2np@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First, a byte-by-byte strcpy_from_user of the whole name string to
> kernel space. Then a byte-by-byte chunking and hashing component
> paths according to '/'. Then a byte-by-byte memcmp against the
> dentry name.

Well, you've put your finger on the obvious place to to the aligned copy,
if you want.  Looking into it, I note that __d_lookup() does a 32-bit
hash compare before doing a string compare, so the memcmp should almost
always succeed.  (Failures are due to hash collisions and rename races.)

> I'd love to do everything with 8 byte loads, do the component
> separation and hashing at the same time as copy from user, and
> have the padded and aligned component strings and their hash
> available... but complexity.

It actually doesn't seem that difficult to do in fs/namei.c:do_getname
via a heavily hacked strncpy_from_user.  Call it strhash_from_user, and
it copies the string, while accumulating the hash and the length,
until it hits a nul or /.  It has to return the length, the hash,
and the termination condition: nul, /, or space exhausted.

Then you could arrange for each component to be padded so that it
starts aligned.

(The hash and length can be stored directly in the qstr.  The length is
only otherwise needed for components that end in /, so you could return
a magic negative length in those cases.)

If it matters, Bob Jenkins wrote a "one-at-a-time" hash function
that is actually sligthy less work per character than the current
partial_name_hash.  (Two shifts, two adds and a *11 gets turned into
two shifts, two adds, and and an XOR)

static inline u32 __attribute__((const))
partial_name_hash(unsigned char c, u32 hash)
{
	hash += c;
	hash += hash << 10;
	hash ^= hash >> 6;
	return hash;
}

static inline u32 end_name_hash(u32 hash)
{
	hash += hash << 3;
	hash ^= hash >> 11;
	hash += hash << 15;
	return hash;
}

(I note that there's zero reason for the current partial_name_hash to
use an unsigned long intermediate value, since the high 32 bits have no
effect on the final result.  It just forces unnecessary REX prefixes.)

The main problem with initializing all the qstr structures early is that
it can lead to an oddly dynamic PATH_MAX and/or a type of kernel
DOS by passing in paths with many short directory names that would need
maximal padding.

> On my Westmere system, time to do a stat is 640 cycles plus 10
> cycles for every byte in the string (this cost holds perfectly
> from 1 byte name up to 32 byte names in my test range).
> `git diff` average path name strings are 31 bytes, although this
> is much less cache friendly, and over several components (my
> test is just a single component).

Thank you for this useful real-world number!
I hadn't realized the base cost was so low.
