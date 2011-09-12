Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1ILBoT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 21:44:19 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64907 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1ILBoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 21:44:17 -0400
Date: Sun, 11 Sep 2011 18:44:07 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: NeilBrown <neilb@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [GIT] Bcache version 12
Message-ID: <20110912014407.GA5171@moria>
References: <20110910064531.GA32536@moria>
 <20110911081854.2958fdc8@notabene.brown>
 <20110911192259.GA3743@moria>
 <FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FD294A0B-7127-4ED1-89B8-3E3ADA796360@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 07:35:56PM -0600, Andreas Dilger wrote:
> On 2011-09-11, at 1:23 PM, Kent Overstreet <kent.overstreet@gmail.com> wrote:
> > On Sun, Sep 11, 2011 at 08:18:54AM +0200, NeilBrown wrote:
> >> 
> >> Looking at bcache.txt....
> >> 
> >> To make bcache devices known to the kernel, echo them to /sys/fs/bcache/register
> >>  echo /dev/sdb > /sys/fs/bcache/register
> >>  echo /dev/sdc > /sys/fs/bcache/register
> >> 
> >> ???
> >> I know that /sys is heading the way of /proc and becoming a disorganised ad
> >> hoc mess, but we don't need to actively encourage that.
> >> So when you are created a new block device type, putting controls
> >> under /sys/fs (where I believe 'fs' stands for "file system") seem ill
> >> advised.
> >> 
> >> My personal preference would be to see this as configuring the module and us
> >>  /sys/modules/bcache/parameters/register
> > 
> > I don't think that makes any more sense, as module paramaters AFAIK are
> > even more explicitly just a value you can stick in and pull out.
> > /sys/fs/bcache/register is really more analagous to mount().
> > 
> > You're not the first person to complain about that, I moved it to
> > configfs for awhile at Greg K-H's behest... but when I added cache sets
> > I had to move it back to sysfs.
> > 
> >> Alternately you could device a new 'bus' type for bcache and do some sort of
> >> device-model magic to attach something as a new device of that type.
> > 
> > I like that, I think that could make a lot of sense.
> > 
> > I'm not sure what to do about register though, I do prefer to have it a
> > file you can echo to but it doesn't really fit anywhere.
> 
> Rather than using /proc or /sys to configure bcache, why not integrate it with device mapper, and use dmsetup to configure it?  That avoids adding yet another block device abstraction into the kernel, and yet one more obscure way of configuring things. 
> 
> A bcache device could be considered almost like an LV snapshot, where writes go to the SSD device instead of a disk, and they can have writeback or writethrough cache. 

I looked into that many months ago, spent quite a bit of time fighting
with the dm code trying to get it to do what I wanted and... no. Never
again. It's worse than the cgroups code, and that's saying something.

It'd be great to have some uniformity, but you can't pay me enough to
touch that code again; IMO it's horribly misdesigned and probably a lost
cause.

Anyways, the code to create a new block device in bcache is trivial,
using dm certainly wouldn't make bcache any simpler (quite the
opposite). Supporting a standard interface would also be easy provided
it was a sane one.
