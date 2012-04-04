Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab2DDXM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:12:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44156 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab2DDXM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:12:26 -0400
Date: Wed, 4 Apr 2012 16:12:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/2] IPC: message queue stealing feature introduced
Message-Id: <20120404161224.dea67733.akpm@linux-foundation.org>
In-Reply-To: <20120215165439.27978.43513.stgit@localhost6.localdomain6>
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
	<20120215165439.27978.43513.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 20:54:39 +0400
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> v2:
> 1) compat functions added.
> 2) message slot size in array is now aligned by struct msgbuf_a.
> 3) check for enough free space in buffer before message copying added.
> 4) if MSG_STEAL flag is set, then do_msgrcv() returns number of bytes written
> to buffer.
> 5) flag MSG_NOERROR is ignored if MSG_STEAL flag is set.
> 
> This patch is required for checkpoint/restore in userspace.
> IOW, c/r requires some way to get all pending IPC messages without deleting
> them for the queue (checkpoint can fail and in this case tasks will be resumed,
> so queue have to be valid).
> To achive this, new operation flag MSG_STEAL for sys_msgrcv() system call
> introduced.
> If this flag is set, then passed struct msgbuf pointer will be used for storing
> array of structures:
> 
> struct msgbuf_a {
> 	long mtype;         /* type of message */
> 	int msize;          /* size of message */
> 	char mtext[0];      /* message text */
> };
> 
> each of which will be followed by corresponding message data.
> 

I'd be a bit more comfortable if there was some sign that other c/r
developers have reviewed and tested this and have successfully used it
in c/r operation testing?

We've been trying to isolate the c/r-specific functions inside #ifdef
CONFIG_CHECKPOINT_RESTORE, but this patch doesn't do that.  I have been
encouraging this isolation so that people who aren't using c/r don't
have to carry the overhead it adds and so that we can more easily hunt
down and remove everything if the entire c/r project doesn't work out
successfully.

This patch modifies the sys_msgrcv() API and so we should update the
manpage for that syscall.  Please work with Michael on this.

What does all the compat fiddling actually do?  I guess it's needed for
checkpoint and restore of 32-bit userspace on 64-bit kernels?  Does c/r
as a whole support that?  It should.  How well tested is this?

