Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1BQEWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 23:22:20 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:34278 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752290Ab1BQEWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 23:22:18 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Date: Thu, 17 Feb 2011 17:22:15 +1300
User-Agent: KMail/1.9.10
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171531.03924.manningc2@actrix.gen.nz> <20110217034914.GB5194@opensource.wolfsonmicro.com>
In-Reply-To: <20110217034914.GB5194@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102171722.15683.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011 16:49:14 Mark Brown wrote:
> On Thu, Feb 17, 2011 at 03:31:03PM +1300, Charles Manning wrote:
> > On Thursday 17 February 2011 14:48:08 Mark Brown wrote:
> > > On Thu, Feb 17, 2011 at 11:12:06AM +1300, Charles Manning wrote:
> > >
> > > Even for embedded systems people do end up wanting to do things like
> > > using the same kernel on multiple systems which may have different
> > > hardware configurations (distros and reference boards are the obvious
> > > examples, but I've worked on systems where multiple generations and
> > > builds of the product were in active use and similar enough to be
> > > maintained from the same kernel).  Even with single system kernels
> > > there's still an issue with things like reference boards where users
> > > are doing things like picking up a new upstream kernel rather than the
> > > vendor BSP.
> >
> > Every one of the "stupid compile time options" is there because someone
> > that actually **uses** yaffs wanted it. None are there just for fun. The
>
> The fact that users have asked for something doesn't mean that the
> particular implementation that was chosen to meet the need makes sense.
> Having lots of compile time options is terribly common in many embedded
> systems but that doesn't mean it's a good idea to do things this way.
>
> > compile-time switches are very limited - mostly just there to set up
> > default runtime flags that can be overridden at runtime. Some of them are
> > there to work around bugs and limitations in the mtd.
>
> If these are just setting overridable defaults then that sounds like
> stuff that doesn't need to be in the kernel in the first place, they're
> just as trivial to tweak in userspace as with in kernel defines..  For the
> hardware workarounds having this in the kernel seems reasonable, we just
> need to figure out a way to propagate it from the machine driver to the
> filesystem.

Ok. I have no problems dumping all the compile switches that set up defaults 
or work around mtd bugs. If it is mainlined then this implies that mtd 
breakage will be fixed in the mtd - something that was not possible in the 
out-of-kernel code.

> > Even with BSPs, there will often be some board tuning to, do things like
> > set up the mtd partitions.
> >
> > Picking up an new kernel is easy, so long as the mtd code has not been
> > broken in the interum.
>
> You're missing the use case here - I'm talking about the situation where
> you completely ignore the vendor BSP and go direct to mainline without
> reference to the vendor provided stuff.  The user may not even have the
> vendor provided BSP to look at.

I don't understand what problem you are trying to illustrate.

First off, kernel BSPs should always be available in accordance with the GPL.

Secondly the defaults work for just about every case. So long as the mtd has 
been set up then dropping in yaffs using defaults is generally pretty 
straight forward and there is no tuning required,

Some tuning is required if the mtd does not pass through all the info that is 
required. In the fullness of time I would expect that this info would be 
provided by mtd.

>
> > > I'm not sure exactly how you'd do this for a filesystem but this is
> > > starting to sound a lot like platform data...  Though presumably if the
> > > data isn't stored on the device currently it'd be a simple matter of
> > > programming (if wasteful) to add it.
> >
> > NB flash file system - not file system! Working via mtd is different to
> > working via blocks.
>
> I do have *some* familiarity with embedded systems. 

My point was that the "platform data" -- well just about all of it -- is 
exposed via the mtd interface. That tells you the number of blocks, block 
size, bytes per block etc. Enough to figure out almost all the runtime stuff.

> The fact that the 
> device is a flash device doesn't stop you recording metadata on it -
> obviously you've got some data on there to record the metadata for stuff
> like directory layout.  If some of this is needed to even read the 
> device then it can't go on the device, but otherwise it could be
> included somehow.

At this stage yaffs does not really need or use a "superblock" (and it does 
not store directories). Superblocks are bad in that they provide a single 
point of failure.

I think I can dump all the config stuff and just set it to the most useful 
defaults. Many of the settings are really only there for debug etc.

Having looked through the Kconfig I reckon I can cut that and the associated 
#ifs back to:
CONFIG_YAFFS_FS
and add a new one to strip debugging
CONFIG_YAFFS_DEBUG

-- Charles







