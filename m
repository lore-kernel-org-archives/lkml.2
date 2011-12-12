Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1LLXLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:11:15 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58771 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1LLXLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:11:13 -0500
Date: Mon, 12 Dec 2011 23:11:49 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Colin Walters <walters@verbum.org>
Cc: LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        morgan@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        luto@mit.edu, kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
Subject: Re: chroot(2) and bind mounts as non-root
Message-ID: <20111212231149.GA16408@hallyn.com>
References: <1323280461.10724.13.camel@lenny>
 <20111210052945.GA14931@hallyn.com>
 <1323708089.29338.39.camel@lenny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323708089.29338.39.camel@lenny>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Colin Walters (walters@verbum.org):
> But it was pretty trivial to modify my tool to make a MS_NOSUID bind
> mount over /:
> 
>       mount (NULL, "/", "none", MS_PRIVATE | MS_REMOUNT | MS_NOSUID,
> NULL);
> 
> That's hopefully enough to plug that hole (right?), albeit not in a

Heh, yeah I think that suffices :)

...

> Looks to me like the MS_NOSUID bind mount prevents acquisition of file
> capabilities too.

Yup.

> I experimented with dropping all capabilities from the capability
> bounding set, but the API seems a bit lame in that CAP_LAST_CAP is
> encoded in the kernel capability.h, but if an old binary is run on a new
> kernel, I might silently fail to drop a newly added capability.  Right?

Look at the cap_get_bound.3 manpage, and look for CAP_IS_SUPPORTED.
If you start at CAP_LAST_CAP and keep going up/down depending on whether
it was support or not it shouldn't take too long to find the last
valid value.  Not ideal, but should be reliable.

> Steve Grubb's "libcap-ng" appears to not handle this scenario at all;
> Steve, am I missing something?
> 
> Anyways, in the big picture here I think this tool is now pretty safe to
> install suid root, since we rely on MS_NOSUID to close all privilege

I haven't taken a critical look at the mount code but other than that
it seems reasonable and useful to me!  Thanks.

> escalation mechanisms today from plugging in a USB drive, which is
> effectively "user controls arbitrary filesystem layout".
> 
> But getting in Eric's patch for disabling suid binaries from a process
> tree would be really nice.  Alan, do you still object?  Your main issue
> seemed to be that it should be in a LSM, but the suid issue does span
> existing LSMs.  And as far as adding restrictions introduces new attack
> vectors, pretty much all of those are abusing suid binaries, precisely
> what we just want to axe off entirely.

-serge
