Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab1KWAve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:51:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759098Ab1KWAkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:40:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:06 2011
Message-Id: <20111123002406.590288296@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Boyd <sboyd@codeaurora.org>
Subject: [21/53] tty: hvc_dcc: Fix duplicate character inputs
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit c2a3e84f950e7ddba1f3914b005861d46ae60359 upstream.

Reading from the DCC grabs a character from the buffer and
clears the status bit. Since this is a context-changing
operation, instructions following the character read that rely on
the status bit being accurate need to be synchronized with an
ISB.

In this case, the status bit check needs to execute after the
character read otherwise we run the risk of reading the character
and checking the status bit before the read can clear the status
bit in the first place. When this happens, the user will see the
same character they typed twice, instead of once.

Add an ISB after the read and the write, so that the status check
is synchronized with the read/write operations.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/hvc/hvc_dcc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/hvc/hvc_dcc.c
+++ b/drivers/tty/hvc/hvc_dcc.c
@@ -46,6 +46,7 @@ static inline char __dcc_getchar(void)
 
 	asm volatile("mrc p14, 0, %0, c0, c5, 0	@ read comms data reg"
 		: "=r" (__c));
+	isb();
 
 	return __c;
 }
@@ -55,6 +56,7 @@ static inline void __dcc_putchar(char c)
 	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
 		: /* no output register */
 		: "r" (c));
+	isb();
 }
 
 static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)


