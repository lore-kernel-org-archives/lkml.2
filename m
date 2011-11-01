Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1KAHOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:14:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39366 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1KAHOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd88-QomPkrrDY0TzuJodW6XwecMSKufBqFaE2W16ntX2Q@mail.gmail.com>
References: <1320075907-4079-1-git-send-email-linkinjeon@gmail.com>
	<20111031160145.GD4468@shiny>
	<CAKYAXd88-QomPkrrDY0TzuJodW6XwecMSKufBqFaE2W16ntX2Q@mail.gmail.com>
Date: Tue, 1 Nov 2011 15:14:53 +0800
X-Google-Sender-Auth: GzZ2XcVUhLLtzwMWnwXmUNeHsQ0
Message-ID: <CANejiEVg18ZFZWzFRK6Lm2H_65ovW=N6Fe0q02y1LcDQnKsi2Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: add block plug for .writepages
From: Shaohua Li <shaohua.li@intel.com>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/1 NamJae Jeon <linkinjeon@gmail.com>:
> 2011/11/1 Chris Mason <chris.mason@oracle.com>:
>> On Tue, Nov 01, 2011 at 12:45:07AM +0900, Namjae Jeon wrote:
>>> Add block plug for btrfs .writepages. Block plug is helpful to reduce block lock contention.
>>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>>> ---
>>>  fs/btrfs/extent_io.c |    4 ++++
>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index d418164..8f2d6bd 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -2388,6 +2388,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
>>>       pgoff_t end;            /* Inclusive */
>>>       int scanned = 0;
>>>       int tag;
>>> +     struct blk_plug plug;
>>>
>>>       pagevec_init(&pvec, 0);
>>>       if (wbc->range_cyclic) {
>>> @@ -2405,6 +2406,8 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
>>>  retry:
>>>       if (wbc->sync_mode == WB_SYNC_ALL)
>>>               tag_pages_for_writeback(mapping, index, end);
>>> +
>>> +     blk_start_plug(&plug);
>>>       while (!done && !nr_to_write_done && (index <= end) &&
>>>              (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
>>>                       min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
>>> @@ -2468,6 +2471,7 @@ retry:
>>>               pagevec_release(&pvec);
>>>               cond_resched();
>>>       }
>>> +     blk_finish_plug(&plug);
>>>       if (!scanned && !done) {
>>>               /*
>>>                * We hit the last page and there is more work to be done: wrap
>>
>> Thanks for the patch, but we actually do this at a lower level in btrfs.
>> The actual IO can be done to multiple block devices, so we try to plug
>> for each device individually.
>>
>> -chris
>>
>>
> Hi. Chris.
>
> I got your point. pending bio is operated by worker_loop thread.
> But Is block plug needed in extent_readpages ?
.readpages are called in readahead, where we already have block
plug.
