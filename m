Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1AYWCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:02:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1AYWC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:02:29 -0500
Date: Tue, 25 Jan 2011 23:01:18 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        =?utf-8?B?QUtQTeOAgA==?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Avoid unmapping THP when it is failed to be split.
Message-ID: <20110125220118.GJ926@random.random>
References: <4D3E6377.6060803@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E6377.6060803@np.css.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 02:45:27PM +0900, Jin Dongming wrote:
> If the THP is failed to be split,
>    1. The processes using the poisoned page could not be collected.
>       (Because page_mapped_in_vma() in collect_procs_anon() always
>        returns NULL.)

page_mapped_in_vma is only called after split_huge_page without
requiring this change.

>    2. The poisoned page could not be unmapped.
>       (If CONFIG_DEBUG_VM is "y", VM_BUG_ON(PageTransHuge(page))
>        in try_to_unmap() will be called, and system panic will be
>        caused.)

This is more reasonable argument for the change because at times
collect_procs may fail kmalloc or for other reasons kill may be set to
1 without split_huge_page having run.

>    3. The processes using the poisoned page could not be killed, too.
>       (Because no process is collected in 1.)

I don't see the point of the change for 1.

> So if splitting THP is failed, it is better to stop unmapping
> rather than causing panic. System might servive if the page is freed
> later.

Splitting THP can't fail unless the page is freed under
split_huge_page (like if the process quits while you're calling
split_huge_page and in turn the anon_vma was already unusable).

Patch looks good but just for point 2.
