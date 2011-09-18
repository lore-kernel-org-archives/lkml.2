Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1IRUfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 16:35:38 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48197 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab1IRUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 16:35:36 -0400
Subject: Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CA+55aFwmwYXzC_4q+XuEAx3ta6U-jf=NvMcAc-J+4DBxLm8Efg@mail.gmail.com>
References: <20110918.022125.1554085675403900813.davem@davemloft.net>
	 <CA+55aFxc1tMCXKBV33PVD5BybTLBpfJAEcObvoQwbwqbKOsp7g@mail.gmail.com>
	 <20110918192333.GA1641@x4.trippels.de>
	 <1316375164.31335.18.camel@edumazet-laptop>
	 <20110918194818.GB1641@x4.trippels.de>
	 <CA+55aFwmwYXzC_4q+XuEAx3ta6U-jf=NvMcAc-J+4DBxLm8Efg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Sep 2011 22:35:30 +0200
Message-ID: <1316378130.31335.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 18 septembre 2011 à 12:55 -0700, Linus Torvalds a écrit :
> On Sun, Sep 18, 2011 at 12:48 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> >
> > The following works for me:
> 
> No it doesn't. It may *compile* for you, but it doesn't work for you.
> It avoids all the other stuff that tcp_syn_flood_action() also does
> (notably the printout).
> 
> The real fix looks to be either:
> 
>  - make an empty (inline/macro) cookie_v4_init_sequence() for the
> non-syncookie config case
> 

Yes, this one seems the less ugly.

Frankly, we should remove CONFIG_SYN_COOKIE option...

Sorry for the mess, dont blame David on this, since netdev guys
probably always use CONFIG_SYN_COOKIE.

Thanks

[PATCH] tcp: fix build error if !CONFIG_SYN_COOKIE

commit 946cedccbd7387 (tcp: Change possible SYN flooding messages)
added a build error if CONFIG_SYN_COOKIE=n

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/net/tcp.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e9b48b0..f860d64 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -431,17 +431,34 @@ extern int tcp_disconnect(struct sock *sk, int flags);
 extern __u32 syncookie_secret[2][16-4+SHA_DIGEST_WORDS];
 extern struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb, 
 				    struct ip_options *opt);
+#ifdef CONFIG_SYN_COOKIE
 extern __u32 cookie_v4_init_sequence(struct sock *sk, struct sk_buff *skb, 
 				     __u16 *mss);
+#else
+static inline __u32 cookie_v4_init_sequence(struct sock *sk,
+					    struct sk_buff *skb,
+					    __u16 *mss)
+{
+	return 0;
+}
+#endif
 
 extern __u32 cookie_init_timestamp(struct request_sock *req);
 extern bool cookie_check_timestamp(struct tcp_options_received *opt, bool *);
 
 /* From net/ipv6/syncookies.c */
 extern struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb);
+#ifdef CONFIG_SYN_COOKIE
 extern __u32 cookie_v6_init_sequence(struct sock *sk, struct sk_buff *skb,
 				     __u16 *mss);
-
+#else
+static inline __u32 cookie_v6_init_sequence(struct sock *sk,
+					    struct sk_buff *skb,
+					    __u16 *mss)
+{
+	return 0;
+}
+#endif
 /* tcp_output.c */
 
 extern void __tcp_push_pending_frames(struct sock *sk, unsigned int cur_mss,


