Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2BCOBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:01:30 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62938 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab2BCOB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:01:29 -0500
MIME-Version: 1.0
In-Reply-To: <1328275948.2662.15.camel@laptop>
References: <1328275626-5322-1-git-send-email-amit.sahrawat83@gmail.com>
	<1328275948.2662.15.camel@laptop>
Date: Fri, 3 Feb 2012 19:31:27 +0530
Message-ID: <CADDb1s1sc=69=QsmC+KAqHP=G93JQ95nVdyUPRNRJaVYbwu=HA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: make do_writepages() use plugging
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
Thanks for pointing out.

While checking the plug support in Write code flow, I came across this
main point from which - we invoke
writepages(mapping->a_ops->writepages(mapping, wbc)) from almost all
the the filesystems.

By mistake I checked 2 different kernel versions for this code(and
missed that the current version already has put plug in
mpage_writepages) ... so may be this patch is not worth considering.

Regards,
Amit Sahrawat


On Fri, Feb 3, 2012 at 7:02 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-02-03 at 18:57 +0530, Amit Sahrawat wrote:
>> This will cover all the invocations for writepages to be called with
>> plugging support.
>
> This changelog fails to explain why this is a good thing... I thought
> the idea of the new plugging stuff was that we now don't need to
> sprinkle plugs all over the kernel..
>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  mm/page-writeback.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 363ba70..2bea32c 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1866,14 +1866,18 @@ EXPORT_SYMBOL(generic_writepages);
>>
>>  int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
>>  {
>> +     struct blk_plug plug;
>>       int ret;
>>
>>       if (wbc->nr_to_write <= 0)
>>               return 0;
>> +
>> +     blk_start_plug(&plug);
>>       if (mapping->a_ops->writepages)
>>               ret = mapping->a_ops->writepages(mapping, wbc);
>>       else
>>               ret = generic_writepages(mapping, wbc);
>> +     blk_finish_plug(&plug);
>>       return ret;
>>  }
>>
>
>
>
