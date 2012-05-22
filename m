Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2EVVBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:01:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44853 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab2EVVBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:01:15 -0400
Message-ID: <4FBBFE49.4070409@linux.vnet.ibm.com>
Date: Tue, 22 May 2012 13:59:53 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: cl@linux.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, hughd@google.com,
        rientjes@google.com, adobriyan@gmail.com, mel@csn.ul.ie
Subject: Re: [PATCH] hugetlb: fix resv_map leak in error path
References: <20120521202814.E01F0FE1@kernel> <20120522134558.49255899.akpm@linux-foundation.org>
In-Reply-To: <20120522134558.49255899.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052221-4242-0000-0000-000001BF5568
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 01:45 PM, Andrew Morton wrote:
> On Mon, 21 May 2012 13:28:14 -0700
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
>> When called for anonymous (non-shared) mappings,
>> hugetlb_reserve_pages() does a resv_map_alloc().  It depends on
>> code in hugetlbfs's vm_ops->close() to release that allocation.
>>
>> However, in the mmap() failure path, we do a plain unmap_region()
>> without the remove_vma() which actually calls vm_ops->close().
>>
>> This is a decent fix.  This leak could get reintroduced if
>> new code (say, after hugetlb_reserve_pages() in
>> hugetlbfs_file_mmap()) decides to return an error.  But, I think
>> it would have to unroll the reservation anyway.
> 
> How far back does this bug go?  The patch applies to 3.4 but gets
> rejects in 3.3 and earlier.

commit 17c9d12e126cb0de8d535dc1908c4819d712bc68
Date:   Wed Feb 11 16:34:16 2009 +0000

So, ~2.6.30.

I don't think it existed before that.  The code was there, but the
ordering made it OK.

