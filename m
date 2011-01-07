Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1AGCDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:03:35 -0500
Received: from void.printf.net ([89.145.121.20]:33552 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab1AGCDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:03:32 -0500
Date: Fri, 7 Jan 2011 02:03:26 +0000
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>, Jongman Heo <jongman.heo@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [announce] vfs-scale git tree update
Message-ID: <20110107020325.GA18808@void.printf.net>
References: <20110105102534.GA6679@amd> <loom.20110106T030535-794@post.gmane.org> <AANLkTikO68RQW0jzeLDOzRw7Hm15Ho0G9=Bp1KobKsrQ@mail.gmail.com> <20110107005954.GA18145@void.printf.net> <AANLkTimdV1WtdPXeZ8JO40gkC=2dt27bqKxGORuHVyrn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimdV1WtdPXeZ8JO40gkC=2dt27bqKxGORuHVyrn@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 05:41:39PM -0800, Linus Torvalds wrote:
> I'm wondering if this is a previously existing race condition leading
> to a deadlock. One that previously would have been serialized enough
> by the dcache lock that you'd never have that happen.
> 
> It might be interesting to re-run it with mutex debugging and lockdep
> enabled, to see if that reports anything. Although it probably won't,
> because it's not about a plain lock dependency, but ends up being
> deadlocked on the uevent being finished (but you have the modprobe and
> the request_firmware ones waiting on each other).
> 
> I dunno. I haven't really though that fully through. But we've had
> cases roughly like that before, and yes, they can be exposed by some
> independent serialization going away - long-standing potential bugs,
> that simply never happened in practice before.

Yeah, that sounds right:

arch/x86/kernel/microcode_core.c:
        mutex_lock(&microcode_mutex);
        ...
        error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);

(which calls request_microcode_fw() indirectly, and goes out to userspace.)

I'm willing to have a try at making this lockless if no-one beats me to it,
although it would need to wait until I've got the MMC merge out of the way.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
