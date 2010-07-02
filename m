Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0GBFzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 01:55:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60436 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab0GBFzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 01:55:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 2 Jul 2010 14:50:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg KH <gregkh@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Message-Id: <20100702145042.5298416f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100701232634.GD13617@suse.de>
References: <20100628154455.GA13918@suse.de>
	<1277769867.8354.531.camel@nimitz>
	<20100629115232.38BC.A69D9226@jp.fujitsu.com>
	<1277827384.8354.3413.camel@nimitz>
	<20100629180415.GB1240@suse.de>
	<20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>
	<20100630154755.GB12158@suse.de>
	<20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
	<20100701232634.GD13617@suse.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 16:26:34 -0700
Greg KH <gregkh@suse.de> wrote:

> On Thu, Jul 01, 2010 at 09:31:30AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 30 Jun 2010 08:47:55 -0700
> > Greg KH <gregkh@suse.de> wrote:
> > > > and adding a scalable interface for large scale machines ?
> > > > I'd like to consider something..
> > > 
> > > Dynamically changing the layout on big memory boxes makes sense to me,
> > > how about you?
> > > 
> > 
> > like this ?
> > ==
> > boot option:
> > memory_sysfs_layout=compact
> > memory_sysfs_layout=auto (default)
> > memory_sysfs_layout=full
> > 
> > Considering briefly, how about this compact layout ?
> > 
> > /sys/devices/system/memory/:
> >                             list, hide, show, memoryX...
> > 
> > list: // show available memory index list.
> >   #cat list
> >    0 1 2 ....10000...
> > 
> > show: //an interface to enable the interface.
> >   #echo INDEX > memory_index
> >   will create memoryINDEX diretory.
> > 
> > hide: //an interface to hide the interface.
> >   #echo INDEX > memory_hide
> >   will remove memoryINDEX sysfs directory.
> 
> Ick, that can get confusing very quickly, and not really solve any of
> your root problems, right?
> 
Why not ?

I'm sorry if I misunderstand the problem . It is tooo many entries under
a directory, which makes the routine slow. No ?
By this interface, the sysfs entries pops up on demand if the user hides
it at boot time (by boot options.)

IIUC, the most problematic IBM's 16MB-sections system has no notification
from firmware and their system management middleware controls all
memory hotplug information. IOW, all memory-hotplug actions are from
user-land, not from firmware. They should know which mem_section should be
visible under /memory before starting hotplug.

In other platforms, using ACPI, hot-added memory sections can be automatically
visible. At memory hot-remove, management software should now which phys_address
memory should be removed before it starts action. It can make visible
section directory.

For many many users, who never wants memory hotplug, they can avoid creating
sysfs for memory hotplug and will be happy.



> > In compact mode, all memoryX interface are hidden at boot.
> > In full mode, all memoryX interaface are shown.
> > The Boot option just affects status at boot. If users want, he can make
> > all memory sysfs in shown state.
> > 
> > At hot-add event (via acpi) or probe-event, newly created memory section
> > should be start from "shown" mode. hotplug scirpt can hide it after online.
> > 
> > At hot-remove, the users has to offline memory before hotplug. He'll has
> > to do check list and show interface.
> > 
> > I think this change is not very difficult technically but can this kind of
> > interface be allowed ?
> 
> Not really, I don't like it.
> 
> Why not just simplify what you currently have to not use so many
> directories and files?
> 
> And maybe, this doesn't belong in sysfs at all...
> 

Because the system has topology and sysfs's /sys/devices/system/ shows
system's topology by directories and files, we use it. Especially, "node"
information is important in some system and we'd made use of it.

If you recommend guys to remake all NUMA-cpu-memory topology information
in other fs, someone will do.

Fujitsu will not complain about that and welcome it because we have a long
period until RHEL7 ages.

Thanks,
-Kame

