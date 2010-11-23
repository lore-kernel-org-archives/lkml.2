Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0KWHSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:18:54 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36525 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0KWHQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:16:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Ted Ts'o" <tytso@mit.edu>, Minchan Kim <minchan.kim@gmail.com>,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [BUG?] [Ext4] INFO: suspicious rcu_dereference_check() usage
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20101121173726.GG23423@thunk.org>
References: <20101121153949.GD20947@barrios-desktop> <20101121173726.GG23423@thunk.org>
Message-Id: <20101122174516.E24A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 16:16:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 22, 2010 at 12:39:49AM +0900, Minchan Kim wrote:
> > 
> > I think it's no problem. 
> > 
> > That's because migration always holds lock_page on the file page.
> > So the page couldn't remove from radix. 
> 
> It may be "ok" in that it won't cause a race, but it still leaves an
> unsightly warning if LOCKDEP is enabled, and LOCKDEP warnings will
> cause /proc_lock_stat to be disabled.  So I think it still needs to be
> fixed by adding rcu_read_lock()/rcu_read_unlock() to
> migrate_page_move_mapping().

Hi Ted,

Current mmotm has following patch and I think it should be fixed your
issue.

Thanks.




From: Zeng Zhaoming <zengzm.kernel@gmail.com>

find_task_by_vpid() should be protected by rcu_read_lock(), to prevent
free_pid() reclaiming pid.

Signed-off-by: Zeng Zhaoming <zengzm.kernel@gmail.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/mempolicy.c~mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-add-rcu-read-lock-to-protect-pid-structure
+++ a/mm/mempolicy.c
@@ -1307,15 +1307,18 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
                goto out;

        /* Find the mm_struct */
+       rcu_read_lock();
        read_lock(&tasklist_lock);
        task = pid ? find_task_by_vpid(pid) : current;
        if (!task) {
                read_unlock(&tasklist_lock);
+               rcu_read_unlock();
                err = -ESRCH;
                goto out;
        }
        mm = get_task_mm(task);
        read_unlock(&tasklist_lock);
+       rcu_read_unlock();


