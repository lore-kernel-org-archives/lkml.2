Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab2HFSi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:38:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49010 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2HFSiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:38:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Ariyasu <jan.ariyasu@hp.com>, Jan Ariyasu <jan.ariyasu@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, Thomas Graf <tgraf@infradead.org>,
        Xi Wang <xi.wang@gmail.com>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
	<87mx27rig7.fsf@xmission.com>
Date: Mon, 06 Aug 2012 11:38:09 -0700
In-Reply-To: <87mx27rig7.fsf@xmission.com> (Eric W. Biederman's message of
	"Mon, 06 Aug 2012 11:20:08 -0700")
Message-ID: <87zk67q31q.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19DChgwhPpJ4X+TJGxuwTb/FFXEmPuj1OQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0168]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH net-next 0/9] sctp: Basic support for network namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The other day I wanted to play around with sctp and did a basic pass to
make sctp per network namespace, so that I could play more conviniently.
Apparently this is an idea who's time has come because Jan Ariyasu also
made a similar set of changes.

I have played around some with these changes and have confirmed that
sctp_test from lksctp-tools works without problems.

Compared to Jan's changes I have per network namespace association and
endpoint hash table lookups, my patch has per network namespace mib
statistics, my changes don't contiain per network namespace tunables
and my patchset only touches about half as many lines as Jan's change.

So for both correctness and simplicity reasons it looks like the
practical way to handle this is to merge my changes and get Jan rebase
his tunable changes on top.

 include/net/net_namespace.h |    4 +
 include/net/netns/sctp.h    |   37 +++++
 include/net/sctp/sctp.h     |   44 +++----
 include/net/sctp/structs.h  |   28 +----
 net/sctp/associola.c        |    9 +-
 net/sctp/bind_addr.c        |   14 +-
 net/sctp/chunk.c            |    2 +-
 net/sctp/endpointola.c      |   12 +-
 net/sctp/input.c            |  109 +++++++++------
 net/sctp/ipv6.c             |   36 +++---
 net/sctp/output.c           |    2 +-
 net/sctp/outqueue.c         |   18 ++-
 net/sctp/proc.c             |   58 +++++---
 net/sctp/protocol.c         |  305 ++++++++++++++++++++++---------------------
 net/sctp/sm_statefuns.c     |  208 ++++++++++++++++++-----------
 net/sctp/socket.c           |   29 +++--
 net/sctp/ulpqueue.c         |   18 ++-
 17 files changed, 533 insertions(+), 400 deletions(-)


Eric W. Biederman (9):
      sctp: Make the port hash table use struct net in it's key.
      sctp: Make the endpoint hashtable handle multiple network namespaces
      sctp: Make the association hashtable handle multiple network namespaces
      sctp: Make the address lists per network namespace
      sctp: Make the ctl_sock per network namespace
      sctp: Move the percpu sockets counter out of sctp_proc_init
      sctp: Make the proc files per network namespace.
      sctp: Enable sctp in all network namespaces
      sctp: Make the mib per network namespace
