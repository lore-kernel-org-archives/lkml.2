Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1AHXyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 18:54:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:37786 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1AHXyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 18:54:24 -0500
Date: Sat, 8 Jan 2011 15:49:49 -0800
From: Greg KH <gregkh@suse.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: kobject_put vs module unload
Message-ID: <20110108234949.GA4262@suse.de>
References: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
 <20110108055621.GB10391@suse.de>
 <Pine.LNX.4.64.1101080811400.29089@hs20-bc2-1.build.redhat.com>
 <AANLkTikg7vAG4-E=BD_sC=63R8fDCfEi_wiqnxDnUnK=@mail.gmail.com>
 <Pine.LNX.4.64.1101081258560.24933@hs20-bc2-1.build.redhat.com>
 <AANLkTi=hZ_W877QOwNK3=1-2S03VsKOXF_cVno_ReyrY@mail.gmail.com>
 <Pine.LNX.4.64.1101081340250.1879@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1101081340250.1879@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 01:50:50PM -0500, Mikulas Patocka wrote:
> 
> 
> On Sat, 8 Jan 2011, Kay Sievers wrote:
> 
> > On Sat, Jan 8, 2011 at 19:01, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > On Sat, 8 Jan 2011, Kay Sievers wrote:
> > >> On Sat, Jan 8, 2011 at 14:19, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > >> > On Fri, 7 Jan 2011, Greg KH wrote:
> > >>
> > >> >> > 4) the reference obtained at point 1) is dropped, kobject reference count
> > >> >> > reaches zero and the release callback is called. But that callback points
> > >> >> > to an unloaded module and causes a crash.
> > >> >> >
> > >> >> > How is it solved? Am I missing something?
> > >> >>
> > >> >> You have the code that creates and frees the object, to not be in the
> > >> >> module that could have been unloaded.  It's really just that simple.
> > >> >
> > >> > If the whole device mapper subsystem can be a module, where can I put the
> > >> > code?
> > >> >
> > >> > I think a similar bug exists in md, it can also be unloaded as a module
> > >> > and it has "release" method in its module code.
> > >>
> > >> If you still have data structures hanging around, these structures are
> > >> supposed to take a reference on the module -- and you can not unload
> > >> the module as long as this is the case.
> > >>
> > >> Kay
> > >
> > > kobject references don't increase module reference count. If kobject held
> > > module references, it would be a fix for this bug, but could cause other
> > > bugs (some modules could be unloadable due to self-references to its own
> > > kobjects).
> > 
> > Sure, they don't automatically take references. It's the job of the
> > driver/module, to make sure to pin the module for any data of it,
> > which might be still in use.
> > 
> > Kay
> 
> A module can't unpin itself. If it does, the module can be unloaded 
> immediatelly after module_put(THIS_MODULE) call and the function that 
> called module_put crashes.
> 
> A module must be unpinned by someone else. The question is: who unpins the 
> module when kobject references are gone?

Who ever you decide to have unpin it.

Seriously, it's up to you to handle this properly, it's not something
built into the kobject/driver model at all due to it being something
that can be done in a number of different ways.

thanks,

greg k-h
