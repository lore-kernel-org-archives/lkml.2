Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0FPW6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:58:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42941 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755024Ab0FPW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:58:24 -0400
Date: Thu, 17 Jun 2010 00:01:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617000120.13071be8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100616221833.GM24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As Linux grows in popularity, it will become a larger target for
> malware. One particularly troubling weakness of the Linux process
> interfaces is that a single user is able to examine the memory and
> running state of any of their processes. For example, if one application

And this will help how - or don't you care about procfs.

> +	/* require ptrace target be a child of ptracer on attach */
> +	if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
> +	    !capable(CAP_SYS_PTRACE)) {
> +		struct task_struct *walker = task;
> +		int rc = 0;
> +
> +		read_lock(&tasklist_lock);
> +		while (walker->pid > 0) {
> +			if (walker == current)
> +				break;
> +			walker = walker->parent;
> +		}
> +		if (walker->pid == 0)
> +			rc = -EPERM;
> +		read_unlock(&tasklist_lock);
> +		if (rc)
> +			return rc;
> +	}


But even if it wasn't pointless this would be the wrong way to do it.

Other distributions do this sensibly by using things like SELinux which
can describe the relationships in ways that matter and also arbitrate
other access paths beyond ptrace which can be used for the same purpose.

And even if you don't care about using the same security stuff the rest
of the world is using to solve the problem this like the other half baked
stuff you posted for links belongs as a security module.

If you'd put it all in security/ubuntu/grsecurity or similar probably
nobody would care too much. The hooks are there so you can do different
things with security policy without making a mess for anyone else.

See ptrace_access_check, ptrace_traceme, and do remember /proc/mem -
which you'll find if you use the proper security hooks is already covered
for you.

So NAK. If you want to use bits of grsecurity then please just write
yourselves a grsecurity kernel module that uses the security hooks
properly and stop messing up the core code. It's all really quite simple,
the infrastrucuture is there, so use it.

Alan

