Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2LJVmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:42:52 -0500
Received: from flmx07.ccur.com ([173.221.59.12]:56405 "EHLO flmx07.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2LJVmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:42:50 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 16:42:50 EST
Message-ID: <50C65612.3070604@ccur.com>
Date: Mon, 10 Dec 2012 15:37:22 -0600
From: John Blackwood <john.blackwood@ccur.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kgdb/kdb: A fix for kdb command table expansion
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When locally adding in some additional kdb commands, I stumbled
across an issue with the dynamic expansion of the kdb command table.
When the number of kdb commands exceeds the size of the statically
allocated kdb_base_commands[] array, additional space is allocated in
the kdb_register_repeat() routine.

The unused portion of the newly allocated array was not being initialized
to zero properly and this would result in segfaults when help '?' was
executed or when a search for a non-existing command would traverse the
command table beyond the end of valid command entries and then attempt
to use the non-zeroed area as actual command entries.

Signed-off-by: John Blackwood <john.blackwood@ccur.com>
Index: b/kernel/debug/kdb/kdb_main.c
===================================================================
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -3341,7 +3341,7 @@ int kdb_register_repeat(char *cmd,
  			  (kdb_max_commands - KDB_BASE_CMD_MAX) * sizeof(*new));
  			kfree(kdb_commands);
  		}
-		memset(new + kdb_max_commands, 0,
+		memset(new + kdb_max_commands - KDB_BASE_CMD_MAX, 0,
  		       kdb_command_extend * sizeof(*new));
  		kdb_commands = new;
  		kp = kdb_commands + kdb_max_commands - KDB_BASE_CMD_MAX;
