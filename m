Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2LDOmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:42:22 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55011 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2LDOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:42:21 -0500
MIME-Version: 1.0
In-Reply-To: <20121202151232.GB12911@gmail.com>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org>
	<CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com>
	<20121201094927.GA12366@gmail.com>
	<20121201122649.GA20322@gmail.com>
	<CA+55aFx8QtP0hg8qxn__4vHQuzH7QkhTN-4fwgOpM-A=KuBBjA@mail.gmail.com>
	<20121201184135.GA32449@gmail.com>
	<CA+55aFyq7OaUxcEHXvJhp0T57KN14o-RGxqPmA+ks8ge6zJh5w@mail.gmail.com>
	<20121201201538.GB2704@gmail.com>
	<50BA69B7.30002@redhat.com>
	<20121202151232.GB12911@gmail.com>
Date: Tue, 4 Dec 2012 06:42:19 -0800
Message-ID: <CANN689HEvQ=APNYD3GJuC392KzutuMKorY9vZ9fXFwjmRbik1A@mail.gmail.com>
Subject: Re: [PATCH 2/2, v2] mm/migration: Make rmap_walk_anon() and
 try_to_unmap_anon() more scalable
From: Michel Lespinasse <walken@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 7:12 AM, Ingo Molnar <mingo@kernel.org> wrote:
> * Rik van Riel <riel@redhat.com> wrote:
>
>> >+static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
>> >+{
>> >+    down_read(&anon_vma->root->rwsem);
>> >+}
>>
>> I see you did not rename anon_vma_lock and anon_vma_unlock to
>> anon_vma_lock_write and anon_vma_unlock_write.
>>
>> That could get confusing to people touching that code in the
>> future.
>
> Agreed, doing that rename makes perfect sense - I've done that
> in the v2 version attached below.
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index f3f41d2..c20635c 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -118,7 +118,7 @@ static inline void vma_unlock_anon_vma(struct vm_area_struct *vma)
>                 up_write(&anon_vma->root->rwsem);
>  }

Note that you haven't changed the names for vma_lock_anon_vma() and
vma_unlock_anon_vma().
I don't have any real good names to suggest though.

> -static inline void anon_vma_lock(struct anon_vma *anon_vma)
> +static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
>  {
>         down_write(&anon_vma->root->rwsem);
>  }
> @@ -128,6 +128,17 @@ static inline void anon_vma_unlock(struct anon_vma *anon_vma)
>         up_write(&anon_vma->root->rwsem);
>  }

And as Rik noticed, you forgot to rename anon_vma_unlock() too.

But really, this is nitpicking. I like the idea behind the patch, and
after giving it a close look, I couldn't find anything wrong with it.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
