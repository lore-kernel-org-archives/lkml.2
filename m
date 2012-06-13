Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2FMPNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:13:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40239 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab2FMPNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <1339596420-18127-1-git-send-email-javi.merino@arm.com>
References: <1339596420-18127-1-git-send-email-javi.merino@arm.com>
Date: Wed, 13 Jun 2012 20:43:05 +0530
Message-ID: <CAJe_Zhfv2WdQYyQZE9KrFYHQajmBh31jQk7N26BtYSL20TaCyQ@mail.gmail.com>
Subject: Re: [PATCH] DMA: PL330: Fix racy mutex unlock
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2012 19:37, Javi Merino <javi.merino@arm.com> wrote:
> pl330_update() stores a pointer to the thrd->req that finished, which
> contains a pointer to the corresponding pl330_req.  This is done with
> the pl330_lock held.  Then, it iterates through the req_done list,
> calling the callback for each of the requests that are done.  The
> problem is that the driver releases the lock before calling the
> callback for each of the callbacks.  pl330_submit_req() running in
> another processor can then acquire the lock and insert another request
> in one of the thrd->req that hasn't been processed yet, replacing the
> pointer to pl330_req there.  When the callback returns in
> pl330_update() and the next rqdone is popped from the list, it
> dereferences the pl330_req pointer to the just scheduled pl330_req,
> instead of the one that has finished, calling pl330 with the wrong r.
>
> This patch fixes this by storing the pointer to pl330_req directly in
> the list.
>
.....
> @@ -1683,7 +1683,7 @@ static void pl330_dotask(unsigned long data)
>  /* Returns 1 if state was updated, 0 otherwise */
>  static int pl330_update(const struct pl330_info *pi)
>  {
> -       struct _pl330_req *rqdone;
> +       struct pl330_req *rqdone, *tmp;
>        struct pl330_dmac *pl330;
>        unsigned long flags;
>        void __iomem *regs;
> @@ -1750,7 +1750,10 @@ static int pl330_update(const struct pl330_info *pi)
>                        if (active == -1) /* Aborted */
>                                continue;
>
> -                       rqdone = &thrd->req[active];
> +                       /* Detach the req */
> +                       rqdone = thrd->req[active].r;
> +                       thrd->req[active].r = NULL;
> +
Doesn't this movement of "Detach the req" chunk effectively remain the
same? Since that was already protected by the same lock. I thought I
deliberately took care of that already.

Do you see some real problem fixed by this patch? Info about that
could help me better understand if I missed something here.

Thanks.
