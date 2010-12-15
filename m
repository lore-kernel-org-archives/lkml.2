Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab0LOA1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:27:23 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40721 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab0LOA1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:27:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Dec 2010 09:21:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Korb <ingo@akana.de>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mel@csn.ul.ie,
        cl@linux-foundation.org, yinghai@kernel.org, andi.kleen@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: __offline_isolated_pages may offline too many pages
Message-Id: <20101215092134.e2c8849f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D0786D3.7070007@akana.de>
References: <4D0786D3.7070007@akana.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 16:01:39 +0100
Ingo Korb <ingo@akana.de> wrote:

> Hi!
> 
> [1.] One line summary of the problem:
> __offline_isolated_pages may isolate too many pages
> 
> [2.] Full description of the problem/report:
> While experimenting with remove_memory/online_pages, removing as few 
> pages as possible (pageblock_nr_pages, 512 on my box) I noticed that the 
> number of pages marked "reserved" increased even though both functions 
> did not indicate an error. Following the code it was clear that 
> __offline_isolated_pages marked twice as many pages as it should:
> 

It's designed for offline memory section > MAX_ORDER. pageblock_nr_pages
is tend to be smaller than that.

Do you see the problem with _exsisting_ user interface of memory hotplug ?
I think we have no control other than memory section.

> === start paste (from dmesg) ===
> Offlined Pages 512
> remove from free list c00 1024 e00
> === end paste ===
> 
> The issue seems to be that __offline_isolated_pages blindly uses 
> page_order() to determine how many pages it should mark as reserved in 
> the current loop iteration, without checking if this would exceed the 
> limit set by end_pfn.
> 

It's because designed to work under memory section, it's aligned to MAX_ORDER.
Its blindness works correctly.


> I'm not sure what the correct way to fix this would be - is memory 
> isolation supposed to touch the order of a page if it crosses the end 
> (or beginning!) of the range of pages to be isolated?
> 

Nothing to be fixed. If you _need_ another functionality, please add a new
feature. But, in theory, memory offline doesn't work in the range smaller
than MAX_ORDER because of buddy allocator.

Thanks,
-Kame

