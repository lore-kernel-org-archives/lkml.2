Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1AQPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 10:25:29 -0500
Received: from pcpool00.mathematik.uni-freiburg.de ([132.230.30.150]:41702
	"EHLO pcpool00.mathematik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617Ab1AQPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 10:25:26 -0500
X-Greylist: delayed 2705 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2011 10:25:25 EST
Date: Mon, 17 Jan 2011 15:39:54 +0100
From: "Bernhard R. Link" 
	<brl+ccmadness@pcpool00.mathematik.uni-freiburg.de>
To: David Miller <davem@davemloft.net>
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110117143954.GA17813@pcpool00.mathematik.uni-freiburg.de>
Mail-Followup-To: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
	609371@bugs.debian.org, ben@decadent.org.uk,
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
	rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
	Jesper.Nilsson@axis.com, jeffm@suse.com
References: <4D302B2F.7030108@oldelvet.org.uk> <4D3074FE.3030707@oldelvet.org.uk> <20110115.211722.39173519.davem@davemloft.net> <20110116.220755.179947617.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110116.220755.179947617.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net> [110117 07:07]:
> Although I've seen commentary to the contrary, in fact using a too-small
> __attribute__((aligned())) directive will lower the alignment of data
> members, and yes that means it will lower the alignemnt to be below the
> natural and required alignment for the given type.
>
> So if you have, on 64-bit:
>
> struct foo {
> 	void *bar;
> };
>
> static struct foo test __attribute__((__aligned__(4)));
>
> The compiler will emit "test" with 4-byte alignment into the data
> section, even though 8-byte alignment is required for "test.bar"
>
> Assuming we wanted that to actually happen, the GCC manual is very
> explicit to state that in order for this to work, such down-aligned
> data structures must also use the "packed" attribute.

The manual seems to have changed in that regard.

http://gcc.gnu.org/onlinedocs/gcc-4.2.4/gcc/Variable-Attributes.html
and earlier versions say:

"The aligned attribute can only increase the alignment; but you can
decrease it by specifying packed as well. See below."

but http://gcc.gnu.org/onlinedocs/gcc-4.3.5/gcc/Variable-Attributes.html
and later versions say:

"When used on a struct, or struct member, the aligned attribute can only
increase the alignment; in order to decrease it, the packed attribute
must be specified as well. When used as part of a typedef, the aligned
attribute can both increase and decrease alignment, and specifying the
packed attribute will generate a warning."

And seems to still be a bit confusing, as an attribute in a
variable declaration seems to count as typedef:

| struct foo {
|         void *bar;
| };
| 
| static struct foo a __attribute__((__aligned__(2)));
| static struct foo b;
| 
| struct foo2 {
|         void *bar;
| } __attribute__((__aligned__(2)));
| 
| static struct foo2 c __attribute__((__aligned__(2)));
| static struct foo2 d;
| 
| struct foo3 {
|         void *bar;
| } __attribute__((__aligned__(2))) __attribute__((__packed__));
| 
| static struct foo3 e;
| 
| int main() {
|         printf("a: %d, b: %d, c: %d, d: %d, e: %d\n",
|                 __alignof__(a), __alignof__(b),
|                 __alignof__(c), __alignof__(d),
|                 __alignof__(e)
|                 );
|         return 0;
| }

gives something like:
a: 2, b: 4, c: 2, d: 4, e: 2
or on sparc64:
a: 2, b: 8, c: 2, d: 8, e: 2

> I think we want none of this, and I think we should elide the align
> directives entirely, or at least fix them so we don't get unaligned
> stuff on 64-bit.

One fix might be to move the __attribute__ from include/trace/ftrace.h
(and from include/linux/syscalls.h) to include/linux/ftrace_event.h
and attach it to the struct there. This way it should only increase it.

> Ugh, and I just noticed that include/linux/klist.h does this fixed
> alignment of "4" too, where is this stuff coming from?  It's
> wrong on 64-bit, at best.  But I can't see the impetus behind doing
> this at all in the first place.

Is that actually misaligned? Unless I still mix things up, that is in the
struct thus should be fine (i.e. the "d" case in my example above).

	Bernhard R. Link
