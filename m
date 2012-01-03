Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2ACWhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:37:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab2ACWhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:36 2012
Message-Id: <20120103223036.304670426@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Weiping Pan <panweiping3@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [59/67] ipv4: flush route cache after change accept_local
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Weiping Pan <panweiping3@gmail.com>

[ Upstream commit d01ff0a049f749e0bf10a35bb23edd012718c8c2 ]

After reset ipv4_devconf->data[IPV4_DEVCONF_ACCEPT_LOCAL] to 0,
we should flush route cache, or it will continue receive packets with local
source address, which should be dropped.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/devinet.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1490,7 +1490,9 @@ static int devinet_conf_proc(ctl_table *
 			     void __user *buffer,
 			     size_t *lenp, loff_t *ppos)
 {
+	int old_value = *(int *)ctl->data;
 	int ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
+	int new_value = *(int *)ctl->data;
 
 	if (write) {
 		struct ipv4_devconf *cnf = ctl->extra1;
@@ -1501,6 +1503,9 @@ static int devinet_conf_proc(ctl_table *
 
 		if (cnf == net->ipv4.devconf_dflt)
 			devinet_copy_dflt_conf(net, i);
+		if (i == IPV4_DEVCONF_ACCEPT_LOCAL - 1)
+			if ((new_value == 0) && (old_value != 0))
+				rt_cache_flush(net, 0);
 	}
 
 	return ret;


