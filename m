Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1FFTtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:49:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61116 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1FFTtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:49:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Mon, 6 Jun 2011 21:48:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Timur Tabi <timur@freescale.com>, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org, akpm@kernel.org,
        linux-console@vger.kernel.org, greg@kroah.com,
        linuxppc-dev@lists.ozlabs.org
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106061753.10154.arnd@arndb.de> <20110606131516.69b9f361@schlenkerla.am.freescale.net>
In-Reply-To: <20110606131516.69b9f361@schlenkerla.am.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106062148.57165.arnd@arndb.de>
X-Provags-ID: V02:K0:Umrg4CqMg74gkowG3eVS28YJNV0JSqI6ijGRO9u3/b2
 IJhcCyLJ8aj9bpNEKtENiLlreSySlmXhVFU0NUca4LBvL2sV8A
 A97oMQI0L9CjICiuV+VQx+94XzKBGjq064Au5IyG7IdUwDAWZK
 QYGHkEAXOI3N3M7oZKvWTxGcgmXxXu4pqKOrczEOO/KEpdHZJA
 BkgRN65FLTRp8yYWRnfMQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 June 2011 20:15:16 Scott Wood wrote:
> On Mon, 6 Jun 2011 17:53:09 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:

> > > > > You can't delete anything. 
> > > > 
> > > > rm, rmdir
> > > > 
> > > > > You can't create empty nodes.
> > > > 
> > > > mkdir
> > > 
> > > I know how to operate a filesystem.  You can't do these operations *on
> > > another guest's device tree through the hv interface*.
> > 
> > Why not?
> 
> Because the hypervisor does not support it.  It provides only getprop and
> setprop.  I think you took my "you can't do that" statements to be a
> statement about limitations of using a filesystem interfcae -- quite the
> opposite, I was saying the hv functionality is too limited to support a
> filesystem interface with normal semantics.

Ok, sorry for the confusion on my part. It makes a lot more sense now.

> > > And what would be the benefit of this major restructuring and added
> > > complexity?
> > 
> > I think it would be a slightly better abstraction, and the complexity
> > is not as big as you make it sound. I'm mainly countering your statement
> > that it would be a bad interface or that would not possible to do.
> > 
> > I'm not that opposed to having an ioctl interface for your hypervisor
> > interface, but I am opposed to making design choices based on
> > a bad representations of facts or not having considered the options
> > that other people suggest.
> 
> I don't really see how a filesystem is a better abstraction for a wrapper
> around a procedural interface.  A somewhat better argument is that ioctls
> are a pain, and Linux doesn't have a better way to expose a procedural
> interface, that doesn't require a wrapper program -- though as the wrapper
> already exists, and the fs interface would probably be sufficiently awkward
> that people would still use a wrapper, that doesn't buy us too much either.
> 
> This is not being proposed as any sort of standard kernel API, just a way
> for userspace to get access to implementation-specific hcalls.
> Implementation-specific backdoor is practically the definition of ioctl. :-)
> 
> I would be interested to see a concrete proposal for what this would look
> like as a filesystem, though, based on the actual operations that are
> available.  How would you deal with getting all the parameters in,
> performing the operation, and getting the results back?  What about when
> multiple processes are doing this at the same time?  What would the memcpy
> hcall look like?

In fs/libfs.c, we have support for "simple transaction files", where you
write input parameters into a file and then read it back to get the
results. They are very rarely used, but can serve as a way to replace ioctls
with file operations where that makes sense.

For an inter-partition memcpy, a better interface might be a pipe
representation: You have a namespace that is shared between two
partitions, so each side can create directory entries with arbitrary
names in one of the subdirectories of the file system. Then you can
open the file for reading on one side and writing on the other side
and when both sides have started the respective operation, the hypervisor
will copy data. The possible ways to use that functionality are countless.

Similarly, you can mmap a file to get inter-partition shared memory.

	Arnd
