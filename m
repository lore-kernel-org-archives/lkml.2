Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab2IQR6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:58:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7037 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab2IQR6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:58:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6838"; a="237695960"
Message-ID: <505764A7.901@codeaurora.org>
Date: Mon, 17 Sep 2012 10:57:59 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC][PATCH] fs/buffer.c: Revoke LRU when trying to drop buffers
References: <1347384529-5862-1-git-send-email-lauraa@codeaurora.org> <alpine.LSU.2.00.1209141821310.2138@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1209141821310.2138@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 9/14/2012 6:41 PM, Hugh Dickins wrote:
> On Tue, 11 Sep 2012, Laura Abbott wrote:
>> When a buffer is added to the LRU list, a reference is taken which is
>> not dropped until the buffer is evicted from the LRU list. This is the
>> correct behavior, however this LRU reference will prevent the buffer
>> from being dropped. This means that the buffer can't actually be dropped
>> until it is selected for eviction. There's no bound on the time spent
>> on the LRU list, which means that the buffer may be undroppable for
>> very long periods of time. Given that migration involves dropping
>> buffers, the associated page is now unmigratible for long periods of
>> time as well.
>
> Disclaimer: I'm no expert on buffer_heads, and haven't studied your
> patch.  But it seems to me that this is an issue with the (unnamed)
> filesystem you use, rather than a problem to be solved in drop_buffers().
>

We are using ext4

> extN, gfs2, ntfs, ocfs2 and xfs set .migratepage = buffer_migrate_page,
> and I cannot see that page migration involves drop_buffers() at all in
> that case: it transfers the buffer_heads from the old page to the new,
> whether they're busy or not, with no attempt to free them.
>

That's true for most of the address spaces EXCEPT for the journaled 
address space operations; ext4_ordered_aops, ext4_writeback_aops, 
ext4_da_aops all set migratepage but ext4_journalled_aops does not set 
migratepage at all. This seems to be true all the way back to when the 
migratepage was added for ext3.

> Maybe your filesystem can be converted, with or without some extra help,
> to buffer_migrate_page() instead of the default fallback_migrate_page():
> which indeed has to play safe, doing the try_to_release_page() you see.
> Maybe ask on the mailing list for your filesystem?
>

I could ask on the ext mailing list for the historical reasons why the 
journalled ops don't have migrate pages, but I'm still going to assert 
this is still a problem with fallback_migrate_page. It's still possible 
to have drop_buffers fail unnecessarily because the buffer is stuck on 
the LRU list and I don't see why the problem shouldn't be fixed there as 
well.

> Hugh
>

Thanks,
Laura
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
