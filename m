Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0I0Gdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:33:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40357 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab0I0Gdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:33:37 -0400
Message-ID: <4CA03A2D.4050503@kernel.org>
Date: Sun, 26 Sep 2010 23:31:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: caiqian@redhat.com
CC: kexec <kexec@lists.infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <870873343.2003871285555329846.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <870873343.2003871285555329846.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check this one on top of tip or next.

Thanks

Yinghai

[PATCH] x86, memblock: Fix crashkernel allocation

Cai Qian found that crashkernel is broken with x86 memblock changes
1. crashkernel=128M@32M always reported that range is used, even first kernel is small
   no one use that range
2. always get following report when using "kexec -p"
	Could not find a free area of memory of a000 bytes...
	locate_hole failed

The root cause is that generic memblock_find_in_range() will try to get range from top_down.
But crashkernel do need from low and specified range.

Let's limit the target range with rash_base + crash_size to make sure that
We get range from bottom.

Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -516,19 +516,28 @@ static void __init reserve_crashkernel(v
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
+		unsigned long long start = 0;
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
-				 alignment);
-		if (crash_base == MEMBLOCK_ERROR) {
+		crash_base = alignment;
+		while (crash_base < 0xffffffff) {
+			start = memblock_find_in_range(crash_base,
+				crash_base + crash_size, crash_size, alignment);
+
+			if (start == crash_base)
+				break;
+
+			crash_base += alignment;
+		}
+		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
-				 1<<20);
+		start = memblock_find_in_range(crash_base,
+				 crash_base + crash_size, crash_size, 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
