Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab1JCJIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:08:54 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:44814 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1JCJIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:08:49 -0400
Date: Mon, 3 Oct 2011 12:08:47 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Andy Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [3.1 patch] x86: default to vsyscall=native
Message-ID: <20111003090846.GA25136@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After upgrading a kernel the existing userspace should just work
(assuming it did work before ;-) ), but when I upgraded my kernel
from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.

dmesg said:
  linux-2.6.30.1[3800] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb9c498 ax:ffffffffff600000 si:0 di:606790
  linux-2.6.30.1[3856] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb13168 ax:ffffffffff600000 si:0 di:606790

Looking throught the changelog I ended up at commit 3ae36655
("x86-64: Rework vsyscall emulation and add vsyscall= parameter").

Linus suggested in https://lkml.org/lkml/2011/8/9/376 to default to 
vsyscall=native.

That sounds reasonable to me, and fixes the problem for me.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
---
 Documentation/kernel-parameters.txt |    7 ++++---
 arch/x86/kernel/vsyscall_64.c       |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 854ed5ca..d6e6724 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2706,10 +2706,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			functions are at fixed addresses, they make nice
 			targets for exploits that can control RIP.
 
-			emulate     [default] Vsyscalls turn into traps and are
-			            emulated reasonably safely.
+			emulate     Vsyscalls turn into traps and are emulated
+			            reasonably safely.
 
-			native      Vsyscalls are native syscall instructions.
+			native      [default] Vsyscalls are native syscall
+			            instructions.
 			            This is a little bit faster than trapping
 			            and makes a few dynamic recompilers work
 			            better than they would in emulation mode.
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 18ae83d..b56c65de 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -56,7 +56,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
 
-static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
 
 static int __init vsyscall_setup(char *str)
 {
-- 
1.7.6.3

