Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593Ab0HMN2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:28:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51651 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0HMN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vCExaWerS3/U17eVwb2bCHCSvaEDVTsoQaE4nAQ4mGb4W0dDaLwoNRlGH4WnJ2Bmcx
         54XL/mP3kyzsQIxLyLQB49Eirsd/umxFjbfDjK8n4NFgADz1dwR1Km3BoHWkDqizBswK
         XuFR2Y/enHxab+lRcj0ReqDYhpvVePAnAwWAk=
Subject: [QUESTION] Need some explanations in regard to memory alignment of
 requests that a block device receives
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 16:27:51 +0300
Message-ID: <1281706071.4160.18.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I currently am writing a block driver for Legacy Memory sticks.

I have few questions about that type of data my ->request will receive
from kernel.

First of all I think that by default, driver receives requests that
contains just one sector and it isn't in high memory.

However I am opting in to allow to receive requests that have many
sectors span several memory regions, and be in highmem).
The request is converted to scatterlist upon which I operate.
(Untill this point I did the same think Alex does in mspro_blk.c)

For simplicity lets assume 512 byte hardware sector size.

However is there a guarantee that incoming memory segments will be
aligned on 512 byte boundary?

If this isn't true I run into 2 problems:

1. Sector can span 2 pages. Therefore if I decide to do pio, and I use
kmap_atomic (because of highmem), I need first map 1st page, read/write
it, unmap it, and then then do the same with 2nd page.


2. Sectors can span 2 memory regions.
This is even worse. For DMA I would need to bounce the sector.
Also it becames very difficult to handle input on sector by sector basis
(short of bouncing everything...)


If the above is true (I hope), then I have different problem.

The problem is that I will have small buffer that will contain few
hardware sectors.
I currently allocate it using kmalloc.
However I want to send that buffer to same functions that deal with IO,
therefore I need it to be aligned on 512 byte boundary.

Is there a way to allocate aligned memory (short of allocating more and
aligning pointer manually which I hate to do)
Maybe I should just use __get_free_pages?
(I will need a buffer of page or two (once per driver load) I think).

Best regards,
Maxim Levitsky


