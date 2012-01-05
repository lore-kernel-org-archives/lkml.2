Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2AERiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:38:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:58918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab2AERiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:38:09 -0500
Message-ID: <4F05DFF0.3000809@infradead.org>
Date: Thu, 05 Jan 2012 15:37:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-media@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
In-Reply-To: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-01-2012 15:02, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 8:16 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Just fix the *obvious* breakage in BLKROSET. It's clearly what the
>> code *intends* to do, it just didn't check for ENOIOCTLCMD.
> 
> So it seems from quick grepping that the block layer isn't actually
> all that confused apart from that one BLK[SG]ETRO issue, although I'm
> sure there are crazy drivers that think that EINVAL is the right error
> return.
> 
> The *really* confused layer seems to be the damn media drivers. The
> confusion there seems to go very deep indeed, where for some crazy
> reason the media people seem to have made it part of the semantics
> that "if a driver doesn't support a particular ioctl, it returns
> EINVAL".
> 
> Added, linux-media and Mauro to the Cc, because I'm about to commit
> something like the attached patch to see if anything breaks. We may
> have to revert it if things get too nasty, but we should have done
> this years and years ago, so let's hope not.

For the media drivers, we've already fixed it, at the V4L side:
-EINVAL doesn't mean that an ioctl is not supported anymore.
I think that such fix went into Kernel 3.1.

There are still two different behaviors there:
	at the V4L API: the return code is -ENOTTY;
	at the DVB API: the return code is currrently -EOPNOTSUPP.

Yeah, I know that DVB is returning the wrong code. Fixing it is on
my todo list, although with low priority, as the behavior inside the
DVB part is consistent.

On both DVB and V4L, -EINVAL now means only invalid parameters.

Regards,
Mauro

> Basic rules: ENOTTY means "I don't recognize this ioctl". Yes, the
> name is odd, and yes, it's for historical Unix reasons. ioctl's were
> originally a way to control mainly terminal settings - think termios -
> so when you did an ioctl on a file, you'd get "I'm not a tty, dummy".
> File flags were controlled with fcntl().
> 
> In contrast, EINVAL means "there is something wrong with the
> arguments", which very much implies "I do recognize the ioctl".
> 
> And finally, ENOIOCTLCMD is a way to say ENOTTY in a sane manner, and
> will now be turned into ENOTTY for the user space return (not EINVAL -
> I have no idea where that idiocy came from, but it's clearly confused,
> although it's also clearly very old).
> 
> This fixes the core files I noticed. It removes the *insane*
> complaints from the compat_ioctl() (which would complain if you
> returned ENOIOCTLCMD after an ioctl translation - the reason that is
> totally insane is that somebody might use an ioctl on the wrong kind
> of file descriptor, so even if it was translated perfectly fine,
> ENOIOCTLCMD is a perfectly fine error return and shouldn't cause
> warnings - and that allows us to remove stupid crap from the socket
> ioctl code).
> 
> Does this break things and need to be reverted? Maybe. There could be
> user code that tests *explicitly* for EINVAL and considers that the
> "wrong ioctl number", even though it's the wrong error return.
> 
> And we may have those kinds of mistakes inside the kernel too. We did
> in the block layer BLKSETRO code, for example, as pointed out by
> Paulo. That one is fixed here, but there may be others.
> 
> I didn't change any media layers, since there it's clearly an endemic
> problem, and there it seems to be used as a "we pass media ioctls down
> and drivers should by definition recognize them, so if they don't, we
> assume the driver is limited and doesn't support those particular
> settings and return EINVAL".
> 
> But in general, any code like this is WRONG:
> 
>    switch (cmd) {
>    case MYIOCTL:
>       .. do something ..
>    default:
>       return -EINVAL;
>    }
> 
> while something like this is CORRECT:
> 
>    switch (cmd) {
>    case MYIOCT:
>       if (arg)
>          return -EINVAL;
>       ...
> 
>    case OTHERIOCT:
>       /* I recognize this one, but I don't support it */
>       return -EINVAL;
> 
>    default:
>       return -ENOIOCTLCMD; // Or -ENOTTY - see below about the difference
>    }
> 
> where right now we do have some magic differences between ENOIOCTLCMD
> and ENOTTY (the compat layer will try to do a translated ioctl *only*
> if it gets ENOIOCTLCMD, iirc, so ENOTTY basically means "this is my
> final answer").
> 
> I'll try it out on my own setup here to see what problems I can
> trigger, but I thought I'd send it out first just as (a) a heads-up
> and (b) to let others try it out and see.. See the block/ioctl.c code
> for an example of the kinds of things we may need even just inside the
> kernel (and the kinds of things that could cause problems for
> user-space that makes a difference between EINVAL and ENOTTY).
> 
>                              Linus

