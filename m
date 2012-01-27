Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2A0AAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:00:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55009 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2A0AAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:00:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, xemul@parallels.com,
        sjur.brandeland@stericsson.com, levinsasha928@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        sjurbren@gmail.com
Subject: [PATCH 1/2] netns: Fail conspicously if someone uses net_generic at an inappropriate time.
References: <4F212E7E.2040801@parallels.com>
	<1327575108.2500.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<m1zkdacbsx.fsf@fess.ebiederm.org>
	<20120126.180754.679593869814492219.davem@davemloft.net>
Date: Thu, 26 Jan 2012 16:02:55 -0800
In-Reply-To: <20120126.180754.679593869814492219.davem@davemloft.net> (David
	Miller's message of "Thu, 26 Jan 2012 18:07:54 -0500 (EST)")
Message-ID: <m1ehumc8r4.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18VvpBh3kKDhr+16xCg0yMcLAm0GRbgqE4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


By definition net_generic should never be called when it can return
NULL.  Fail conspicously with a BUG_ON to make it clear when people mess
up that a NULL return should never happen.

Recently there was a bug in the CAIF subsystem where it was registered
with register_pernet_device instead of register_pernet_subsys.  It was
erroneously concluded that net_generic could validly return NULL and
that net_assign_generic was buggy (when it was just inefficient).
Hopefully this BUG_ON will prevent people to coming to similar erroneous
conclusions in the futrue.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/netns/generic.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/netns/generic.h b/include/net/netns/generic.h
index 3419bf5..d55f434 100644
--- a/include/net/netns/generic.h
+++ b/include/net/netns/generic.h
@@ -41,6 +41,7 @@ static inline void *net_generic(const struct net *net, int id)
 	ptr = ng->ptr[id - 1];
 	rcu_read_unlock();
 
+	BUG_ON(!ptr);
 	return ptr;
 }
 #endif
-- 
1.7.2.5

