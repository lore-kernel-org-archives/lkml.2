Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2CEQta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:49:30 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:5898 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2CEQt2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Mon, 5 Mar 2012 11:49:28 -0500
Message-Id: <4F54FCA402000078000766F1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 05 Mar 2012 16:49:24 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] vsprintf: make %pV handling compatible with
 kasprintf()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kasprintf() (and potentially other functions that I didn't run across
so far) want to evaluate argument lists twice. Caring to do so for the
primary list is obviously their job, but they can't reasonably be
expected to check the format string for instances of %pV, which however
need special handling too: On architectures like x86-64 (as opposed to
e.g. ix86), using the same argument list twice doesn't produce the
expected results, as an internally managed cursor gets updated during
the first run.

Fix the problem by always acting on a copy of the original list when
handling %pV.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 lib/vsprintf.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- 3.3-rc6/lib/vsprintf.c
+++ 3.3-rc6-kasprintf-pV/lib/vsprintf.c
@@ -891,9 +891,15 @@ char *pointer(const char *fmt, char *buf
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
 	case 'V':
-		return buf + vsnprintf(buf, end > buf ? end - buf : 0,
-				       ((struct va_format *)ptr)->fmt,
-				       *(((struct va_format *)ptr)->va));
+		{
+			va_list va;
+
+			va_copy(va, *((struct va_format *)ptr)->va);
+			buf += vsnprintf(buf, end > buf ? end - buf : 0,
+					 ((struct va_format *)ptr)->fmt, va);
+			va_end(va);
+			return buf;
+		}
 	case 'K':
 		/*
 		 * %pK cannot be used in IRQ context because its test



