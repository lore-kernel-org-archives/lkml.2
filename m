Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1BYSxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:53:06 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41821 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab1BYSxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=UH4YtfzHY+oM3VyENs/jfJwJeSR6kpWC2+6KqO5/WP3ue0RBZEMc1d9wmL4ccZfSvX
         T6jBiYflUYArwjFHxP0EUKQNLFzmQIFTU6234zIn/qCKqlqV5KcaUM9VrGLtKCJ52am7
         QyouhmBdAXj72W/1sfIcieqdp2RpfrIqMP7f8=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Octavian Purdila <tavi@cs.pub.ro>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RFC v1: sysctl: add sysctl header cookie, share tables between nets
Date: Fri, 25 Feb 2011 20:52:32 +0200
Message-Id: <1298659961-23863-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new approach to the "share sysctl tables" RFC series I
posted earlier this month.

In previous patches I proposed deriving 'struct net*' from the parent
ctl_entry's ->extra1 field, but that has seen opposition due to mixing
in information from the dentry cache/fs layers.

In this version, the clt_table_header is extended to hold a cookie at
creation time and pass it to the handlers. By default every
ctl_table_header that is netns specific will store the 'struct net*'
in the cookie.

I could go on with the patch series and share other ctl_tables between
network namespace in the same manner, but I stopped here to not waste
time on a solution that you do not consider applying for reasons I
don't see now.

If you like this, I'll post a full patch series:
* change proc_handler to accept a cookie
* change all proc_handler functions in the kernel to accept a cookie
* apply sysctl table sharing to other tables. Candidates would be:
  nf_conntrack_acct_init_sysctl, nf_conntrack_standalone_init_sysctl,
  unix_sysctl_register, but there may be others I'm not seeing now.

This series is against Linus's 2.6.38-rc6 (plus a few other patches).


 fs/proc/proc_sysctl.c       |   11 +++++++-
 include/linux/sysctl.h      |    8 +++++-
 include/net/ipv6.h          |    6 +---
 include/net/net_namespace.h |   26 ++++++++++++++++++
 kernel/sysctl.c             |   12 +++++---
 net/core/sysctl_net_core.c  |   28 ++-----------------
 net/ipv4/ip_fragment.c      |   34 ++++-------------------
 net/ipv4/route.c            |   36 +++++--------------------
 net/ipv4/sysctl_net_ipv4.c  |   53 ++++++-------------------------------
 net/ipv6/icmp.c             |   17 +----------
 net/ipv6/reassembly.c       |   34 ++++-------------------
 net/ipv6/route.c            |   54 ++++++++++---------------------------
 net/ipv6/sysctl_net_ipv6.c  |   61 +++++-------------------------------------
 net/sysctl_net.c            |   37 ++++++++++++++++++++++++--
 14 files changed, 143 insertions(+), 274 deletions(-)


 * [PATCH 1/9] sysctl: add ctl_header_cookie
 * [PATCH 2/9] sysctl: use ctl_header_cookie in proc_handler
 * [PATCH 3/9] sysctl: add netns_proc_dointvec and similar handlers
 * [PATCH 4/9] sysctl: ipv4: ipfrag: share ip4_frags_ns_ctl_table between nets
 * [PATCH 5/9] sysctl: net: share netns_core_table between nets
 * [PATCH 6/9] sysctl: route: share ipv4_route_flush_table between nets
 * [PATCH 7/9] sysctl: ipv4: share ipv4_net_table between nets
 * [PATCH 8/9] sysctl: ipv6: share ip6_frags_ns_ctl_table between nets
 * [PATCH 9/9] sysctl: ipv6: share ip6_ctl_table, ipv6_icmp_table and ipv6_route_table between nets
