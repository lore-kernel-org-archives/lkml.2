Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2GRRSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab2GRRSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:18:20 -0400
Date: Wed, 18 Jul 2012 13:18:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Kexec Mailing List <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Subject: [PATCH] printk: Export struct log size and member offsets through
 vmcoreinfo
Message-ID: <20120718171812.GC21746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are tools like makedumpfile and vmcore-dmesg which can extract
kernel log buffer from vmcore. Since we introduced structured logging,
that functionality is broken. Now user space tools need to know about
"struct log" and offsets of various fields to be able to parse struct
log data and extract text message or dictonary.

This patch exports some of the fields.

Currently I am not exporting log "level" info as that is a bitfield and
offsetof() bitfields can't be calculated. But if people start asking for
log level info in the output then we probably either need to seprate
out "level" or use bit shift operations for flags and level.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/printk.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c	2012-07-20 14:02:38.213581253 -0400
+++ linux-2.6/kernel/printk.c	2012-07-20 14:02:42.004581438 -0400
@@ -646,6 +646,15 @@ void log_buf_kexec_setup(void)
 	VMCOREINFO_SYMBOL(log_buf_len);
 	VMCOREINFO_SYMBOL(log_first_idx);
 	VMCOREINFO_SYMBOL(log_next_idx);
+	/*
+	 * Export struct log size and field offsets. User space tools can
+	 * parse it and detect any changes to structure down the line.
+	 */
+	VMCOREINFO_STRUCT_SIZE(log);
+	VMCOREINFO_OFFSET(log, ts_nsec);
+	VMCOREINFO_OFFSET(log, len);
+	VMCOREINFO_OFFSET(log, text_len);
+	VMCOREINFO_OFFSET(log, dict_len);
 }
 #endif
 
