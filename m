Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2K1TbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:31:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab2K1TbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:31:05 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>,
        linux-audit@redhat.com
Subject: Re: [PATCH] audit: create explicit AUDIT_SECCOMP event type
Date: Wed, 28 Nov 2012 14:30:45 -0500
Message-ID: <1922872.TCpz1FzEvS@x2>
Organization: Red Hat
User-Agent: KMail/4.9.3 (Linux/3.6.7-4.fc17.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAGXu5j+Fj_MfdaoRx9-VE6hgZ7h5u8OokqGhJUqK-FyOpKfPAA@mail.gmail.com>
References: <20121119215653.GA12715@www.outflux.net> <2424177.54a8UTzN38@x2> <CAGXu5j+Fj_MfdaoRx9-VE6hgZ7h5u8OokqGhJUqK-FyOpKfPAA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 09:45:56 AM Kees Cook wrote:
> On Mon, Nov 26, 2012 at 6:14 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> > On Monday, November 19, 2012 01:56:53 PM Kees Cook wrote:
> >> The seccomp path was using AUDIT_ANOM_ABEND from when seccomp mode 1
> >> could only kill a process. While we still want to make sure an audit
> >> record is forced on a kill, this should use a separate record type since
> >> seccomp mode 2 introduces other behaviors. In the case of "handled"
> >> behaviors (process wasn't killed), only emit a record if the process is
> >> under inspection.
> > 
> > Under the old record type, we know that the process is being terminated.
> > Therefore the meaning of the action is known as its implicit in the record
> > type. With this new type, we need to record what behavior is being
> > enforced on the process. I don't see where that is being recorded.
> 
> The action is encoded in the "code=". If one is doing seccomp
> auditing, this code will be meaningful already.
> 
> > Could we add that?
> 
> I'd rather not expand the code into the separate meanings if we don't
> have to. It's part of the BPF already, so it's useful to leave it
> as-is, IMO.

Support for this has been added in the user space utilities. This event type 
switch actually fixes a problem where the seccomp use of AUDIT_ANOM_ABEND makes 
it malformed because it has different fields. This could be pushed into stable 
(after testing) in my opinion since it corrects a problem.

ack: Steve Grubb <sgrubb@redhat.com>



> >> Cc: Julien Tinnes <jln@google.com>
> >> Cc: Will Drewry <wad@google.com>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >> 
> >>  include/linux/audit.h      |    3 ++-
> >>  include/uapi/linux/audit.h |    1 +
> >>  kernel/auditsc.c           |   14 +++++++++++---
> >>  3 files changed, 14 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/include/linux/audit.h b/include/linux/audit.h
> >> index bce729a..9d5104d 100644
> >> --- a/include/linux/audit.h
> >> +++ b/include/linux/audit.h
> >> @@ -157,7 +157,8 @@ void audit_core_dumps(long signr);
> >> 
> >>  static inline void audit_seccomp(unsigned long syscall, long signr, int
> >> 
> >> code) {
> >> -     if (unlikely(!audit_dummy_context()))
> >> +     /* Force a record to be reported if a signal was delivered. */
> >> +     if (signr || unlikely(!audit_dummy_context()))
> >> 
> >>               __audit_seccomp(syscall, signr, code);
> >>  
> >>  }
> >> 
> >> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> >> index 76352ac..09a2d94 100644
> >> --- a/include/uapi/linux/audit.h
> >> +++ b/include/uapi/linux/audit.h
> >> @@ -106,6 +106,7 @@
> >> 
> >>  #define AUDIT_MMAP           1323    /* Record showing descriptor and
> >>  flags in> 
> > mmap */
> > 
> >>  #define AUDIT_NETFILTER_PKT  1324    /* Packets traversing netfilter
> >>  chains
> > 
> > */
> > 
> >>  #define AUDIT_NETFILTER_CFG  1325    /* Netfilter chain modifications */
> >> 
> >> +#define AUDIT_SECCOMP                1326    /* Secure Computing event
> >> */
> >> 
> >>  #define AUDIT_AVC            1400    /* SE Linux avc denial or grant */
> >>  #define AUDIT_SELINUX_ERR    1401    /* Internal SE Linux Errors */
> >> 
> >> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> >> index 2f186ed..157e989 100644
> >> --- a/kernel/auditsc.c
> >> +++ b/kernel/auditsc.c
> >> @@ -2735,7 +2735,7 @@ void __audit_mmap_fd(int fd, int flags)
> >> 
> >>       context->type = AUDIT_MMAP;
> >>  
> >>  }
> >> 
> >> -static void audit_log_abend(struct audit_buffer *ab, char *reason, long
> >> signr) +static void audit_log_task(struct audit_buffer *ab)
> >> 
> >>  {
> >>  
> >>       kuid_t auid, uid;
> >>       kgid_t gid;
> >> 
> >> @@ -2753,6 +2753,11 @@ static void audit_log_abend(struct audit_buffer
> >> *ab,
> >> char *reason, long signr) audit_log_task_context(ab);
> >> 
> >>       audit_log_format(ab, " pid=%d comm=", current->pid);
> >>       audit_log_untrustedstring(ab, current->comm);
> >> 
> >> +}
> >> +
> >> +static void audit_log_abend(struct audit_buffer *ab, char *reason, long
> >> signr) +{
> >> +     audit_log_task(ab);
> >> 
> >>       audit_log_format(ab, " reason=");
> >>       audit_log_string(ab, reason);
> >>       audit_log_format(ab, " sig=%ld", signr);
> >> 
> >> @@ -2783,8 +2788,11 @@ void __audit_seccomp(unsigned long syscall, long
> >> signr, int code) {
> >> 
> >>       struct audit_buffer *ab;
> >> 
> >> -     ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_ANOM_ABEND);
> >> -     audit_log_abend(ab, "seccomp", signr);
> >> +     ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
> >> +     if (unlikely(!ab))
> >> +             return;
> >> +     audit_log_task(ab);
> >> +     audit_log_format(ab, " sig=%ld", signr);
> >> 
> >>       audit_log_format(ab, " syscall=%ld", syscall);
> >>       audit_log_format(ab, " compat=%d", is_compat_task());
> >>       audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
