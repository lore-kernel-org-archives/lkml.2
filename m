Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2ALXeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:34:12 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60956 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756038Ab2ALXeJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:34:09 -0500
MIME-Version: 1.0
In-Reply-To: <1326409536.9705.4.camel@localhost>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
 <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com>
 <CAObL_7GVo8rH=Knv=t5VtJG24m7tY9MhNf9QNah+8G9oYiXo6g@mail.gmail.com>
 <1326385635.7642.89.camel@gandalf.stny.rr.com> <CA+55aFw2yigXqfiKMH4aZ9w8dOkAEB0cZ2m4ZUEhiddnrQuueg@mail.gmail.com>
 <CAObL_7HE6_NE79tKASQcAxyvCS_7L=vMqfjvZDbCe99pa2t8Wg@mail.gmail.com>
 <CA+55aFwLoOT-5oRn0k9oErAhTW4hT0_-bMXsn-mf00zcxmHheQ@mail.gmail.com>
 <CAObL_7GXw8XpVHJrBABUQt9u9pXFDnzUP3nxagS1+g7tPE1kew@mail.gmail.com>
 <CAGZ=bq+E3PFm8aZ1eaJaLnHK2dL_nxKBJ_F6MDR-uON+6T-87A@mail.gmail.com> <1326409536.9705.4.camel@localhost>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 12 Jan 2012 15:33:47 -0800
X-Google-Sender-Auth: A-bueLs8J9-6zwNVc6crd2RSWSo
Message-ID: <CAObL_7HbL-+613aALTb2g1RSaYqhZ6tAX-Oaj5Dhw9eZry=mew@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
To: Eric Paris <eparis@redhat.com>
Cc: Kyle Moffett <kyle@moffetthome.net>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 3:05 PM, Eric Paris <eparis@redhat.com> wrote:
> On Thu, 2012-01-12 at 14:08 -0500, Kyle Moffett wrote:
>> On Thu, Jan 12, 2012 at 13:44, Andrew Lutomirski <luto@mit.edu> wrote:
>> > On Thu, Jan 12, 2012 at 10:32 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> >> You can do any amount of crazy things with selinux, but the other side
>> >> of the coin is that it would also be trivial to teach selinux about
>> >> this same "restricted environment" bit, and just say that a process
>> >> with that bit set doesn't get to match whatever selinux privilege
>> >> escalation rules..
>
>> I don't see any issues with SELinux support for this feature.
>>
>> Specifically, when you try to execute something in SELinux, it will
>> first look at the types and try to "execute" (involving a type
>> transition IE: security label change).
>>
>> But if that fails in many cases it may still be allowed to
>> "execute_no_trans" (IE: regular non-privileged exec() without a
>> transition).
>
> That's not true.  See specifically
> security/selinux/hooks.c::selinux_bprm_set_creds()  We calculate a label
> for the new task (that may or may not be the same) and then check if
> there is permission to run the new binary with the new label.  There is
> no fallback.
>
> The exception would be if the binary is on a MNT_NOSUID mount point, in
> which case we calculate the new label, then just revert to the same
> label.
>
> At first glance it looks to me like a reasonable way to implement this
> at first would be to do the new checks right next to any place we
> already do MNT_NOSUID checks and mimic their behavior.  If there are
> other priv escalation points in the kernel we might need to consider if
> MNT_NOSUID is adequate....
>

I don't really like the current logic.  It does:

        if (old_tsec->exec_sid) {
                new_tsec->sid = old_tsec->exec_sid;
                /* Reset exec SID on execve. */
                new_tsec->exec_sid = 0;
        } else {
                /* Check for a default transition on this program. */
                rc = security_transition_sid(old_tsec->sid, isec->sid,
                                             SECCLASS_PROCESS, NULL,
                                             &new_tsec->sid);
                if (rc)
                        return rc;
        }

        COMMON_AUDIT_DATA_INIT(&ad, PATH);
        ad.u.path = bprm->file->f_path;

        if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
                new_tsec->sid = old_tsec->sid;

which means that, if MNT_NOSUD, then exec_sid is silently ignored.
I'd rather fail in that case, but it's probably too late for that.
However, if we set the "no new privileges" flag, then we could fail,
since there's no old ABI to be compatible with.  I'll implement it
that way.

--Andy
