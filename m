Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1L0XXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:23:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1L0XXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:23:45 -0500
Date: Tue, 27 Dec 2011 15:23:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-Id: <20111227152344.c8c140d3.akpm@linux-foundation.org>
In-Reply-To: <20111223124920.661126615@openvz.org>
References: <20111223124741.711871189@openvz.org>
	<20111223124920.661126615@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 16:47:42 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> The routine XORs the given pointer with a random value
> producing an ID (32 or 64 bit, depending on the arch).
> 
> Since it's a valuable information -- only CAP_SYS_ADMIN
> is allowed to obtain it.
> 
>  - Tejun worried about the single poison value was a weak side -
>    leaking one makes all the IDs vulnerable. To address this
>    several poison values - one per object type - are introduced.
>    They are stored in a plain array.
>  - Pekka proposed to initialized poison values in the late_initcall callback
>  - ... and move the code to mm/util.c

I'm trying to remember what this is all about, and I don't want to have
to remember all the discussion from last time this came up!

Please, do cover all this in the changelogs: tell us what the code is
all for and try to capture the design decisions thus far.  It's a
useful reminder for current reviewers and is very valuable for new
reviewers.

The root-only restriction sounds like a pretty bad one.  I suspect it
really isn't that bad but again, the changelog should discuss the pros
and cons here.


A thought: if all we're trying to do here is to check for the sameness
of objects, can we push the comparison into the kernel so we don't have
this exporting-sensitive-info problem at all?  Just return a boolean to
userspace?

Something like

int sys_pid_fields_equal(pid_t pid1, pid_t pid2, enum pid_field field_id);

?

For /proc/pid/fdinfo/* userspace can open /proc/pid1/fdinfo/0 and
/proc/pid2/fdinfo/0 and call sys_are_these_files_the_same(fd1, fd2, ...).

Perhaps sys_pid_fields_equal() can use sys_are_these_files_the_same()
as well, if we can think up a way of passing it two fds to represent
the two pids.

Have a think about it ;)
