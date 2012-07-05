Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2GEMAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:00:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40442 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2GEMAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:00:22 -0400
From: Max Neklyudov <macscomp@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Max Neklyudov <macscomp@gmail.com>
Subject: [PATCH 1/1] arm: Fix kernel crash problem in binfmt_flat.c
Date: Thu,  5 Jul 2012 15:59:59 +0400
Message-Id: <1341489599-29463-1-git-send-email-macscomp@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If createion of the new process is aborted due to some erros
(lack of memory in my case) kernel will crash because created process
is not terminated properly.
I just sent SIG_KILL in all such points.

Tested on my LM3S1D21 based board

Signed-off-by: Max Neklyudov <macscomp@gmail.com>
---
 fs/binfmt_flat.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 178cb70..79c9838 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -545,6 +545,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		textpos = vm_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
 				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
 		if (!textpos || IS_ERR_VALUE(textpos)) {
+			send_sig(SIGKILL, current, 0);
 			if (!textpos)
 				textpos = (unsigned long) -ENOMEM;
 			printk("Unable to mmap process text, errno %d\n", (int)-textpos);
@@ -558,6 +559,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
 
 		if (realdatastart == 0 || IS_ERR_VALUE(realdatastart)) {
+			send_sig(SIGKILL, current, 0);
 			if (!realdatastart)
 				realdatastart = (unsigned long) -ENOMEM;
 			printk("Unable to allocate RAM for process data, errno %d\n",
@@ -585,6 +587,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 					data_len + (relocs * sizeof(unsigned long)), &fpos);
 		}
 		if (IS_ERR_VALUE(result)) {
+			send_sig(SIGKILL, current, 0);
 			printk("Unable to read data+bss, errno %d\n", (int)-result);
 			vm_munmap(textpos, text_len);
 			vm_munmap(realdatastart, len);
@@ -603,6 +606,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
 
 		if (!textpos || IS_ERR_VALUE(textpos)) {
+			send_sig(SIGKILL, current, 0);
 			if (!textpos)
 				textpos = (unsigned long) -ENOMEM;
 			printk("Unable to allocate RAM for process text/data, errno %d\n",
@@ -653,6 +657,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			}
 		}
 		if (IS_ERR_VALUE(result)) {
+			send_sig(SIGKILL, current, 0);
 			printk("Unable to read code+data+bss, errno %d\n",(int)-result);
 			vm_munmap(textpos, text_len + data_len + extra +
 				MAX_SHARED_LIBS * sizeof(unsigned long));
-- 
1.7.9.5

