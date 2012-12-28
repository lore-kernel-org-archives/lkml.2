Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab2L1Oqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 09:46:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab2L1Oqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 09:46:36 -0500
Date: Fri, 28 Dec 2012 15:46:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: Andrew Vagin <avagin@parallels.com>, Pavel Emelyanov <xemul@parallels.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 1/4] signalfd: add ability to return siginfo in
	a raw format
Message-ID: <20121228144618.GC24229@redhat.com>
References: <20121225152716.GA3198@redhat.com> <50D9C8E9.6020602@parallels.com> <20121225165803.GA9066@redhat.com> <20121226144751.GA18767@paralelels.com> <20121226163112.GA6593@redhat.com> <20121227143626.GA15154@gmail.com> <20121227153020.GA1864@redhat.com> <CANaxB-x8k-c+gkeUJ1LovxSdWHJZggt0POPQxEotmuQvcXeicg@mail.gmail.com> <20121228141249.GA24229@redhat.com> <CANaxB-ytn_KvPx6D7y00MOCzWCxcwBEfBs7y0WHHm2rCJR1-Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANaxB-ytn_KvPx6D7y00MOCzWCxcwBEfBs7y0WHHm2rCJR1-Vg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28, Andrey Wagin wrote:
>
> 2012/12/28 Oleg Nesterov <oleg@redhat.com>:
> >> >> @@ -321,6 +372,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
> >> >>               }
> >> >>
> >> >>               file->f_flags |= flags & SFD_RAW;
> >> >> +             file->f_mode |= FMODE_PREAD;
> >> >>
> >> >>               fd_install(ufd, file);
> >> >
> >> > Hmm. Looks like it is based on other patches I didnt see...
> >> >
> >> > But I don't understand how FMODE_PREAD connects to this patch, we need
> >> > this flag set even for regular sys_read() ???
> >>
> >> It doesn't need for sys_read(), but this patch is about pread() and
> >> sys_pread() checks it.
> >>
> >> SYSCALL_DEFINE(pread64)(unsigned int fd, char __user *buf,
> >>                         size_t count, loff_t pos)
> >> {
> >> ....
> >>         if (f.file) {
> >>                 ret = -ESPIPE;
> >>                 if (f.file->f_mode & FMODE_PREAD)
> >>                         ret = vfs_read(f.file, buf, count, &pos);
> >
> > And sys_read() checks it too, that was my point.
>
> sys_read() doesn't check this flag. I tryed to remove this code from
> this patch and pread returned ESPIPE as expected.

sys_read() calls vfs_read() which checks f_mode & FMODE_READ at the
start ?

Oleg.

