Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2AETKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:10:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:60229 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab2AETKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:10:04 -0500
Message-ID: <4F05F57A.2070007@infradead.org>
Date: Thu, 05 Jan 2012 17:09:46 -0200
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
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com> <4F05DFF0.3000809@infradead.org> <CA+55aFyDJ5PJ75R_bSaV5KCpLANmNwCjCA=mYj4g+H+35NQSNQ@mail.gmail.com>
In-Reply-To: <CA+55aFyDJ5PJ75R_bSaV5KCpLANmNwCjCA=mYj4g+H+35NQSNQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-01-2012 15:47, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 9:37 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>>
>> For the media drivers, we've already fixed it, at the V4L side:
>> -EINVAL doesn't mean that an ioctl is not supported anymore.
>> I think that such fix went into Kernel 3.1.
> 
> Ok, I'm happy to hear that the thing should be fixed. My grepping
> still found a fair amount of EINVAL returns both in code and in the
> Documentation subdirectory for media ioctls, but it really was just
> grepping with a few lines of context, so I didn't look closer at the
> semantics. I was just looking for certain patterns (ie grepping for
> "EINVAL" near ioctl or ENOIOCTLCMD etc) that I thought might indicate
> problem spots, and the media subdirectory had a lot of them.

Yeah, there are lots of EINVAL there, as the API is fairly complex
(about 80 ioctl's for V4L, plus a similar set for DVB),  but there's
an ioctl dispatcher inside the V4L core that handles the ENOTTY case,
at drivers/media/video/v4l2-ioctl.c.

You'll see some -EINVAL things there, but they're due to errors
on parameters (the semantics there is somewhat complex, to avoid
returning -ENOTTY where a -EINVAL should be returned, instead).

In summary, the code there is:

static long __video_do_ioctl(struct file *file,
                unsigned int cmd, void *arg)
{
...
        long ret = -ENOTTY;
...
	switch (cmd) {
		/*
		 * several ioctl callbacks here. if they're not
		 * implemented, break (e. g. -ENOTTY will be returned).
		 */
...
	}
...
        return ret;

The context there is too big for noticing it with a few lines of
context, and too complex as well, as some ioctl's may be implemented 
by more than one callback, depending on what's needed, and some 
others have a default implementation there. This is somewhat similar 
to file ops callbacks.

> Can you test the patch with some media capture apps (preferably with
> the obvious fix for the problem that Paulo already pointed out -
> although that won't actually matter until some block driver starts
> using ENOIOCTLCMD there, so even the unfixed patch should mostly work
> for testing)?

Sure. I'm currently traveling, so I have just my "first aids kit" of devices
but they should be enough for testing it. I'll return you as soon as I finish
compiling the kernel on this slow 4 years-old notebook and run some
tests with the usual applications.

Regards,
Mauro
