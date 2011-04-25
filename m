Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1DYUXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:55 -0400
Received: from 1wt.eu ([62.212.114.60]:33835 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465Ab1DYUXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:52 -0400
Message-Id: <20110425200234.079044068@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Kyle McMartin <kyle@parisc-linux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 025/173] parisc: pass through \t to early (iodc) console
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kyle McMartin <kyle@mcmartin.ca>

commit d9b68e5e88248bb24fd4e455588bea1d56108fd6 upstream.

The firmware handles '\t' internally, so stop trying to emulate it
(which, incidentally, had a bug in it.)

Fixes a really weird hang at bootup in rcu_bootup_announce, which,
as far as I can tell, is the first printk in the core kernel to use
a tab as the first character.

Cc: stable@kernel.org
Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 4c247e0..df971fa 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1123,7 +1123,6 @@ static char __attribute__((aligned(64))) iodc_dbuf[4096];
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	static int posx;        /* for simple TAB-Simulation... */
 	unsigned int i;
 	unsigned long flags;
 
@@ -1133,19 +1132,12 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
-			posx = 0;
 			goto print;
-		case '\t':
-			while (posx & 7) {
-				iodc_dbuf[i] = ' ';
-				i++, posx++;
-			}
-			break;
 		case '\b':	/* BS */
-			posx -= 2;
+			i--; /* overwrite last */
 		default:
 			iodc_dbuf[i] = str[i];
-			i++, posx++;
+			i++;
 			break;
 		}
 	}


