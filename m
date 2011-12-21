Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1LUR4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:56:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47001 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1LUR4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:56:40 -0500
Date: Wed, 21 Dec 2011 18:56:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20111221175632.GF17668@somewhere>
References: <20111221034334.GD17668@somewhere>
 <20111221130848.GA19679@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221130848.GA19679@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:08:48PM +0100, Oleg Nesterov wrote:
> On 12/21, Frederic Weisbecker wrote:
> > Hi,
> >
> > Starring at some parts of cgroups, I have a few questions:
> >
> > - Is cgroup_enable_task_cg_list()'s while_each_thread() safe
> > against concurrent exec()? The leader may change in de_thread()
> > and invalidate the test done in while_each_thread().
> 
> Yes. Oh, we need to do something with while_each_thread.

Would something like this work?

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c0c5876..e002a00 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2293,8 +2293,12 @@ extern bool current_is_single_threaded(void);
 #define do_each_thread(g, t) \
 	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
 
-#define while_each_thread(g, t) \
-	while ((t = next_thread(t)) != g)
+#define while_each_thread(g, t)					\
+	while (({						\
+		struct task_struct *__prev = t;			\
+		t = next_thread(t);				\
+		t != __prev && t != g;				\
+	}))
 
 static inline int get_nr_threads(struct task_struct *tsk)
 {
