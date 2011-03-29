Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1C2LZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:25:07 -0400
Received: from mail.aknet.ru ([78.158.192.28]:46433 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1C2LZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:25:05 -0400
Message-ID: <4D91C18D.8030701@aknet.ru>
Date: Tue, 29 Mar 2011 15:25:01 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Subject: vmsplice from mmapped DMA buffer
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'm trying to use vmsplice() to speed up the transfer
from the mmapped DMA buffer, and read it by another process.
As it seems to me, right now this is not really possible:
if the pipe reader lags, the DMA will overwrite the pages
that were not yet transferred. And I can't pause the DMA,
because it transfers the incoming realtime data stream.
So right now I am using the classic read/write, but that's
a huge CPU load.
Is there any way to achieve the reliable results with vmsplice?

If right now vmsplice cannot be reliably used to transfer
from the non-pausible DMA buffer, then I can think of the
following extensions (flags) to it:
- VMSPLICE_F_QUERY_PENDING: returns the number of bytes
still pending for IO, within the specified memory areas.
- VMSPLICE_F_VACATE: vacate the specified memory areas
from the pending IO, if any. By copying the pending data to the
kernel buffer.
- VMSPLICE_F_FLUSH: block until there is no more pending
IO for the specified memory areas.
- VMSPLICE_F_ASYNC: give SIGIO when the specified memory
areas are completely xferred and consumed by the reader.

Well, this flags will not play well with the existing vmsplice(),
so basically this is a brain-storming.
Anyway, are there any suggestions about vmsplicing from
the DMA buffer? Or, if not yet possible - what have to be done
to get there?
