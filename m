Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0G2E2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 00:28:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab0G2E2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 00:28:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Jul 2010 13:23:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201007282334.08063.rjw@sisk.pl>
References: <201007282320.39528.linux@rainbow-software.org>
	<201007282334.08063.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 23:34:07 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, July 28, 2010, Ondrej Zary wrote:
> > Hello,
> > after very long bisection, I finally found what's causing memory corruption 
> > during hibernation on my machine sice 2.6.31:
> > https://bugzilla.kernel.org/show_bug.cgi?id=15753
> > 
> > It's commit c9e444103b5e7a5a3519f9913f59767f92e33baf (mm: reuse unused swap 
> > entry if necessary).
> > 
> > I don't know anything about swapping in Linux so I don't have a clue what's
> > wrong with that commit.
> 
> Thanks for bisecting!
> 
> This looks rather serious.  I'd be grateful from any clues from the mm guys
> involved (CCed).
> 

Considering possible cases...and here is a patch.
but I'm not fully sure. Could you clarify ?

But hmm...status of swap_map[] to be recovered at resume() seems to be just
based on luck. or hibernation has some tricks on swap_map[] ?

==
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
@@ -316,7 +316,9 @@ checks:
 		scan_base = offset = si->lowest_bit;
 
 	/* reuse swap entry of cache-only swap if not busy. */
-	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+	if (vm_swap_full()
+		&& usage == SWAP_HAS_CACHE
+		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&swap_lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);







