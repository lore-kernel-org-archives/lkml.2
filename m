Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab1HPTYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:24:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32827 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1HPTYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:24:33 -0400
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <20110816190858.GA4890@redhat.com>
References: <20110816190858.GA4890@redhat.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Tue, 16 Aug 2011 14:24:12 -0500
Message-ID: <CAHrUA357c2eCq=VkZwL97-nK7Kopzfj84gSESxebhL_P7rCurw@mail.gmail.com>
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 August 2011 14:08, Oleg Nesterov <oleg@redhat.com> wrote:
> daemonize() is only needed when a user-space task does kernel_thread().
>
> eeh_event_handler() thread is created by the worker kthread, and thus
> it doesn't need the soon-to-be-deprecated daemonize().
>
> Note: looks like eeh_event_wq can be static and it can do all work
> itself without kernel_thread().
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I've not been following the deprecation of daemonize(), so I presume
that the suggested change is indeed appropriate.

As to the kernel thread, realize that the eeh recovery proceedure
can take many seconds, or in certain pathological situations, it
can hang (e.g. if a sata controller dies and fails to recover when
there's a mounted file system on it ..)

so, given that, I'll just say:

Acked-by: Linas Vepstas <linasvepstas@gmail.com>

BTW, if someone wants to tackle a big, difficult project, one would be
to untangle the mess that happens when the hardware underneath an
active block device dies.  Currently, the kernel will deadlock in
umpteen zillion places waiting for blocks and files that will never
arrive.

--linas


> ---
>
>  arch/powerpc/platforms/pseries/eeh_event.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- 3.1/arch/powerpc/platforms/pseries/eeh_event.c~3_daemonize_eeh      2011-04-06 21:33:42.000000000 +0200
> +++ 3.1/arch/powerpc/platforms/pseries/eeh_event.c      2011-08-16 21:03:56.000000000 +0200
> @@ -60,7 +60,7 @@ static int eeh_event_handler(void * dumm
>        struct eeh_event        *event;
>        struct pci_dn *pdn;
>
> -       daemonize ("eehd");
> +       set_task_comm(current, "eehd");
>        set_current_state(TASK_INTERRUPTIBLE);
>
>        spin_lock_irqsave(&eeh_eventlist_lock, flags);
>
>
