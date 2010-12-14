Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab0LNFHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 00:07:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:47506 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0LNFHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 00:07:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] kgdboc,input: Fix regression with keyboard release key and early debugging
Date: Mon, 13 Dec 2010 23:04:52 -0600
Message-Id: <1292303092-32677-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1292303092-32677-1-git-send-email-jason.wessel@windriver.com>
References: <1292303092-32677-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Dec 2010 05:06:57.0941 (UTC) FILETIME=[BBB80450:01CB9B4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 111c182340cd22e238ab1cc6564df336c6ebd7cb (kgdboc: reset
input devices (keyboards) when exiting debugger) introduced a
regression in early debugging such that you get a kernel oops on
continue (with the go command) if you boot a kernel with:

    earlyprintk=vga ekgdboc=kbd kgdbwait

The restore kgdboc_restore_input() routine schedules work for the
purpose of sending key release events for any keys that were in the
depressed state prior to entering the kernel debugger.  A simple fix
to the crash is to not invoke the schedule_work() if the kernel
system_state is anything other than SYSTEM_RUNNING.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Sergei Shtylyov <sshtylyov@mvista.com>
---
 drivers/serial/kgdboc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 3374618..25a8bc5 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -90,7 +90,8 @@ static DECLARE_WORK(kgdboc_restore_input_work, kgdboc_restore_input_helper);
 
 static void kgdboc_restore_input(void)
 {
-	schedule_work(&kgdboc_restore_input_work);
+	if (likely(system_state == SYSTEM_RUNNING))
+		schedule_work(&kgdboc_restore_input_work);
 }
 
 static int kgdboc_register_kbd(char **cptr)
-- 
1.7.0.4

