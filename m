Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3AIQEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:04:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab3AIQEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:04:40 -0500
Message-ID: <1357747463.2593.28.camel@localhost>
Subject: Friendlier EPERM - Request for input
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org
Cc: dwalsh@redhat.com, dmalcolm@redhat.com
Date: Wed, 09 Jan 2013 11:04:23 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Getting an EPERM/EACCES in userspace really kinda blows.  As a user you
don't have any idea why you got it.  It could be SELinux, it could be
rwx bits on the file, it could be a missing capability, it could be an
ACL, it could be who knows what.  We'd like to start figuring out the
who knows what and hopefully find a way to expose that to userspace.  My
initial thought is a small buffer in the task struct in which the kernel
can dump some data when it is going to send back an EPERM.  I was
thinking of exposing that data via a /proc/self/task/[tid]/file which
userspace could poll after an EPERM.  The hope would be to all userspace
a better understanding of why it failed.  Wouldn't it be nice if instead
of httpd log just saying 'permission denied' it would be able to say
'permision denied because the file was 640"?

I was thinking this buffer would look something like (very pseudo codie)

struct friendly_response {
        enum { NONE, CAPABILITIES, SELINUX, FILE_PERMS } type;
        union {
                struct capabilities {
                        int cap;
                };
                struct selinux {
                        __u32 source_label
                        __u32 target_label
                        __u32 operation;
                        __u32 tclass;
                };
                struct file_perms {
                        int uid;
                        int gid;
                        int file_uid;
                        int file_gid;
                        int file_mode;
                };
        };
};

The idea being that the buffer should only hold stateless data which can
be overwritten or destroyed on the next EPERM.  Reading the proc file
could then translate that into something a little more useful, but
hopefully still computer friendly enough that it can be translated and
useful to a user/developer.  So after a denial from file permissions the
proc file would return a string like:

3 500 500 0 0 0640
^  ^   ^  ^ ^  ^--- Mode
|  |   |  | |--- File Gid
|  |   |  |---File Uid
|  |   |--- User Gid
|  |---User Uid
|--- Type for failure (file perms)

Or from SELinux:

2 unconfined_u:unconfined_r:unconfined_t:s0 system_u:system_r:system_t:s0 { read } file

This would take patching hundreds of call sites in the kernel to fill
the buffer.  But just getting extended denial information in a couple of
the hot spots would be a huge win.  Put it in capable(), LSM hooks, the
open() syscall and path walk code.

It was pointed out that this isn't perfect, and I'm well aware of that.
Lots of userspace libraries do things like save errno, make other kernel
calls which could overwrite the buffer, then pass errno up the stack.  I
don't believe there is much that can done about that.  Other than
userspace trying to save the extended error information as well?

One suggestion was to make it a ring buffer of some configurable size
instead.  I'm not sure how a program could find the 'right' message in
the ring buffer, but it is a thought to help the problem of intervening
kernel calls overwriting the last extended error info.  I was pointed to
the win32 api for getLastError() as something to look at.  This API is
mostly like errno/strerror in libc, except without the easy ability to
save it for later.  My new proposed API would have the same problems.
No 'easy' way to save it for later.  (also getLastError() doesn't pass
any kind of extended information, so it seems to solve a different
problem and I haven't seen any OS that is doing this, so point me to
places I can learn)

Another thought was that some people might want to turn off the ability
to get this information.  I don't see a reason a sysctl couldn't be used
to disable extended errno information if the admin so chose.

But maybe those great minds on the lists can help me think of ways to
get Friendlier denials that I haven't thought of.  Please.  What are you
thoughts, concerns, issues?

-Eric

