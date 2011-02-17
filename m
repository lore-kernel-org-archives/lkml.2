Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1BQDuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:50:06 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:34167 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753758Ab1BQDuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 22:50:00 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Date: Thu, 17 Feb 2011 16:49:57 +1300
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171531.03924.manningc2@actrix.gen.nz> <4D5C8D62.4060809@bluewatersys.com>
In-Reply-To: <4D5C8D62.4060809@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102171649.57457.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011 15:52:18 Ryan Mallon wrote:
> On 17/02/11 15:31, Charles Manning wrote:
> > On Thursday 17 February 2011 14:48:08 Mark Brown wrote:
> >> On Thu, Feb 17, 2011 at 11:12:06AM +1300, Charles Manning wrote:
> >>> On Wednesday 16 February 2011 21:04:20 Christoph Hellwig wrote:
> >>>> The procfs interfaces should be replaced by something saner,
> >>>> the insane amount of ad-hoc tracing crap should be replaced by much
> >>>> less strategically placed trace events, and all those stupid compile
> >>>> time options have absolutely no business at all beeing there for a
> >>>> filesystem -
> >>>
> >>> Why not?
> >>>
> >>>> remember you can get media from all over the place.
> >>>
> >>> No you can't. This is a flash file system for soldered down flash. I
> >>> think that is a fundamental place where your understanding of what
> >>> yaffs is falls down.
> >
> > I'm not sure I really understand what Christoph means by "get media from
> > all over the place". I took that to mean he thinks people will pug in
> > random flash cards and would need to fiddle with options to make them
> > work. That would of course suck badly.
> >
> > That is obviously not the case for a flash file system used on hard-wired
> > flash where the system integrator is in control. Users don't get to
> > fiddle.
> >
> >> Even for embedded systems people do end up wanting to do things like
> >> using the same kernel on multiple systems which may have different
> >> hardware configurations (distros and reference boards are the obvious
> >> examples, but I've worked on systems where multiple generations and
> >> builds of the product were in active use and similar enough to be
> >> maintained from the same kernel).  Even with single system kernels
> >> there's still an issue with things like reference boards where users are
> >> doing things like picking up a new upstream kernel rather than the
> >> vendor BSP.
> >
> > Every one of the "stupid compile time options" is there because someone
> > that actually **uses** yaffs wanted it. None are there just for fun. The
> > compile-time switches are very limited - mostly just there to set up
> > default runtime flags that can be overridden at runtime. Some of them are
> > there to work around bugs and limitations in the mtd.
>
> The Kconfig options which are can be overridden by runtime flags should
> simply be removed. Pick a default and stick with it. Existing users will
> either have to modify their mount flags to suit, continuing using an old
> version, or patch the yaffs code themselves.
>
> It's also possibly worth removing some of the more esoteric options such
> as the ECC options at least for the first attempt at getting Yaffs into
> mainline. It will make it easier to get the code accepted, and if enough
> users complain that the feature is not there a sensible way to patch it
> in can be added later.

Ok. It is easy enough to strip out the Kconfigs and some compile time flags to 
make two versions: one to match the vfs-glue being mainlined and another for 
the patch-in.sh version.

>
> I think the downside at the moment is that it is getting less and less
> likely that you can maintain a single yaffs codebase and get it merged
> into mainline. I really think you are going to need to fork the code.


The part I struggle with is that if I fork the code to keep a full featured 
code base (that real integrators want) in yaffs.net git and a stripped 
version that is accepted into the kernel (but lacks what real integrators 
want), then that is a waste of effort. It is pointless putting something into 
the kernel if anyone really wanting to use yaffs has to do what they do now 
and patch in a "full fat" out of tree version.

So far the objections can be broadly classified as follows:

(A) Stuff that is clearly wrong or taste issues that should be fixed and is 
easy to do (eg. some of the odd-ball code you have pointed out). Even some of 
the configs could be sorted with this too).

(B)  Stuff that is there and is useful and real integrators tell me they want 
to see kept (eg the tracing stuff) but unfortunately some kernel folk don't 
like.

(C) Stuff which would potentially improve the performance - but perhaps not as 
much many think - and is a hell of a lot of work to do (eg. moving away from 
single locking).

I really have no objections to (A). (C) would just take time, effort and 
motivation but can be done. 

(B) seems counter productive. It is more important, IMHO, to have yaffs being 
useful rather than mainlined. Getting a "yaffs-lite" into the kernel seems 
like a very hollow victory.

> > Even with BSPs, there will often be some board tuning to, do things like
> > set up the mtd partitions.
> >
> > Picking up an new kernel is easy, so long as the mtd code has not been
> > broken in the interum.
> >
> > Last week I dropped the yaffs code into an omap3 build of 2.6.37 with no
> > fiddling and with default settings and it "just worked".
>
> Mark is talking about the case where you have a single kernel which can
> be run on multiple boards/platforms. This is becoming increasingly
> common for development and testing purposes. Because some of the yaffs
> config options are compile time only selectable, it may not be possible
> to support yaffs correctly on multiple boards in a single kernel. 


It is certainly possible. No problems at all. Balloon does that and I thought 
Bluewater do too. Same for running up yaffs in an omap multi-board kernel. I 
dropped yaffs into am omap build using defaults and everything "just works" 
on the boards I tested on.

Same for running on a PC using nandsim. Just compile with defaults and drop it 
in and it will work with any nandsim configuration by sniffing the mtd 
partition info and setting things up accordingly.

> This 
> is why it is much more ideal for config options to be mount flags.

It would be better if those were info passed through mtd (or determined from 
mtd) so that the flags were not needed. I'll have a look at what can be 
sorted at runtime.

The compile flags that set defaults  are there to provide flexibility, but I 
can get rid of those easy enough.

What is the really hard is getting rid of the single locking (estimate the 
thick end of a month of work). That is the really hard part.

Stripping out the tracing is easy enough but pointless if people (ie those 
actually using yaffs) really want it. Same for the proc interface (though 
that could be moved to sysfs).

-- Charles

