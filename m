Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab1BJWoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:44:20 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:27601 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756890Ab1BJWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:44:16 -0500
Message-ID: <4D546A5B.5090301@bluewatersys.com>
Date: Fri, 11 Feb 2011 11:44:43 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 03/10] Add yaffs2 file system: checkpoint streaming
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <1297221968-6747-4-git-send-email-cdhmanning@gmail.com> <alpine.LNX.2.00.1102102324530.8012@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102102324530.8012@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 11:27 AM, Jesper Juhl wrote:
> On Wed, 9 Feb 2011, Charles Manning wrote:
> 
>> Signed-off-by: Charles Manning <cdhmanning@gmail.com>
>> ---
>>  fs/yaffs2/yaffs_checkptrw.c |  408 +++++++++++++++++++++++++++++++++++++++++++
>>  fs/yaffs2/yaffs_checkptrw.h |   33 ++++
>>  2 files changed, 441 insertions(+), 0 deletions(-)
>>  create mode 100644 fs/yaffs2/yaffs_checkptrw.c
>>  create mode 100644 fs/yaffs2/yaffs_checkptrw.h
>>
>> diff --git a/fs/yaffs2/yaffs_checkptrw.c b/fs/yaffs2/yaffs_checkptrw.c
>> new file mode 100644
>> index 0000000..997a618
>> --- /dev/null
>> +++ b/fs/yaffs2/yaffs_checkptrw.c
>> @@ -0,0 +1,408 @@
>> +/*
>> + * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
>> + *
>> + * Copyright (C) 2002-2011 Aleph One Ltd.
>> + *   for Toby Churchill Ltd and Brightstar Engineering
>> + *
>> + * Created by Charles Manning <charles@aleph1.co.uk>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include "yaffs_checkptrw.h"
>> +#include "yaffs_getblockinfo.h"
>> +
>> +static int yaffs2_checkpt_space_ok(struct yaffs_dev *dev)
>> +{
>> +	int blocks_avail = dev->n_erased_blocks - dev->param.n_reserved_blocks;
>> +
>> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
>> +		"checkpt blocks_avail = %d", blocks_avail);
>> +
>> +	return (blocks_avail <= 0) ? 0 : 1;
>> +}
>> +
>> +static int yaffs_checkpt_erase(struct yaffs_dev *dev)
>> +{
>> +	int i;
>> +
>> +	if (!dev->param.erase_fn)
>> +		return 0;
>> +	yaffs_trace(YAFFS_TRACE_CHECKPOINT,
>> +		"checking blocks %d to %d",
>> +		dev->internal_start_block, dev->internal_end_block);
>> +
>> +	for (i = dev->internal_start_block; i <= dev->internal_end_block; i++) {
> 
> Why does 'i' need 'function scope'? can't it just have 'for scope'?
> 
>      for (int i = dev->internal_start_block; i <= dev->internal_end_block; i++) {

Because we don't do that in kernel code.

ryan@okiwi:linux-2.6$ grep "for (int" * -R | wc -l
16

Those sixteen should be fixed :-). Half of them are in drivers/staging.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
