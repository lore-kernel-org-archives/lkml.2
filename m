Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2CBF51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:57:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2CBF50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:57:26 -0500
Date: Thu, 1 Mar 2012 23:57:16 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Goirand <thomas@goirand.fr>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        xen-devel@lists.xensource.com, William Dauchy <wdauchy@gmail.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org, linux-kernel@vger.kernel.org
Subject: Re: ioatdma: Boot process hangs then reboots when using Xen + Linux
 3.2
Message-ID: <20120302055715.GA692@burratino>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
 <20120127144737.GA27750@andromeda.dapyr.net>
 <20120219223125.GA820@burratino>
 <20120220181618.GD17566@burratino>
 <4F4891B8.9050008@goirand.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4891B8.9050008@goirand.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Thomas and William (cc-ed) have been having trouble loading the
ioatdma driver on a 32-bit Xen dom0.  The module loads automatically
at boot time and trips

	BUG_ON(active && !seen_current); /* no active descs have written a completion? */

from drivers/dma/ioat/dma_v2.c.  That check has been present since
5cbafa65b92e (ioat2,3: convert to a true ring buffer, 2009-08-26).
The bug is probably in Xen code and seems to be a regression (the bug
is present in 3.2 but not 3.1.8).

Thomas Goirand wrote:
> On 03/01/2012 11:53 PM, Bastian Blank wrote:
>> On Thu, Mar 01, 2012 at 06:02:15PM +0800, Thomas Goirand wrote:

>>>                     Any clue why I don't see crashes without Xen, with a
>>> 64 bits kernel, or with earlier versions of Linux (eg: 3.1 for example)?
>>
>> xen/i386 uses a different memory model to anything else, this may be a
>> problem.
[...]
> Replacing BUG_ON by a WARN_ON, and adding #define DEBUG 1 on top of
> dma_v2.c, my kernel booted, and I had the attached dmesg output.
>
> Blacklisting the ioatdma kernel module of course, solved the issue.
>
> I hope that helps, please let me know if I should do more to help. If
> you need access to my server, that's possible (I use it only for
> packaging XCP and some tests...).

I don't expect you to debug this Xen-specific bug, but I'm wondering:
is there any reason this check has to be a BUG_ON instead of a
WARN_ON?  If there is some way to recover when the impossible happens,
that would make using and debugging the kernel a little easier.

Curious,
Jonathan
