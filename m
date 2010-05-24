Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0EXUE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:04:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:55631 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0EXUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:04:24 -0400
Message-ID: <4BFADBC1.9000802@windriver.com>
Date: Mon, 24 May 2010 15:04:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kgdb tree
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au> <20100325154307.9cdeae10.sfr@canb.auug.org.au> <201003242159.25770.dmitry.torokhov@gmail.com> <20100521102158.bf6df441.sfr@canb.auug.org.au> <4BF5D8AF.6010408@windriver.com> <20100521110938.7bbbbf59.sfr@canb.auug.org.au> <20100521012340.GA12372@core.coreip.homeip.net> <4BF5E1D6.1090607@windriver.com> <20100524181735.GC6033@core.coreip.homeip.net>
In-Reply-To: <20100524181735.GC6033@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2010 20:04:18.0317 (UTC) FILETIME=[4AD06BD0:01CAFB7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 01:17 PM, Dmitry Torokhov wrote:

> Do we really need to force SysRq on or off? Maybe we should export
> __handle_sysrq() instead?


It seems cleanest to export __handle_sysrq() if that is ok?

> Also, I think I need to add locking in sysrq_toggle_support(), which
> will make it unsuitable for using in kdb handler, won't it?
> 

Any kind of locking would provide another opportunity to deadlock the
debugger.  It is probably worth noting that any of the sysrq
operations have the possibility to dead lock the system depending on
what type of exception was taken.  The idea is that you can use kdb in
one of these fatal exceptions and additionally run sysrq when you
might not have otherwise been able to before because the keyboard
handler was dead after a call to panic() for example.  At the point it
in time that it hangs there, the system was dead anyway. :-)


--------------

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] sysrq,kdb: Use __handle_sysrq() for kdb's sysrq function

The kdb code should not toggle the sysrq state in case an end user
wants to try and resume the normal kernel execution.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/char/sysrq.c        |    2 +-
 include/linux/sysrq.h       |    1 +
 kernel/debug/kdb/kdb_main.c |    3 +--
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -493,7 +493,7 @@ static void __sysrq_put_key_op(int key, 
                 sysrq_key_table[i] = op_p;
 }
 
-static void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
+void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 {
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -45,6 +45,7 @@ struct sysrq_key_op {
  */
 
 void handle_sysrq(int key, struct tty_struct *tty);
+void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
 struct sysrq_key_op *__sysrq_get_key_op(int key);
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1820,9 +1820,8 @@ static int kdb_sr(int argc, const char *
 {
 	if (argc != 1)
 		return KDB_ARGCOUNT;
-	sysrq_toggle_support(1);
 	kdb_trap_printk++;
-	handle_sysrq(*argv[1], NULL);
+	__handle_sysrq(*argv[1], NULL, 0);
 	kdb_trap_printk--;
 
 	return 0;
