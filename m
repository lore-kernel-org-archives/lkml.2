Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab0KDOMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab0KDOMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:12:36 -0400
Message-ID: <4CD2BF1C.10608@redhat.com>
Date: Thu, 04 Nov 2010 10:11:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, arunabal@in.ibm.com,
        sbest@us.ibm.com, stable <stable@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Revalidate page->mapping in do_generic_file_read()
References: <20101103220941.C88FA932@kernel.beaverton.ibm.com>
In-Reply-To: <20101103220941.C88FA932@kernel.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 06:09 PM, Dave Hansen wrote:
> 70 hours into some stress tests of a 2.6.32-based enterprise kernel,
> we ran into a NULL dereference in here:
>
> 	int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
> 	                                        unsigned long from)
> 	{
> ---->		struct inode *inode = page->mapping->host;
>
> It looks like page->mapping was the culprit.  (xmon trace is below).
> After closer examination, I realized that do_generic_file_read() does
> a find_get_page(), and eventually locks the page before calling
> block_is_partially_uptodate().  However, it doesn't revalidate the
> page->mapping after the page is locked.  So, there's a small window
> between the find_get_page() and ->is_partially_uptodate() where the
> page could get truncated and page->mapping cleared.
>
> We _have_ a reference, so it can't get reclaimed, but it certainly
> can be truncated.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
