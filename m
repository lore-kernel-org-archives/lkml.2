Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1AYVus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:50:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53392 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab1AYVuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rsGONqFvThfrJupalQctdi58vKGQpXjkVLzTiIHvbGtLhRH2xz1lzkkH4kmvSRyoWM
         zvCe0gdwxBr+aJuDjinWu314UJYhC/XYydyXCvXh4lPHY2El3atT3w6ucIgHOcoXsiII
         s6VLZhjrRNo3XILqR3kKnoQ3qX8YtPsVYBGpg=
Date: Tue, 25 Jan 2011 13:50:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125215039.GB20030@core.coreip.homeip.net>
References: <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com>
 <4D3E5A91.30207@teksavvy.com>
 <20110125053117.GD7850@core.coreip.homeip.net>
 <4D3EB734.5090100@redhat.com>
 <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <20110125210153.GB19896@core.coreip.homeip.net>
 <AANLkTiknmVaOhvhTXC_5G3m-HDrTJCyqbjOPgnUEFZpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiknmVaOhvhTXC_5G3m-HDrTJCyqbjOPgnUEFZpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 07:20:07AM +1000, Linus Torvalds wrote:
> On Wed, Jan 26, 2011 at 7:01 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > BTW, another issue is that evdev's ioctl returns -EINVAL for unknown
> > ioctls so applications would have hard time figuring out whether error
> > returned because of kernel being too old or because they are trying to
> > retrieve/establish invalid mapping if they had to go only by the error
> > code.
> 
> So that's just another evdev interface bug.

Huh? I do not have lot of options here as far as error codes go. Invalid
request, invalid data in request - all goes to EINVAL.

> 
> > As far as I can see EINVAL is a proper error for unknown ioctls:
> >
> > [dtor@hammer work]$ man 2 ioctl | grep EINVAL
> >       EINVAL Request or argp is not valid.
> 
> Yeah, there's some confusion there.
> 
> The "unknown ioctl" error code is (for traditional reasons) ENOTTY,
> but yes, the EINVAL thing admittedly has a lot of legacy use too.
> 
> Inside the kernel, the preferred way to say "I don't recognize that
> ioctl number" is actually ENOIOCTLCMD.  That's exactly so that various
> nested ioctl handlers can then tell the difference between "I didn't
> recognize that ioctl" and "I understand what you asked me to do, but
> your arguments were crap".
> 
> vfs_ioctl() will then turn ENOIOCTLCMD to EINVAL to return to user space.

OK, so I can change evdev to employ ENOIOCTLCMD where needed, bit that
will not change older kernels where such distinction is needed (as never
kernels do support newer ioctl). And even if I could go back it would
not help since userspace still sees EINVAL only.

-- 
Dmitry
