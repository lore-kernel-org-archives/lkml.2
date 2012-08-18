Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2HRRuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:50:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36806 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2HRRuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <1344862344-27434-1-git-send-email-chenhc@lemote.com>
References: <1344862344-27434-1-git-send-email-chenhc@lemote.com>
Date: Sat, 18 Aug 2012 10:50:20 -0700
Message-ID: <CAJiQ=7DGRxHp2hv79xpBdB_gV=iTiQaap=aytMe8=cNcm29Vrg@mail.gmail.com>
Subject: Re: [PATCH V2] MIPS: Fix poweroff failure when HOTPLUG_CPU configured.
From: Kevin Cernekee <cernekee@gmail.com>
To: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, Yong Zhang <yong.zhang@windriver.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 5:52 AM, Huacai Chen <chenhc@lemote.com> wrote:
> When poweroff machine, kernel_power_off() call disable_nonboot_cpus().
> And if we have HOTPLUG_CPU configured, disable_nonboot_cpus() is not an
> empty function but attempt to actually disable the nonboot cpus. Since
> system state is SYSTEM_POWER_OFF, play_dead() won't be called and thus
> disable_nonboot_cpus() hangs. Therefore, we make this patch to avoid
> poweroff failure.

I have seen the same problem; sometimes it causes a kernel oops too.

>  #ifdef CONFIG_HOTPLUG_CPU
> -               if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map) &&
> -                   (system_state == SYSTEM_RUNNING ||
> -                    system_state == SYSTEM_BOOTING))
> +               if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
>                         play_dead();

This fix works for me.

Acked-by: Kevin Cernekee <cernekee@gmail.com>

I do see SMP boot problems ("Attempted to kill the idle task!" panic)
on a 4-way box if the !cpu_isset() check is removed.
