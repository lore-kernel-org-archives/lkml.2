Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0IWIpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:45:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59162 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab0IWIpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:45:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, <linux-fsdevel@vger.kernel.org>,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
Date: Thu, 23 Sep 2010 01:45:04 -0700
Message-ID: <m1ocborgq7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [ABI REVIEW][PATCH 0/8] Namespace file descriptors
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce file for manipulating namespaces and related syscalls.
files:
/proc/self/ns/<nstype>

syscalls:
int setns(unsigned long nstype, int fd);
socketat(int nsfd, int family, int type, int protocol);

Netlink attribute:
IFLA_NS_FD int fd.

Name space file descriptors address three specific problems that
can make namespaces hard to work with.
- Namespaces require a dedicated process to pin them in memory.
- It is not possible to use a namespace unless you are the child of the
  original creator.
- Namespaces don't have names that userspace can use to talk about them.

Opening of the /proc/self/ns/<nstype> files return a file descriptor
that can be used to talk about a specific namespace, and to keep the
specified namespace alive.

/proc/self/ns/<nstype> can be bind mounted as:
mount --bind /proc/self/ns/net /some/filesystem/path
to keep the namespace alive as long as the mount exists.

setns() as a companion to unshare allows changing the namespace
of the current process, being able to unshare the namespace is
a requirement.

There are two primary envisioned uses for this functionality.
o ``Entering'' an existing container.
o Allowing multiple network namespaces to be in use at once on
  the same machine, without requiring elaborate infrastructure.

Overall this received positive reviews on the containers list but this
needs a wider review of the ABI as this is pretty fundamental kernel
functionality.


I have left out the pid namespaces bits for the moment because the pid
namespace still needs work before it is safe to unshare, and my concern
at the moment is ensuring the system calls seem reasonable.

Eric W. Biederman (8):
      ns: proc files for namespace naming policy.
      ns: Introduce the setns syscall
      ns proc: Add support for the network namespace.
      ns proc: Add support for the uts namespace
      ns proc: Add support for the ipc namespace
      ns proc: Add support for the mount namespace
      net: Allow setting the network namespace by fd
      net: Implement socketat.

---
 fs/namespace.c              |   57 +++++++++++++
 fs/proc/Makefile            |    1 +
 fs/proc/base.c              |   22 +++---
 fs/proc/inode.c             |    7 ++
 fs/proc/internal.h          |   18 ++++
 fs/proc/namespaces.c        |  193 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/if_link.h     |    1 +
 include/linux/proc_fs.h     |   20 +++++
 include/net/net_namespace.h |    1 +
 ipc/namespace.c             |   31 +++++++
 kernel/nsproxy.c            |   39 +++++++++
 kernel/utsname.c            |   32 +++++++
 net/core/net_namespace.c    |   56 +++++++++++++
 net/core/rtnetlink.c        |    4 +-
 net/socket.c                |   26 ++++++-
 15 files changed, 494 insertions(+), 14 deletions(-)

