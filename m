Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2L1OfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 09:35:13 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:50215 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2L1OfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 09:35:11 -0500
MIME-Version: 1.0
In-Reply-To: <20121228141249.GA24229@redhat.com>
References: <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com>
	<20121225143043.GA1813@redhat.com>
	<20121225152716.GA3198@redhat.com>
	<50D9C8E9.6020602@parallels.com>
	<20121225165803.GA9066@redhat.com>
	<20121226144751.GA18767@paralelels.com>
	<20121226163112.GA6593@redhat.com>
	<20121227143626.GA15154@gmail.com>
	<20121227153020.GA1864@redhat.com>
	<CANaxB-x8k-c+gkeUJ1LovxSdWHJZggt0POPQxEotmuQvcXeicg@mail.gmail.com>
	<20121228141249.GA24229@redhat.com>
Date: Fri, 28 Dec 2012 18:28:06 +0400
Message-ID: <CANaxB-ytn_KvPx6D7y00MOCzWCxcwBEfBs7y0WHHm2rCJR1-Vg@mail.gmail.com>
Subject: Re: [CRIU] [PATCH 1/4] signalfd: add ability to return siginfo in a
 raw format
From: Andrey Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Vagin <avagin@parallels.com>, Pavel Emelyanov <xemul@parallels.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/28 Oleg Nesterov <oleg@redhat.com>:
> On 12/27, Andrey Wagin wrote:
>>
>> 2012/12/27 Oleg Nesterov <oleg@redhat.com>:
>> > On 12/27, Andrey Wagin wrote:
>> >>
>> >> On Wed, Dec 26, 2012 at 05:31:12PM +0100, Oleg Nesterov wrote:
>> >> >
>> >> > So I think we should not use llseek. But, probably we can rely on pread() ?
>> >> > This way we can avoid the problem above, and this looks even simpler.
>> >>
>> >> Yes. It is a good idea. A new patch is attached to this email. I
>> >> implemented pread for signalfd and fixed all your previous comments.
>> >>
>> ...
>> > I think it would be better to pass ppos, not *ppos, because ...
>> >
>> >> +             if (*ppos)
>> >> +                     (*ppos)++;
>> >
>> > in this case we can update *ppos in signalfd_peek() and simplify the
>> > code a bit.
>> >
>> > Compared to the previous version it is "safe" to change *ppos even if
>> > copy_to_user() fails, *ppos will be "lost" anyway after we return.
>>
>> Yes. But ppos is updated, because pread() reads all siginfo-s from a queue,
>> which fit in a buffer starting with the initial ppos.
>
> Can't understand. And I guess you misunderstood.
>
> I meant, we can update *ppos in signalfd_peek() _and_ we can do this
> unconditionally even if copy_to_user() failed.

I see. Any way I fixed that in a new version of this patch. Thanks.

The new patch is a part of
[PATCH 0/3] signalfd: a kernel interface for dumping/restoring pending
signals (v2)

>
>> >> @@ -321,6 +372,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>> >>               }
>> >>
>> >>               file->f_flags |= flags & SFD_RAW;
>> >> +             file->f_mode |= FMODE_PREAD;
>> >>
>> >>               fd_install(ufd, file);
>> >
>> > Hmm. Looks like it is based on other patches I didnt see...
>> >
>> > But I don't understand how FMODE_PREAD connects to this patch, we need
>> > this flag set even for regular sys_read() ???
>>
>> It doesn't need for sys_read(), but this patch is about pread() and
>> sys_pread() checks it.
>>
>> SYSCALL_DEFINE(pread64)(unsigned int fd, char __user *buf,
>>                         size_t count, loff_t pos)
>> {
>> ....
>>         if (f.file) {
>>                 ret = -ESPIPE;
>>                 if (f.file->f_mode & FMODE_PREAD)
>>                         ret = vfs_read(f.file, buf, count, &pos);
>
> And sys_read() checks it too, that was my point.

sys_read() doesn't check this flag. I tryed to remove this code from
this patch and pread returned ESPIPE as expected.

>
> So either this code was already broken before this patch, or FMODE_PREAD
> is already set and you do not need this chunk.

>
> Oleg.
>
