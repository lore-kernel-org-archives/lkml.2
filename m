Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab1CaGOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:14:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54858 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1CaGOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xOM1gl5qjGgl3qBtB6/Pt2EJnhi9Qvu0uIXjyRbVZy+uf0tljFHIChwsbiR2J5ehdc
         GQ1KHicvp0Ur63uHX2h+5p2Xnx2+lZ4WP6bgtTi/ZtIgWIMOqDby64ig0iTjhXtOTSLQ
         0km04IUfU9hL6tfGEw7MM9yGjpyunlVl8T5K8=
MIME-Version: 1.0
In-Reply-To: <4D91B260.6090506@snapgear.com>
References: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
	<4D91B260.6090506@snapgear.com>
Date: Thu, 31 Mar 2011 14:14:07 +0800
Message-ID: <AANLkTi=1uFnONhEaLo7u-YQJJZhBFpRv36LmwKq1xYiK@mail.gmail.com>
Subject: Re: [uClinux-dev] Re: [PATCH] NOMMU: implement access_remote_vm
From: Wan ZongShun <mcuos.com@gmail.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: Greg Ungerer <gerg@snapgear.com>, Mike Frysinger <vapier@gentoo.org>,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/29 Greg Ungerer <gerg@snapgear.com>:
> On 26/03/11 06:32, Mike Frysinger wrote:
>>
>> Recent vm changes brought in a new function which the core procfs code
>> utilizes.  So implement it for nommu systems too to avoid link failures.
>>
>> Signed-off-by: Mike Frysinger<vapier@gentoo.org>
>
> Looks good.
>
> Acked-by: Greg Ungerer <gerg@uclinux.org>
>

It applys to my nuc700 arm7tdmi platform, thanks!

Tested-by: Wan ZongShun <mcuos.com@gmail.com>

>
>> ---
>>  mm/nommu.c |   52 +++++++++++++++++++++++++++++++++++++++-------------
>>  1 files changed, 39 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/nommu.c b/mm/nommu.c
>> index cb86e7d..c4c542c 100644
>> --- a/mm/nommu.c
>> +++ b/mm/nommu.c
>> @@ -1971,21 +1971,10 @@ int filemap_fault(struct vm_area_struct *vma,
>> struct vm_fault *vmf)
>>  }
>>  EXPORT_SYMBOL(filemap_fault);
>>
>> -/*
>> - * Access another process' address space.
>> - * - source/target buffer must be kernel space
>> - */
>> -int access_process_vm(struct task_struct *tsk, unsigned long addr, void
>> *buf, int len, int write)
>> +static int __access_remote_vm(struct task_struct *tsk, struct mm_struct
>> *mm,
>> +               unsigned long addr, void *buf, int len, int write)
>>  {
>>        struct vm_area_struct *vma;
>> -       struct mm_struct *mm;
>> -
>> -       if (addr + len<  addr)
>> -               return 0;
>> -
>> -       mm = get_task_mm(tsk);
>> -       if (!mm)
>> -               return 0;
>>
>>        down_read(&mm->mmap_sem);
>>
>> @@ -2010,6 +1999,43 @@ int access_process_vm(struct task_struct *tsk,
>> unsigned long addr, void *buf, in
>>        }
>>
>>        up_read(&mm->mmap_sem);
>> +
>> +       return len;
>> +}
>> +
>> +/**
>> + * @access_remote_vm - access another process' address space
>> + * @mm:                the mm_struct of the target address space
>> + * @addr:      start address to access
>> + * @buf:       source or destination buffer
>> + * @len:       number of bytes to transfer
>> + * @write:     whether the access is a write
>> + *
>> + * The caller must hold a reference on @mm.
>> + */
>> +int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>> +               void *buf, int len, int write)
>> +{
>> +       return __access_remote_vm(NULL, mm, addr, buf, len, write);
>> +}
>> +
>> +/*
>> + * Access another process' address space.
>> + * - source/target buffer must be kernel space
>> + */
>> +int access_process_vm(struct task_struct *tsk, unsigned long addr, void
>> *buf, int len, int write)
>> +{
>> +       struct mm_struct *mm;
>> +
>> +       if (addr + len<  addr)
>> +               return 0;
>> +
>> +       mm = get_task_mm(tsk);
>> +       if (!mm)
>> +               return 0;
>> +
>> +       len = __access_remote_vm(tsk, mm, addr, buf, len, write);
>> +
>>        mmput(mm);
>>        return len;
>>  }
>
>
> --
> ------------------------------------------------------------------------
> Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
> SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
> 8 Gardner Close                             FAX:         +61 7 3217 5323
> Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
> _______________________________________________
> uClinux-dev mailing list
> uClinux-dev@uclinux.org
> http://mailman.uclinux.org/mailman/listinfo/uclinux-dev
> This message was resent by uclinux-dev@uclinux.org
> To unsubscribe see:
> http://mailman.uclinux.org/mailman/options/uclinux-dev
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
