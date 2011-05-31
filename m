Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1EaNRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:17:55 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:59893 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab1EaNRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:17:17 -0400
X-AuditID: 1209190e-b7c39ae000000a8c-e2-4de4ea521fd1
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 07/10] x86-64: Fill unused parts of the vsyscall page with 0xcc
Date: Tue, 31 May 2011 09:16:01 -0400
Message-Id: <db506cc22d5ca0cbd239fdc2d89b021e4f5ace00.1306847455.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsUixCmqrRv06omvwdnJMhZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZex6foCx4Apnxc0Pj9gaGO+ydzFy
	ckgImEj8ndIHZYtJXLi3ng3EFhLYxyjx4ZVqFyMXkL2BUWJxz3t2COcZk8TTnslgVWwCKhId
	Sx8wdTFycIgI6Etc/cwIUsMsMIlF4vDf0ywgNcICQRJNbV2MIDaLgKrEn817wGxeoPihuadY
	IDYrSFy5Mg/M5hQwkGheuQbqCn2J+0+uMOMSn8AosICRYRWjbEpulW5uYmZOcWqybnFyYl5e
	apGusV5uZoleakrpJkZw1Ejy7WD8elDpEKMAB6MSD2/8wce+QqyJZcWVuYcYJTmYlER5ZV4+
	8RXiS8pPqcxILM6ILyrNSS0+xCjBwawkwvuNDyjHm5JYWZValA+TkuZgURLnnSmp7iskkJ5Y
	kpqdmlqQWgSTleHgUJLgnQEyVLAoNT21Ii0zpwQhzcTBCTKcB2h4KEgNb3FBYm5xZjpE/hSj
	Lkfj2h0HGYVY8vLzUqXEebNAigRAijJK8+DmwJLdK0ZxoLeEeftBqniAiRJu0iugJUxAS3rf
	PQRZUpKIkJJqYCyY6PzhM/+RSsXbc88evfjl/5/NuufmC8hJS9fOc327pvzTZYOyxT6xy/at
	K62dfM1Dj1vR5FdH1VzrZoVpQo13pCrs9ryUTt1wWUO1/oYK64mQjOSzR09XSDpwbxDotGtp
	Z29xcnt+7Oa1lNZss0dpMxX7hE5IJCxbGqh3xHTz87ebTxV+b1diKc5INNRiLipOBADTeItW
	UQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jumping to 0x00 might do something depending on the following bytes.
Jumping to 0xcc is a trap.  So fill the unused parts of the vsyscall
page with 0xcc to make it useless for exploits to jump there.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1583238..8d6a0b7 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -166,22 +166,20 @@ SECTIONS
 	__vsyscall_0 = .;
 
 	. = VSYSCALL_ADDR;
-	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
+	.vsyscall : AT(VLOAD(.vsyscall)) {
 		*(.vsyscall_0)
-	} :user
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
+		. = ALIGN(L1_CACHE_BYTES);
 		*(.vsyscall_fn)
-	}
 
-	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
+		. = 1024;
 		*(.vsyscall_1)
-	}
-	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
+
+		. = 2048;
 		*(.vsyscall_2)
-	}
 
+		. = 4096;  /* Pad the whole page. */
+	} :user =0xcc
 	. = ALIGN(__vsyscall_0 + PAGE_SIZE, PAGE_SIZE);
 
 #undef VSYSCALL_ADDR
-- 
1.7.5.1

