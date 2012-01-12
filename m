Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2ALQzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:55:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab2ALQzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:55:14 -0500
Date: Thu, 12 Jan 2012 17:47:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using
	BPF
Message-ID: <20120112164751.GA24802@redhat.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org> <1326302710-9427-2-git-send-email-wad@chromium.org> <1326383015.7642.77.camel@gandalf.stny.rr.com> <20120112161418.GA22360@redhat.com> <1326386324.7642.96.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326386324.7642.96.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Steven Rostedt wrote:
>
> On Thu, 2012-01-12 at 17:14 +0100, Oleg Nesterov wrote:
>
> > May be this needs something like LSM_UNSAFE_SECCOMP, or perhaps
> > cap_bprm_set_creds() should take seccomp.mode == 2 into account, I dunno.
> >
> > OTOH, currently seccomp.mode == 1 doesn't allow to exec at all.
>
> I've never used seccomp, so I admit I'm totally ignorant on this topic.

me too ;)

> But looking at seccomp from the outside, the biggest advantage to this
> would be the ability for normal processes to be able to limit tasks it
> kicks off. If I want to run a task in a sandbox, I don't want to be root
> to do so.
>
> I guess a web browser doesn't perform an exec to run java programs. But
> it would be nice if I could execute something from the command line that
> I could run in a sand box.
>
> What's the problem with making sure that the setuid isn't set before
> doing an execv? Only fail when setuid (or some other magic) is enabled
> on the file being exec'd.

I agree. That is why I mentioned LSM_UNSAFE_SECCOMP/cap_bprm_set_creds.
Just I do not know what would be the most simple/clean way to do this.


And in any case I agree that the current seccomp_check_exec() looks
strange. Btw, it does
{
	if (current->seccomp.mode != 2)
		return 0;
	/* We can rely on the task refcount for the filter. */
	if (!current->seccomp.filter)
		return -EPERM;

How it is possible to have seccomp.filter == NULL with mode == 2?

Oleg.

