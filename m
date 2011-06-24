Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1FXHiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 03:38:11 -0400
Received: from natsu.mindrot.org ([116.66.166.108]:27812 "EHLO
	natsu.mindrot.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1FXHiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 03:38:09 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 03:38:08 EDT
Date: Fri, 24 Jun 2011 17:30:46 +1000 (EST)
From: Damien Miller <djm@mindrot.org>
To: Will Drewry <wad@chromium.org>
cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        segoon@openwall.com, kees.cook@canonical.com, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org, fweisbec@gmail.com,
        tglx@linutronix.de, scarybeasts@gmail.com,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Michal Marek <mmarek@suse.cz>, Mike Galbraith <efault@gmx.de>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 03/13] seccomp_filter: new mode with configurable
 syscall filters
In-Reply-To: <1308875813-20122-3-git-send-email-wad@chromium.org>
Message-ID: <alpine.BSO.2.00.1106241723350.15663@natsu.mindrot.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org> <1308875813-20122-3-git-send-email-wad@chromium.org>
User-Agent: Alpine 2.00 (BSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Will Drewry wrote:

> This change adds a new seccomp mode which specifies the allowed system
> calls dynamically.  When in the new mode (2), all system calls are
> checked against process-defined filters - first by system call number,
> then by a filter string.  If an entry exists for a given system call and
> all filter predicates evaluate to true, then the task may proceed.
> Otherwise, the task is killed.

This would be a great help for OpenSSH to improve pre-authentication
privilege separation. We use a separate process that is chroot()ed and
switched to a dedicated UID to limit the effects of compromise in the
complex network-facing code, but a vulnerability in this process
still allows an attacker to open new network sockets (e.g. to proxy
attacks through your firewall) or attempt to exploit local kernel bugs.

If we are able to restrict the syscalls the unprivileged process can make
then it becomes very difficult for an attacker to do anything useful -
they won't be able to open new sockets and a narrow set of available
syscalls makes exploitable kernel bugs much harder to find or reach.

The current SECCOMP sandbox is too restrictive, because we need to
poll/select() on sockets and mmap() to allocate new memory. Allowing
application developers to specify which syscalls are allowed is a
good, low-cost way to make the SECCOMP sandbox much more useful.

-d
