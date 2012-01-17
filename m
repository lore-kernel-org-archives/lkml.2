Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2AQXzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:55:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35964 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2AQXzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:55:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@MIT.EDU,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from granting privs
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
Date: Tue, 17 Jan 2012 15:57:20 -0800
In-Reply-To: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Thu, 12 Jan 2012 18:12:27 -0800")
Message-ID: <m1pqeh9927.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19XoMx1Ub2ltP0p/YaIx1DFTRRqWyspjoI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> With this set, a lot of dangerous operations (chroot, unshare, etc)
> become a lot less dangerous because there is no possibility of
> subverting privileged binaries.
>
> This patch completely breaks apparmor.  Someone who understands (and
> uses) apparmor should fix it or at least give me a hint.

Foolish implementation question.

Is there a reason why we are putting this in a new field in the task
struct instead of adding a new flag in securebits in struct cred?

It seems to me like putting this information on the task_struct instead
of struct cred will tend to make this frozen state transition less
discoverable for future developers.

Also I would expect if you were applying this policy that you would
to ensure that task->read_cred == task->cred.

Do we want to disable setuid() and it's friends as well?  Certainly
freezing everything at exec is good I'm just wondering if handling
the handful of other cases where we explicitly change the permissions
on a process might be interesting.

My gut says you are trying to implement SECURE_NO_CHANGEPRIVS.

Eric
