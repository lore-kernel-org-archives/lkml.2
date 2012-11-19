Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2KSVCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:02:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2KSVCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:02:02 -0500
Date: Mon, 19 Nov 2012 15:01:53 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH review 12/16] userns: For /proc/self/{uid, gid}_map
 derive the lower userns from the struct file
Message-ID: <20121119210153.GA11904@sergelap>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
 <1353337961-12962-12-git-send-email-ebiederm@xmission.com>
 <20121119180322.GC1883@serge-ThinkPad-X130e>
 <87fw451m5i.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw451m5i.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Serge Hallyn <serge.hallyn@canonical.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >> 
> >> To keep things sane in the context of file descriptor passing derive the
> >> user namespace that uids are mapped into from the opener of the file
> >> instead of from current.
> >> 
> >> When writing to the maps file the lower user namespace must always
> >> be the parent user namespace, or setting the mapping simply does
> >> not make sense.  Enforce that the opener of the file was in
> >> the parent user namespace or the user namespace whose mapping
> >> is being set.
> >
> > Is there a reasonable use case for writing from the ns whose mapping
> > is being set?  Are you expecting cases where the child opens the file
> > and passes it back to the parent to set the mappings?
> 
> Passing the open mappings file no.  Although by using seq_user_ns I do
> make certain the semantics are correct if the file descriptor is passed,
> but I did that on general principles.
> 
> I expect a process in the user namespace to be able to meaningfully set
> the mapping to some the current uid and the current gid.

Sorry, I think a word is missing there.  To be precise (bc I haven't
thought about this much before as it's not my target goal :) you're
saying if I'm uid 1000 gid 1000, I can create a new user namespace
and, from inside that new userns (where I'm first uid/gid -1) I can
map any uid+gid in the container to 1000 in the parent ns?  Or is there
something more?

It still seems to me no less flexible to require being in the parent
ns, so

> >> +	if ((seq_ns != ns) && (seq_ns != ns->parent))
> >> +		return -EPERM;

would become

> >> +	if (seq_ns != ns->parent)
> >> +		return -EPERM;

I also wonder if -EINVAL would be a more appropriate choice here.
We're trying to keep things sane, rather than saying "not allowed"
for its own sake.

-serge
