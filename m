Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830Ab0HFSfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:35:24 -0400
Received: from kroah.org ([198.145.64.141]:48555 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761792Ab0HFSfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:21 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:00 2010
Message-Id: <20100806183200.406242674@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kyle McMartin <kyle@parisc-linux.org>
Subject: [04/38] parisc: pass through \t to early (iodc) console
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kyle McMartin <kyle@mcmartin.ca>

commit d9b68e5e88248bb24fd4e455588bea1d56108fd6 upstream.

The firmware handles '\t' internally, so stop trying to emulate it
(which, incidentally, had a bug in it.)

Fixes a really weird hang at bootup in rcu_bootup_announce, which,
as far as I can tell, is the first printk in the core kernel to use
a tab as the first character.

Signed-off-by: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/kernel/firmware.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1123,7 +1123,6 @@ static char __attribute__((aligned(64)))
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	static int posx;        /* for simple TAB-Simulation... */
 	unsigned int i;
 	unsigned long flags;
 
@@ -1133,19 +1132,12 @@ int pdc_iodc_print(const unsigned char *
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


