Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1C2KVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:21:22 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:13974 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1C2KVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:21:21 -0400
Message-ID: <4D91B260.6090506@snapgear.com>
Date: Tue, 29 Mar 2011 20:20:16 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: <uclinux-dev@uclinux.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NOMMU: implement access_remote_vm
References: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/11 06:32, Mike Frysinger wrote:
> Recent vm changes brought in a new function which the core procfs code
> utilizes.  So implement it for nommu systems too to avoid link failures.
>
> Signed-off-by: Mike Frysinger<vapier@gentoo.org>

Looks good.

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>   mm/nommu.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
>   1 files changed, 39 insertions(+), 13 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index cb86e7d..c4c542c 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1971,21 +1971,10 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>   }
>   EXPORT_SYMBOL(filemap_fault);
>
> -/*
> - * Access another process' address space.
> - * - source/target buffer must be kernel space
> - */
> -int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
> +static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
> +		unsigned long addr, void *buf, int len, int write)
>   {
>   	struct vm_area_struct *vma;
> -	struct mm_struct *mm;
> -
> -	if (addr + len<  addr)
> -		return 0;
> -
> -	mm = get_task_mm(tsk);
> -	if (!mm)
> -		return 0;
>
>   	down_read(&mm->mmap_sem);
>
> @@ -2010,6 +1999,43 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
>   	}
>
>   	up_read(&mm->mmap_sem);
> +
> +	return len;
> +}
> +
> +/**
> + * @access_remote_vm - access another process' address space
> + * @mm:		the mm_struct of the target address space
> + * @addr:	start address to access
> + * @buf:	source or destination buffer
> + * @len:	number of bytes to transfer
> + * @write:	whether the access is a write
> + *
> + * The caller must hold a reference on @mm.
> + */
> +int access_remote_vm(struct mm_struct *mm, unsigned long addr,
> +		void *buf, int len, int write)
> +{
> +	return __access_remote_vm(NULL, mm, addr, buf, len, write);
> +}
> +
> +/*
> + * Access another process' address space.
> + * - source/target buffer must be kernel space
> + */
> +int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write)
> +{
> +	struct mm_struct *mm;
> +
> +	if (addr + len<  addr)
> +		return 0;
> +
> +	mm = get_task_mm(tsk);
> +	if (!mm)
> +		return 0;
> +
> +	len = __access_remote_vm(tsk, mm, addr, buf, len, write);
> +
>   	mmput(mm);
>   	return len;
>   }


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
