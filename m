Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab1EXTey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:34:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754455Ab1EXTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:34:53 -0400
Date: Tue, 24 May 2011 12:34:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 5/7] um: print info about fatal segfaults
Message-Id: <20110524123433.0b74f33e.akpm@linux-foundation.org>
In-Reply-To: <1306075716-20042-5-git-send-email-richard@nod.at>
References: <1306075716-20042-1-git-send-email-richard@nod.at>
	<1306075716-20042-5-git-send-email-richard@nod.at>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 May 2011 16:48:34 +0200
Richard Weinberger <richard@nod.at> wrote:

> +static void show_segv_info(struct uml_pt_regs *regs)
> +{
> +	struct task_struct *tsk = current;
> +	struct faultinfo *fi = UPT_FAULTINFO(regs);
> +
> +	if (!unhandled_signal(tsk, SIGSEGV))
> +		return;
> +
> +	if (!printk_ratelimit())
> +		return;
> +
> +	printk("%s%s[%d]: segfault at %lx ip %p sp %p error %x",
> +		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
> +		tsk->comm, task_pid_nr(tsk), FAULT_ADDRESS(*fi),
> +		(void *)UPT_IP(regs), (void *)UPT_SP(regs),
> +		fi->error_code);
> +
> +	print_vma_addr(KERN_CONT " in ", UPT_IP(regs));
> +	printk(KERN_CONT "\n");
> +}

Please see the nice comment in printk.h

/*
 * Please don't use printk_ratelimit(), because it shares ratelimiting state
 * with all other unrelated printk_ratelimit() callsites.  Instead use
 * printk_ratelimited() or plain old __ratelimit().
 */

I thought we had a checkpatch rule for this but apparently I dreamed
it.

