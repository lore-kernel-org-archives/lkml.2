Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1AYVCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:02:03 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62704 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1AYVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pjm6XQn3qH+4QwvMmF1ptE+Is8z22aZXI+KCEP4YqRUHMi3wPGuvFIEmHQhCP2Fq6c
         zOF0SvQp9AJu0M8Ug62qDfWj+01djisuvUl1telNS4QsD1rXhhuIrfiqy+9X12LeypNT
         UXRdAsv4kZZlg90/3PDQQN6+tL0MaLzv8Y17c=
Date: Tue, 25 Jan 2011 13:01:54 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125210153.GB19896@core.coreip.homeip.net>
References: <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com>
 <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com>
 <4D3E5A91.30207@teksavvy.com>
 <20110125053117.GD7850@core.coreip.homeip.net>
 <4D3EB734.5090100@redhat.com>
 <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125205453.GA19896@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:54:53PM -0800, Dmitry Torokhov wrote:
> On Wed, Jan 26, 2011 at 06:09:45AM +1000, Linus Torvalds wrote:
> > On Wed, Jan 26, 2011 at 2:48 AM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > >
> > > We should be able to handle the case where scancode is valid even though
> > > it might be unmapped yet. This is regardless of what version of
> > > EVIOCGKEYCODE we use, 1 or 2, and whether it is sparse keymap or not.
> > >
> > > Is it possible to validate the scancode by driver?
> > 
> > More appropriately, why not just revert the thing? The version change
> 
> Well, then we'll break Ubuntu again as they recompiled their input-utils
> package (without fixing the check). And the rest of distros do not seem
> to be using that package...
> 
> > and the buggy EINVAL return both.
> 
> I believe that -EINVAL thing only affects RC devices that Mauro switched
> to the new rc-core; input core in itself should be ABI compatible. Thus
> I'll leave the decision to him whether he wants to revert or fix
> compatibility issue.
> 
> > 
> > As Mark said, breaking user space simply isn't acceptable. And since
> > breaking user space isn't acceptable, then incrementing the version is
> > stupid too.
> 
> It might not have been the best idea to increment, however I maintain
> that if there exists version is can be changed. Otherwise there is no
> point in having version at all.
> 
> As I said, reverting the version bump will cause yet another wave of
> breakages so I propose leaving version as is.
> 
> > 
> > The way we add new ioctl's is not by incrementing some "ABI version"
> > crap. It's by adding new ioctl's or system calls or whatever that
> > simply used to return -ENOSYS or other error before, while preserving
> > the old ABI. That way old binaries don't break (for _ANY_ reason), and
> > new binaries can see "oh, this doesn't support the new thing".
> 
> That has been done as well; we have 2 new ioctls and kept 2 old ioctls.
> 

BTW, another issue is that evdev's ioctl returns -EINVAL for unknown
ioctls so applications would have hard time figuring out whether error
returned because of kernel being too old or because they are trying to
retrieve/establish invalid mapping if they had to go only by the error
code.

As far as I can see EINVAL is a proper error for unknown ioctls:

[dtor@hammer work]$ man 2 ioctl | grep EINVAL
       EINVAL Request or argp is not valid.
[dtor@hammer work]$

-- 
Dmitry
