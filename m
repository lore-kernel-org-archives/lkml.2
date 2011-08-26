Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1H0O6t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab1H0O6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:58:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:55 2011
Message-Id: <20110826215055.557301047@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
        Andres Salomon <dilinger@queued.net>, Ingo Molnar <mingo@elte.hu>
Subject: [26/35] x86, olpc: Wait for last byte of EC command to be accepted
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Fox <pgf@laptop.org>

commit a3ea14df0e383f44dcb2e61badb71180dbffe526 upstream.

When executing EC commands, only waiting when there are still
more bytes to write is usually fine. However, if the system
suspends very quickly after a call to olpc_ec_cmd(), the last
data byte may not yet be transferred to the EC, and the command
will not complete.

This solves a bug where the SCI wakeup mask was not correctly
written when going into suspend.

It means that sometimes, on XO-1.5 (but not XO-1), the
devices that were marked as wakeup sources can't wake up
the system. e.g. you ask for wifi wakeups, suspend, but then
incoming wifi frames don't wake up the system as they should.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/platform/olpc/olpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -157,13 +157,13 @@ restart:
 	if (inbuf && inlen) {
 		/* write data to EC */
 		for (i = 0; i < inlen; i++) {
+			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
+			outb(inbuf[i], 0x68);
 			if (wait_on_ibf(0x6c, 0)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC accept data!\n");
 				goto err;
 			}
-			pr_devel("olpc-ec:  sending cmd arg 0x%x\n", inbuf[i]);
-			outb(inbuf[i], 0x68);
 		}
 	}
 	if (outbuf && outlen) {


