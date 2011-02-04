Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1BDEhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:37:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46255 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1BDEhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:37:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=B3I5lJbLZsd8cA9JsLQ/Opilrhae5qvxoqjvNnG7vKHztSiiIgmSP8MmDN286ha0+n
         QH/E2b3dfamzdjOQ7at9LQyNFEx8PnA2XGdJGF3vKa+83UdRhAZa6h8iwy8WPhbSRqFi
         MMhLeTQ3jcI7PLihmzVatn1UeiTMFLjz/ui+4=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Octavian Purdila <opurdila@ixiacom.com>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 0/5] net: sysctl: share ipv4/ipv6 sysctl tables
Date: Fri,  4 Feb 2011 06:37:03 +0200
Message-Id: <cover.1296793770.git.lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Each network device gets the same 25/24 sysctl entries for ipv4/ipv6
in /proc/sys/net/ipv4/conf/DEVNAME and /proc/sys/net/ipv6/conf/DEVNAME

Unfortunately, space is wasted holding very much similar data.
Fortunately, with some tricks these entries can be shared between all
network devices.


The single entry in 'struct ctl_table' that was modified at runtime
for leaf ctl_table nodes and prevented sharing was 'parent'. This
field was first introduces for selinux and then was used to implement
sysctl_check_table. Selinux recently removed the need for this field:
* http://thread.gmane.org/gmane.linux.kernel.lsm/12623
* LKML-Reference: 1296519474-15714-1-git-send-email-lucian.grijincu@gmail.com


Remove the need for 'parent' in sysctl_check_table and remove the
'parent' field:

  [PATCH 1/5] sysctl: faster reimplementation of sysctl_check_table
  [PATCH 2/5] sysctl: remove useless ctl_table->parent field


Pave the way for sharing of ipv4/6 tables: allow data to be stored in
the nodes above the leafs that will be shared:

  [PATCH 3/5] sysctl: write ctl_table->extra2 to entries created from ctl_path


Finally share the leaf sysctl tables for ipv4/ipv6:

  [PATCH 4/5] ipv4: share sysctl net/ipv4/conf/DEVNAME/ tables
  [PATCH 5/5] ipv6: share sysctl net/ipv6/conf/DEVNAME/ tables


 fs/proc/proc_sysctl.c       |   16 +++-
 include/linux/inetdevice.h  |   12 +++-
 include/linux/ipv6.h        |   15 +++-
 include/linux/sysctl.h      |    3 +-
 include/net/net_namespace.h |    2 +
 kernel/sysctl.c             |   18 +---
 kernel/sysctl_check.c       |  125 +++++++++++++--------------
 net/ipv4/devinet.c          |  203 ++++++++++++++++++++++++++++--------------
 net/ipv6/addrconf.c         |  192 +++++++++++++++++++++++++++-------------
 net/sysctl_net.c            |   20 +++--
 10 files changed, 387 insertions(+), 219 deletions(-)

-- 
1.7.4.rc1.7.g2cf08.dirty

