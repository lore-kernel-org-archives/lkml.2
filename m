Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab1EYOzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:55:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756142Ab1EYOzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110525085816.GA24233@elte.hu>
References: <alpine.LRH.2.00.1105242146240.12134@tundra.namei.org>
 <20110525074040.GA9233@elte.hu> <20110525085816.GA24233@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2011 07:54:42 -0700
Message-ID: <BANLkTimSpDM4ZbDx92r7jkoGq8SkY2fMyA@mail.gmail.com>
Subject: Re: [PATCH] Revert "slub: Remove node check in slab_free"
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 1:58 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> As Linus explained it's broken. Quoting Linus:

Actually, apparently Linus' explanation doesn't hold water.

There does seem to be something very broken in that commit, and a
revert is appropriate, but as Christoph says, "c" is a local per-cpu
thing that is protected by interrupts being disabled. So the case I
thought looked bad cannot happen - it's not actually protected by the
page lock.

That said, we have one bisect that pinpointed that commit, and you
reporting that stability improves dramatically by reverting it, so I
definitely will revert it. I would like to be able to figure out what
the problem with it is, though.

(Not that that will hold up the revert).

One thing that I don't understand is why the debug case does *any* of
that at all: it used to only do "c->node = NUMA_NO_NODE;" and even
that looks bogus. A normal successful allocation doesn't do it, so why
does the debug allocation? The normal allocation path just does

        c->freelist = get_freepointer(s, object);
        page->inuse = page->objects;
        page->freelist = NULL;

so why does the debug path do something totally different:

        page->inuse++;
        page->freelist = get_freepointer(s, object);
        deactivate_slab(s, c);
        c->page = NULL;
        c->node = NUMA_NO_NODE;

(with that "decativate_slab + c->page = NULL" being the new part to
the offending commit).

The code is also ugly as hell. "deactivate_slab()" already sets
c->page to NULL, and it probably should have set c->node too.
Whatever.

Christoph, please look into this. With the kind of confirmation we
have, there is no question that commit gets reverted. So I'll revert
it soon, but I'd still like to know what is going on.

                                    Linus
