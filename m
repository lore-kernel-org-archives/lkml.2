Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2HOOPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:15:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2HOOPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:15:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
Date: Wed, 15 Aug 2012 14:15:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-17-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1344966752-16102-17-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201208151415.39570.arnd@arndb.de>
X-Provags-ID: V02:K0:UR9toXt9rTrbn7CtH6/Lh/b0+U0R30gZUi4c0fa/TvY
 gJRd6DHQn8Jq6K4JQB1Ry8ElyZuRYYUrMxtTFJ1Yd0OXfNzLMf
 wCiHZiTa8b5CfsidL4T79TgQTz50s/OosgNQ5Du21hLDfkgiTW
 58/opNvCxApp3xfz3kjcGKC51cYep3UGq+BjE5u5XvmsHYANUc
 WojUJsb+ThCUHHpomzQUxXBCWfxETmWTCrBjaFUMm2r092fhY5
 ChkQOvKp863NZzmT1F+LjrlGIW6DL5Ub9WK5QokiHaN/AH/CGa
 rXJnKXkAQj/8jZOEAdCMR0AxjrFK2KvBi0s7KAz8aup/1eX1qe
 meQYnG0ilDBgsmqTHELk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012, Catalin Marinas wrote:
> +
> +void elf_set_personality(int personality)
> +{
> +       switch (personality & PER_MASK) {
> +       case PER_LINUX:
> +               clear_thread_flag(TIF_32BIT);
> +               break;
> +       case PER_LINUX32:
> +               set_thread_flag(TIF_32BIT);
> +               break;
> +       default:
> +               pr_warning("Process %s tried to assume unknown personality %d\n",
> +                          current->comm, personality);
> +               return;
> +       }
> +
> +       current->personality = personality;
> +}
> +EXPORT_SYMBOL(elf_set_personality);

This looks wrong: PER_LINUX/PER_LINUX32 decides over the output of the
uname system call, while TIF_32BIT decides over the instruction set
when returning to user space. You definitely should not set the personality
to the value you pass from the elf loader. Instead, just do

#define SET_PERSONALITY(ex) clear_thread_flag(TIF_32BIT);
#defined COMPAT_SET_PERSONALITY(ex) set_thread_flag(TIF_32BIT);

I also don't see a reason to export this. You'd have trouble loading
the elf interpreter module from user space without the elf interpreter.

	Arnd
