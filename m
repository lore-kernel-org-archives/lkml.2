Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2AaP2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:28:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:51073 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2AaP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:28:30 -0500
Message-ID: <1328023651.5344.17.camel@lappy>
Subject: Re: [PATCH] module: Remove module size limit
From: Sasha Levin <sasha.levin@oracle.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tim Abbott <tim.abbott@oracle.com>, stable@vger.kernel.org
Date: Tue, 31 Jan 2012 10:27:31 -0500
In-Reply-To: <CA+5PVA5zSjyOj9nbtPQ+cUKnYcdpHZgoD8PRSSF+DEwxJLYHzA@mail.gmail.com>
References: <1327982842-13898-1-git-send-email-sasha.levin@oracle.com>
	 <CA+5PVA5zSjyOj9nbtPQ+cUKnYcdpHZgoD8PRSSF+DEwxJLYHzA@mail.gmail.com>
Organization: Oracle
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F280897.0083,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 09:07 -0500, Josh Boyer wrote:
> On Mon, Jan 30, 2012 at 11:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > Module size was limited to 64MB, this was legacy limitation due to vmalloc()
> > which was removed a while ago.
> >
> > Limiting module size to 64MB is both pointless and affects real world use
> > cases.
> >
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Tim Abbott <tim.abbott@oracle.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > ---
> >  kernel/module.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 2c93276..3d56b6f 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2380,8 +2380,7 @@ static int copy_and_check(struct load_info *info,
> >                return -ENOEXEC;
> >
> >        /* Suck in entire file: we'll want most of it. */
> > -       /* vmalloc barfs on "unusual" numbers.  Check here */
> > -       if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
> > +       if ((hdr = vmalloc(len)) == NULL)
> >                return -ENOMEM;
> >
> >        if (copy_from_user(hdr, umod, len) != 0) {
> 
> I could be missing something somewhere, but this is the only upper bounds
> check that is in place on the overall module size.  If we remove this without
> putting some other kind of sanity check, wouldn't it be possible for someone
> to exhaust the entire vmalloc space for the kernel by loading a bloated module?

That someone needs CAP_SYS_MODULE to load a module in the first place,
it means that the user has to be privileged enough to load modules at
all.
Right now he can exhaust the vmalloc space simply by loading multiple
64MB modules, I don't think it matters much if we allow him to load one
module with over 64MB.
Also, if a malicious user can get a privileged user to load a kernel
module of his choice there are bigger things to worry about than the
vmalloc space.

> I would think we still want to have some form of upper bounds check to prevent
> that, but maybe I'm paranoid.

If there is a valid technical limit it would make sense, but just
scaling the 64MB limit up arbitrarily is pointless.

> As an aside, which real world use cases are blocked by having a 64MB limit?
> That is already HUGE.

When using KSplice, there is a debug option which allows you to generate
debug modules which weigh just a bit over 64MB. We currently patched the
64MB check out using a different KSplice patch, and everything works
quite well.


