Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2C0EDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 00:03:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64596 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2C0EDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 00:03:40 -0400
Date: Tue, 27 Mar 2012 01:02:53 -0300
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [REVIEW][PATCH] Making poll generally useful for sysctls
Message-ID: <20120327010253.26e5087f@vader>
In-Reply-To: <CAMOw1v4hZFk20QzvwWUL73Nax2m77HOkfp0KkuOPFjCgYprZgw@mail.gmail.com>
References: <20120313005855.GA24639@redhat.com>
	<CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
	<20120318192755.GB6589@ZenIV.linux.org.uk>
	<CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
	<m1vclw1fx8.fsf@fess.ebiederm.org>
	<CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
	<m1iphuu9pd.fsf_-_@fess.ebiederm.org>
	<CAMOw1v65TePmMOxzGsnW4xv1ge1RDD=Stxgo9-eqtyi8hdjZOQ@mail.gmail.com>
	<m1ty1esa52.fsf@fess.ebiederm.org>
	<CAMOw1v4hZFk20QzvwWUL73Nax2m77HOkfp0KkuOPFjCgYprZgw@mail.gmail.com>
Organization: ProFUSION
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 14:44:50 -0300
Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

> Hi Eric,
> 
> On Sat, Mar 24, 2012 at 4:58 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> > Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
> >
> >>>  /* A sysctl table is an array of struct ctl_table: */
> >>>  struct ctl_table
> >>>  {
> >>>        const char *procname;           /* Text ID for /proc/sys, or zero */
> >>>        void *data;
> >>> +       atomic_t event;
> >>>        int maxlen;
> >>>        umode_t mode;
> >>>        struct ctl_table *child;        /* Deprecated */
> >>>        proc_handler *proc_handler;     /* Callback for text formatting */
> >>> -       struct ctl_table_poll *poll;
> >>>        void *extra1;
> >>>        void *extra2;
> >>>  };
> >>> @@ -1042,6 +1025,7 @@ struct ctl_table_header
> >>>                };
> >>>                struct rcu_head rcu;
> >>>        };
> >>> +       wait_queue_head_t wait;
> >>
> >> If you have a waitqueue per table instead of per entry you will get
> >> spurious notifications when other entries change. The easiest way to
> >> test this is to poll /proc/sys/kernel/hostname and change your
> >> domainname.
> >
> > You will get spurious wakeups but not spurious notifications to
> > userspace since event is still per entry.
> 
> Yeah, indeed.
> 
> > For my money that seemed a nice compromise of code simplicity, and
> > generality.  We could of course do something much closer to what
> > sysfs does and allocate and refcount something similar to your
> > ctl_table_poll when we have a ctl_table opened.  But that just looked
> > like a pain.
> 
> I don't think we want spurious wakeups in favor of a slightly simpler code.
> 
> 
> >
> > Of course we already have spurious notifications for hostname and
> > domainname when multiple uts namespaces are involved, but that
> > is a different problem.
> >
> >> I couldn't apply this patch to any tree (linus/master + my previous
> >> patch, your master, 3.3 + my previous patch), so I couldn't test. On
> >> top of your tree:
> >
> > How odd.  It should have applied cleanly to my tree and it applies
> > with just a two line offset top of Linus's latest with my tree merged
> > in.  Those two lines of offset coming from the two extra includes
> > that came in through the merge.
> >
> > patch -p1 --dry-run <  ~/tmp/sysctl-poll-test.patch
> > patching file fs/proc/proc_sysctl.c
> > Hunk #1 succeeded at 18 (offset 2 lines).
> > Hunk #2 succeeded at 173 (offset 2 lines).
> > Hunk #3 succeeded at 245 (offset 2 lines).
> > Hunk #4 succeeded at 512 (offset 2 lines).
> > Hunk #5 succeeded at 542 (offset 2 lines).
> > Hunk #6 succeeded at 561 (offset 2 lines).
> > patching file include/linux/sysctl.h
> > patching file kernel/utsname_sysctl.c
> >
> >> [lucas@vader kernel]$ git am /tmp/a.patch
> >> Applying: Making poll generally useful for sysctls
> >> error: patch failed: fs/proc/proc_sysctl.c:16
> >> error: fs/proc/proc_sysctl.c: patch does not apply
> >> error: patch failed: include/linux/sysctl.h:992
> >> error: include/linux/sysctl.h: patch does not apply
> >> Patch failed at 0001 Making poll generally useful for sysctls
> >
> > Here is rebased version of the patch just in case that helps.
> 
> Now I can apply, but I can't boot: we hit a NULL dereference in
> __wake_up_common(), called by proc_sys_poll_notify(). It seems that
> you forgot to initialize the waitqueue with
> __WAIT_QUEUE_HEAD_INITIALIZER().

Trying again I came up with the following simple oneliner on top
of your patch. With it I can boot successfully and poll any file
under /proc/sys (I didn't try many, but there's no reason it would not
work).

The nice part of this patch is that suddenly all sysctl entries can be
monitored through poll() instead of having to add adhoc code. However
that spurious wake ups are not very nice. Eric, what if we keep the
waitqueue inside the entry and initialize it there, just like we did
for ->event? This would mean iterating through them on unregister
though.

Lucas De Marchi

--------------------------

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 739615c..85ae957 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -168,6 +168,7 @@ static void init_header(struct ctl_table_header *head,
 	head->set = set;
 	head->parent = NULL;
 	head->node = node;
+	init_waitqueue_head(&head->wait);
 	if (node) {
 		struct ctl_table *entry;
 		for (entry = table; entry->procname; entry++, node++) {
