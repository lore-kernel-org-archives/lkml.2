Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2BAIIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:08:44 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:57993 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2BAIIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:08:43 -0500
Date: Wed, 1 Feb 2012 18:38:36 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] Fix race in process_vm_rw_core
Message-ID: <20120201183836.1cf5fc52@Gantu.yeoh.info>
In-Reply-To: <CA+55aFxstU98L64xgoUiacsV0zwX5ioNv3cT5CH2rvBrUGaovw@mail.gmail.com>
References: <20120130124406.1567af7a@Gantu.yeoh.info>
	<20120130150922.GA17643@redhat.com>
	<20120201162330.43d421d3@Gantu.yeoh.info>
	<CA+55aFxstU98L64xgoUiacsV0zwX5ioNv3cT5CH2rvBrUGaovw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12013121-9264-0000-0000-000000BD5732
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 22:10:13 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Jan 31, 2012 at 9:53 PM, Christopher Yeoh <cyeoh@au1.ibm.com>
> wrote:
> > +       mm = mm_access(task, PTRACE_MODE_ATTACH);
> > +       if (!mm || IS_ERR(mm)) {
> > +               if (!mm)
> > +                       rc = -EINVAL;
> > +               else
> > +                       rc = -EPERM;
> >                goto put_task_struct;
> 
> Btw, do you really want to throw away the error code?
> 
> IOW, maybe it should be
> 
>    rc = IS_ERR(mm) ? PTR_ERR(mm) : -EINVAL;
> 
> or something? Instead of forcing the EPERM? And the -EINVAL might be
> better off as an ESRCH? I dunno.

Yea, that probably makes more sense.

> Right now you turn all errors into EPERM, whether they were really
> about permission problems or not. And that just makes be a bit
> nervous. I wonder if we wouldn't be better off just returning EACCES
> (and any possible future problem) than try so hard to always return
> EPERM?
> 
> I dunno. I don't have any really *strong* opinion and I see why you do
> it, but my gut feel is still that the error number change really does
> seem a bit arbitrary.

I'm not super attached to returning EPERM instead of EACCES though I do
think it would look at bit odd from a user of the syscall view. Is it
too ugly to do:

    rc = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
    if (rc == -EACCES)
            rc = -EPERM;

That way we avoid the problem of overwriting EINTR and if there are
changes in the future which return different error codes we won't
override those.

If you think it is too ugly then I'll give in and just return EACESS.
Just should to get it settled before too many people start using the
syscalls.

Chris
-- 
cyeoh@au.ibm.com

