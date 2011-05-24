Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab1EXXD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:03:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770Ab1EXXD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 16:03:04 -0700
Message-ID: <BANLkTik=H=1+oqQ9_5ZZaHpFn8_9x5V-nQ@mail.gmail.com>
Subject: Re: SLUB regression in current Linus
To: James Morris <jmorris@namei.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 4:52 AM, James Morris <jmorris@namei.org> wrote:
>
> Reverting the patch appears to fix the hang for me, although I'm not sure
> what the actual problem is.
>
> This is on a quad-core Opteron (1352). Let me know if you need any further
> info.

That whole "deactivate_slab()" + "c->page = NULL" that that patch does
looks bogus.

Look at __slab_alloc: we have:


        page = c->page;
        if (!page)
                goto new_slab;

        slab_lock(page);
        if (unlikely(!node_match(c, node)))
                goto another_slab;

and let's assume we have two users racing on that "c->page". The
"slab_lock()" is going to work for one of them, right?

Ok, so the one it works for will then hit

        if (kmem_cache_debug(s))
                goto debug;

and thus get to the new "deactivate_slab(s,c) + c->page = NULL" and
then unlock the page.

In the meantime, the one that wasn't able to lock the page will now go
forward, but will not have "node_match()" any more, so it does that
"goto another_slab".

Which does "deactivate_slab(s,c)" again, and now c->page is NULL, so
that totally breaks.

What am I missing?

That patch seems to be just broken piece-of-s%^!

Christoph, Pekka, please tell me why I shouldn't immediately revert
it. What am I missing?

                       Linus
