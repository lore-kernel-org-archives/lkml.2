Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab0LNQ7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:59:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49805 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575Ab0LNQ7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:59:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KyG595WK3+UQhRTn+HrdgM7LTTGPOOy3tt1XLOsT1f8WFSMU/lTPzxe+zNfiCaG/yk
         MXmVvsVHlAjBGnINUPnqTmkAfdjqDbSivWvGnZEbVuA2vcTMMvJLkKYRm9hIY0lpXhDL
         GjyuxC+ojSTHDD9hyanyeONRRtJ2vafXNPBPA=
MIME-Version: 1.0
In-Reply-To: <20100517134320.A190.A69D9226@jp.fujitsu.com>
References: <1273653045_3386@mail4.comsite.net>
	<201005142209.14473.rusty@rustcorp.com.au>
	<20100517134320.A190.A69D9226@jp.fujitsu.com>
Date: Tue, 14 Dec 2010 08:59:35 -0800
Message-ID: <AANLkTi=ghZn9o_7Dab2GQebZUZBZk+um0vYbZZLC3dMf@mail.gmail.com>
Subject: Re: cpumask: fix compat getaffinity
From: Josh Hunt <joshhunt00@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Milton Miller <miltonm@bga.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, anton@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realize this thread is fairly old, but I have a question about this
statement in the changelog:

> On NUMA systems with less than 32 possibly CPUs, the
> current compat_sys_sched_getaffinity now returns '4'
> instead of the actual NR_CPUS/8, which makes libnuma
> bail out when parsing the cpumap.

This does not seem accurate, at least not on my system with NR_CPUS=32
and nr_cpu_ids=8. The smallest value retlen will ever be set to is
sizeof(long) which is 8 on most modern systems. This breaks the
statement that this function will now return NR_CPUS/8.

Thanks
Josh


On Sun, May 16, 2010 at 11:04 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Wed, 12 May 2010 06:00:45 pm Milton Miller wrote:
>> >
>> > At least for parsing, we need to allocate and parse NR_CPUS until
>> > all places like arch/powerpc/platforms/pseries/xics.c that compare a
>> > user-supplied mask to CPUMASK_ALL are eliminated.
>>
>> Good point.  Anton will want to fix those anyway for CONFIG_CPUMASK_OFFSTACK,
>> too, but that's the reason the parsing uses nr_cpumask_bits.
>>
>> > > Would it make sense to use my initial patch for -stable, which reverts
>> > > the ABI back to before the change that caused the problem, but apply
>> > > the correct fix (changing the ABI throughout) for future releases?
>> >
>> > This would definitly be the conservative fix.
>>
>> Instead of changing back to NR_CPUS which will break libnuma for
>> CPUMASK_OFFSTACK, how about changing it to nr_cpumask_bits and having an
>> explicit comment above it:
>
> Yes and No.
>
> 1) sched_getaffinity syscall is used from glibc and libnuma.
> 2) glibc doesn't use the return value almostly. glibc emulate it as NR_CPUS=1024.
> 3) Now, both sched_getaffinity() and compat_sys_sched_getaffinity() have nr_cpu_ids thing.
> 4) But only compat_sys_sched_getaffinity() hit libnuma problem.
>
> I think It mean compat_sys_sched_getaffinity() should behave as sched_getaffinity().
> IOW, libnuma assume compat_sys_sched_getaffinity() return len args or NR_CPUS.
> then, following patch do it. I confirmed the patch works with or without CPUMASK_OFFSTACK.
>
> So, My proposal is
>        1) merge both mine and yours to linus tree
>        2) but backport only mine
>
>
> How do you think?
>
>
> ==========================================================
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Subject: [PATCH] cpumask: fix compat getaffinity
>
> Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> libnuma, which abuses sched_getaffinity to find out NR_CPUS
> in order to parse /sys/devices/system/node/node*/cpumap.
>
> On NUMA systems with less than 32 possibly CPUs, the
> current compat_sys_sched_getaffinity now returns '4'
> instead of the actual NR_CPUS/8, which makes libnuma
> bail out when parsing the cpumap.
>
> The libnuma call sched_getaffinity(0, bitmap, 4096)
> at first. It mean the libnuma expect the return value of
> sched_getaffinity() is either len argument or NR_CPUS.
> But it doesn't expect to return nr_cpu_ids.
>
> Strictly speaking, userland requirement are
>
> 1) Glibc assume the return value mean the lengh of initialized
>   of mask argument. E.g. if sched_getaffinity(1024) return 128,
>   glibc make zero fill rest 896 byte.
> 2) Libnuma assume the return value can be used to guess NR_CPUS
>   in kernel. It assume len-arg<NR_CPUS makes -EINVAL. But
>   it try len=4096 at first and 4096 is always bigger than
>   NR_CPUS. Then, if we remove strange min_length normalization,
>   we never hit -EINVAL case.
>
> sched_getaffinity() already solved this issue. This patch
> adapt compat_sys_sched_getaffinity() as it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/compat.c |   25 +++++++++++--------------
>  1 files changed, 11 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/compat.c b/kernel/compat.c
> index 7f40e92..5adab05 100644
> --- a/kernel/compat.c
> +++ b/kernel/compat.c
> @@ -495,29 +495,26 @@ asmlinkage long compat_sys_sched_getaffinity(compat_pid_t pid, unsigned int len,
>  {
>        int ret;
>        cpumask_var_t mask;
> -       unsigned long *k;
> -       unsigned int min_length = cpumask_size();
> -
> -       if (nr_cpu_ids <= BITS_PER_COMPAT_LONG)
> -               min_length = sizeof(compat_ulong_t);
>
> -       if (len < min_length)
> +       if ((len * BITS_PER_BYTE) < nr_cpu_ids)
> +               return -EINVAL;
> +       if (len & (sizeof(compat_ulong_t)-1))
>                return -EINVAL;
>
>        if (!alloc_cpumask_var(&mask, GFP_KERNEL))
>                return -ENOMEM;
>
>        ret = sched_getaffinity(pid, mask);
> -       if (ret < 0)
> -               goto out;
> +       if (ret == 0) {
> +               size_t retlen = min_t(size_t, len, cpumask_size());
>
> -       k = cpumask_bits(mask);
> -       ret = compat_put_bitmap(user_mask_ptr, k, min_length * 8);
> -       if (ret == 0)
> -               ret = min_length;
> -
> -out:
> +               if (compat_put_bitmap(user_mask_ptr, cpumask_bits(mask), retlen * 8))
> +                       ret = -EFAULT;
> +               else
> +                       ret = retlen;
> +       }
>        free_cpumask_var(mask);
> +
>        return ret;
>  }
>
> --
> 1.6.5.2
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
