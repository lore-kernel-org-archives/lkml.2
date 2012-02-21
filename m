Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2BUR6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:58:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36693 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2BUR6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:58:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of brgerst@gmail.com designates 10.236.154.232 as permitted sender) smtp.mail=brgerst@gmail.com; dkim=pass header.i=brgerst@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F43AA37.5050004@gmail.com>
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com>
	<CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com>
	<4F411373.50304@gmail.com>
	<CAOe6JY3yM24CGYOpPc98QfjRYah5U+L9DB46WH60LVrxN9=eRQ@mail.gmail.com>
	<4F4262A4.9000204@gmail.com>
	<CAOe6JY1_dYGCK2=+EHARz5mTm=KCgWynnJjA9SuEHfj+Z0xjwA@mail.gmail.com>
	<4F43AA37.5050004@gmail.com>
Date: Tue, 21 Feb 2012 12:58:47 -0500
Message-ID: <CAMzpN2gnOgZWZFTVHnL8ySQSXCykc9ZpoDYMUvHGPVpy4OVWOw@mail.gmail.com>
Subject: Re: A problem with percpu variable cpu_number
From: Brian Gerst <brgerst@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Tao Jiang <jiangtao.jit@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 9:29 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On 02/21/2012 08:41 PM, Tao Jiang wrote:
>>
>> Hi Cong Wang:
>>
>> I read the file vmlinux.lds.S in arch/x86/kernel
>> section .data..percpu is between .init.data and .init.end
>> Is that means these percpu variables will be freed after init?
>
>
> % grep -e __init_begin -e __init_end -e __per_cpu_start -e __per_cpu_end
> /boot/System.map
> 0000000000000000 D __per_cpu_start
> 0000000000014bc0 D __per_cpu_end
> ffffffff81cf3000 D __init_begin
> ffffffff81dfc000 R __init_end
> % objdump -d -j .data..percpu vmlinux | grep cpu_number
> 000000000000dc38 <cpu_number>:

The .data..percpu section is placed in the init section, but x86-64 is
a special case as noted below.  The boot cpu is pointed to the init
percpu section until setup_per_cpu_areas() is called, when it switches
to the regular percpu area.  The init percpu data is then freed with
all other init data.

The reason the percpu symbols start at virtual address 0 on x86-64 is
because of the requirement that gs_base must be a canonical address
(it cannot be a simple offset like x86-32).  But, the data is still
loaded in the init section in memory.  See
arch/x86/kernel/vmlinux.lds.S for the explanation of how the linker
changes the program headers to set the virtual address to zero but
keeps the load address in the init section.

To answer the original question. in the case of cpu_number, it is set
to zero in the init section because it doesn't have an explicit
initializer.  Therefore the boot cpu will always read zero for the
cpu_number, even before setup_per_cpu_areas() is called.


--
Brian Gerst
