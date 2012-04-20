Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2DTTTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:19:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52275 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2DTTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120420190418.GK6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor> <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils> <20120420190418.GK6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 12:18:43 -0700
X-Google-Sender-Auth: -XQyy4MkBP5tOaoh33kHYbgto84
Message-ID: <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Deferring the final pass after dropping ->mmap_sem is going to be
> interesting; what would protect ->vm_next on those suckers?

Just remove them from the active list, and keep them linked to each
other using vm_next.

After all, the only case we care about is the case where the vma gets
removed entirely, so we just put them on their own list.

In fact, that's what we already do for other reasons. See
detach_vmas_to_be_unmapped().

So vm_next is actually entirely *private* by this time, and needs no
locking at all.

As far as I can tell, we could just make do_munmap() return that
private list, and then do the fput's and freeing of the list outside
the mmap_sem lock.

That actually looks pretty simple. There are a fair number of callers,
which looks to be the main annoyance. But fixing it up with some
pattern of "do finish_munmap after drooping the mmap_sem" doesn't look
*complicated*, just slightly annoying.

The *bigger* annoyance is actually "do_mmap()", which does a
do_munmap() as part of it, so it needs the same cleanup too.

There might be other cases that do munmap as part of their operation
(and that have the mmap_sem held outside of the caller), but
do_munmap() and do_mmap() seem to be the two obvious ones.

Many of the callers seem to do the mmap_sem() right around the call,
though (see binfmt_elf.c for example), so it really would be a rather
local fixup.

                   Linus
