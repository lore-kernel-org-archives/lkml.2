Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2ALXG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:06:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab2ALXGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:06:54 -0500
Message-ID: <1326409536.9705.4.camel@localhost>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Eric Paris <eparis@redhat.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Andrew Lutomirski <luto@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, djm@mindrot.org,
        segoon@openwall.com, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Date: Thu, 12 Jan 2012 18:05:36 -0500
In-Reply-To: <CAGZ=bq+E3PFm8aZ1eaJaLnHK2dL_nxKBJ_F6MDR-uON+6T-87A@mail.gmail.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	 <1326302710-9427-2-git-send-email-wad@chromium.org>
	 <1326383015.7642.77.camel@gandalf.stny.rr.com>
	 <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com>
	 <1326385635.7642.89.camel@gandalf.stny.rr.com>
	 <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
	 <CAObL_7HE6_NE79tKASQcAxyvCS_7L=vMqfjvZDbCe99pa2t8Wg@mail.gmail.com>
	 <CA+55aFwLoOT-5oRn0k9oErAhTW4hT0_-bMXsn-mf00zcxmHheQ@mail.gmail.com>
	 <CAObL_7GXw8XpVHJrBABUQt9u9pXFDnzUP3nxagS1+g7tPE1kew@mail.gmail.com>
	 <CAGZ=bq+E3PFm8aZ1eaJaLnHK2dL_nxKBJ_F6MDR-uON+6T-87A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 14:08 -0500, Kyle Moffett wrote:
> On Thu, Jan 12, 2012 at 13:44, Andrew Lutomirski <luto@mit.edu> wrote:
> > On Thu, Jan 12, 2012 at 10:32 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> >> You can do any amount of crazy things with selinux, but the other side
> >> of the coin is that it would also be trivial to teach selinux about
> >> this same "restricted environment" bit, and just say that a process
> >> with that bit set doesn't get to match whatever selinux privilege
> >> escalation rules..

> I don't see any issues with SELinux support for this feature.
> 
> Specifically, when you try to execute something in SELinux, it will
> first look at the types and try to "execute" (involving a type
> transition IE: security label change).
> 
> But if that fails in many cases it may still be allowed to
> "execute_no_trans" (IE: regular non-privileged exec() without a
> transition).

That's not true.  See specifically
security/selinux/hooks.c::selinux_bprm_set_creds()  We calculate a label
for the new task (that may or may not be the same) and then check if
there is permission to run the new binary with the new label.  There is
no fallback.

The exception would be if the binary is on a MNT_NOSUID mount point, in
which case we calculate the new label, then just revert to the same
label.

At first glance it looks to me like a reasonable way to implement this
at first would be to do the new checks right next to any place we
already do MNT_NOSUID checks and mimic their behavior.  If there are
other priv escalation points in the kernel we might need to consider if
MNT_NOSUID is adequate....

-Eric

