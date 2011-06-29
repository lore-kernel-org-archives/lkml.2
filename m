Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1F2LmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:42:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48773 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1F2LmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:42:19 -0400
Date: Wed, 29 Jun 2011 15:42:11 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Subject: Re: [PATCH 2/2] taskstats: restrict access to user
Message-ID: <20110629114211.GA29701@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 06:57 +0530, Balbir Singh wrote:
> On Fri, Jun 24, 2011 at 5:39 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > taskstats information may be used for gathering private information.
> > E.g. for openssh and vsftpd daemons read_characters/write_characters may
> > be used to learn the precise password length.  Restrict it to processes
> > being able to ptrace the target process.
> >
> > For TASKSTATS_CMD_ATTR_REGISTER_CPUMASK the fix is euid check instead of
> > a ptrace check as the handler is processed in the context of the target
> > process, not the listener process'.  When ptrace_task_may_access_current()
> > is introduced, it should be used instead of euid check.  Currently there
> > is a small race when a process temporarily changes its euid (e.g. to
> > access user's files), until the process sets euid back user's processes
> > may gather privileged process' statistics.
> >
> > Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> > ---
> >  kernel/taskstats.c |   23 ++++++++++++++++++++++-
> >  1 files changed, 22 insertions(+), 1 deletions(-)
> >
> > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > index 9ffea36..d92c95a 100644
> > --- a/kernel/taskstats.c
> > +++ b/kernel/taskstats.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/cgroup.h>
> >  #include <linux/fs.h>
> >  #include <linux/file.h>
> > +#include <linux/ptrace.h>
> >  #include <net/genetlink.h>
> >  #include <asm/atomic.h>
> >
> > @@ -132,6 +133,8 @@ static void send_cpu_listeners(struct sk_buff *skb,
> >        struct sk_buff *skb_next, *skb_cur = skb;
> >        void *reply = genlmsg_data(genlhdr);
> >        int rc, delcount = 0;
> > +       const struct cred *cred = current_cred();
> > +       struct task_struct *task;
> >
> >        rc = genlmsg_end(skb, reply);
> >        if (rc < 0) {
> > @@ -142,6 +145,15 @@ static void send_cpu_listeners(struct sk_buff *skb,
> >        rc = 0;
> >        down_read(&listeners->sem);
> 
> Why not grab RCU lock here

Yes, it makes sense.  I was thinking about not holding a lock for a too
long time, but it should be rather cheap anyway.


Thank you,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
