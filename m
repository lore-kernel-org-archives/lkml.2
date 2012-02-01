Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2BAI6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:58:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38184 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2BAI6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:58:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 1 Feb 2012 17:56:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] speed up /proc/pid/stat, statm
Message-Id: <20120201175657.0b67bc00.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1328075682.2617.48.camel@edumazet-laptop>
References: <20120131171443.567b53ad.kamezawa.hiroyu@jp.fujitsu.com>
	<20120131123612.6b60bdfc.akpm@linux-foundation.org>
	<20120201085546.ecbf628d.kamezawa.hiroyu@jp.fujitsu.com>
	<1328075682.2617.48.camel@edumazet-laptop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Feb 2012 06:54:42 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le mercredi 01 février 2012 à 08:55 +0900, KAMEZAWA Hiroyuki a écrit :
> 
> > seq_xxxx functions set m->count == m->size when it finds possible buffer overflow.
> > If m->count == m->size after ->show(), buffer will be freed and twice size buffer
> > will be re-allocated, and retry.
> > 
> > If we don't set m->count == m->size here, following seq_putc() will succeed and
> > we'll see corrupted outputs.
> 
> I suppose we could define a self documented helper
> 
> void seq_overflow(struct seq_file *seq)
> {
> 	seq->count = seq->size;
> }
> 

How about this ?
==
>From 76769c79d44ae0532c32113a352dc0269bb7a7d5 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 1 Feb 2012 18:10:16 +0900
Subject: [PATCH] add seq_set_overflow(), seq_overflow()

It's undocumented but seq file's overflow state is checked by
m->count == m->size. This patch adds seq_set_overflow() and
seq_overflow() to set/check overflow status explicitly.

Based on an idea from Eric Dumazet <eric.dumazet@gmail.com>

Signed-off-by:KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/seq_file.c |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index eea2b01..8712652 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -13,6 +13,22 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
+
+/*
+ * seq file has a buffer but it may overflow. At overflow, larger buffer
+ * is re-allocated and all data will be printed, again.
+ * Now, overflow check is done by m->count == m->size.
+ */
+static bool seq_overflow(struct seq_file *m)
+{
+	return m->count == m->size;
+}
+
+static void seq_set_overflow(struct seq_file *m)
+{
+	m->count = m->size;
+}
+
 /**
  *	seq_open -	initialize sequential file
  *	@file: file we initialize
@@ -92,7 +108,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 			error = 0;
 			m->count = 0;
 		}
-		if (m->count == m->size)
+		if (seq_overflow(m))
 			goto Eoverflow;
 		if (pos + m->count > offset) {
 			m->from = offset - pos;
@@ -232,7 +248,7 @@ Fill:
 			break;
 		}
 		err = m->op->show(m, p);
-		if (m->count == m->size || err) {
+		if (seq_overflow(m) || err) {
 			m->count = offs;
 			if (likely(err <= 0))
 				break;
@@ -359,7 +375,7 @@ int seq_escape(struct seq_file *m, const char *s, const char *esc)
 			*p++ = '0' + (c & 07);
 			continue;
 		}
-		m->count = m->size;
+		seq_set_overflow(m);
 		return -1;
         }
 	m->count = p - m->buf;
@@ -381,7 +397,7 @@ int seq_printf(struct seq_file *m, const char *f, ...)
 			return 0;
 		}
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_printf);
@@ -510,7 +526,7 @@ int seq_bitmap(struct seq_file *m, const unsigned long *bits,
 			return 0;
 		}
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_bitmap);
@@ -526,7 +542,7 @@ int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
 			return 0;
 		}
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_bitmap_list);
@@ -637,7 +653,7 @@ int seq_puts(struct seq_file *m, const char *s)
 		m->count += len;
 		return 0;
 	}
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_puts);
@@ -671,7 +687,7 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 	m->count += len;
 	return 0;
 overflow:
-	m->count = m->size;
+	seq_set_overflow(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
@@ -681,7 +697,7 @@ int seq_put_decimal_ll(struct seq_file *m, char delimiter,
 {
 	if (num < 0) {
 		if (m->count + 3 >= m->size) {
-			m->count = m->size;
+			seq_set_overflow(m);
 			return -1;
 		}
 		if (delimiter)
@@ -709,7 +725,7 @@ int seq_write(struct seq_file *seq, const void *data, size_t len)
 		seq->count += len;
 		return 0;
 	}
-	seq->count = seq->size;
+	seq_set_overflow(seq);
 	return -1;
 }
 EXPORT_SYMBOL(seq_write);
-- 
1.7.4.1


