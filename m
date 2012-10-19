Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2JSHjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:39:17 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58414 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2JSHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:39:16 -0400
Message-ID: <5081039C.1040303@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2012 15:39:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH] emulator test: add "rep ins" mmio access test
References: <5081033C.4060503@linux.vnet.ibm.com>
In-Reply-To: <5081033C.4060503@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101907-9574-0000-0000-000004EEAAFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the test to trigger the bug that "rep ins" causes vcpu->mmio_fragments
overflow overflow while move large data from ioport to MMIO

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 x86/emulator.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 24b33d1..0735405 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -731,6 +731,18 @@ static void test_crosspage_mmio(volatile uint8_t *mem)
     report("cross-page mmio write", mem[4095] == 0xaa && mem[4096] == 0x88);
 }

+static void test_string_io_mmio(volatile uint8_t *mem)
+{
+	/* Cross MMIO pages.*/
+	volatile uint8_t *mmio = mem + 4032;
+
+	asm volatile("outw %%ax, %%dx  \n\t" : : "a"(0x9999), "d"(TESTDEV_IO_PORT));
+
+	asm volatile ("cld; rep insb" : : "d" (TESTDEV_IO_PORT), "D" (mmio), "c" (1024));
+
+	report("string_io_mmio", mmio[1023] == 0x99);
+}
+
 static void test_lgdt_lidt(volatile uint8_t *mem)
 {
     struct descriptor_table_ptr orig, fresh = {};
@@ -878,6 +890,8 @@ int main()

 	test_crosspage_mmio(mem);

+	test_string_io_mmio(mem);
+
 	printf("\nSUMMARY: %d tests, %d failures\n", tests, fails);
 	return fails ? 1 : 0;
 }
-- 
1.7.7.6

