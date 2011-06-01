Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab1FAQnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:43:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43966 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab1FAQnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:43:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH] swiotlb=nslabs not honored when launching xen pv guests.
Date: Wed,  1 Jun 2011 12:42:43 -0400
Message-Id: <1306946564-30481-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DE66C15.0044:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tomo-san,

I ran into an issue where the 'swiotlb' argument was being ignored when
launching a PV guest. Please see the patch - it has a nice explanation
in the description of the patch.

Not sure if this is the best way of fixing it. The other way of fixing
this would be to change swiotlb_init_with_tbl to sample the 'io_tlb_nslabs'
and if the io_tlb_nslabs is set use that instead of the passed in value?
But that looks a bit sneaky..

Something like this (not tested, nor compiled)?

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 93ca08b..3cfad6e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -136,9 +136,11 @@ void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
 {
 	unsigned long i, bytes;
 
+	if (io_tlb_nslabs)
+		nslabs = io_tlb_nslabs;
+
 	bytes = nslabs << IO_TLB_SHIFT;
 
-	io_tlb_nslabs = nslabs;
 	io_tlb_start = tlb;
 	io_tlb_end = io_tlb_start + bytes;
 

