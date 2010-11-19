Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab0KSWcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:32:48 -0500
Received: from kroah.org ([198.145.64.141]:45009 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab0KSV6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:30 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:40 2010
Message-Id: <20101119215640.228334833@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Drake <dsd@laptop.org>, dilinger@queued.net,
        Ingo Molnar <mingo@elte.hu>
Subject: [18/82] x86, olpc: Dont retry EC commands forever
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Fox <pgf@laptop.org>

commit 286e5b97eb22baab9d9a41ca76c6b933a484252c upstream.

Avoids a potential infinite loop.

It was observed once, during an EC hacking/debugging
session - not in regular operation.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: dilinger@queued.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/olpc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -117,6 +117,7 @@ int olpc_ec_cmd(unsigned char cmd, unsig
 	unsigned long flags;
 	int ret = -EIO;
 	int i;
+	int restarts = 0;
 
 	spin_lock_irqsave(&ec_lock, flags);
 
@@ -173,7 +174,9 @@ restart:
 			if (wait_on_obf(0x6c, 1)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC to provide data!\n");
-				goto restart;
+				if (restarts++ < 10)
+					goto restart;
+				goto err;
 			}
 			outbuf[i] = inb(0x68);
 			printk(KERN_DEBUG "olpc-ec:  received 0x%x\n",


