Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab1EORAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:00:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1EORAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:00:32 -0400
Date: Sun, 15 May 2011 18:59:45 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Michal Marek <mmarek@suse.cz>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1] igmp: fix ip_mc_clear_src to not reset
 ip_mc_list->sf{mode,count}
Message-ID: <20110515165945.GA20024@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ip_mc_clear_src resets the imc->sfcount and imc->sfmode, without taking into
account the current number of sockets listening on that multicast struct, which
can lead to bogus routes for local listeners.

On NETDEV_DOWN/UP event, if there were 3 multicast listeners for that interface's
address, the imc->sfcount[MCAST_EXCLUDE] will be reset to 1. And after that a
listener socket destroys, multicast traffic will not be delivered to local
listeners because __mkroute_output drops the local flag for the route (by
checking ip_check_mc).

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 1fd3d9c..b14f371 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1775,9 +1775,6 @@ static void ip_mc_clear_src(struct ip_mc_list *pmc)
 		kfree(psf);
 	}
 	pmc->sources = NULL;
-	pmc->sfmode = MCAST_EXCLUDE;
-	pmc->sfcount[MCAST_INCLUDE] = 0;
-	pmc->sfcount[MCAST_EXCLUDE] = 1;
 }
 
 
