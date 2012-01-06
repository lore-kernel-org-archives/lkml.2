Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab2AFQUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:20:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2AFQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:20:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices)
Date: Fri, 6 Jan 2012 16:19:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com, Christoph Hellwig <hch@lst.de>
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
In-Reply-To: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201061619.43584.arnd@arndb.de>
X-Provags-ID: V02:K0:QSn9jwXnGX9iY6oGdQ16zV+CVFFq8hYmid/xf9a4I6P
 VXco/40Eg0emP0YsSAy1pEHysnbrEKBGfLX+LAC2byQIf7Yapw
 7vEKatPfPA5Dx+KLwK1ZkeqFBCOlf77JcPZegX+I9wjua3gH3k
 HpRBwUD3IkJv9lynht4Hig91HlGAyIZsnjYbUFLtZxH4iMgMIh
 aNsjTeOdnlsJBEvWO7uILRKxFawQ+T/hYsSJil2pKoizVaQzBh
 NTKXEi3gL31Kw6lW6fp8Eo25uXX1jje7M5NCTfJaAW7MIo6yHS
 CTJ9cNhyDjyRjIKseLruSSDLlew8XdJBdr1xHSdhIEM/Q61+GU
 Ff/KaPT6dLqJ6w8JI0ps=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 January 2012, Linus Torvalds wrote:

> And finally, ENOIOCTLCMD is a way to say ENOTTY in a sane manner, and
> will now be turned into ENOTTY for the user space return (not EINVAL -
> I have no idea where that idiocy came from, but it's clearly confused,
> although it's also clearly very old).

To give some background here: While I did a lot of changes to the
compat ioctl code over the years, I never touched the EINVAL/ENOTTY
logic out of fear of breaking things further. Your patch is probably
the right answer here and we should have done it long ago.

> This fixes the core files I noticed. It removes the insane
> complaints from the compat_ioctl() (which would complain if you
> returned ENOIOCTLCMD after an ioctl translation - the reason that is
> totally insane is that somebody might use an ioctl on the wrong kind
> of file descriptor, so even if it was translated perfectly fine,
> ENOIOCTLCMD is a perfectly fine error return and shouldn't cause
> warnings - and that allows us to remove stupid crap from the socket
> ioctl code).

Now this behavior was entirely intentional. ENOIOCTLCMD was introduced
explicitly so we could tell the difference between compat_ioctl handlers
saying "I don't know how to translate this but common code might know"
(ENOIOCTLCMD) and "I know that this is not a valid command code here"
(ENOTTY plus whatever a broken driver might return).

The distinction is used in two places:

1. To let device drivers return early from fops->compat_ioctl when
they want to avoid the overhead from searching the COMPATIBLE_IOCTL()
table and from the (formerly large) switch statement in do_ioctl_trans(),
or when they want to make sure that the common translation is not
called. We have some really tricky bits in the socket code where
the crazy SIOCDEVPRIVATE needs to be handled specially by some drivers
while the majority can use the default siocdevprivate_ioctl() function.

2. To return from do_ioctl_trans() when we know that there is no
translation for the command number, so that the we can write a warning
to the console (which you have now removed). This was initially more
useful back when do_ioctl_trans() knew about practically all command
numbers, but we have gradually moved all handlers into device drivers
where they belong, and that has caused the problem that we get warnings
whenever a user attempts an ioctl on a device that does not handle the
command even when all the correct devices that support the command also
have a compat handler. The common way we handle those is to add an
IGNORE_IOCTL() entry for a command that repeatedly shows up in logs
that way and is known to be handled correctly.

I used to have patches to completely remove the remains of do_ioctl_trans()
that can be resurrected if that helps, but it's mostly an independent
issue.

While I agree that the existing compat_ioctl_error() method was somewhat
broken, I'd like to keep having a way to get some indication from
drivers that are missing ioctl translations. Ideally, we would move
all of fs/compat_ioctl.c into drivers and then just warn when we register
some file_operations on a 64 bit machine that have an ioctl but no
compat_ioctl function, but that would be a large amount of work.

For a simpler solution, we could keep the old warning message, but change
the logic from

(.compat_ioctl == NULL || .compat_ioctl() == -ENOIOCTL) && (no generic handler)

to

(.ioctl != NULL && .compat_ioctl == NULL) && (no generic handler).

and then fix the warnings we see by adding appropriate .compat_ioctl
functions.

	Arnd
