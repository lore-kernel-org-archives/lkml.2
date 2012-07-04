Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab2GDIMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:12:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60807 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2GDIL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:11:57 -0400
Message-ID: <4FF3FAC4.1000005@gmail.com>
Date: Wed, 04 Jul 2012 16:11:48 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, yinghan@google.com,
        akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        sage@newdream.net, ceph-devel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 4/7] Use vfs __set_page_dirty interface instead of doing
 it inside filesystem
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881423-5703-1-git-send-email-handai.szj@taobao.com> <Pine.LNX.4.64.1206282218260.18049@cobra.newdream.net> <4FF15782.5090807@gmail.com> <Pine.LNX.4.64.1207020745180.23342@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.1207020745180.23342@cobra.newdream.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 10:49 PM, Sage Weil wrote:
> On Mon, 2 Jul 2012, Sha Zhengju wrote:
>> On 06/29/2012 01:21 PM, Sage Weil wrote:
>>> On Thu, 28 Jun 2012, Sha Zhengju wrote:
>>>
>>>> From: Sha Zhengju<handai.szj@taobao.com>
>>>>
>>>> Following we will treat SetPageDirty and dirty page accounting as an
>>>> integrated
>>>> operation. Filesystems had better use vfs interface directly to avoid
>>>> those details.
>>>>
>>>> Signed-off-by: Sha Zhengju<handai.szj@taobao.com>
>>>> ---
>>>>    fs/buffer.c                 |    2 +-
>>>>    fs/ceph/addr.c              |   20 ++------------------
>>>>    include/linux/buffer_head.h |    2 ++
>>>>    3 files changed, 5 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/fs/buffer.c b/fs/buffer.c
>>>> index e8d96b8..55522dd 100644
>>>> --- a/fs/buffer.c
>>>> +++ b/fs/buffer.c
>>>> @@ -610,7 +610,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
>>>>     * If warn is true, then emit a warning if the page is not uptodate and
>>>> has
>>>>     * not been truncated.
>>>>     */
>>>> -static int __set_page_dirty(struct page *page,
>>>> +int __set_page_dirty(struct page *page,
>>>>    		struct address_space *mapping, int warn)
>>>>    {
>>>>    	if (unlikely(!mapping))
>>> This also needs an EXPORT_SYMBOL(__set_page_dirty) to allow ceph to
>>> continue to build as a module.
>>>
>>> With that fixed, the ceph bits are a welcome cleanup!
>>>
>>> Acked-by: Sage Weil<sage@inktank.com>
>> Further, I check the path again and may it be reworked as follows to avoid
>> undo?
>>
>> __set_page_dirty();
>> __set_page_dirty();
>> ceph operations;                ==>                     if (page->mapping)
>> if (page->mapping)                                            ceph operations;
>>      ;
>> else
>>      undo = 1;
>> if (undo)
>>      xxx;
> Yep.  Taking another look at the original code, though, I'm worried that
> one reason the __set_page_dirty() actions were spread out the way they are
> is because we wanted to ensure that the ceph operations were always
> performed when PagePrivate was set.
>

Sorry, I've lost something:

__set_page_dirty();                        __set_page_dirty();
ceph operations;
if(page->mapping)         ==>      if(page->mapping) {
        SetPagePrivate;                            SetPagePrivate;
else                                                      ceph operations;
     undo = 1;                                  }

if (undo)
     XXX;

I think this can ensure that ceph operations are performed together with
SetPagePrivate.

> It looks like invalidatepage won't get called if private isn't set, and
> presumably it handles the truncate race with __set_page_dirty() properly
> (right?).  What about writeback?  Do we need to worry about writepage[s]
> getting called with a NULL page->private?

__set_page_dirty does handle racing conditions with truncate and
writeback writepage[s] also take page->private into consideration
which is done inside specific filesystems. I notice that ceph has handled
this in ceph_writepage().
Sorry, not vfs expert and maybe I've not caught your point...


Thanks,
Sha

> Thanks!
> sage
>
>
>
>>
>>
>> Thanks,
>> Sha
>>
>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>> index 8b67304..d028fbe 100644
>>>> --- a/fs/ceph/addr.c
>>>> +++ b/fs/ceph/addr.c
>>>> @@ -5,6 +5,7 @@
>>>>    #include<linux/mm.h>
>>>>    #include<linux/pagemap.h>
>>>>    #include<linux/writeback.h>	/* generic_writepages */
>>>> +#include<linux/buffer_head.h>
>>>>    #include<linux/slab.h>
>>>>    #include<linux/pagevec.h>
>>>>    #include<linux/task_io_accounting_ops.h>
>>>> @@ -73,14 +74,8 @@ static int ceph_set_page_dirty(struct page *page)
>>>>    	int undo = 0;
>>>>    	struct ceph_snap_context *snapc;
>>>>
>>>> -	if (unlikely(!mapping))
>>>> -		return !TestSetPageDirty(page);
>>>> -
>>>> -	if (TestSetPageDirty(page)) {
>>>> -		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
>>>> -		     mapping->host, page, page->index);
>>>> +	if (!__set_page_dirty(page, mapping, 1))
>>>>    		return 0;
>>>> -	}
>>>>
>>>>    	inode = mapping->host;
>>>>    	ci = ceph_inode(inode);
>>>> @@ -107,14 +102,7 @@ static int ceph_set_page_dirty(struct page *page)
>>>>    	     snapc, snapc->seq, snapc->num_snaps);
>>>>    	spin_unlock(&ci->i_ceph_lock);
>>>>
>>>> -	/* now adjust page */
>>>> -	spin_lock_irq(&mapping->tree_lock);
>>>>    	if (page->mapping) {	/* Race with truncate? */
>>>> -		WARN_ON_ONCE(!PageUptodate(page));
>>>> -		account_page_dirtied(page, page->mapping);
>>>> -		radix_tree_tag_set(&mapping->page_tree,
>>>> -				page_index(page), PAGECACHE_TAG_DIRTY);
>>>> -
>>>>    		/*
>>>>    		 * Reference snap context in page->private.  Also set
>>>>    		 * PagePrivate so that we get invalidatepage callback.
>>>> @@ -126,14 +114,10 @@ static int ceph_set_page_dirty(struct page *page)
>>>>    		undo = 1;
>>>>    	}
>>>>
>>>> -	spin_unlock_irq(&mapping->tree_lock);
>>>> -
>>>>    	if (undo)
>>>>    		/* whoops, we failed to dirty the page */
>>>>    		ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
>>>>
>>>> -	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>>>> -
>>>>    	BUG_ON(!PageDirty(page));
>>>>    	return 1;
>>>>    }
>>>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
>>>> index 458f497..0a331a8 100644
>>>> --- a/include/linux/buffer_head.h
>>>> +++ b/include/linux/buffer_head.h
>>>> @@ -336,6 +336,8 @@ static inline void lock_buffer(struct buffer_head *bh)
>>>>    }
>>>>
>>>>    extern int __set_page_dirty_buffers(struct page *page);
>>>> +extern int __set_page_dirty(struct page *page,
>>>> +		struct address_space *mapping, int warn);
>>>>
>>>>    #else /* CONFIG_BLOCK */
>>>>
>>>> -- 
>>>> 1.7.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>

