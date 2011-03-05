Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753Ab1CEBSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:18:45 -0500
Received: from kroah.org ([198.145.64.141]:50139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760205Ab1CEA74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 19:59:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:35 2011
Message-Id: <20110305005635.563197960@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Pavel Emelyanov <xemul@openvz.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [10/73] tcp: fix inet_twsk_deschedule()
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 91035f0b7d89291af728b6f3e370c3be58fcbe1b upstream.

Eric W. Biederman reported a lockdep splat in inet_twsk_deschedule()

This is caused by inet_twsk_purge(), run from process context,
and commit 575f4cd5a5b6394577 (net: Use rcu lookups in inet_twsk_purge.)
removed the BH disabling that was necessary.

Add the BH disabling but fine grained, right before calling
inet_twsk_deschedule(), instead of whole function.

With help from Linus Torvalds and Eric W. Biederman

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Pavel Emelyanov <xemul@openvz.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/inet_timewait_sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -505,7 +505,9 @@ restart:
 			}
 
 			rcu_read_unlock();
+			local_bh_disable();
 			inet_twsk_deschedule(tw, twdr);
+			local_bh_enable();
 			inet_twsk_put(tw);
 			goto restart_rcu;
 		}


