Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1BLSNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 13:13:15 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36954 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1BLSNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 13:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=USyQvHJdH0CW75Mkb3dxWSrf8g+fpRbjzcTbuOmAdSbmHNKA69fLpGek0x8WmyZsp0
         zDEAJjKop7rMLaSDUgNbXRnAS+SchE3vijgl7RIcdKOQjLNUMf2AU7nx2ux+JMuDWJrV
         mmgwZ/hgjH1+UdQNHGX4y2IeqCdGk4wtcvQOk=
MIME-Version: 1.0
In-Reply-To: <20110212032944.GA24080@outflux.net>
References: <20110212032944.GA24080@outflux.net>
Date: Sat, 12 Feb 2011 10:13:04 -0800
Message-ID: <AANLkTiniMPKD6EGpQ=TAbeS4tFVtZybcf-8kFuNbU7t_@mail.gmail.com>
Subject: Re: [PATCH] drm: do not leak kernel addresses via /proc/dri/*/vma
From: Corbin Simpson <mostawesomedude@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Eugene Teo <eugeneteo@kernel.org>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 7:29 PM, Kees Cook <kees.cook@canonical.com> wrote:
> In the continuing effort to avoid kernel addresses leaking to unprivileged
> users, this patch switches to %pK for /proc/dri/*/vma.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  drivers/gpu/drm/drm_info.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_info.c b/drivers/gpu/drm/drm_info.c
> index 3cdbaf3..be9a9c0 100644
> --- a/drivers/gpu/drm/drm_info.c
> +++ b/drivers/gpu/drm/drm_info.c
> @@ -283,17 +283,18 @@ int drm_vma_info(struct seq_file *m, void *data)
>  #endif
>
>        mutex_lock(&dev->struct_mutex);
> -       seq_printf(m, "vma use count: %d, high_memory = %p, 0x%08llx\n",
> +       seq_printf(m, "vma use count: %d, high_memory = %pK, 0x%pK\n",
>                   atomic_read(&dev->vma_count),
> -                  high_memory, (u64)virt_to_phys(high_memory));
> +                  high_memory, (void *)virt_to_phys(high_memory));
>
>        list_for_each_entry(pt, &dev->vmalist, head) {
>                vma = pt->vma;
>                if (!vma)
>                        continue;
>                seq_printf(m,
> -                          "\n%5d 0x%08lx-0x%08lx %c%c%c%c%c%c 0x%08lx000",
> -                          pt->pid, vma->vm_start, vma->vm_end,
> +                          "\n%5d 0x%pK-0x%pK %c%c%c%c%c%c 0x%08lx000",
> +                          pt->pid,
> +                          (void *)vma->vm_start, (void *)vma->vm_end,
>                           vma->vm_flags & VM_READ ? 'r' : '-',
>                           vma->vm_flags & VM_WRITE ? 'w' : '-',
>                           vma->vm_flags & VM_EXEC ? 'x' : '-',
> --
> 1.7.2.3

This is a highly reasonable patch. Does 0x%pK show up as 0x0x0 in the
log, or just 0x0? Other than that...

Reviewed-by: Corbin Simpson <MostAwesomeDude@gmail.com>

-- 
When the facts change, I change my mind. What do you do, sir? ~ Keynes

Corbin Simpson
<MostAwesomeDude@gmail.com>
