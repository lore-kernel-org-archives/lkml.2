Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2IDWQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:16:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739Ab2IDWQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:16:53 -0400
Date: Wed, 5 Sep 2012 00:16:41 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, riel@redhat.com, peterz@infradead.org,
        hughd@google.com, daniel.santos@pobox.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/7] mm: fix potential anon_vma locking issue in
 mprotect()
Message-ID: <20120904221641.GL3334@redhat.com>
References: <1346750457-12385-1-git-send-email-walken@google.com>
 <1346750457-12385-3-git-send-email-walken@google.com>
 <20120904142745.GE3334@redhat.com>
 <20120904215347.GA6769@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904215347.GA6769@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:53:47PM -0700, Michel Lespinasse wrote:
> I think the minimal fix would actually be:
> 
>  	if (vma->anon_vma && (importer || start != vma->vm_start)) {
>  		anon_vma = vma->anon_vma;
> +	else if (next->anon_vma && adjust_next)
> +		anon_vma = next->anon_vma;

Right indeed. The last change required to the above is to check
adjust_next first.

> I suppose if we were to consider adding this fix to the stable series,
> we should probably do it in such a minimal way. I hadn't actually
> considered it, because I was only thinking about this patch series,
> and at patch 4/7 it becomes necessary to lock the anon_vma even if
> only the vm_end side gets modified (so we'd still end up with what I
> proposed in the end)

Ah, that fully explains you removed the optimization :). I was
reviewing the patch as a bugfix for upstream without noticing the
new requirements introduced by the later patches.

I would suggest to do the strict fix as above in as patch 1/8 and push
it in -mm, and to do only the optimization removal in 3/8. I think
we want it in -stable too later, so it'll make life easier to
cherry-pick the commit if it's merged independently.

Thanks!
Andrea
