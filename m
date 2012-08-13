Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2HMUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:25:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2HMUZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Mahoney <jeffm@suse.com>
Subject: [ 75/82] printk: Fix calculation of length used to discard records
Date: Mon, 13 Aug 2012 13:19:51 -0700
Message-Id: <20120813201753.013023496@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit e3756477aec028427fec767957c0d4b6cfb87208 upstream.

While tracking down a weird buffer overflow issue in a program that
looked to be sane, I started double checking the length returned by
syslog(SYSLOG_ACTION_READ_ALL, ...) to make sure it wasn't overflowing
the buffer.

Sure enough, it was.  I saw this in strace:

  11339 syslog(SYSLOG_ACTION_READ_ALL, "<5>[244017.708129] REISERFS (dev"..., 8192) = 8279

It turns out that the loops that calculate how much space the entries
will take when they're copied don't include the newlines and prefixes
that will be included in the final output since prev flags is passed as
zero.

This patch properly accounts for it and fixes the overflow.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/printk.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -999,6 +999,7 @@ static int syslog_print_all(char __user
 			struct log *msg = log_from_idx(idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
+			prev = msg->flags;
 			idx = log_next(idx);
 			seq++;
 		}
@@ -1011,6 +1012,7 @@ static int syslog_print_all(char __user
 			struct log *msg = log_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
+			prev = msg->flags;
 			idx = log_next(idx);
 			seq++;
 		}


