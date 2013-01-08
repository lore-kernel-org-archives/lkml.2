Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3AHRTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:19:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40395 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab3AHRTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:19:21 -0500
MIME-Version: 1.0
In-Reply-To: <201301081747.17853.trenn@suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<3649945.08HKjS0y0c@hammer82.arch.suse.de>
	<CAE9FiQUueTB6gc5uMUApqeS7FtzMESLLFEt3ZuOMJgXsnjFQ0A@mail.gmail.com>
	<201301081747.17853.trenn@suse.de>
Date: Tue, 8 Jan 2013 09:19:18 -0800
X-Google-Sender-Auth: NZmjsHAp_xq8EN4gpLSrmO3htqE
Message-ID: <CAE9FiQW=gT86Eo0gwPHi5iFi4sg=1SHkBohBAo2KXdoB_Ouqvw@mail.gmail.com>
Subject: Re: [PATCH] Only reset e820 once, even with multiple memmap=exactmap params
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 8:47 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Tuesday, January 08, 2013 04:04:56 AM Yinghai Lu wrote:
>> On Mon, Jan 7, 2013 at 4:42 PM, Thomas Renninger <trenn@suse.de> wrote:
>> > memmap=256M$3584M
>>
>> may need to change to:
>>
>> memmap=256M\$\$3584M
> The problem is (beside the special char $) that
> memmap=exactmap boot param resets all e820 maps every time the
> parameter is processed.
> And:
> /sbin/kexec -p xy --append="..." --initrd yx
> seem to magically add (append):
> memmap=exactmap memmap=640K@0K memmap=392556K@115328K elfcorehdr=507884K memmap=252K#3099760K
>
> therefore all memmap= I try to pass are voided out by:
> memmap=exactmap
> which is always added by kexec after my params.
>
> I could come around with attached patch and passing:
> /sbin/kexec -p xy --append='... memmap=exactmap memmap=256M$3584M' --initrd yx
>
> Now mmconfig is working in kdump kernel.
> This would mean mmconfig is broken by design in kexec?
>
> Only way to fix this I can think of is to export
> mmconfig area through /sys  (../kernel/debug/mmconfig?, possibly
> already in X$Y format?) in the productive kernel and make kexec add it
> like the other memmap= params automatically.
>
> I'll attach the output in a separate mail.
>
>    Thomas
>
> ---
>
> x86 e820: Do not reset e820 map twice, even if memmap=exactmap is passed as boot param several times
>
> This is needed to be able to explicitly pass (debug) e820
> modifications through kexec via memmap=.
> Otherwise those get voided by kexec appending memmap=exactmap always
> after the user defined boot parameters.
>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
>
>  linux-2.6_t/arch/x86/kernel/e820.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: git/linux-2.6_t/arch/x86/kernel/e820.c
> ===================================================================
> --- git.orig/linux-2.6_t/arch/x86/kernel/e820.c
> +++ git/linux-2.6_t/arch/x86/kernel/e820.c
> @@ -845,7 +845,9 @@ static int __init parse_memmap_opt(char
>
>         if (!strncmp(p, "exactmap", 8)) {
>  #ifdef CONFIG_CRASH_DUMP
> -               /*
> +               /* memmap=exactmap passed twice, do not reset tables again */
> +               if (saved_max_pfn)
> +                       return 0;               /*
>                  * If we are doing a crash dump, we still need to know
>                  * the real mem size before original memory map is
>                  * reset.

that exactmap logic still have problem:
We need to check exactmap at first, aka need to scan the whole comand line to
see if exactmap is there at first and reset e820 tables then handle
other memmap opt.

Also please update your patch after

tip/x86/mm2

I have one patch that process memmap= with "," there.

http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=9710f581bb4c35589ac046b0cfc0deb7f369fc85

We could put exactmap scanning in new parse_memmap_opt.

Thanks

Yinghai
