Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab1LJF3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 00:29:15 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47917 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1LJF3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 00:29:14 -0500
Date: Sat, 10 Dec 2011 05:29:46 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Colin Walters <walters@verbum.org>
Cc: LKML <linux-kernel@vger.kernel.org>, morgan@kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, dhowells@redhat.com,
        kzak@redhat.com
Subject: Re: chroot(2) and bind mounts as non-root
Message-ID: <20111210052945.GA14931@hallyn.com>
References: <1323280461.10724.13.camel@lenny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323280461.10724.13.camel@lenny>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Colin Walters (walters@verbum.org):
>       if (prctl (PR_SET_SECUREBITS,
>                  SECBIT_NOROOT | SECBIT_NOROOT_LOCKED) < 0)
>         fatal_errno ("prctl (SECBIT_NOROOT)");

Sorry, only just saw this now.  Haven't taken too close a look, but a
comment and a few warnings.

First, 	what you are after is an explicit goal of user namespaces:  to
be able to change the environment without risk of fooling privileged
setuid programs with that environment.  And, thereby, to allow unprivileged
users to clone namespaces and, in new namespaces, freely muck with the
resources they own or create.  However, they're not quite usable yet.

So regarding your use of securebits: You are preventing a setuid-root
program from automatically acquiring capabilities, which is a good
start.  However, a setuid-root program will still execute as root (or
a setuid-mysql program as setuid-mysql).  That means it will own
root (or mysql) files while it is running.  That could still be
plenty dangerous.  (With user namespaces, programs running as the
container root will not own files belonging to the host root as they
are different users.)  Second, programs with file capabilities -a
more finegrained alternative to setuid-root - will still run with
privilege.  You could prevent that by not allowing xattrs I suppose.

-serge
