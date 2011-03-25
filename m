Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab1CYPSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:18:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1CYPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:18:13 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=8nJEP1OIZ-IA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=84Nmi-sFSNYap_sNikQA:9 a=vj250IXp1--HQX59vVMA:7 a=hpU2Us0BfAmSbSD2IbucPYFDYMkA:4 a=wPNLvfGTeEIA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 25 Mar 2011 11:18:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jay <jinshan.xiong@whamcloud.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: is this a bug?
Message-ID: <20110325151810.GC9313@home.goodmis.org>
References: <AANLkTikipA3__OX3sZd-VBS2Hvg5BSE=B9s+0RTyiVVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikipA3__OX3sZd-VBS2Hvg5BSE=B9s+0RTyiVVQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strange mail client you have.

On Wed, Mar 23, 2011 at 05:46:56PM -0700, Jay wrote:
> Hi,
> 
> Assuming vmscan is doing its job to steal the last page from an
> inode's namespace, so:
> 
> shrink_page_list -> remove_mapping -> __remove_from_page_cache:
> 
> void __remove_from_page_cache(struct page *page)
> 
> {
> 
>         ...
> 
>         radix_tree_delete(&mapping->page_tree, page->index);
> 
>         page->mapping = NULL;
> 
> >>> after removing the page from radix tree, it stuck at here.
> 
>         mapping->nrpages--;
> 
>         ...
> 
> }
> 
> then another process just calls iput_final to release the inode, so
> iput_final -> evict:
> 
> static void evict(struct inode *inode)
> 
> {
> 
>        ...
> 
>         } else {
> 
>                 if (inode->i_data.nrpages)
> 
> >>> here it finds that nrpage is 1, so go into truncate_inode_pages() but it won't find any page in the page tree.
> 
>                         truncate_inode_pages(&inode->i_data, 0);
> 
> >>> here nrpages remains 1.
> 
>                 end_writeback(inode);
> 
> >>> hit  BUG_ON(inode->i_data.nrpages) in end_writeback().


Did you actually hit this bug?

> 
>         }
> 
>         ...
> 
> }
> 
> The root cause of this problem is that nrpages is accessed w/o holding
> mapping->page_tree. The fix is also easy, just grab ->tree_lock inside
> truncate_inode_pages_range:
> 
> +       spin_lock_irq(&mapping->tree_lock);
> 
> -         if (mapping->nrpages == 0)
> 
> +        if (mapping->nrpages == 0) {
> 
> +               spin_unlock_irq(&mapping->tree_lock);
> 
>                 return;
> 
> +        }
> 
> +        spin_unlock_irq(&mapping->tree_lock);
> 
> Am I missed anything?

Perhaps the comment before the __remove_from_page_cache()

/*
 * Remove a page from the page cache and free it. Caller has to make
 * sure the page is locked and that nobody else uses it - or that usage
 * is safe.  The caller must hold the mapping's tree_lock.
 */

-- Steve

