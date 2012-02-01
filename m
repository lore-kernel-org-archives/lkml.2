Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2BAGKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:10:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51669 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2BAGKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:10:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120201162330.43d421d3@Gantu.yeoh.info>
References: <20120130124406.1567af7a@Gantu.yeoh.info> <20120130150922.GA17643@redhat.com>
 <20120201162330.43d421d3@Gantu.yeoh.info>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 Jan 2012 22:10:13 -0800
X-Google-Sender-Auth: Mu1rVWR9Emp8BiSsD8wmsT2yoVA
Message-ID: <CA+55aFxstU98L64xgoUiacsV0zwX5ioNv3cT5CH2rvBrUGaovw@mail.gmail.com>
Subject: Re: [PATCH RESEND] Fix race in process_vm_rw_core
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 9:53 PM, Christopher Yeoh <cyeoh@au1.ibm.com> wrote:
> +       mm = mm_access(task, PTRACE_MODE_ATTACH);
> +       if (!mm || IS_ERR(mm)) {
> +               if (!mm)
> +                       rc = -EINVAL;
> +               else
> +                       rc = -EPERM;
>                goto put_task_struct;

Btw, do you really want to throw away the error code?

IOW, maybe it should be

   rc = IS_ERR(mm) ? PTR_ERR(mm) : -EINVAL;

or something? Instead of forcing the EPERM? And the -EINVAL might be
better off as an ESRCH? I dunno.

Right now mm_access() returns EACCES for a permission problem, not
EPERM. EACCES is the normal filesystem access "Permission denied",
while EPERM is "Operation not permitted". I do agree that EPERM tends
to go with non-filesystem system calls (like ptrace() or sending
signals to a process that you aren't allowed to), so I do agree that
EPERM makes perfect sense within the context of process_vm_rw().

HOWEVER.

mm_access() can actually also return EINTR. Now, admittedly it only
returns that for killable signals, so user applications should never
*see* that, but it's a special-case example of other errors at least
being possible. What if we ever have some situation where we end up
needing a temporary memory allocation and could return ENOMEM?

Right now you turn all errors into EPERM, whether they were really
about permission problems or not. And that just makes be a bit
nervous. I wonder if we wouldn't be better off just returning EACCES
(and any possible future problem) than try so hard to always return
EPERM?

I dunno. I don't have any really *strong* opinion and I see why you do
it, but my gut feel is still that the error number change really does
seem a bit arbitrary.

                    Linus
