Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab1LLQlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:41:52 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58645 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab1LLQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:41:49 -0500
X-Sasl-enc: 4szgDI7DBQ2SeENrzZdAyUmFeg0tSY/f6Nc3aTo5vfB8 1323708108
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        morgan@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        luto@mit.edu, kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
Date: Mon, 12 Dec 2011 11:41:28 -0500
In-Reply-To: <20111210052945.GA14931@hallyn.com>
References: <1323280461.10724.13.camel@lenny>
	 <20111210052945.GA14931@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323708089.29338.39.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-10 at 05:29 +0000, Serge E. Hallyn wrote:

> First, 	what you are after is an explicit goal of user namespaces:  to
> be able to change the environment without risk of fooling privileged
> setuid programs with that environment. 

Hmm...so I looked at the user namespace stuff
( https://wiki.ubuntu.com/UserNamespace ) and it kind of scares me in
terms of complexity.  I think I understand the intersection of cgroups,
capabilities, and SELinux as they are today; this would be a whole new
set of options.  But that's an aside.

>  And, thereby, to allow unprivileged
> users to clone namespaces and, in new namespaces, freely muck with the
> resources they own or create.  However, they're not quite usable yet.

So I'm assuming the actual high level goal of user namespaces is more
secure "containers" where you can run a mostly unmodified General
Purpose Linux system which includes setuid binaries, creating new users
etc., right?

If that's the case then my use case is much smaller - I don't need to be
able to run setuid binaries, or in fact change user ids at all.

A tool like this would make my life *so* much better that I'm trying
hard to use existing kernel features.

> So regarding your use of securebits: You are preventing a setuid-root
> program from automatically acquiring capabilities, which is a good
> start.  However, a setuid-root program will still execute as root (or
> a setuid-mysql program as setuid-mysql).  That means it will own
> root (or mysql) files while it is running. 

Oh, very good point.  I should have noticed that =/

But it was pretty trivial to modify my tool to make a MS_NOSUID bind
mount over /:

      mount (NULL, "/", "none", MS_PRIVATE | MS_REMOUNT | MS_NOSUID,
NULL);

That's hopefully enough to plug that hole (right?), albeit not in a
beautiful way.  I would be happier with a prctl to turn off suid
binaries entirely.

Oh...ok, digging farther back in here from the thread Andy started I see
Eric proposed a patch for exactly this:

https://lkml.org/lkml/2009/12/30/265

Ok, I've now read most of the back threads for this - I should have
searched farther back for previous discussion, sorry.

>  Second, programs with file capabilities -a
> more finegrained alternative to setuid-root - will still run with
> privilege.  You could prevent that by not allowing xattrs I suppose.

Looks to me like the MS_NOSUID bind mount prevents acquisition of file
capabilities too.

I experimented with dropping all capabilities from the capability
bounding set, but the API seems a bit lame in that CAP_LAST_CAP is
encoded in the kernel capability.h, but if an old binary is run on a new
kernel, I might silently fail to drop a newly added capability.  Right?
Steve Grubb's "libcap-ng" appears to not handle this scenario at all;
Steve, am I missing something?

Anyways, in the big picture here I think this tool is now pretty safe to
install suid root, since we rely on MS_NOSUID to close all privilege
escalation mechanisms today from plugging in a USB drive, which is
effectively "user controls arbitrary filesystem layout".

But getting in Eric's patch for disabling suid binaries from a process
tree would be really nice.  Alan, do you still object?  Your main issue
seemed to be that it should be in a LSM, but the suid issue does span
existing LSMs.  And as far as adding restrictions introduces new attack
vectors, pretty much all of those are abusing suid binaries, precisely
what we just want to axe off entirely.


