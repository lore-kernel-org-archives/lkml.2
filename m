Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab2LaO1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 09:27:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab2LaO1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 09:27:34 -0500
Message-ID: <1356964034.31923.12.camel@localhost>
Subject: Re: [PATCH] prctl: fix validation of an address
From: Eric Paris <eparis@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>
Date: Mon, 31 Dec 2012 09:27:14 -0500
In-Reply-To: <20121231101414.GA27119@paralelels.com>
References: <1356778810-20879-1-git-send-email-avagin@openvz.org>
	 <1356904987.9725.10.camel@localhost>
	 <20121231101414.GA27119@paralelels.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-31 at 14:14 +0400, Andrew Vagin wrote:
> On Sun, Dec 30, 2012 at 05:03:07PM -0500, Eric Paris wrote:
> > On Sat, 2012-12-29 at 15:00 +0400, Andrey Vagin wrote:
> > > The address should be bigger than dac_mmap_min_addr, because
> > > a process with CAP_RAWIO can map a vma bellow mmap_min_addr.
> > 
> > NAK
> 
> Currently prctl(PR_SET_MM_*, addr, ) returns EINVAL for valid addresses.
> I think it's a bug. Are you agree?

Can you help me understand how prctl(PR_SET_MM_*, relates to
checkpoint/restore?  My worry here is that somehow this interface could
be used to bypass the security properties of mmap_min_addr.    I have no
idea how the interface is used, so I don't know if my fears are founded.
When I hear 'restore' I think of a privileged application setting up
some unprivileged application based on untrusted data.  My fear is that
some unpriv application, that doesn't have permission to map below
mmap_min_addr, may be able to trick the privileged application, which
would have this permission, into doing it on its behalf.  Does that make
sense?  Is that a realistic scenario with how this interface is used?

> CONFIG_LSM_MMAP_MIN_ADDR could not be got from user space.
> 
> This application can use a real value of mmap_min_addr, but it is not
> provided into userspace.

Unrelated to this patch issue, but I guess either could be exposed if
there is a need.

> Currently a task can have user memory area bellow dac_mmap_min_addr,
> but prctl returns -EINVAL for such addresses.
> How can I understand the reason, if I know that the address is valid?

Talking about dac_mmap_min_addr is wrong.  The capabilities security
module uses dac_mmap_min_addr but other LSMs can (and obviously do) use
other things.  mmap_min_addr is just the shorthand to make sure you
clear all hurdles.  Breaking those hurdles up outside of the security
subsystem is wrong.

The kernel makes the decision on what is valid via security_mmap_addr().
Assuming there are no security fears of an untrusted application
tricking some priviledged application to set up these maps the answer is
just calling security_mmap_addr() instead of doing if(addr <
mmap_min_addr) return -EINVAL;

I don't know if it is a good idea to allow this interface to ever go
below mmap_min_addr, but I do know that using (or even thinking about)
dac_mmap_min_addr is wrong and you should be looking at
security_mmap_addr() if you look at anything...

-Eric

