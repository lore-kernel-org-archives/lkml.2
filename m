Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1HOK6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:58:05 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:40379 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1HOK6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110815104656.GG26978@dastard>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
	<1313334832-1150-4-git-send-email-glommer@parallels.com>
	<CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>
	<20110815104656.GG26978@dastard>
Date: Mon, 15 Aug 2011 13:58:01 +0300
X-Google-Sender-Auth: gQxSuseWpEzs-kLQ5vzCmYdQtCY
Message-ID: <CAOJsxLGFJmqO-W=itQbO4Mh4DxSD4wrHOC8gQ5bWL5aE1YYeQw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
From: Pekka Enberg <penberg@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, Aug 15, 2011 at 1:46 PM, Dave Chinner <david@fromorbit.com> wrote:
> That's usage for the entire slab, though, and we don't have a dentry
> slab per superblock so I don't think that helps us. And with slab
> merging, I think that even if we did have a slab per superblock,
> they'd end up in the same slab context anyway, right?

You could add a flag to disable slab merging but there's no sane way
to fix the per-superblock thing in slab.

On Mon, Aug 15, 2011 at 1:46 PM, Dave Chinner <david@fromorbit.com> wrote:
> Ideally what we need is a slab, LRU and shrinkers all rolled into a
> single infrastructure handle so we can simply set them up per
> object, per context etc and not have to re-invent the wheel for
> every single slab cache/LRU/shrinker setup we have in the kernel.
>
> I've got a rough node-aware generic LRU/shrinker infrastructure
> prototype that is generic enough for most of the existing slab
> caches with shrinkers, but I haven't looked at what is needed to
> integrate it with the slab cache code. That's mainly because I don't
> like the idea of having to implement the same thing 3 times in 3
> different ways and debug them all before anyone would consider it
> for inclusion in the kernel.
>
> Once I've sorted out the select_parent() use-the-LRU-for-disposal
> abuse and have a patch set that survives a 'rm -rf *' operation,
> maybe we can then talk about what is needed to integrate stuff into
> the slab caches....

Well, now that I really understand what you're trying to do here, it's
probably best to keep slab as-is and implement "slab accounting" on
top of it.

You'd have something like you do now but in slightly more generic form:

  struct kmem_accounted_cache {
                  struct kmem_cache *cache;
                  /* ... statistics... */
  }

  void *kmem_accounted_alloc(struct kmem_accounted_cache *c)
  {
          if (/* within limits */)
                  return kmem_cache_alloc(c->cache);

          return NULL;
  }

Does something like that make sense to you?

                        Pekka
