Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1AYVVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:21:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919Ab1AYVU6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:20:58 -0500
MIME-Version: 1.0
In-Reply-To: <20110125210153.GB19896@core.coreip.homeip.net>
References: <20110125042016.GA7850@core.coreip.homeip.net> <4D3E5372.9010305@teksavvy.com>
 <20110125045559.GB7850@core.coreip.homeip.net> <4D3E59CA.6070107@teksavvy.com>
 <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net>
 <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net> <20110125210153.GB19896@core.coreip.homeip.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Jan 2011 07:20:07 +1000
Message-ID: <AANLkTiknmVaOhvhTXC_5G3m-HDrTJCyqbjOPgnUEFZpA@mail.gmail.com>
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:01 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> BTW, another issue is that evdev's ioctl returns -EINVAL for unknown
> ioctls so applications would have hard time figuring out whether error
> returned because of kernel being too old or because they are trying to
> retrieve/establish invalid mapping if they had to go only by the error
> code.

So that's just another evdev interface bug.

> As far as I can see EINVAL is a proper error for unknown ioctls:
>
> [dtor@hammer work]$ man 2 ioctl | grep EINVAL
>       EINVAL Request or argp is not valid.

Yeah, there's some confusion there.

The "unknown ioctl" error code is (for traditional reasons) ENOTTY,
but yes, the EINVAL thing admittedly has a lot of legacy use too.

Inside the kernel, the preferred way to say "I don't recognize that
ioctl number" is actually ENOIOCTLCMD.  That's exactly so that various
nested ioctl handlers can then tell the difference between "I didn't
recognize that ioctl" and "I understand what you asked me to do, but
your arguments were crap".

vfs_ioctl() will then turn ENOIOCTLCMD to EINVAL to return to user space.

                  Linus
