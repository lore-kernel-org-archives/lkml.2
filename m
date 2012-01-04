Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2ADRdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:33:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65342 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2ADRdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:33:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120104003446.695fd426@gmail.com>
References: <20120104003446.695fd426@gmail.com>
Date: Wed, 4 Jan 2012 12:33:11 -0500
Message-ID: <CA+5PVA7BowJwum9TLCdLUfS7b6ifRQtkw3vf0rhO4+TwyLD6jg@mail.gmail.com>
Subject: Re: possible use-after-free in drivers/mtd/ubi/wl.c: erase_worker
From: Josh Boyer <jwboyer@gmail.com>
To: Emese Revfy <re.emese@gmail.com>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 6:34 PM, Emese Revfy <re.emese@gmail.com> wrote:
> Hi,
>
> I think I found a potential problem in drivers/mtd/ubi/wl.c in
> erase_worker():
>
> 1050         ubi_err("failed to erase PEB %d, error %d", pnum, err);
> 1051         kfree(wl_wrk);
> 1052         kmem_cache_free(ubi_wl_entry_slab, e);
> 1053
> 1054         if (err == -EINTR || err == -ENOMEM || err == -EAGAIN ||
> 1055             err == -EBUSY) {
> 1056                 int err1;
> 1057
> 1058                 /* Re-schedule the LEB for erasure */
> 1059                 err1 = schedule_erase(ubi, e, 0);
>
> The pointer e is freed at line 1052 (kmem_cache_free), but
> later it is passed to schedule_erase which will eventually call
> erase_worker where it will be dereferenced and/or freed again.

Yes.  That does seem to be a problem.  Care to create a patch that solves this
by deferring the frees until after the err variable is checked?

josh
