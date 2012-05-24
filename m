Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902Ab2EXSHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:07:20 -0400
Received: from natasha.panasas.com ([67.152.220.90]:52449 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804Ab2EXSHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:07:18 -0400
Message-ID: <4FBE78A2.8000803@panasas.com>
Date: Thu, 24 May 2012 21:06:26 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Kent Overstreet <koverstreet@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-bcache@vger.kernel.org>, <dm-devel@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, <tj@kernel.org>, <axboe@kernel.dk>,
        <agk@redhat.com>, <neilb@suse.de>, <drbd-dev@lists.linbit.com>,
        <mpatocka@redhat.com>, <sage@newdream.net>, <yehuda@hq.newdream.net>
Subject: Re: [PATCH v2 01/14] block: Generalized bio pool freeing
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-2-git-send-email-koverstreet@google.com> <20120524174649.GC27550@redhat.com>
In-Reply-To: <20120524174649.GC27550@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 08:46 PM, Vivek Goyal wrote:

> On Wed, May 23, 2012 at 05:02:38PM -0700, Kent Overstreet wrote:
>> With the old code, when you allocate a bio from a bio pool you have to
>> implement your own destructor that knows how to find the bio pool the
>> bio was originally allocated from.
>>
>> This adds a new field to struct bio (bi_pool) and changes
>> bio_alloc_bioset() to use it. This makes various bio destructors
>> unnecessary, so they're then deleted.
>>
> 
> [..]
>> @@ -419,7 +406,11 @@ void bio_put(struct bio *bio)
>>  	 */
>>  	if (atomic_dec_and_test(&bio->bi_cnt)) {
>>  		bio->bi_next = NULL;
>> -		bio->bi_destructor(bio);
>> +
>> +		if (bio->bi_pool)
>> +			bio_free(bio, bio->bi_pool);
>> +		else
>> +			bio->bi_destructor(bio);
> 
> If you have removed all the users of bi_destructor, then I am wondering that
> why are we retaining this field and trying to call into it when bio_pool
> is not set?
> 


At this point there are still some users they are all removed and this field
later in the patchset

Boaz

> Thanks
> Vivek
> 


