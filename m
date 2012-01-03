Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2ACXei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:34:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36408 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2ACXee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:34:34 -0500
Date: Wed, 4 Jan 2012 00:34:46 +0100
From: Emese Revfy <re.emese@gmail.com>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: possible use-after-free in drivers/mtd/ubi/wl.c: erase_worker
Message-ID: <20120104003446.695fd426@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think I found a potential problem in drivers/mtd/ubi/wl.c in
erase_worker():

1050         ubi_err("failed to erase PEB %d, error %d", pnum, err);
1051         kfree(wl_wrk);
1052         kmem_cache_free(ubi_wl_entry_slab, e);
1053
1054         if (err == -EINTR || err == -ENOMEM || err == -EAGAIN ||
1055             err == -EBUSY) {
1056                 int err1;
1057
1058                 /* Re-schedule the LEB for erasure */
1059                 err1 = schedule_erase(ubi, e, 0);

The pointer e is freed at line 1052 (kmem_cache_free), but
later it is passed to schedule_erase which will eventually call
erase_worker where it will be dereferenced and/or freed again.

It seems to have been introduced in commit
784c145444e7dd58ae740d406155b72ac658f151

Emese
