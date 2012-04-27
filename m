Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2D0Hf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:35:29 -0400
Received: from mga05.intel.com ([192.55.52.89]:7795 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757513Ab2D0Hf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzEwsW1kdLo2hpgW2PUCRkyaRxS_KB40iwmuk1FDgV+cg@mail.gmail.com>
References: <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
	<1334772473.2137.22.camel@falcor>
	<20120418183938.GH6589@ZenIV.linux.org.uk>
	<1334865448.2429.35.camel@falcor>
	<20120420004303.GB6871@ZenIV.linux.org.uk>
	<alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
	<20120420190418.GK6871@ZenIV.linux.org.uk>
	<CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
	<20120420195833.GM6871@ZenIV.linux.org.uk>
	<CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>
	<20120420221315.GN6871@ZenIV.linux.org.uk>
	<CA+55aFzEwsW1kdLo2hpgW2PUCRkyaRxS_KB40iwmuk1FDgV+cg@mail.gmail.com>
Date: Fri, 27 Apr 2012 10:35:25 +0300
Message-ID: <CALLzPKarZY11htkukZPi+7ny5r=au9hMdKBOy20wAdFjSBOyjA@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 1:35 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Apr 20, 2012 at 3:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Kinda-sorta.  I agree that such helpers make sense, but you are too
> > optimistic about the number of such places.  And clusterfuck around
> > mremap() is fairly deep, so propagating all way back to up_write()
> > wont' be fun.
>
> Fair enough.
>
> I'll do the helpers and see how much they get rid of, just because
> looking at all the callers, those helpers seem to be obviously the
> right thing anyway. So even if we don't do anything else, we can
> improve things regardless.
>
> For do_brk(), for example, it looks like do_brk() itself should
> actually be entirely static to mm/mmap.c, because every single caller
> from the outside actually wants the self-locking version.
>
> So plan right now: do "vm_xyzzy()" helper functions that do
> "do_xyzzy()" and take the lock (and do not take the "mm" argument,
> because it had better always be the current one - keep the calling
> convention as simple as possible).
>
>                   Linus

Moi Linus,

Taking the list of files to fput out of do_munmap() and doing it after
unlocking mmap sem
was one of possible solutions when we discussed it with Mimi.
But we were looking for the solution with less modifications of existing kernel.

In fact IMA is already doing some work before taking mmap sem.
---
	ret = ima_file_mmap(filep, prot);
	if (ret < 0)
		return ret;
	down_write(&current->mm->mmap_sem);
--

But have you seen the proposed patch for __fput()?
[PATCH v4 10/12] ima: defer calling __fput()

It defers only of course the last AND mmap_sem is locked AND open for write.

	if (current->mm && rwsem_is_locked(&current->mm->mmap_sem)) {
		if (ima_defer_fput(file) == 0)
			return;
	}

Just 5 out of ~100,000 mmap_sem held fput() calls were deferred.

t.
- Dmitry
