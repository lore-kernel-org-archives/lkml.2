Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2LWUh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 15:37:56 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:35185 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2LWUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 15:37:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [Regression w/ patch] Media commit causes user space to misbahave (was: Re: Linux 3.8-rc1)
Date: Sun, 23 Dec 2012 21:39:06 +0100
Message-ID: <2270597.SFkK637gAd@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CA+55aFy98A+LJK4+GWMcbzaa1zsPBRo76q+ioEjbx-uaMKH6Uw@mail.gmail.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com> <20121223120822.233282ba@redhat.com> <CA+55aFy98A+LJK4+GWMcbzaa1zsPBRo76q+ioEjbx-uaMKH6Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sunday 23 December 2012 09:36:15 Linus Torvalds wrote:
> On Sun, Dec 23, 2012 at 6:08 AM, Mauro Carvalho Chehab wrote:
> > Are you saying that pulseaudio is entering on some weird loop if the
> > returned value is not -EINVAL? That seems a bug at pulseaudio.
> 
> Mauro, SHUT THE FUCK UP!
> 
> It's a bug alright - in the kernel. How long have you been a
> maintainer? And you *still* haven't learnt the first rule of kernel
> maintenance?
> 
> If a change results in user programs breaking, it's a bug in the
> kernel. We never EVER blame the user programs. How hard can this be to
> understand?

This is certainly a kernel side regression, there's no doubt about that, and 
as such it needs to be fixed on the kernel side. There's likely a userspace 
bug as well here, but that's irrelevant from a kernel side point of view.

> To make matters worse, commit f0ed2ce840b3 is clearly total and utter
> CRAP even if it didn't break applications. ENOENT is not a valid error
> return from an ioctl. Never has been, never will be. ENOENT means "No
> such file and directory", and is for path operations. ioctl's are done
> on files that have already been opened, there's no way in hell that
> ENOENT would ever be valid.
> 
> > So, on a first glance, this doesn't sound like a regression,
> > but, instead, it looks tha pulseaudio/tumbleweed has some serious
> > bugs and/or regressions.
> 
> Shut up, Mauro. And I don't _ever_ want to hear that kind of obvious
> garbage and idiocy from a kernel maintainer again. Seriously.
> 
> I'd wait for Rafael's patch to go through you, but I have another
> error report in my mailbox of all KDE media applications being broken
> by v3.8-rc1, and I bet it's the same kernel bug. And you've shown
> yourself to not be competent in this issue, so I'll apply it directly
> and immediately myself.
> 
> WE DO NOT BREAK USERSPACE!
> 
> Seriously. How hard is this rule to understand? We particularly don't
> break user space with TOTAL CRAP. I'm angry, because your whole email
> was so _horribly_ wrong, and the patch that broke things was so
> obviously crap. The whole patch is incredibly broken shit. It adds an
> insane error code (ENOENT), and then because it's so insane, it adds a
> few places to fix it up ("ret == -ENOENT ? -EINVAL : ret").

The patch uses the -ENOENT error code internally in the uvcvideo driver to 
inform the caller function (internal to the driver) that the requested control 
doesn't exist. It was never meant to be returned out of the driver, and 
definitely not to userspace. This is clearly a bug.

> The fact that you then try to make *excuses* for breaking user space,
> and blaming some external program that *used* to work, is just
> shameful. It's not how we work.
> 
> Fix your f*cking "compliance tool", because it is obviously broken.

The "compliance tool" doesn't mandate -ENOENT. It has detected a V4L2 non-
compliance issue in the uvcvideo driver not related to error codes, and the 
fix had the very unfortunate side effect of breaking userspace.

I've tested the patch back then and apparently failed to notice the erroneous 
error code being pushed all the way to userspace. Sorry about that. I'll add a 
test case to the V4L2 compliance tool to catch such regressions in the future.

> And fix your approach to kernel programming.

-- 
Regards,

Laurent Pinchart

