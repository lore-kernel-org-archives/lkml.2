Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2HJTHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:07:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab2HJTHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:07:19 -0400
Message-ID: <50255BDD.2070508@suse.com>
Date: Fri, 10 Aug 2012 15:07:09 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Cc: stable@kernel.org, Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] printk: Fix calculation of length used to discard records
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While tracking down a weird buffer overflow issue in a program that
looked to be sane, I started double checking the length returned
by syslog(SYSLOG_ACTION_READ_ALL, ...) to make sure it wasn't overflowing
the buffer. Sure enough, it was.  I saw this in strace:

11339 syslog(SYSLOG_ACTION_READ_ALL, "<5>[244017.708129] REISERFS (dev"..., 8192) = 8279

It turns out that the loops that calculate how much space the entries
will take when they're copied don't include the newlines and
prefixes that will be included in the final output since prev flags
is passed as 0. 

This patch properly accounts for it and fixes the overflow.

CC: stable@kernel.org
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 kernel/printk.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1034,6 +1034,7 @@ static int syslog_print_all(char __user
 			struct log *msg = log_from_idx(idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
+			prev = msg->flags;
 			idx = log_next(idx);
 			seq++;
 		}
@@ -1046,6 +1047,7 @@ static int syslog_print_all(char __user
 			struct log *msg = log_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
+			prev = msg->flags;
 			idx = log_next(idx);
 			seq++;
 		}

-- 
Jeff Mahoney
SUSE Labs
