Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0HTIT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:19:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab0HTIT5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:19:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=i/e5k5K9rD9qb+r6nsNB32JyJ8ulO3GDTn2WfPZhCt4h1jzdddX0i38IduvL0D7YY
	ivKOZm9W8TFhISf72mUKA==
MIME-Version: 1.0
In-Reply-To: <20100820023419.GA5502@localhost>
References: <1282251447-16937-1-git-send-email-mrubin@google.com>
 <1282251447-16937-2-git-send-email-mrubin@google.com> <20100820023419.GA5502@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Fri, 20 Aug 2010 01:19:33 -0700
Message-ID: <AANLkTinzS5J2PsG4Ftmbjvpi=beyD54A=ZrRw3_DA8jv@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: helper functions for dirty and writeback accounting
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 7:34 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Thu, Aug 19, 2010 at 01:57:25PM -0700, Michael Rubin wrote:
>> Exporting account_pages_dirty and adding a symmetric routine
>> account_pages_writeback.
>
> s/account_pages_writeback/account_page_writeback/

Got it. thanks.

> I'd recommend to separate the changes into two patches.
> It's actually a bug fix to export account_pages_dirty() for ceph,
> which should be a good candidate for 2.6.36.

Good idea.

>> This allows code outside of the mm core to safely manipulate page state
>> and not worry about the other accounting. Not using these routines means
>> that some code will lose track of the accounting and we get bugs. This
>> has happened once already.
>>
>> Signed-off-by: Michael Rubin <mrubin@google.com>
>> ---
>>  fs/ceph/addr.c      |    8 ++------
>>  fs/nilfs2/segment.c |    2 +-
>>  include/linux/mm.h  |    1 +
>>  mm/page-writeback.c |   15 +++++++++++++++
>>  4 files changed, 19 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index d9c60b8..359aa3a 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -106,12 +106,8 @@ static int ceph_set_page_dirty(struct page *page)
>>       if (page->mapping) {    /* Race with truncate? */
>>               WARN_ON_ONCE(!PageUptodate(page));
>>
>> -             if (mapping_cap_account_dirty(mapping)) {
>> -                     __inc_zone_page_state(page, NR_FILE_DIRTY);
>> -                     __inc_bdi_stat(mapping->backing_dev_info,
>> -                                     BDI_RECLAIMABLE);
>> -                     task_io_account_write(PAGE_CACHE_SIZE);
>> -             }
>> +             if (mapping_cap_account_dirty(mapping))
>
> That 'if' is not necessary. account_page_dirtied() already has one.
> The extra 'if' is not an optimization either, because the ceph fs is
> not likely to have un-accountable mappings.

Sweet. Thanks.
>
>> +                     account_page_dirtied(page, page->mapping);
>>               radix_tree_tag_set(&mapping->page_tree,
>>                               page_index(page), PAGECACHE_TAG_DIRTY);
>>
>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index c920164..967ed7d 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -1599,7 +1599,7 @@ nilfs_copy_replace_page_buffers(struct page *page, struct list_head *out)
>>       kunmap_atomic(kaddr, KM_USER0);
>>
>>       if (!TestSetPageWriteback(clone_page))
>> -             inc_zone_page_state(clone_page, NR_WRITEBACK);
>> +             account_page_writeback(clone_page, page_mapping(clone_page));
>>       unlock_page(clone_page);
>>
>>       return 0;
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index a2b4804..b138392 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -855,6 +855,7 @@ int __set_page_dirty_no_writeback(struct page *page);
>>  int redirty_page_for_writepage(struct writeback_control *wbc,
>>                               struct page *page);
>>  void account_page_dirtied(struct page *page, struct address_space *mapping);
>> +void account_page_writeback(struct page *page, struct address_space *mapping);
>>  int set_page_dirty(struct page *page);
>>  int set_page_dirty_lock(struct page *page);
>>  int clear_page_dirty_for_io(struct page *page);
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 37498ef..b8e7b3b 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1096,6 +1096,21 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
>>               task_io_account_write(PAGE_CACHE_SIZE);
>>       }
>>  }
>> +EXPORT_SYMBOL(account_page_dirtied);
>> +
>> +/*
>> + * Helper function for set_page_writeback family.
>> + * NOTE: Unlike account_page_dirtied this does not rely on being atomic
>> + * wrt interrupts.
>> + */
>> +
>> +void account_page_writeback(struct page *page, struct address_space *mapping)
>> +{
>> +     if (mapping_cap_account_dirty(mapping))
>
> The 'if' test and *mapping parameter looks unnecessary at least for
> now. The only place a mapping has BDI_CAP_NO_ACCT_WB but not
> BDI_CAP_NO_WRITEBACK is fuse, which does its own accounting.

Cool.
Thanks.
