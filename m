Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab0G2F3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:29:21 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55015 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0G2F3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:29:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Jul 2010 14:24:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100729142245.4AA5.A69D9226@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 14:23:33 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Can you please add explicit commenting in the code?
> 
How about this ?
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At hibernation, all pages-should-be-saved are written into a image (here, swap).
Then, swap_map[], memmap etcs are also saved into disks.

But, swap allocation happens one by one. So, the final image of swap_map[] is
different from saved one and the commit c9e444103b5e7a5a3519f9913f59767f92e33baf
changes page's state while assiging swap. Because memory can be modified in
hibernation is only not-to-be-save memory. it's a breakage.

This patch fixes it by disabling swap entry reuse at hibernation.



Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.34.org/mm/swapfile.c
===================================================================
--- linux-2.6.34.org.orig/mm/swapfile.c
+++ linux-2.6.34.org/mm/swapfile.c
@@ -315,8 +315,15 @@ checks:
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
 
-	/* reuse swap entry of cache-only swap if not busy. */
-	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+	/*
+ 	 * reuse swap entry of cache-only swap if not busy &&
+ 	 * when we're called via pageout(). At hibernation, swap-reuse
+ 	 * is harmful because it changes memory status...which may
+ 	 * be saved already.
+ 	 */
+	if (vm_swap_full()
+		&& usage == SWAP_HAS_CACHE
+		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&swap_lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);

