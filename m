Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab0CZQau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:30:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:3531 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0CZQas convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Fri, 26 Mar 2010 12:30:48 -0400
Message-Id: <4BACEF490200007800037346@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 26 Mar 2010 16:30:49 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <yinghai@kernel.org>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] relax free_area() for compatibility with
	 free_bootmem()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be compatible with the traditional free_bootmem() (which is just a
wrapper around free_earl() under CONFIG_NO_BOOTMEM), free_area()
should allow freeing not only exact ranges, but also proper subsets.
This is still different from free_early_partial() in that the latter
also handles an input range spanning multiple reserved ranges,
possibly even with holes between them (not that I think permitting
this is a good idea).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 kernel/early_res.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.34-rc2/kernel/early_res.c	2010-03-25 15:23:45.000000000 +0100
+++ 2.6.34-rc2-free_early-subrange/kernel/early_res.c	2010-03-26 14:49:41.000000000 +0100
@@ -321,11 +321,11 @@ void __init free_early(u64 start, u64 en
 
 	i = find_overlapped_early(start, end);
 	r = &early_res[i];
-	if (i >= max_early_res || r->end != end || r->start != start)
+	if (i >= max_early_res || r->end < end || r->start > start)
 		panic("free_early on not reserved area: %llx-%llx!",
 			 start, end - 1);
 
-	drop_range(i);
+	drop_range_partial(i, start, end);
 }
 
 void __init free_early_partial(u64 start, u64 end)



