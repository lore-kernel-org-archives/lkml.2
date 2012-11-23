Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2KWOat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:30:49 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39706 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2KWOar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:30:47 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Subject: Re: [PATCH 1/2] autofs4: allow autofs to work outside the initial PID namespace
References: <87obipehbt.fsf@tucsk.pomaz.szeredi.hu>
	<1353642304.2309.25.camel@perseus.themaw.net>
	<1353672540.6699.18.camel@perseus.themaw.net>
Date: Fri, 23 Nov 2012 15:30:39 +0100
In-Reply-To: <1353672540.6699.18.camel@perseus.themaw.net> (Ian Kent's message
	of "Fri, 23 Nov 2012 20:09:00 +0800")
Message-ID: <874nkgwfw0.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Fri, 2012-11-23 at 11:45 +0800, Ian Kent wrote:
>> On Thu, 2012-11-22 at 17:24 +0100, Miklos Szeredi wrote:
>> > Patches were tested by the customer.
>> > 
>> > Ian, Eric, do these patches look OK?
>> 
>> They look OK to me but I'm still a bit concerned about changing the way
>> this behaves, but I also believe this is the way we want it to behave.
>
> OK, I ran the autofs Connectathon tests that I often use on a kernel
> with these patches and they worked fine. So, AFAICS. the patches
> shouldn't introduce regressions.

And the reason for that is the patches introduce no behavioral changes
at all if the automount daemon was started in the initial namespace.

They only change (and fix) semantics of the case when automount is
started in a cloned pid namespace.

>
>> 
>> Give me a little bit more time to run a simple test to ensure we can at
>> least do what we could previously, and that's nothing more than
>> umounting duplicated mounts (which probably shouldn't be duplicated at
>> all) in the container.
>
> Interestingly the simple container test program I have also worked in
> the same way it does on current kernels so again I didn't see a problem
> adding the patches.
>
> But I do have a couple of questions that are a little related.
>
> Calling clone(2) with flags
> CLONE_NEWPID|CLONE_NEWNS|CLONE_NEWUTS|CLONE_NEWIPC|SIGCHLD|CLONE_NEWNET
> will result in a copy of the existing set of mounts. The autofs mounts
> can be umounted if they are not needed.
>
> But, on Fedora systemd sets "/" as shared at boot which prevents the
> umount of these autofs mounts, unless you mark "/" as private in the
> clone, after which the mounts can be umounted.
>
> Does having "/" marked as shared in the root namespace mean that further
> mounts in the root namespace will also appear in the clone and that
> mounts done in the clone will appear in the root namespace?

Yes.

>
> Will mounting all autofs mounts with MS_PRIVATE prevent the autofs
> mounts and any mounts under them from appearing in the root namespace?

Changing autofs mounts to MS_PRIVATE will prevent submounts of these
from being propagated to/from the root namespace.

>
> I assume there is no way for autofs to stop the propagation from the
> root namespace, is that correct?

Not for the children of the shared mount.  For the children of the
autofs mounts, they can be prevented, which is really what you want, I
guess.

Thanks,
Miklos

