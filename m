Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1BWRTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:19:52 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:49215 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1BWRTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pgxhXtTeRrcJxLnaFtvPTimUM9FPzVnKcqanXlsJz4nbAjWX+XOeBS7xgoIImEX5Ay
         b40bUtmV6Gq4WHiAlYpoKX1AowrIkT5Zt4AHOrkLA8lT+WvX0zrtOyRZCUmucSuwngGz
         woGPzY7DnDzJgM2f7I74+7ue9rzq1qY/UwUtk=
Date: Wed, 23 Feb 2011 18:19:45 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: questions about init_memory_mapping_high()
Message-ID: <20110223171945.GI26065@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

I've been looking at init_memory_mapping_high() added by commit
1411e0ec31 (x86-64, numa: Put pgtable to local node memory) and I got
curious about several things.

1. The only rationale given in the commit description is that a
   RED-PEN is killed, which was the following.

	/*
	 * RED-PEN putting page tables only on node 0 could
	 * cause a hotspot and fill up ZONE_DMA. The page tables
	 * need roughly 0.5KB per GB.
	 */

   This already wasn't true with top-down memblock allocation.

   The 0.5KB per GiB comment is for 32bit w/ 3 level mapping.  On
   64bit, it's ~4KiB per GiB when using 2MiB mappings and, well, very
   small per GiB if 1GiB mapping is used.  Even with 2MiB mapping,
   1TiB mapping would only be 4MiB.  Under ZONE_DMA, this could be
   problematic but with top-down this can't be a problem in any
   realistic way in foreseeable future.

2. In most cases, the kernel mapping ends up using 1GiB mappings and
   when using 1GiB mappings, a single second level table would cover
   512GiB of memory.  IOW, little, if any, is gained by trying to
   allocate the page table on node local memory when 1GiB mappings are
   used, they end up sharing the same page somewhere anyway.

   I guess this was the reason why the commit message showed usage of
   2MiB mappings so that each node would end up with their own third
   level page tables.  Is this something we need to optimize for?  I
   don't recall seeing recent machines which don't use 1GiB pages for
   the linear mapping.  Are there NUMA machines which can't use 1GiB
   mappings?

   Or was this for the future where we would be using a lot more than
   512GiB of memory?  If so, wouldn't that be a bit over-reaching?
   Wouldn't we be likely to have 512GiB mappings if we get to a point
   where NUMA locality of such mappings actually become a problem?

3. The new code creates linear mapping only for memory regions where
   e820 actually says there is memory as opposed to mapping from base
   to top.  Again, I'm not sure what the intention of this change was.
   Having larger mappings over holes is much cheaper than having to
   break down the mappings into smaller sized mappings around the
   holes both in terms of memory and run time overhead.  Why would we
   want to match the linear address mapping to the e820 map exactly?

Also, Yinghai, can you please try to write commit descriptions with
more details?  It really sucks for other people when they have to
guess what the actual changes and underlying intentions are.  The
commit adding init_memory_mapping_high() is very anemic on details
about how the behavior changes and the only intention given there is
RED-PEN removal even which is largely a miss.

Thank you.

-- 
tejun
