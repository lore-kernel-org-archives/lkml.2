Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2IBIlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 04:41:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35379 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2IBIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 04:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <1344500582-11110-1-git-send-email-qiang.liu@freescale.com>
References: <1344500582-11110-1-git-send-email-qiang.liu@freescale.com>
Date: Sun, 2 Sep 2012 01:41:18 -0700
X-Google-Sender-Auth: YP_b-_s0fs150wFXrRmhV7TMI0s
Message-ID: <CAA9_cmeFamCX1u+z3fP_gxAqe83JFbY9Beqpqgb-PjRoJ8BrWA@mail.gmail.com>
Subject: Re: [PATCH v7 6/8] fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
From: Dan Williams <djbw@fb.com>
To: qiang.liu@freescale.com
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        kim.phillips@freescale.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, arnd@arndb.de, gregkh@linuxfoundation.org,
        Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 1:23 AM,  <qiang.liu@freescale.com> wrote:
> From: Qiang Liu <qiang.liu@freescale.com>
>
> The use of spin_lock_irqsave() is a stronger locking mechanism than is
> required throughout the driver. The minimum locking required should be
> used instead. Interrupts will be turned off and context will be saved,
> there is needless to use irqsave.
>
> Change all instances of spin_lock_irqsave() to spin_lock_bh().
> All manipulation of protected fields is done using tasklet context or
> weaker, which makes spin_lock_bh() the correct choice.

It seems you are coordinating fsl-dma copy and talitos xor operations.
 It looks like fsl-dma will be called through
talitos_process_pending()->dma_run_dependencies(), which is
potentially called in hard irq context.

This all comes back to the need to fix raid offload to manage the
channels explicitly rather than the current dependency chains.

--
Dan
