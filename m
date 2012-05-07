Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2EGVv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:51:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53110 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2EGVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:51:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Christoph Hellwig <hch@infradead.org>,
        <linux-fsdevel@vger.kernel.org>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<1336014721.7370.32.camel@marge.simpson.net>
	<1336057018.8119.46.camel@marge.simpson.net>
	<1336105676.7356.42.camel@marge.simpson.net>
	<m1aa1oidmn.fsf@fess.ebiederm.org>
	<1336124716.25479.36.camel@marge.simpson.net>
	<m1vckcdoey.fsf@fess.ebiederm.org>
	<1336142995.25479.49.camel@marge.simpson.net>
	<m1zk9oc61j.fsf@fess.ebiederm.org>
	<1336150643.7502.4.camel@marge.simpson.net>
	<m1fwbfd71h.fsf@fess.ebiederm.org>
	<1336197362.7346.9.camel@marge.simpson.net>
	<1336198093.7346.11.camel@marge.simpson.net>
	<1336201977.7346.22.camel@marge.simpson.net>
Date: Mon, 07 May 2012 14:51:08 -0700
In-Reply-To: <1336201977.7346.22.camel@marge.simpson.net> (Mike Galbraith's
	message of "Sat, 05 May 2012 09:12:57 +0200")
Message-ID: <87r4uv64oj.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+48XCvx4v4yC8gmazCVVvXTU6JowjsANM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: XX
Subject: [PATCH] vfs: Speed up deactivate_super for non-modular filesystems
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently it was observed that a distilled version of vsftp was taking a
surprising amount of time reaping zombies.  A measurement was taken
and vsftp was taking about 4ms (one jiffie) to reap each zombie and
those 4ms were spent spleeping in rcu_barrier in deactivate_locked_super.

The reason vsftp was sleeping in deactivate_locked_super is because
vsftp creates a pid namespace for each connection, and with that
pid namespace comes an internal mount of /proc.  That internal mount
of proc is unmounted when the last process in the pid namespace is
reaped.

/proc and similar non-modular filesystems do not need a rcu_barrier
in deactivate_locked_super.  Being non-modular there is no danger
of the rcu callback running after the module is unloaded.

Therefore do the easy thing and remove 4ms+ from unmount times by only
calling rcu_barrier for modular filesystems in unmount.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index cf00177..c739ef8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -261,7 +261,8 @@ void deactivate_locked_super(struct super_block *s)
 		 * We need to call rcu_barrier so all the delayed rcu free
 		 * inodes are flushed before we release the fs module.
 		 */
-		rcu_barrier();
+		if (fs->owner)
+			rcu_barrier();
 		put_filesystem(fs);
 		put_super(s);
 	} else {
-- 
1.7.5.4

