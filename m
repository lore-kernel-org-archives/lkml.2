Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2GKKdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:33:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37191 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab2GKKde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:33:34 -0400
Message-ID: <1342002808.810.12.camel@mop>
Subject: pr_cat() + CATSTR(name, size)?
From: Kay Sievers <kay@vrfy.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 12:33:28 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joe,

what do you think this?

It would make composing continuation lines at the caller side entirely
race-free, and it might fit into the usual pattern.

The more interesting thing, this would allow us to completely race-free
use the dev_printk() calls with continuation content, which we should
avoid otherwise for integrity reasons.

The patch below is just hacked it into the printk.c file to illustrate
the idea. It prints:
  [    0.000000] Kernel command line: root=/dev/sda2 ...
  [    0.000000] 12 34 56 78
  [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)

  5,96,0;Kernel command line: root=/dev/sda2 ...
  4,97,0;12 34 56 78
  6,98,0;PID hash table entries: 2048 (order: 2, 16384 bytes)

Thanks,
Kay


diff --git a/kernel/printk.c b/kernel/printk.c
index dba1821..1fd00b0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -48,6 +48,32 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#define CATSTR(name, max)		\
+	char name[max];			\
+	size_t _##name_len = 0;		\
+	size_t _##name_max = max;
+
+#define pr_cat(name, fmt, ...)		\
+	_catstr(name, &_##name_len, _##name_max, fmt, ##__VA_ARGS__)
+
+ssize_t _catstr(char *s, size_t *len, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	size_t l = *len;
+	size_t r;
+
+	va_start(args, fmt);
+	r = vsnprintf(s + l, size - l, fmt, args);
+	va_end(args);
+
+	if (r >= size - l)
+		return -EINVAL;
+
+	*len += r;
+	s[*len] = '\0';
+	return r;
+}
+
 /*
  * Architectures can override it:
  */
@@ -668,6 +694,12 @@ void __init setup_log_buf(int early)
 	char *new_log_buf;
 	int free;
 
+	CATSTR(line, 80);
+	pr_cat(line, "%i ", 12);
+	pr_cat(line, "%i ", 34);
+	pr_cat(line, "%i ", 56);
+	pr_warn("%s%i\n", line, 78);
+
 	if (!new_log_buf_len)
 		return;
 

