Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0I0Gh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:37:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40560 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab0I0Gh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uNFBSfLUZnZKP5qAvt1giODpp8S10N8UxiFoOdZfhavDX4DdRkQ2ir1gdbCVG/FOnY
         0xfswib3VyM9sQEE7MEOuiKt76PqT8xbawg6ptM+acn0XpXuXESwLXi7cJZ2KbWZ6FPh
         HkrQa5KpaQcTSwpoZLsuyqKBgHUwdw3bSKUog=
MIME-Version: 1.0
In-Reply-To: <m1iq1t9z3y.fsf@fess.ebiederm.org>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
	<m1iq1t9z3y.fsf@fess.ebiederm.org>
Date: Mon, 27 Sep 2010 09:37:56 +0300
X-Google-Sender-Auth: iGXhiBe1Nn6aKMVSqQpuKs6UikM
Message-ID: <AANLkTin4DKGhcZ4=os1-NxrQ65pEDZ+USG1xpW54y4_T@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: Consolidate vma destruction into remove_vma.
From: Pekka Enberg <penberg@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sun, Sep 26, 2010 at 2:34 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Consolidate vma destruction in remove_vma.   This is slightly
> better for code size and for code maintenance.  Avoiding the pain
> of 3 copies of everything needed to tear down a vma.
>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  mm/mmap.c |   21 +++++----------------
>  1 files changed, 5 insertions(+), 16 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 6128dc8..17dd003 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -643,16 +643,10 @@ again:                    remove_next = 1 + (end > next->vm_end);
>                spin_unlock(&mapping->i_mmap_lock);
>
>        if (remove_next) {
> -               if (file) {
> -                       fput(file);
> -                       if (next->vm_flags & VM_EXECUTABLE)
> -                               removed_exe_file_vma(mm);
> -               }
>                if (next->anon_vma)
>                        anon_vma_merge(vma, next);
> +               remove_vma(next);

remove_vma() does vma->vm_ops->close() but we don't do that here. Are
you sure the conversion is safe?

>                mm->map_count--;
> -               mpol_put(vma_policy(next));
> -               kmem_cache_free(vm_area_cachep, next);
>                /*
>                 * In mprotect's case 6 (see comments on vma_merge),
>                 * we must remove another next too. It would clutter
