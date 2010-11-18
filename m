Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab0KROAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:00:48 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:50814 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0KROAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mAFUaLEyPZoxBsFiqBCddB9XrVDzZlU/OL2fRpDGPQC4fcHf68Oq1uUuOAuZODpLmf
         wenj3vAWkIs2BEmOLgRSvhexukpMG8JzKRBZ5WsyVVKF1mHdiO7qpZ3fRtLeviA28BVS
         14OqNnYX+eu0chvAGSQE5387t2/YIqm3fX+QI=
Date: Thu, 18 Nov 2010 22:03:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2/2] uml: Disable winch irq before freeing handler data.
Message-ID: <20101118140346.GB3800@hack>
References: <AANLkTikT9ch4NfL2MBDL=qUT=Q2ierehFNp1=Ux8tNNC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikT9ch4NfL2MBDL=qUT=Q2ierehFNp1=Ux8tNNC@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 05:45:19PM +0000, Will Newton wrote:
>Disable the winch irq early to make sure we don't
>take an interrupt part way through the freeing of
>the handler data, resulting in a crash on shutdown:
>
>winch_interrupt : read failed, errno = 9
>fd 13 is losing SIGWINCH support
>------------[ cut here ]------------
>WARNING: at lib/list_debug.c:48 list_del+0xc6/0x100()
>list_del corruption, next is LIST_POISON1 (00100100)
>082578c8:  [<081fd77f>] dump_stack+0x22/0x24
>082578e0:  [<0807a18a>] warn_slowpath_common+0x5a/0x80
>08257908:  [<0807a23e>] warn_slowpath_fmt+0x2e/0x30
>08257920:  [<08172196>] list_del+0xc6/0x100
>08257940:  [<08060244>] free_winch+0x14/0x80
>08257958:  [<080606fb>] winch_interrupt+0xdb/0xe0
>08257978:  [<080a65b5>] handle_IRQ_event+0x35/0xe0
>08257998:  [<080a8717>] handle_edge_irq+0xb7/0x170
>082579bc:  [<08059bc4>] do_IRQ+0x34/0x50
>082579d4:  [<08059e1b>] sigio_handler+0x5b/0x80
>082579ec:  [<0806a374>] sig_handler_common+0x44/0xb0
>08257a68:  [<0806a538>] sig_handler+0x38/0x50
>08257a78:  [<0806a77c>] handle_signal+0x5c/0xa0
>08257a9c:  [<0806be28>] hard_handler+0x18/0x20
>08257aac:  [<00c14400>] 0xc14400
>
>Signed-off-by: Will Newton <will.newton@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Cc Andrew Morton.

>---
> arch/um/drivers/line.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
>index 5f12fef..050e4dd 100644
>--- a/arch/um/drivers/line.c
>+++ b/arch/um/drivers/line.c
>@@ -727,6 +727,9 @@ struct winch {
>
> static void free_winch(struct winch *winch, int free_irq_ok)
> {
>+	if (free_irq_ok)
>+		free_irq(WINCH_IRQ, winch);
>+
> 	list_del(&winch->list);
>
> 	if (winch->pid != -1)
>@@ -735,8 +738,6 @@ static void free_winch(struct winch *winch, int free_irq_ok)
> 		os_close_file(winch->fd);
> 	if (winch->stack != 0)
> 		free_stack(winch->stack, 0);
>-	if (free_irq_ok)
>-		free_irq(WINCH_IRQ, winch);
> 	kfree(winch);
> }
>
>-- 
>1.7.0.4

>From 439d75478f6981ff1b829d711bcce3603f5a9786 Mon Sep 17 00:00:00 2001
>From: Will Newton <will.newton@gmail.com>
>Date: Sat, 13 Nov 2010 17:12:33 +0000
>Subject: [PATCH 2/2] uml: Disable winch irq before freeing handler data.
>
>Disable the winch irq early to make sure we don't
>take an interrupt part way through the freeing of
>the handler data, resulting in a crash on shutdown:
>
>winch_interrupt : read failed, errno = 9
>fd 13 is losing SIGWINCH support
>------------[ cut here ]------------
>WARNING: at lib/list_debug.c:48 list_del+0xc6/0x100()
>list_del corruption, next is LIST_POISON1 (00100100)
>082578c8:  [<081fd77f>] dump_stack+0x22/0x24
>082578e0:  [<0807a18a>] warn_slowpath_common+0x5a/0x80
>08257908:  [<0807a23e>] warn_slowpath_fmt+0x2e/0x30
>08257920:  [<08172196>] list_del+0xc6/0x100
>08257940:  [<08060244>] free_winch+0x14/0x80
>08257958:  [<080606fb>] winch_interrupt+0xdb/0xe0
>08257978:  [<080a65b5>] handle_IRQ_event+0x35/0xe0
>08257998:  [<080a8717>] handle_edge_irq+0xb7/0x170
>082579bc:  [<08059bc4>] do_IRQ+0x34/0x50
>082579d4:  [<08059e1b>] sigio_handler+0x5b/0x80
>082579ec:  [<0806a374>] sig_handler_common+0x44/0xb0
>08257a68:  [<0806a538>] sig_handler+0x38/0x50
>08257a78:  [<0806a77c>] handle_signal+0x5c/0xa0
>08257a9c:  [<0806be28>] hard_handler+0x18/0x20
>08257aac:  [<00c14400>] 0xc14400
>
>Signed-off-by: Will Newton <will.newton@gmail.com>
>---
> arch/um/drivers/line.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
>index 5f12fef..050e4dd 100644
>--- a/arch/um/drivers/line.c
>+++ b/arch/um/drivers/line.c
>@@ -727,6 +727,9 @@ struct winch {
> 
> static void free_winch(struct winch *winch, int free_irq_ok)
> {
>+	if (free_irq_ok)
>+		free_irq(WINCH_IRQ, winch);
>+
> 	list_del(&winch->list);
> 
> 	if (winch->pid != -1)
>@@ -735,8 +738,6 @@ static void free_winch(struct winch *winch, int free_irq_ok)
> 		os_close_file(winch->fd);
> 	if (winch->stack != 0)
> 		free_stack(winch->stack, 0);
>-	if (free_irq_ok)
>-		free_irq(WINCH_IRQ, winch);
> 	kfree(winch);
> }
> 
>-- 
>1.7.0.4
>


-- 
Live like a child, think like the god.
 
