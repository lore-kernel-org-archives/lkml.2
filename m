Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab2LOBun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:50:43 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52561 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab2LOBum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:50:42 -0500
MIME-Version: 1.0
In-Reply-To: <1354503541-13463-1-git-send-email-josephl@nvidia.com>
References: <1354503541-13463-1-git-send-email-josephl@nvidia.com>
Date: Fri, 14 Dec 2012 17:50:41 -0800
X-Google-Sender-Auth: eryzSorHNMaTkCHB4eQ5VBSSqF4
Message-ID: <CAMbhsRSuff0_JXEsuPh4TMOB9Na2zpV2QXT=eeUKFAyMZcDRoA@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: coupled: fix the potensial race condition and deadlock
From: Colin Cross <ccross@android.com>
To: Joseph Lo <josephl@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 6:59 PM, Joseph Lo <josephl@nvidia.com> wrote:
> Considering the chance that two CPU come into cpuidle_enter_state_coupled at
> very close time. The 1st CPU increases the waiting count and the 2nd CPU do the
> same thing right away. The 2nd CPU found the 1st CPU already in waiting then
> prepare to poke it.
>
> Before the 2nd CPU to poke 1st CPU, the 1st found the waiting count already same
> with cpu_online count. So the 1st won't go into waiting loop and the 2nd CPU
> didn't poke it yet. The 1st CPU will go into ready loop directly.
>
> Then the 2nd CPU set up the couple_cpuidle_mask for 1st CPU and poke it. But the
> 1st CPU already lost the chance to handle the poke and clear the
> couple_cpuidle_mask. Now whole MPcore are alredy to be coupled. The MPcore will
> go into the power saving idle mode.
>
> Because the poke was be implemented as a "smp_call_function_single", it's a
> software intrrupt of "IPI_SINGLE_FUNC". If the power saving idle mode of the
> platform can't retain the software interrupt of power saving idle mode, (e.g.
> Tegra's powerd-down idle mode will shut off cpu power that include the power of
> GIC) the software interrupt will got lost.

This is the root of your problem.  The cpu should never go to idle
while an IPI is pending.  I thought we already had a patch to return
an error from gic_cpu_save when an IPI was pending and abort the idle
transition, but apparently not and I can't find any references to it.

> When the CPU resumed from the power saving idle mode and the system still keep
> idle, it will go into idle mode again immediately. Because the
> "smp_call_function_single" not allow the same function be called for the same
> cpu twice, or it will got a lock. So the "couple_cpuidle_mask" can't be cleared
> by 1st CPU, the 2nd CPU also can't poke it again. Then the deadlock happens
> here.
>
> The fix here used different wake up mechanism. Because there are already two
> loops and a gloable variable "ready_waiting_counts" to sync the status of
> MPcore to coupled state, the "coupled_cpuidle_mask" was not really necessary.
> Just waking up the CPU from waiting and checking if the CPU need resched at
> outside world to take the CPU out of idle are enough. And this fix didn't
> modify the original behavior of coupled cpuidle framework. It should still
> compitable with the origianal. The cpuidle driver that already applies
> coupled cpuidle not need to change as well.

I don't like using the arch IPI functions directly, especially not
reusing arch_send_call_function_single_ipi without a function to call.
