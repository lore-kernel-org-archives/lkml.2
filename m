Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab0CaAk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:40:56 -0400
Received: from kroah.org ([198.145.64.141]:48455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0C3XI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:59 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:49 2010
Message-Id: <20100330224948.404822857@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [15/45] x86: fix csum_ipv6_magic asm memory clobber
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 392d814daf460a9564d29b2cebc51e1ea34e0504 upstream.

Just like ip_fast_csum, the assembly snippet in csum_ipv6_magic needs a
memory clobber, as it is only passed the address of the buffer, not a
memory reference to the buffer itself.

This caused failures in Hurd's pfinetv4 when we tried to compile it with
gcc-4.3 (bogus checksums).

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86/checksum_32.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/asm-x86/checksum_32.h
+++ b/include/asm-x86/checksum_32.h
@@ -161,7 +161,8 @@ static inline __sum16 csum_ipv6_magic(co
 	    "adcl $0, %0	;\n"
 	    : "=&r" (sum)
 	    : "r" (saddr), "r" (daddr),
-	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum));
+	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum)
+	    : "memory");
 
 	return csum_fold(sum);
 }


