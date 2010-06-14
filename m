Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0FNM5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:57:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39650 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0FNM5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U8vP+ZSpX7KJ654PqleoMqW+A0ZAl1CMTRuopPWk6KyqfWaZwVpI3iuOh/S25y7ZC8
         4IioAS6FCQo7rEaFbI2OPuYcvRJ/3VYZCAFaYONL7vwulATnPloVWyZrU7Lqzf0jEhHw
         K+QgaaEW+sirQXqgcvmqIY0VLBEMDiKvcUO2E=
Subject: [PATCH net-next-2.6] net: NET_SKB_PAD should depend on
 L1_CACHE_BYTES
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: alexander.h.duyck@intel.com, jeffrey.t.kirsher@intel.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gospo@redhat.com
In-Reply-To: <20100610.222006.242136751.davem@davemloft.net>
References: <20100602222506.12962.49240.stgit@localhost.localdomain>
	 <1275518650.29413.43.camel@edumazet-laptop>
	 <80769D7B14936844A23C0C43D9FBCF0F2562CD2555@orsmsx501.amr.corp.intel.com>
	 <20100610.222006.242136751.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 14:57:14 +0200
Message-ID: <1276520234.2478.82.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 10 juin 2010 à 22:20 -0700, David Miller a écrit :

> Eric, why don't we do that?  Make NET_SKB_PAD's define L1_CACHE_BYTES.
> 
> Reading the comments you added when the default value was changed to
> 64, this seems to even be your overall intent. :-)

Of course right you are ;)

Thanks !

[PATCH net-next-2.6] net: NET_SKB_PAD should depend on L1_CACHE_BYTES

In old kernels, NET_SKB_PAD was defined to 16.

Then commit d6301d3dd1c2 (net: Increase default NET_SKB_PAD to 32), and
commit 18e8c134f4e9 (net: Increase NET_SKB_PAD to 64 bytes) increased it
to 64.

While first patch was governed by network stack needs, second was more
driven by performance issues on current hardware. Real intent was to
align data on a cache line boundary.

So use max(32, L1_CACHE_BYTES) instead of 64, to be more generic.

Remove microblaze and powerpc own NET_SKB_PAD definitions.

Thanks to Alexander Duyck and David Miller for their comments.

Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 arch/microblaze/include/asm/system.h |    3 ---
 arch/powerpc/include/asm/system.h    |    3 ---
 include/linux/skbuff.h               |    8 +++++---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
index 48c4f03..81e1f7d 100644
--- a/arch/microblaze/include/asm/system.h
+++ b/arch/microblaze/include/asm/system.h
@@ -101,10 +101,7 @@ extern struct dentry *of_debugfs_root;
  * MicroBlaze doesn't handle unaligned accesses in hardware.
  *
  * Based on this we force the IP header alignment in network drivers.
- * We also modify NET_SKB_PAD to be a cacheline in size, thus maintaining
- * cacheline alignment of buffers.
  */
 #define NET_IP_ALIGN	2
-#define NET_SKB_PAD	L1_CACHE_BYTES
 
 #endif /* _ASM_MICROBLAZE_SYSTEM_H */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index a6297c6..6c294ac 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -515,11 +515,8 @@ __cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
  * powers of 2 writes until it reaches sufficient alignment).
  *
  * Based on this we disable the IP header alignment in network drivers.
- * We also modify NET_SKB_PAD to be a cacheline in size, thus maintaining
- * cacheline alignment of buffers.
  */
 #define NET_IP_ALIGN	0
-#define NET_SKB_PAD	L1_CACHE_BYTES
 
 #define cmpxchg64(ptr, o, n)						\
   ({									\
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 122d083..ac74ee0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1414,12 +1414,14 @@ static inline int skb_network_offset(const struct sk_buff *skb)
  *
  * Various parts of the networking layer expect at least 32 bytes of
  * headroom, you should not reduce this.
- * With RPS, we raised NET_SKB_PAD to 64 so that get_rps_cpus() fetches span
- * a 64 bytes aligned block to fit modern (>= 64 bytes) cache line sizes
+ *
+ * Using max(32, L1_CACHE_BYTES) makes sense (especially with RPS)
+ * to reduce average number of cache lines per packet.
+ * get_rps_cpus() for example only access one 64 bytes aligned block :
  * NET_IP_ALIGN(2) + ethernet_header(14) + IP_header(20/40) + ports(8)
  */
 #ifndef NET_SKB_PAD
-#define NET_SKB_PAD	64
+#define NET_SKB_PAD	max(32, L1_CACHE_BYTES)
 #endif
 
 extern int ___pskb_trim(struct sk_buff *skb, unsigned int len);


