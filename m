Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1JWJXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:23:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39401 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab1JWJXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU+xHww_JCYYA4kAKCXmOZpZeu=+rnCyRL-5dW5Uxk1hQ@mail.gmail.com>
References: <CALKntY3Xo6R2zLs8oM=+=-VPdFXeLsdGi_YbMiA_1085xhMOQw@mail.gmail.com>
	<CAM_iQpU+xHww_JCYYA4kAKCXmOZpZeu=+rnCyRL-5dW5Uxk1hQ@mail.gmail.com>
Date: Sun, 23 Oct 2011 05:23:44 -0400
Message-ID: <CALKntY0222DBU88W=j0Y2FpN7NRMSxmDk4XKy-m+keri4Gcu_A@mail.gmail.com>
Subject: Re: copy_*_user
From: Xin Tong <xerox.time.tech@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that __copy_from_user_ll(void *to, const void __user *from,
unsigned long n) eventually calls some asm which use mov and rep on
the passed-in to & from pointers. This is in kernel mode and to & from
are virtual addresses ? are not the kernel accessing physical RAM
directly ( without pagetable ) ?


Thanks

Xin



On Sat, Oct 22, 2011 at 10:50 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Sun, Oct 23, 2011 at 1:06 AM, Xin Tong <xerox.time.tech@gmail.com> wrote:
>> I am investigating copy_from_user  and copy_to_user in linux under
>> i386. These two function both take a pointer with virtual address and
>> a pointer with physical address.
>>
>> copy_from_user calls __copy_from_user_ll and copy_to_user  calls
>> __copy_to_user_ll. It make sense to me that __copy_to_user_ll converts
>> the virtual address to physical address using the current process's
>> page table.
>>
> [...]
>> But it seems to be that __copy_from_user_ll  is not converted the
>> address at all before attempting to copy. Can someone help explain to
>> me why ?
>>
>
> You missed that __copy_to_user_ll() only does that when CONFIG_X86_WP_WORKS_OK
> is not defined. And there is a comment right inside __copy_to_user_ll() said:
>
>
>               /*
>                 * CPU does not honor the WP bit when writing
>                 * from supervisory mode, and due to preemption or SMP,
>                 * the page tables can change at any time.
>                 * Do it manually.      Manfred <manfred@colorfullife.com>
>                 */
>
> this is why it uses kmap_atomic()+memcpy() to copy the data.
>
> Also, all the addresses are virtual address.
>
