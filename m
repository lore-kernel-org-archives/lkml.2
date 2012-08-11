Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2HKLVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 07:21:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54776 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2HKLU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 07:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120810142602.12411.63440.stgit@localhost6.localdomain6>
References: <20120810141517.12411.83398.stgit@localhost6.localdomain6>
	<20120810142602.12411.63440.stgit@localhost6.localdomain6>
Date: Sat, 11 Aug 2012 13:20:58 +0200
Message-ID: <CALgW_8X_gSDG0GdoU4WShohsyhdXOXTh8o9KsYPFtnkzcJXpCQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] IPC: message queue copy feature introduced
From: Manfred Spraul <manfred@colorfullife.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, eparis@parisplace.org, a.p.zijlstra@chello.nl,
        arnd@arndb.de, hughd@google.com, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, yeohc@au1.ibm.com,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, casey@schaufler-ca.com,
        sds@tycho.nsa.govjames.l.morris, devel@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislav,

2012/8/10 Stanislav Kinsbursky <skinsbursky@parallels.com>:
> This patch is required for checkpoint/restore in userspace.
> IOW, c/r requires some way to get all pending IPC messages without deleting
> them from the queue (checkpoint can fail and in this case tasks will be resumed,
> so queue have to be valid).
> To achive this, new operation flag MSG_COPY for sys_msgrcv() system call was
> introduced. Also, copy counter was added to msg_queue structure. It's set to
> zero by default and increases by one on each copy operation and decreased by
> one on each receive operation until reaches zero.

Is msq->q_copy_cnt really necessary?
As far as I can see user space needs the ability to read the n-th message.

The implementation adds a state variable to the kernel, adds two
automatic updates of the state into msgrcv() (an increase during
MSG_COPY, a decrease during normal receives) and adds a msgctl() to
set the state to a certain value.

a) What about the simpler approach:
- if MSG_COPY is set, then @mtype is interpreted as the number of the
message that should be copied.
  If there are less than @mtype messages, then -ENOMSG is returned.

b) I do not understand the purpose of the decrease of msq->q_copy_cnt:
Do you want to handle normal msgrcv() calls in parallel with
msgrcv(|MSG_COPY) calls?
I don't think that this will work:
What if msq->q_copy_cnt is 1 and and msgrcv() call receives the 20th
message in the queue?

--
  Manfred
