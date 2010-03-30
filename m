Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0C3XLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:11:46 -0400
Received: from kroah.org ([198.145.64.141]:48606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab0C3XJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:21 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:05 2010
Message-Id: <20100330225005.041222928@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stanislav Brabec <sbrabec@suse.cz>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [38/45] b44 WOL setup: one-bit-off stack corruption kernel panic fix
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislav Brabec <sbrabec@suse.cz>

commit e0188829cb724e7d12a2d4e343b368ff1d6e1471 upstream.

About 50% of shutdowns of b44 Ethernet adapter ends by kernel panic
with kernels compiled with stack-protector.

Checking b44_magic_pattern() return values, one call of
b44_magic_pattern() returns 127. It means, that set_bit(128, pmask)
was called on line 1509. It means that bit 0 of 17th byte of pmask was
overwritten. But pmask has only 16 bytes. Stack corruption happens.

It seems that set_bit() on line 1509 always writes one bit off.

The fix does not only solve the stack corruption, but also makes Wake
On LAN working on my onboard B44 on Asus A7V-333X mainboard.

It seems that this problem affects all kernel versions since commit
725ad800 ([PATCH] b44: add wol for old nic) on 2006-06-20.

Signed-off-by: Stanislav Brabec <sbrabec@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/b44.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -1502,8 +1502,7 @@ static int b44_magic_pattern(u8 *macaddr
 		for (k = 0; k< ethaddr_bytes; k++) {
 			ppattern[offset + magicsync +
 				(j * ETH_ALEN) + k] = macaddr[k];
-			len++;
-			set_bit(len, (unsigned long *) pmask);
+			set_bit(len++, (unsigned long *) pmask);
 		}
 	}
 	return len - 1;


