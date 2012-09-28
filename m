Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033318Ab2I1VnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:43:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032371Ab2I1UZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:25:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jianguo Wu <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        "Luck, Tony" <tony.luck@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 081/218] mm/ia64: fix a memory block size bug
Date: Fri, 28 Sep 2012 13:14:58 -0700
Message-Id: <20120928201510.858307758@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@huawei.com>

commit 05cf96398e1b6502f9e191291b715c7463c9d5dd upstream.

I found following definition in include/linux/memory.h, in my IA64
platform, SECTION_SIZE_BITS is equal to 32, and MIN_MEMORY_BLOCK_SIZE
will be 0.

  #define MIN_MEMORY_BLOCK_SIZE     (1 << SECTION_SIZE_BITS)

Because MIN_MEMORY_BLOCK_SIZE is int type and length of 32bits,
so MIN_MEMORY_BLOCK_SIZE(1 << 32) will will equal to 0.
Actually when SECTION_SIZE_BITS >= 31, MIN_MEMORY_BLOCK_SIZE will be wrong.
This will cause wrong system memory infomation in sysfs.
I think it should be:

  #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)

And "echo offline > memory0/state" will cause following call trace:

  kernel BUG at mm/memory_hotplug.c:885!
  sh[6455]: bugcheck! 0 [1]
  Pid: 6455, CPU 0, comm:                   sh
  psr : 0000101008526030 ifs : 8000000000000fa4 ip  : [<a0000001008c40f0>]    Not tainted (3.6.0-rc1)
  ip is at offline_pages+0x210/0xee0
  Call Trace:
    show_stack+0x80/0xa0
    show_regs+0x640/0x920
    die+0x190/0x2c0
    die_if_kernel+0x50/0x80
    ia64_bad_break+0x3d0/0x6e0
    ia64_native_leave_kernel+0x0/0x270
    offline_pages+0x210/0xee0
    alloc_pages_current+0x180/0x2a0

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -19,7 +19,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 
-#define MIN_MEMORY_BLOCK_SIZE     (1 << SECTION_SIZE_BITS)
+#define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
 struct memory_block {
 	unsigned long start_section_nr;


