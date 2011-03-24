Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527Ab1CXAq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:46:58 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51459 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab1CXAq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:46:57 -0400
MIME-Version: 1.0
Date: Wed, 23 Mar 2011 17:46:56 -0700
Message-ID: <AANLkTikipA3__OX3sZd-VBS2Hvg5BSE=B9s+0RTyiVVQ@mail.gmail.com>
Subject: is this a bug?
From: Jay <jinshan.xiong@whamcloud.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Assuming vmscan is doing its job to steal the last page from an
inode's namespace, so:

shrink_page_list -> remove_mapping -> __remove_from_page_cache:

void __remove_from_page_cache(struct page *page)

{

        ...

        radix_tree_delete(&mapping->page_tree, page->index);

        page->mapping = NULL;

>>> after removing the page from radix tree, it stuck at here.

        mapping->nrpages--;

        ...

}

then another process just calls iput_final to release the inode, so
iput_final -> evict:

static void evict(struct inode *inode)

{

       ...

        } else {

                if (inode->i_data.nrpages)

>>> here it finds that nrpage is 1, so go into truncate_inode_pages() but it won't find any page in the page tree.

                        truncate_inode_pages(&inode->i_data, 0);

>>> here nrpages remains 1.

                end_writeback(inode);

>>> hit  BUG_ON(inode->i_data.nrpages) in end_writeback().

        }

        ...

}

The root cause of this problem is that nrpages is accessed w/o holding
mapping->page_tree. The fix is also easy, just grab ->tree_lock inside
truncate_inode_pages_range:

+       spin_lock_irq(&mapping->tree_lock);

-         if (mapping->nrpages == 0)

+        if (mapping->nrpages == 0) {

+               spin_unlock_irq(&mapping->tree_lock);

                return;

+        }

+        spin_unlock_irq(&mapping->tree_lock);

Am I missed anything?

Thanks
