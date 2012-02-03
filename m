Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2BCQLl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:11:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab2BCQLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:11:37 -0500
Date: Fri, 3 Feb 2012 17:04:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: Re: cgroup_release_agent() with call_usermodehelper() with
	UMH_WAIT_EXEC may crash
Message-ID: <20120203160454.GA3092@redhat.com>
References: <20120203154411.GB2471@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203154411.GB2471@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Heiko Carstens wrote:
>
> setup_new_exec(...)
> 	[...]
> 	name = bprm->filename;
>
> 	/* Copies the binary name from after last slash */
> 	for (i=0; (ch = *(name++)) != '\0';) {	<-- crashes here
> 		if (ch == '/')

Ough, and this happens after flush_old_exec()...

> Looking into the dump I was able to tell that the piece of memory got freed
> by cgroup_release_agent().
> Which has the following code sequence:
>
> static void cgroup_release_agent(struct work_struct *work)
> {
> 		[...]
> 		agentbuf = kstrdup(cgrp->root->release_agent_path, GFP_KERNEL);
> 		[...]
> 		i = 0;
> 		argv[i++] = agentbuf;
> 		[...]
> 		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> 		[...]
> 		kfree(agentbuf);
> 		[...]
> }
>
> So obviously cgroup_release_agent() freed the filename before do_execve()
> was finished.

Good catch.

> So the question is: what is broken? The cgroup stuff which doesn't take
> into account that the passed path may still be in use and hence can't
> be freed (simple fix would be to simply use UMH_WAIT_PROC instead).
> Or is it that call_usermodehelper() still uses the passed path after
> it returned?

Well, it seems that do_coredump() has the same problem.

Can't we simply move that code into flush_old_exec() ? (wrapped into
the new helper).

Oleg.

