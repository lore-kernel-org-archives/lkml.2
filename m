Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2DDXu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:50:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37116 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2DDXuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:50:24 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120404161224.dea67733.akpm@linux-foundation.org>
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
 <20120215165439.27978.43513.stgit@localhost6.localdomain6> <20120404161224.dea67733.akpm@linux-foundation.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 5 Apr 2012 11:50:03 +1200
Message-ID: <CAKgNAkjpWpHR9Ww0JzZqsACktXzsm9r8=k6e7CJF_9+5cWdJBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] IPC: message queue stealing feature introduced
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        serge.hallyn@canonical.com, criu@openvz.org,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, dhowells@redhat.com,
        Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 11:12 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 15 Feb 2012 20:54:39 +0400
> Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

Stanislav,

Luckily, Andrew added me to CC. However, as noted in
Documentation/SubmitChecklist, all patches that change the ABI/API
should CC linux-api@vger.kernel.org. Please do that for the future.
(CC added for this thread.)

>> v2:
>> 1) compat functions added.
>> 2) message slot size in array is now aligned by struct msgbuf_a.
>> 3) check for enough free space in buffer before message copying added.
>> 4) if MSG_STEAL flag is set, then do_msgrcv() returns number of bytes written
>> to buffer.

By the way, why the name "MSG_STEAL"? At first glance, it sounds like
that means we're taking messages that belong to someone else. But I
gather you are in fact just flushing all messages from a queue. So I
more intuitive name seems to be in order (MSG_READ_ALL,
MSG_FLUSH_ALL?).

>> 5) flag MSG_NOERROR is ignored if MSG_STEAL flag is set.

Would it not be better to return an error if MSG_NOERROR is specified?

>> This patch is required for checkpoint/restore in userspace.
>> IOW, c/r requires some way to get all pending IPC messages without deleting
>> them for the queue (checkpoint can fail and in this case tasks will be resumed,
>> so queue have to be valid).
>> To achive this, new operation flag MSG_STEAL for sys_msgrcv() system call
>> introduced.
>> If this flag is set, then passed struct msgbuf pointer will be used for storing
>> array of structures:
>>
>> struct msgbuf_a {
>>       long mtype;         /* type of message */
>>       int msize;          /* size of message */
>>       char mtext[0];      /* message text */
>> };

So, I'm not clear on how things look here. We get back array like this:

[0]                     [1]                     [2]
| mtype | msize | mtext | mtype | msize | mtext | ...

How do I calculate the offset of element 1 of the array? I assume it
can't be just
(&item[0].mtext + msize), since there'll be alignment issues to deal
with, so that there are padding bytes after each mtext. In that case,
msize on its own seems insufficient (since there is no null-terminator
in msize).

>> each of which will be followed by corresponding message data.
>>
>
> I'd be a bit more comfortable if there was some sign that other c/r
> developers have reviewed and tested this and have successfully used it
> in c/r operation testing?

Indeed, do you have a userspace test program that you could post?

> We've been trying to isolate the c/r-specific functions inside #ifdef
> CONFIG_CHECKPOINT_RESTORE, but this patch doesn't do that.  I have been
> encouraging this isolation so that people who aren't using c/r don't
> have to carry the overhead it adds and so that we can more easily hunt
> down and remove everything if the entire c/r project doesn't work out
> successfully.
>
> This patch modifies the sys_msgrcv() API and so we should update the
> manpage for that syscall.  Please work with Michael on this.

Yes please.

Cheers,

Michael


> What does all the compat fiddling actually do?  I guess it's needed for
> checkpoint and restore of 32-bit userspace on 64-bit kernels?  Does c/r
> as a whole support that?  It should.  How well tested is this?
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
