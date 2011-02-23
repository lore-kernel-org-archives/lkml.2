Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1BWWlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:41:02 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050Ab1BWWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:41:00 -0500
MIME-Version: 1.0
In-Reply-To: <E1PsEA7-0007G0-29@pomaz-ex.szeredi.hu>
References: <E1PsEA7-0007G0-29@pomaz-ex.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Feb 2011 14:33:54 -0800
Message-ID: <AANLkTimeihuzjgR2f7Avq2PJrCw1vZxtjh=wBPXO3aHP@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same inode
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hughd@google.com, gurudas.pai@oracle.com,
        lkml20101129@newton.leun.net, rjw@sisk.pl, florian@mickler.org,
        trond.myklebust@fys.uio.no, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 4:49 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> This resolves Bug 25822 listed in the regressions since 2.6.36 (though
> it's a bug much older than that, for some reason it only started
> triggering for people recently).

Gaah. I hate this patch. It is, in fact, a patch that makes me finally
think that the mm preemptibility is actually worth it, because then
i_mmap_lock turns into a mutex and makes the whole "drop the lock"
thing hopefully a thing of the past (see the patch "mm: Remove
i_mmap_mutex lockbreak").

Because as far as I can see, the only thing that makes this thing
needed in the first place is that horribly ugly "we drop i_mmap_lock
in the middle of random operations that really still need it".

That said, I don't really see any alternatives - I guess we can't
really just say "remove that crazy lock dropping". Even though I
really really really would like to.

Of course, we could also just decide that we should apply the mm
preemptibility series instead. Can people confirm that that fixes the
bug too?

                         Linus
