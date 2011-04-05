Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1DEGnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:43:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1DEGm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xjE9oKqliCyfRZzrs6/YQxYOe3YJM0rRjevBQQSLhRO693/vE/s5D3yhaIaQX6nYjz
         DWcqRsBcfQlUD1LT4vPA==
MIME-Version: 1.0
In-Reply-To: <c4f5166f98cb703742191eb74f583bb8011f9cdf.1301984663.git.michael@ellerman.id.au>
References: <c4f5166f98cb703742191eb74f583bb8011f9cdf.1301984663.git.michael@ellerman.id.au>
Date: Mon, 4 Apr 2011 23:42:54 -0700
Message-ID: <BANLkTi=RJ2GHvHQ3mZiQ-L-MTVUQH-V-eA@mail.gmail.com>
Subject: Re: [PATCH] mm: Check we have the right vma in access_process_vm()
From: Michel Lespinasse <walken@google.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        aarcange@redhat.com, riel@redhat.com, Andrew Morton <akpm@osdl.org>,
        linuxppc-dev@ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 11:24 PM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> In access_process_vm() we need to check that we have found the right
> vma, not the following vma, before we try to access it. Otherwise
> we might call the vma's access routine with an address which does
> not fall inside the vma.
>
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Please note that the code has moved into __access_remote_vm() in
current linus tree. Also, should len be truncated before calling
vma->vm_ops->access() so that we can guarantee it won't overflow past
the end of the vma ?

> diff --git a/mm/memory.c b/mm/memory.c
> index 5823698..7e6f17b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3619,7 +3619,7 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>                         */
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
>                        vma = find_vma(mm, addr);
> -                       if (!vma)
> +                       if (!vma || vma->vm_start > addr)
>                                break;
>                        if (vma->vm_ops && vma->vm_ops->access)
>                                ret = vma->vm_ops->access(vma, addr, buf,
> --
> 1.7.1

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
