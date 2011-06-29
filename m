Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1F2B2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 21:28:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35595 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1F2B1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 21:27:55 -0400
MIME-Version: 1.0
In-Reply-To: <1308917362-4795-1-git-send-email-segoon@openwall.com>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
Date: Wed, 29 Jun 2011 06:57:55 +0530
Message-ID: <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
Subject: Re: [PATCH 2/2] taskstats: restrict access to user
From: Balbir Singh <bsingharora@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 5:39 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> taskstats information may be used for gathering private information.
> E.g. for openssh and vsftpd daemons read_characters/write_characters may
> be used to learn the precise password length.  Restrict it to processes
> being able to ptrace the target process.
>
> For TASKSTATS_CMD_ATTR_REGISTER_CPUMASK the fix is euid check instead of
> a ptrace check as the handler is processed in the context of the target
> process, not the listener process'.  When ptrace_task_may_access_current()
> is introduced, it should be used instead of euid check.  Currently there
> is a small race when a process temporarily changes its euid (e.g. to
> access user's files), until the process sets euid back user's processes
> may gather privileged process' statistics.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  kernel/taskstats.c |   23 ++++++++++++++++++++++-
>  1 files changed, 22 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 9ffea36..d92c95a 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -27,6 +27,7 @@
>  #include <linux/cgroup.h>
>  #include <linux/fs.h>
>  #include <linux/file.h>
> +#include <linux/ptrace.h>
>  #include <net/genetlink.h>
>  #include <asm/atomic.h>
>
> @@ -132,6 +133,8 @@ static void send_cpu_listeners(struct sk_buff *skb,
>        struct sk_buff *skb_next, *skb_cur = skb;
>        void *reply = genlmsg_data(genlhdr);
>        int rc, delcount = 0;
> +       const struct cred *cred = current_cred();
> +       struct task_struct *task;
>
>        rc = genlmsg_end(skb, reply);
>        if (rc < 0) {
> @@ -142,6 +145,15 @@ static void send_cpu_listeners(struct sk_buff *skb,
>        rc = 0;
>        down_read(&listeners->sem);

Why not grab RCU lock here

>        list_for_each_entry(s, &listeners->list, list) {
> +
> +               rcu_read_lock();

You'll end up grabbing RCU read lock too often here, do you need to?

> +               task = find_task_by_vpid(s->pid);
> +               if (!task || __task_cred(task)->euid != cred->euid) {
> +                       rcu_read_unlock();
> +                       continue;
> +               }
> +               rcu_read_unlock();
> +

Release the lock prior to up_read()

>                skb_next = NULL;
>                if (!list_is_last(&s->list, &listeners->list)) {
>                        skb_next = skb_clone(skb_cur, GFP_KERNEL);
> @@ -199,14 +211,19 @@ static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
>  static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
>  {
>        struct task_struct *tsk;
> +       int rc = -ESRCH;
>
>        rcu_read_lock();
>        tsk = find_task_by_vpid(pid);
> +       if (tsk && !ptrace_may_access(tsk, PTRACE_MODE_READ)) {
> +               tsk = NULL;
> +               rc = -EACCES;
> +       }
>        if (tsk)
>                get_task_struct(tsk);
>        rcu_read_unlock();
>        if (!tsk)
> -               return -ESRCH;
> +               return rc;
>        fill_stats(tsk, stats);
>        put_task_struct(tsk);
>        return 0;
> @@ -224,6 +241,10 @@ static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
>         */
>        rcu_read_lock();
>        first = find_task_by_vpid(tgid);
> +       if (first && !ptrace_may_access(first, PTRACE_MODE_READ)) {
> +               rc = -EACCES;
> +               goto out;
> +       }
>
>        if (!first || !lock_task_sighand(first, &flags))
>                goto out;

Balbir Singh
