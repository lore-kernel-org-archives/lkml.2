Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2FMTPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:15:25 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48025 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754467Ab2FMTPS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:15:18 -0400
MIME-Version: 1.0
In-Reply-To: <4FD8DDC3.1070903@arm.com>
References: <1339596420-18127-1-git-send-email-javi.merino@arm.com>
	<CAJe_Zhfv2WdQYyQZE9KrFYHQajmBh31jQk7N26BtYSL20TaCyQ@mail.gmail.com>
	<4FD8DDC3.1070903@arm.com>
Date: Thu, 14 Jun 2012 00:45:16 +0530
Message-ID: <CAJe_ZheY6o3Sg5i5RJNfff4m5-m_UQJ8_VOFQTP1FuumOR3VbA@mail.gmail.com>
Subject: Re: [PATCH] DMA: PL330: Fix racy mutex unlock
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 June 2012 00:06, Javi Merino <javi.merino@arm.com> wrote:
>
> Ok, the description sucks.  Let me try to describe it with the scenario that
> failed:
>
> Core 0:
> - Two DMA transactions finish, in channels 0 and 1.
> - pl330_update() is called, the "Event-Interrupt Status Register" (ES)
>  is 0x3.
> - In the "for (ev = 0;..." loop
>  + two pointers are stored in pl330->req_done:
>    pl330->channels[0]->req[0] and pl330->channels[1]->req[0]
> - In the "while (!list_empty.." loop,
>  + r = pl330->channels[0]->req[0]->r
>  + Release the pl330_lock and call _callback()
>
> Core 1:
> - pl330_submit_req() for channel 1
> - Grab the pl330_lock
> - Hook a request in pl330->channels[1]->req[0]->r
> - Release the pl330_lock
>
> Core 0:
> - _callback() returns
> - Acquire the pl330_lock again
> - second iteration of "while (!list_empty.." loop,
>  + r = pl330->channels[1]->req[0]->r , but you get the r that has just
>    been scheduled, not the one that finished.
>
Thanks for detailed explanation of the bug.

I see, it's not safe across channels. Another option could be taking
channel's lock in update and submit.

Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
