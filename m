Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3ACAbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:31:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab3ACAbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:31:16 -0500
Message-ID: <50E4D145.5030006@redhat.com>
Date: Wed, 02 Jan 2013 19:31:01 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] mm: remap_file_pages() fixes
References: <1356050997-2688-1-git-send-email-walken@google.com> <1356050997-2688-3-git-send-email-walken@google.com>
In-Reply-To: <1356050997-2688-3-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:49 PM, Michel Lespinasse wrote:
> Assorted small fixes. The first two are quite small:
>
> - Move check for vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR)
>    within existing if (!(vma->vm_flags & VM_NONLINEAR)) block.
>    Purely cosmetic.
>
> - In the VM_LOCKED case, when dropping PG_Mlocked for the over-mapped
>    range, make sure we own the mmap_sem write lock around the
>    munlock_vma_pages_range call as this manipulates the vma's vm_flags.
>
> Last fix requires a longer explanation. remap_file_pages() can do its work
> either through VM_NONLINEAR manipulation or by creating extra vmas.
> These two cases were inconsistent with each other (and ultimately, both wrong)
> as to exactly when did they fault in the newly mapped file pages:
>
> - In the VM_NONLINEAR case, new file pages would be populated if
>    the MAP_NONBLOCK flag wasn't passed. If MAP_NONBLOCK was passed,
>    new file pages wouldn't be populated even if the vma is already
>    marked as VM_LOCKED.
>
> - In the linear (emulated) case, the work is passed to the mmap_region()
>    function which would populate the pages if the vma is marked as
>    VM_LOCKED, and would not otherwise - regardless of the value of the
>    MAP_NONBLOCK flag, because MAP_POPULATE wasn't being passed to
>    mmap_region().
>
> The desired behavior is that we want the pages to be populated and locked
> if the vma is marked as VM_LOCKED, or to be populated if the MAP_NONBLOCK
> flag is not passed to remap_file_pages().
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
