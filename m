Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2HOPHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:07:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2HOPHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:07:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 23/31] arm64: Debugging support
Date: Wed, 15 Aug 2012 15:07:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-24-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-24-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208151507.36174.arnd@arndb.de>
X-Provags-ID: V02:K0:Ig78lER7e5JbJ4UWZHBdFy/2CQVYKwLU0DvSE5BIkji
 i5rFU3Vc88kivtY7se48t9goyCOvZILummXjXNRl/Cm7UxhS30
 SgFvH7IOEnNRV/k7vapq747/afpoGN+n04b14J9h9p+HeOTHFu
 mHm/DrEhHZL38+c2FKtDkH/6LsQgX/zyemIaElZXNMwJ1pmufc
 p7g9mactk5s6q+VGSZ9uKBw+1zh2S70KHDyw8qxraHTAcgSNsi
 ieNcWM70aj9p4t+rMS+lEGNlHwhML8+8ER6TaMiA9RGSDIz5i0
 nGuTOKMbRB7QOd77oIO3ogIJkX0SdgPENUavNFkYnpYyY8wB9S
 F3Cr67iPxwb/TgXtsoqo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:

> +const struct user_regset_view *task_user_regset_view(struct task_struct *task)
> +{
> +#ifdef CONFIG_AARCH32_EMULATION
> +	if (test_tsk_thread_flag(task, TIF_32BIT))
> +		return &user_aarch32_view;
> +#endif
> +	return &user_aarch64_view;
> +}

Ah, nice. So you support 64 bit debuggers debugging 32 bit processes, right?

>From what I can tell, there is no support for 32 bit processes debugging
64 bit ones. Is that something you plan to add in the future, or do you
consider that out of scope? In either case, a comment would be helpful.

> +long arch_ptrace(struct task_struct *child, long request,
> +		 unsigned long addr, unsigned long data)
> +{
> +	int ret;
> +	unsigned long *datap = (unsigned long __user *)data;
> +
> +	switch (request) {
> +		case PTRACE_GET_THREAD_AREA:
> +			ret = put_user(child->thread.tp_value, datap);
> +			break;
> +
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +		case PTRACE_GETHBPREGS:
> +			ret = ptrace_gethbpregs(child, addr, datap);
> +			break;
> +
> +		case PTRACE_SETHBPREGS:
> +			ret = ptrace_sethbpregs(child, addr, datap);
> +			break;
> +#endif
> +
> +		default:
> +			ret = ptrace_request(child, request, addr, data);
> +			break;
> +	}
> +
> +	return ret;
> +}

Is there a reaons why these are not regsets but have their own ptrace
commands? I believe new architectures should generally not add ptrace
commands any more.

	Arnd
