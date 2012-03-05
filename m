Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2CEBWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:22:23 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51354 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab2CEBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:22:22 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 Mar 2012 17:22:01 -0800
X-Google-Sender-Auth: dsfypV_KypgsTPWa5Ki3EzUCtA0
Message-ID: <CA+55aFzX9Nj_jSdFR6PJO-G4MPi7R13TLHAxwzZo9C0MHNRBfw@mail.gmail.com>
Subject: Re: [PATCH] fix bug introduced in "mm: simplify find_vma_prev()"
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 4:52 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> This patch fixes a bug introduced in "mm: simplify find_vma_prev()". You
> can apply this, or alternatively revert the original patch.

Hmm.

I realize the patch is a bug-fix, but I do wonder if we shouldn't look
at alternatives.

In particular, how about we just change the rule to be clearer, and
make the rule be:

 - no more find_vma_prev() AT ALL.

 - callers get turned into "find_vma()" and then we have a
"vma_prev()", which basically does your thing.

 - many of the callers seem to be interested in "prev" *only* if they
found a vma. For example, the do_mlock() kind of logic seems to be
common:

    vma = find_vma_prev(current->mm, start, &prev);
    if (!vma || vma->vm_start > start)
        return -ENOMEM;

   which implies that the current find_vma_prev() semantics are really
wrong, because they force us to do extra work in this case where we
really really don't care about the result.

So we could do an entirely mechanical conversion of

   vma = find_vma_prev(mm, address, &prev_vma);

into

   vma = find_vma(mm, address);
   prev_vma = vma_prev(vma);

and then after we've done that conversion, it looks like the bulk of
them will not care about "prev_vma" if vma is NULL, so they can then
be replaced with a pure

   prev_vma = vma->vm_prev;

instead. Leaving just the (few) cases that may care about the
"previous vma may be the last vma of the VM" case.

Hmm? And we'd get away from that horrible "find_vma_prev()" interface
that uses pointers to vma pointers for return values. Ugh. There only
seems to be nine callers in the whole kernel.

                 Linus
