Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0FPQIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759195Ab0FPQIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:08:49 -0400
Date: Wed, 16 Jun 2010 18:08:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Message-ID: <20100616160844.GB1893@jolsa.lab.eng.brq.redhat.com>
References: <1276691043-12694-1-git-send-email-jolsa@redhat.com>
 <1276692314.2632.66.camel@edumazet-laptop>
 <20100616125708.GA1893@jolsa.lab.eng.brq.redhat.com>
 <1276693837.2632.75.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276693837.2632.75.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 03:10:37PM +0200, Eric Dumazet wrote:
> Le mercredi 16 juin 2010 à 14:57 +0200, Jiri Olsa a écrit :
> > On Wed, Jun 16, 2010 at 02:45:14PM +0200, Eric Dumazet wrote:
> 
> > > I respectfully suggest that every patch adding a synchronize_rcu() call
> > > be reviewed by Paul himself. This is really the last option that should
> > > be considered, since it adds a big delay.
> > 
> > no problem, I wasn't aware of this
> > 
> > > 
> > > Can you explain why other solutions cannot be used ?
> > 
> > I'm not sure which ones do you mean.. I'm not RCU expert, and
> > this one occured to me as probable fix, but if there're other
> > ways, no problem ;)
> 
> To be fair, I am not RCU expert either, since I make mistakes on each
> RCU related patch I post. Welcome to the club :)
> 
> 

hm,

maybe I have better solution...

I think there's no need to get the cred refference as long as
the 'cred' handling stays inside the rcu_read_lock block.

And the condition 'make sure task doesn't go away', is done
by proc_single_show as this is the proc file.

I tested this succesfully with the reproducer from
https://bugzilla.redhat.com/show_bug.cgi?id=591015#c19

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9b58d38..ac3b3a4 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -176,7 +176,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		if (tracer)
 			tpid = task_pid_nr_ns(tracer, ns);
 	}
-	cred = get_cred((struct cred *) __task_cred(p));
+	cred = __task_cred(p);
 	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
@@ -199,15 +199,14 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"FDSize:\t%d\n"
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
-	rcu_read_unlock();
 
 	group_info = cred->group_info;
 	task_unlock(p);
 
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
 		seq_printf(m, "%d ", GROUP_AT(group_info, g));
-	put_cred(cred);
 
+	rcu_read_unlock();
 	seq_printf(m, "\n");
 }
 
