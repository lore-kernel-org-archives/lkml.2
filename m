Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab2AWTcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:32:09 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35354 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2AWTcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:32:07 -0500
Date: Mon, 23 Jan 2012 11:31:55 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
In-Reply-To: <1327313719.76517.YahooMailNeo@web162002.mail.bf1.yahoo.com>
Message-ID: <alpine.LSU.2.00.1201231125200.1677@eggly.anvils>
References: <1327310360.96918.YahooMailNeo@web162003.mail.bf1.yahoo.com> <1327313719.76517.YahooMailNeo@web162002.mail.bf1.yahoo.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, PINTU KUMAR wrote:
> Dear All,
> 
> I am facing one problem for one of my kernel module for our linux mobile with kernel2.6.36.
> 
> When I do cat /proc/<Xorg pid>/smaps | grep -A 11 /dev/ump , to track information for my ump module,
> we always get Rss/Pss as 0 kB as shown below:
> cat /proc/1731/smaps | grep -A 11 /dev/ump
> 414db000-415ff000 rw-s 00015000 00:12 6803       /dev/ump
> Size:               1168 kB
> Rss:                   0 kB
> Pss:                   0 kB
> track_rss_value = 0, iswalkcalled = 1, smap_pte_range_called = 1, swap_pte = 0, not_pte_present = 0, not_normal_page = 1
> isspecial = 0, not_special = 1, isMixedMap = 0, pfnpages_null = 0, pfnoff_flag = 0, not_cow_mapping = 1, normal_page_end = 0
>  
> After tracing down the problem, I found out that during "show_smaps" in fs/proc/task_mmu.c and during call to smaps_pte_range the vm_normal_page() is always returning NULL for our /dev/ump driver.
> (smaps_pte_range() is the place where Rss/Pss information is populated)
> Thus mss->resident (Rss value) is never getting incremented.  
>  
> To trace the problem I added few flags during show_smaps & vm_normal_page() as shown above. The value of 1 indicates that the condition is executed.
> Thus "normal_page_end" indicates that the "vm_normal_page" has never ended successfully and always returns from 
> "!is_cow_mapping()".
>  
> So, I wanted to know the main cause for vm_normal_page() always returning NULL page for our ump driver. 
> What is that I am missing in my driver ?
>  
> Can anyone please let me know what could be the problem in our driver.

This not evidence of any problem in your driver.

vm_normal_page() returns NULL because the pages mapped by your driver
are not normal faultable and reclaimable pages, but an area of physical
memory mapped in by remap_pfn_range(), which sets the VM_PFNMAP flag.

The mm subsystem does not count such pages towards rss (or pss),
hence your 0s.

Hugh
