Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1HCTIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:08:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44684 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HCTII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110803182826.GB2865@albatros>
References: <20110803140456.GA14393@redhat.com>
	<20110803182417.GA2510@albatros>
	<20110803182826.GB2865@albatros>
Date: Wed, 3 Aug 2011 21:08:06 +0200
Message-ID: <CAOLZvyFQPCsU7bnyv=iyz3FSBF72iYiLGKarvCfq6Z=2i_bOVw@mail.gmail.com>
Subject: Re: [PATCH] shm: optimize exit_shm()
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Richard Weinberger <richard@nod.at>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 3, 2011 at 8:28 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> We may check .in_use == 0 without holding the rw_mutex as .in_use is int
> and reads of ints are atomic.  As .in_use may be changed to zero while current
> process was sleeping in down_write(), we should check .in_use once again after
> down_write().
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  ipc/shm.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 4e3c883..855ddc0 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -304,6 +304,9 @@ void exit_shm(struct task_struct *task)
>  {
>        struct ipc_namespace *ns = task->nsproxy->ipc_ns;
>
> +       if (shm_ids(ns).in_use == 0)
> +               return;
> +
>        /* Destroy all already created segments, but not mapped yet */
>        down_write(&shm_ids(ns).rw_mutex);
>        if (shm_ids(ns).in_use)

This check here is now unnecessary, yes?

And this also fixes the oops.

Manuel
