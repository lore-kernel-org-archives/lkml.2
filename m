Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1COGdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 02:33:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42430 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1COGdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 02:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=UCW4pY/gYXibRH5jCSzGAhnYTL++cYpIT+KKxGyZUwGpnie6ffldJhAliYivJSSLfS
         o2bONPDO2GEdCEfgANDQ==
MIME-Version: 1.0
In-Reply-To: <20110314151023.GF11699@barrios-desktop>
References: <1299869011-26152-1-git-send-email-gthelen@google.com>
 <1299869011-26152-5-git-send-email-gthelen@google.com> <20110314151023.GF11699@barrios-desktop>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 14 Mar 2011 23:32:38 -0700
Message-ID: <AANLkTinnfM6_ZhzEq6SAG1H2jDfKdVS2=fe_USi8ArNA@mail.gmail.com>
Subject: Re: [PATCH v6 4/9] memcg: add kernel calls for memcg dirty page stats
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 8:10 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Fri, Mar 11, 2011 at 10:43:26AM -0800, Greg Thelen wrote:
>> Add calls into memcg dirty page accounting.  Notify memcg when pages
>> transition between clean, file dirty, writeback, and unstable nfs.
>> This allows the memory controller to maintain an accurate view of
>> the amount of its memory that is dirty.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> Signed-off-by: Andrea Righi <arighi@develer.com>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>> ---
>> Changelog since v5:
>> - moved accounting site in test_clear_page_writeback() and
>>   test_set_page_writeback().
>>
>>  fs/nfs/write.c      |    4 ++++
>>  mm/filemap.c        |    1 +
>>  mm/page-writeback.c |   10 ++++++++--
>>  mm/truncate.c       |    1 +
>>  4 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/nfs/write.c b/fs/nfs/write.c
>> index 42b92d7..7863777 100644
>> --- a/fs/nfs/write.c
>> +++ b/fs/nfs/write.c
>> @@ -451,6 +451,7 @@ nfs_mark_request_commit(struct nfs_page *req)
>>                       NFS_PAGE_TAG_COMMIT);
>>       nfsi->ncommit++;
>>       spin_unlock(&inode->i_lock);
>> +     mem_cgroup_inc_page_stat(req->wb_page, MEMCG_NR_FILE_UNSTABLE_NFS);
>>       inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
>>       inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
>>       __mark_inode_dirty(inode, I_DIRTY_DATASYNC);
>> @@ -462,6 +463,7 @@ nfs_clear_request_commit(struct nfs_page *req)
>>       struct page *page = req->wb_page;
>>
>>       if (test_and_clear_bit(PG_CLEAN, &(req)->wb_flags)) {
>> +             mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_UNSTABLE_NFS);
>>               dec_zone_page_state(page, NR_UNSTABLE_NFS);
>>               dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
>>               return 1;
>> @@ -1319,6 +1321,8 @@ nfs_commit_list(struct inode *inode, struct list_head *head, int how)
>>               req = nfs_list_entry(head->next);
>>               nfs_list_remove_request(req);
>>               nfs_mark_request_commit(req);
>> +             mem_cgroup_dec_page_stat(req->wb_page,
>> +                                      MEMCG_NR_FILE_UNSTABLE_NFS);
>>               dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
>>               dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
>>                               BDI_RECLAIMABLE);
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index a6cfecf..7e751fe 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -143,6 +143,7 @@ void __delete_from_page_cache(struct page *page)
>>        * having removed the page entirely.
>>        */
>>       if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
>> +             mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
>>               dec_zone_page_state(page, NR_FILE_DIRTY);
>>               dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
>>       }
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 632b464..d8005b0 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1118,6 +1118,7 @@ int __set_page_dirty_no_writeback(struct page *page)
>>  void account_page_dirtied(struct page *page, struct address_space *mapping)
>>  {
>>       if (mapping_cap_account_dirty(mapping)) {
>> +             mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_DIRTY);
>>               __inc_zone_page_state(page, NR_FILE_DIRTY);
>>               __inc_zone_page_state(page, NR_DIRTIED);
>>               __inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
>> @@ -1317,6 +1318,7 @@ int clear_page_dirty_for_io(struct page *page)
>>                * for more comments.
>>                */
>>               if (TestClearPageDirty(page)) {
>> +                     mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
>>                       dec_zone_page_state(page, NR_FILE_DIRTY);
>>                       dec_bdi_stat(mapping->backing_dev_info,
>>                                       BDI_RECLAIMABLE);
>> @@ -1352,8 +1354,10 @@ int test_clear_page_writeback(struct page *page)
>>       } else {
>>               ret = TestClearPageWriteback(page);
>>       }
>> -     if (ret)
>> +     if (ret) {
>> +             mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
>>               dec_zone_page_state(page, NR_WRITEBACK);
>> +     }
>>       return ret;
>>  }
>>
>> @@ -1386,8 +1390,10 @@ int test_set_page_writeback(struct page *page)
>>       } else {
>>               ret = TestSetPageWriteback(page);
>>       }
>> -     if (!ret)
>> +     if (!ret) {
>> +             mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
>>               account_page_writeback(page);
>> +     }
>>       return ret;
>>
>>  }
>
> At least in mainline, NR_WRITEBACK handling codes are following as.
>
> 1) increase
>
>  * account_page_writeback
>
> 2) decrease
>
>  * test_clear_page_writeback
>  * __nilfs_end_page_io
>
> I think account_page_writeback name is good to add your account function into that.
> The problem is decreasement. Normall we can handle decreasement in test_clear_page_writeback.
> But I am not sure it's okay in __nilfs_end_page_io.
> I think if __nilfs_end_page_io is right, __nilfs_end_page_io should call
> mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_WRITEBACK).
>
> What do you think about it?
>
>
>
> --
> Kind regards,
> Minchan Kim
>

I would like to not have any special cases that avoid certain memory.
So I think your suggestion is good.
However, nilfs memcg dirty page accounting was skipped in a previous
memcg dirty limit effort due to complexity.  See 'clone_page'
reference in:
  http://lkml.indiana.edu/hypermail/linux/kernel/1003.0/02997.html

I admit that I don't follow all of the nilfs code path, but it looks
like some of the nilfs pages are allocated but not charged to memcg.
There is code in mem_cgroup_update_page_stat() to gracefully handle
pages not associated with a memcg.  So perhaps nilfs clone pages dirty
[un]charge could be attempted.  I have not succeeded in testing in
exercising these code paths in nilfs.
