Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab0JSAvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:51:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37354 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab0JSAvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vfl7j9IoDszbkEamNSr161ANtbqRAGOZiJco1AMSCIo/ojemE9XcRLGyzN0kwxcPU+
         nCK5o7Bq8iyR9MkTjOug7l6/MBRIrNzSPWyJRPoOezLE0129sXV7SvEnInA1lded+e/I
         UdXtXc1RTXxF1rdhNBJe4mvTOrMCz+k8MVhz8=
MIME-Version: 1.0
In-Reply-To: <4CBCE05E.20408@renesas.com>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
	<17d8d27a2356640a4359f1a7dcbb3b42@localhost>
	<4CBC4F4E.5010305@pobox.com>
	<AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
	<4CBCE05E.20408@renesas.com>
Date: Mon, 18 Oct 2010 17:51:09 -0700
Message-ID: <AANLkTinTaW87RGUZ+o4TL8gzUPGkoR8=7C1e7aYWC9=b@mail.gmail.com>
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
From: Kevin Cernekee <cernekee@gmail.com>
To: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Cc: Shinya Kuribayashi <skuribay@pobox.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 5:03 PM, Shinya Kuribayashi
<shinya.kuribayashi.px@renesas.com> wrote:
> IIUC, the problem is that write operation originating from step 5. seems
> to overtake the one originating from step 3., correct?

Correct.  This particular system makes no guarantees that data flushed
out through CACHE operations will not overtake subsequent uncached
stores.

For the case of DMA, it is possible that data that I am attempting to
send to a device (via DRAM) could still be in transit when
dma_cache_wback() returns, and may be incomplete when the DMA
operation starts.  Or that dirty cachelines that I am attempting to
"free up" for a DMA_FROM_DEVICE operation are still in transit when
dma_cache_wback_inv() returns, potentially clobbering whatever data
the peripheral is trying to write to memory.

Adding SYNC at the end of dma_cache_wback* guarantees that the write
buffers have been emptied out to DRAM and I do not have to worry
anymore about any of these cases.

> Then we'd like to know, what is that 'Caller mentioned at step 5.', and
> what kind of operation will be done by the Caller?

It is my recollection that the caller was the USB EHCI driver, and it
was allocating some sort of uncached descriptor block that contained
pointers.  Sometimes those pointers got inexplicably zeroed out, and
this is what we found to be the root cause.
