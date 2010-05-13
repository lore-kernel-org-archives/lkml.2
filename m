Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0EMOI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 10:08:58 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:59845 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0EMOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 10:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NGv52pVfPZgzT83+Ul+jJ4kX9f4nMOqioYoj1fICqKAMJ0UlkeOpuqfgzSmQN0YE9j
         +Qv/8HTpX56okl9wCip9IcfNPaVKB3zk9RFanhnXGJJz02RbNM0NcxddWIGgfTCSJfv6
         JUE15eVMMC0KYgThj1BM/j9AUUXrUqOi+jKcs=
MIME-Version: 1.0
In-Reply-To: <1273756816.5605.3547.camel@twins>
References: <1273744285-8128-1-git-send-email-xiaosuo@gmail.com> 
	<1273756816.5605.3547.camel@twins>
From: Changli Gao <xiaosuo@gmail.com>
Date: Thu, 13 May 2010 22:08:26 +0800
Message-ID: <AANLkTinLT5g5SKjqmQlS2kxvvMq1gsi1jPDgOKTnrT-q@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm: add generic adaptive large memory allocation APIs
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Divy Le Ray <divy@chelsio.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, containers@lists.linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4DE94aS015782

On Thu, May 13, 2010 at 9:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:> On Thu, 2010-05-13 at 17:51 +0800, Changli Gao wrote:>> +void *__kvmalloc(size_t size, gfp_t flags)>> +{>> +       void *ptr;>> +>> +       if (size < PAGE_SIZE)>> +               return kmalloc(size, GFP_KERNEL | flags);>> +       size = PAGE_ALIGN(size);>> +       if (is_power_of_2(size))>> +               ptr = (void *)__get_free_pages(GFP_KERNEL | flags |>> +                                              __GFP_NOWARN, get_order(size));>> +       else>> +               ptr = alloc_pages_exact(size, GFP_KERNEL | flags |>> +                                             __GFP_NOWARN);>> +       if (ptr != NULL) {>> +               virt_to_head_page(ptr)->private = size;>> +               return ptr;>> +       }>> +>> +       ptr = vmalloc(size);>> +       if (ptr != NULL && (flags & __GFP_ZERO))>> +               memset(ptr, 0, size);>> +>> +       return ptr;>> +}>> +EXPORT_SYMBOL(__kvmalloc);>> So if I do kvmalloc(size, GFP_ATOMIC) I get GFP_KERNEL|GFP_ATOMIC, which> is not a recommended variation because one should not mix __GFP_WAIT and> __GFP_HIGH.
__kvmalloc() is only for internal use(kvmalloc, kvcalloc, andkvzalloc), and the only value of flags is __GFP_ZERO. How aboutreplacing flags with a bool variable zero?
void *__kvmalloc(size_t size, bool zero);
 Or check the value of flags in the front of __kvmalloc().
BUG_ON((flags & (~__GFP_ZERO)) != 0);
>> So I would simply drop the gfp argument to avoid confusion.>>> +void __kvfree(void *ptr, bool inatomic)>> +{>> +       if (unlikely(ZERO_OR_NULL_PTR(ptr)))>> +               return;>> +       if (is_vmalloc_addr(ptr)) {>> +               if (inatomic) {>> +                       struct work_struct *work;>> +>> +                       work = ptr;>> +                       BUILD_BUG_ON(sizeof(struct work_struct) > PAGE_SIZE);>> +                       INIT_WORK(work, kvfree_work);>> +                       schedule_work(work);>> +               } else {>> +                       vfree(ptr);>> +               }>> +       } else {>> +               struct page *page;>> +>> +               page = virt_to_head_page(ptr);>> +               if (PageSlab(page) || PageCompound(page))>> +                       kfree(ptr);>> +               else if (is_power_of_2(page->private))>> +                       free_pages((unsigned long)ptr,>> +                                  get_order(page->private));>> +               else>> +                       free_pages_exact(ptr, page->private);>> +       }>> +}>> +EXPORT_SYMBOL(__kvfree);>> NAK, I really utterly dislike that inatomic argument. The alloc side> doesn't function in atomic context either. Please keep the thing> symmetric in that regards.>
There are some users, who release memory in atomic context. forexample: fs/file.c: fdmem.
-- Regards，Changli Gao(xiaosuo@gmail.com)���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
