Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2GKLiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:38:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44034 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2GKLiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:38:22 -0400
Message-ID: <1342006696.810.19.camel@mop>
Subject: Re: pr_cat() + CATSTR(name, size)?
From: Kay Sievers <kay@vrfy.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 13:38:16 +0200
In-Reply-To: <1342002808.810.12.camel@mop>
References: <1342002808.810.12.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.3.1 (3.5.3.1-4.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 12:33 +0200, Kay Sievers wrote:
> Hey Joe,
> 
> what do you think of this?
> 
> It would make composing continuation lines at the caller side entirely
> race-free, and it might fit into the usual pattern.
> 
> The more interesting thing, this would allow us to completely race-free
> use the dev_printk() calls with continuation content, which we should
> avoid otherwise for integrity reasons.

Better version with better range checking and _INIT() to reset the
string for re-use. It prints:
  [    0.000000] Kernel command line: root=/dev/sda2 ...
  [    0.000000] 1:-12 -34 -56 -78 -90
  [    0.000000] 2:-12 -34 -56 --90
  [    0.000000] 3:-12 -34 --90
  [    0.000000] 4:+12 +34 +-90
  [    0.000000] 5:~12 ~34 ~-90
  [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)

Thanks,
Kay


diff --git a/kernel/printk.c b/kernel/printk.c
index dba1821..1490153 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -48,6 +48,39 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
 
+#define CATSTR_INIT(name)		\
+	name##_len = 0;
+
+#define CATSTR_DEFINE(name, max)	\
+	char name[max];			\
+	size_t name##_len = 0;		\
+	size_t name##_max = max;
+
+#define pr_cat(name, fmt, ...)		\
+	_catstr(name, &name##_len, name##_max, fmt, ##__VA_ARGS__)
+
+ssize_t _catstr(char *s, size_t *len, size_t size, const char *fmt, ...)
+{
+	va_list args;
+	size_t r;
+
+	if (*len == size)
+		return -EINVAL;
+
+	va_start(args, fmt);
+	r = vsnprintf(s + *len, size - *len, fmt, args);
+	va_end(args);
+
+	if (r >= size - *len) {
+		*len = size;
+		return -EINVAL;
+	}
+
+	*len += r;
+	s[*len] = '\0';
+	return r;
+}
+
 /*
  * Architectures can override it:
  */
@@ -668,6 +701,47 @@ void __init setup_log_buf(int early)
 	char *new_log_buf;
 	int free;
 
+	CATSTR_DEFINE(line, 24)
+	CATSTR_DEFINE(line2, 16)
+	CATSTR_DEFINE(line3, 12)
+
+	pr_cat(line, "1:");
+	pr_cat(line, "-%i ", 12);
+	pr_cat(line, "-%i ", 34);
+	pr_cat(line, "-%i ", 56);
+	pr_cat(line, "-%i ", 78);
+	pr_warn("%s-%i\n", line, 90);
+
+	pr_cat(line2, "2:");
+	pr_cat(line2, "-%i ", 12);
+	pr_cat(line2, "-%i ", 34);
+	pr_cat(line2, "-%i ", 56);
+	pr_cat(line2, "-%i ", 78);
+	pr_warn("%s-%i\n", line2, 90);
+
+	pr_cat(line3, "3:");
+	pr_cat(line3, "-%i ", 12);
+	pr_cat(line3, "-%i ", 34);
+	pr_cat(line3, "-%i ", 56);
+	pr_cat(line3, "-%i ", 78);
+	pr_warn("%s-%i\n", line3, 90);
+
+	CATSTR_INIT(line3)
+	pr_cat(line3, "4:");
+	pr_cat(line3, "+%i ", 12);
+	pr_cat(line3, "+%i ", 34);
+	pr_cat(line3, "+%i ", 56);
+	pr_cat(line3, "+%i ", 78);
+	pr_warn("%s-%i\n", line3, 90);
+
+	CATSTR_INIT(line3)
+	pr_cat(line3, "5:");
+	pr_cat(line3, "~%i ", 12);
+	pr_cat(line3, "~%i ", 34);
+	pr_cat(line3, "~%i ", 56);
+	pr_cat(line3, "~%i ", 78);
+	pr_warn("%s-%i\n", line3, 90);
+
 	if (!new_log_buf_len)
 		return;
 

