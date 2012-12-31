Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab2LaKPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 05:15:17 -0500
Received: from relay.parallels.com ([195.214.232.42]:35665 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab2LaKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 05:15:15 -0500
Date: Mon, 31 Dec 2012 14:14:14 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Eric Paris <eparis@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] prctl: fix validation of an address
Message-ID: <20121231101414.GA27119@paralelels.com>
References: <1356778810-20879-1-git-send-email-avagin@openvz.org>
 <1356904987.9725.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <1356904987.9725.10.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [79.172.99.29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 05:03:07PM -0500, Eric Paris wrote:
> On Sat, 2012-12-29 at 15:00 +0400, Andrey Vagin wrote:
> > The address should be bigger than dac_mmap_min_addr, because
> > a process with CAP_RAWIO can map a vma bellow mmap_min_addr.
> 
> NAK

Currently prctl(PR_SET_MM_*, addr, ) returns EINVAL for valid addresses.
I think it's a bug. Are you agree?

> 
> This doesn't make any sense.  dac_mmap_min_addr should ONLY be used in
> security/min_addr.c and security/commoncap.c.  Period.  You should not

We can add a function to security/commoncap.c...

> be allowed to circumvent LSM protections.  Maybe you are missing that
> mmap_min_addr = max(dac_mmap_min_addr, CONFIG_LSM_MMAP_MIN_ADDR)  ?

Or maybe you are missing ;) that
/*
 * cap_mmap_addr - check if able to map given addr
 * @addr: address attempting to be mapped
 *
 * If the process is attempting to map memory below dac_mmap_min_addr
 * they need  CAP_SYS_RAWIO.

It was a real case. I have an application, which is failed due to
prlctl. This application uses vm.mmap_min_addr to calculate an adress
for a new vma.

$ sysctl -a | grep min_add
vm.mmap_min_addr = 4096

CONFIG_LSM_MMAP_MIN_ADDR could not be got from user space.

This application can use a real value of mmap_min_addr, but it is not
provided into userspace.

> 
> But this patch is absolutely unacceptable.  Maybe you can help me
> understand what problem you had and what you were hoping for?

Currently a task can have user memory area bellow dac_mmap_min_addr,
but prctl returns -EINVAL for such addresses.
How can I understand the reason, if I know that the address is valid?

I like Linux, because I always can predict its behavior, but this
dac_mmap_min_addr vs mmap_min_addr looks stange for me.

> 
> -Eric
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Eric Paris <eparis@redhat.com>
> > Cc: James Morris <jmorris@namei.org>
> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> > ---
> >  kernel/sys.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 265b376..e0e1bbd 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1868,7 +1868,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
> >  	if (opt == PR_SET_MM_EXE_FILE)
> >  		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
> >  
> > -	if (addr >= TASK_SIZE || addr < mmap_min_addr)
> > +	if (addr >= TASK_SIZE || addr < dac_mmap_min_addr)
> >  		return -EINVAL;
> >  
> >  	error = -EINVAL;
> 
> 
