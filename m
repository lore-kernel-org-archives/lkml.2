Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2BAFli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:41:38 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57632 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2BAFlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:41:36 -0500
Message-ID: <1328074891.2617.45.camel@edumazet-laptop>
Subject: Re: [PATCH] Fix logical and operator at interrupt handler thread
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Geunsik Lim <geunsik.lim@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 01 Feb 2012 06:41:31 +0100
In-Reply-To: <1328073594-16673-1-git-send-email-geunsik.lim@gmail.com>
References: <1328073594-16673-1-git-send-email-geunsik.lim@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 février 2012 à 14:19 +0900, Geunsik Lim a écrit :
> From: Geunsik Lim <geunsik.lim@samsung.com>
> 
> '&' is a bitwise operation. (e.g: a & b )
> Use '&&' and-operator instead of '&' bitwise operator.
> 
> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> ---
>  kernel/irq/manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index a9a9dbe..c0730ad 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -773,7 +773,7 @@ static int irq_thread(void *data)
>  			struct irqaction *action);
>  	int wake;
>  
> -	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
> +	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
>  					&action->thread_flags))
>  		handler_fn = irq_forced_thread_fn;
>  	else


This was intentional, to have a single conditional move :

ffffffff810b0868:       0f b6 15 19 f5 bd 00    movzbl 0xbdf519(%rip),%edx        # ffffffff81c8fd88 <force_irqthreads>
ffffffff810b086f:       49 89 c5                mov    %rax,%r13
ffffffff810b0872:       48 8b 43 40             mov    0x40(%rbx),%rax
ffffffff810b0876:       be 01 00 00 00          mov    $0x1,%esi
ffffffff810b087b:       48 c1 e8 04             shr    $0x4,%rax
ffffffff810b087f:       85 c2                   test   %eax,%edx
ffffffff810b0881:       48 c7 c0 80 0a 0b 81    mov    $0xffffffff810b0a80,%rax
ffffffff810b0888:       48 c7 c2 40 dc 80 81    mov    $0xffffffff8180dc40,%rdx
ffffffff810b088f:       4c 0f 44 f8             cmove  %rax,%r15


I guess you could instead use jump_label here to shorten the code.




