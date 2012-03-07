Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab2CGQa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:30:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:27829 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758732Ab2CGQa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:30:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115937584"
Message-ID: <1331138007.3463.16.camel@sauron.fi.intel.com>
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Date: Wed, 07 Mar 2012 18:33:27 +0200
In-Reply-To: <1329250006-22944-1-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just basic questions to make sure I understand things correctly.

Do you have plans to also change the user-space tools?

On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
> 1) A primary checkpoint block, which contains merily a pointer to the
>    erase block(s) which hold the real checkpointing data.
> 
>    This primary block is guaranteed to be held within the first N
>    eraseblocks of a device. N is momentarily set to 16, but it might
>    be necessary to make this configurable in some way.

Does it mean that you reserve the first 16 PEBs for the primary block? 

I guess we need to carefully look an this number and make the default to
be good enough for the general case.

> 2) The secondary checkpoint blocks, which contain the real
>    checkpointing data (physical to logical eraseblock relations,
>    erase counts, sequence numbers ...)

>    Aside of that the checkpointing data contains a list of blocks
>    which belong to the active working pool. The active working pool is
>    a fixed number of blocks for shortterm, longterm and unknown
>    storage time, which can be modified before the next checkpoint set
>    is written to FLASH. These blocks need to be scanned in the
>    conventional UBI scan mode.

BTW, WRT short-term etc - how about just killing these concepts? I am
really not sure they make much sense anyway and give any improvements. 

I guess this would simplify things for you as well. I'd vote for
removing them.

>    The reason for these pool blocks is to reduce the checkpoint
>    updates to the necessary minimum to avoid accelerated device
>    wearout in scenarios where data changes rapidly. The checkpoint
>    data is updated whenever a working pool runs out of blocks.
> 
>    The number of pool blocks can be defined with a config option at
>    the moment, but this could also be done at runtime via sysfs. In
>    case of a change the checkpointing data would be reconstructed.

Id suggest to introduce as few configuration knob as possible. My
experience show that they usually only hurt. I'd stick to this rule for
most cases: no user, no knob.

> So the checkpoint scan consists of the following steps:
> 
>    1) Find the primary checkpoint block by scanning the start of the
>       device.
> 
>    2) Read the real checkpoint data and construct the UBI device info
>       structures.
> 
>    3) Scan the pool blocks.
> 
> All these operations scan a limited number of erase blocks which makes
> the UBI init O(1) and independent of the device size.

Well, is it really true? The larger is the flash the more you read and
process anyway, and it is still linear, but the multiplier becomes very
small, so this is a huge improvement.

> The checkpoint functionality is fully compatible with existing UBI
> deployments. If no checkpoint blocks can be found then the device is
> scanned and the checkpoint blocks are created from the scanned
> information.
> 
> Aside of review and testing it needs to be decided, whether the number
> of pool blocks should be deduced from the device size (number of
> physical eraseblocks) or made configurable at compile or runtime.

I would go for automatic decisions. Manual configuration can always be
added later if needed.

> Thanks to the folks at CELF who sponsored this work!

Indeed thanks! And thank you Richard!

-- 
Best Regards,
Artem Bityutskiy

