Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab1D2KJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 06:09:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50883 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1D2KJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 06:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Hope+sTf4PKh04xNKRZNfbVnjqwiWTSC4fC3ZWvuO3hbxeriSOnHo6TmUMz1aLqZ6/
         N1+ZV7j/sGUmS+IHRmvX4obuwzfudJAgukry1zmjbBso7z2SfljWzrJMet03XazNXSXB
         hYIoT+viaX/2yJlURXg/kA6QlnXNGPLKgZnLY=
Message-ID: <4DBA8F30.2060206@gmail.com>
Date: Fri, 29 Apr 2011 18:13:04 +0800
From: =?GB2312?B?v7W9o7Hz?= <kjbmail@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dan.j.williams@intel.com
Subject: Can I/OAT DMA engineer access PCI MMIO space
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I try to use ioatdam to copy data from system memory to pci MMIO space:

=======================
void mmio_copy(void *dst, void *src, size_t len)
struct async_submit_ctl submit;
struct memcpy_context ctx;

atomic_set(&ctx.cnt, 1);
init_completion(&ctx.cmp);
init_async_submit(&submit, ASYNC_TX_ACK, NULL,
done_memcpy, &ctx, NULL);

while (len) {
size_t clen = (len > PAGE_SIZE) ? PAGE_SIZE : len;
struct page *p_dst, *p_src;

p_dst = virt_to_page(dst);
p_src = virt_to_page(src);

atomic_inc(&ctx.cnt);

ntb_async_memcpy(p_dst, p_src, 0, 0, clen, &submit);

dst += clen;
src += clen;
len -= clen;
}

if (atomic_dec_and_test(&ctx.cnt))
return;

async_tx_issue_pending_all();
wait_for_completion(&ctx.cmp);
=================

If dst points to a memory space, the operation would pass.
But if dst points to a pci MMIO space, it failed with kernel oops.
It seems the code:
BUG_ON(is_ioat_bug(chanerr));
in drivers/dma/ioat/dma_v3.c, line 365 cause the oops.
Is there anyway to access pci MMIO space using ioat?
The datasheet says that ioat supports MMIO access.


