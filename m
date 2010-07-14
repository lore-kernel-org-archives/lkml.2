Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0GND3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 23:29:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40093 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0GND3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 23:29:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Jul 2010 12:25:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] Allow sysfs memory directories to be split
Message-Id: <20100714122503.74f746a2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C3D2C6B.3050203@austin.ibm.com>
References: <4C3B3446.5090302@austin.ibm.com>
	<4C3B3895.3040209@austin.ibm.com>
	<20100713152854.ec1f4d6a.kamezawa.hiroyu@jp.fujitsu.com>
	<4C3C8B9E.7000208@austin.ibm.com>
	<20100714093550.40036034.kamezawa.hiroyu@jp.fujitsu.com>
	<4C3D2C6B.3050203@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 22:18:03 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> On 07/13/2010 07:35 PM, KAMEZAWA Hiroyuki wrote:
> > On Tue, 13 Jul 2010 10:51:58 -0500
> > Nathan Fontenot <nfont@austin.ibm.com> wrote:
> > 
> >>>
> >>> And for what purpose this interface is ? Does this split memory block into 2 pieces
> >>> of the same size ?? sounds __very__ strange interface to me.
> >>
> >> Yes, this splits the memory_block into two blocks of the same size.  This was
> >> suggested as something we may want to do.  From ppc perspective I am not sure we
> >> would use this.
> >>
> >> The split functionality is not required.  The main goal of the patch set is to
> >> reduce the number of memory sysfs directories created.  From a ppc perspective
> >> the split functionality is not really needed.
> >>
> > 
> > Okay, this is an offer from me.
> > 
> >   1. I think you can add an boot option as "don't create memory sysfs".
> >      please do.
> 
> I posted a patch to do that a week or so ago, it didn't go over very well.
> 
> > 
> >   2. I'd like to write a configfs module for handling memory hotplug even when
> >      sysfs directroy is not created.
> >      Because configfs support rmdir/mkdir, the user (ppc's daemon?) has to do
> >      
> >      When offlining section X.
> >      # insmod configfs_memory.ko
> >      # mount -t configfs none /configfs
> >      # mkdir /configfs/memoryX
> >      # echo offline > /configfs/memoryX/state
> >      # rmdir /configfs/memoryX
> > 
> >   And making this operation as the default bahavior for all arch's memory hotplug may
> >   be better...
> > 
> > Dave, how do you think ? Because ppc guys uses "probe" interface already,
> > this can be handled... no ?
> 
> ppc would still require the existance of the 'probe' interface.
> 
> Are you objecting to the 'split' functionality? 
yes.

> If so I do not see any reason from ppc
> perspective that it is needed.  This was something Dave suggested, unless I am missing
> something.
> 
> Since ppc needs the 'probe' interface in sysfs, and for ppc having mutliple 
> memory_block_sections reside under a single memory_block makes memory hotplug
> simpler.  On ppc we do emory hotplug operations on an LMB size basis.  With my
> patches this now lets us set each memory_block to span an LMB's worth of
> memory.  Now we could do emory hotplug in a single operation instead of multiple
> operations to offline/online all of the memory sections in an LMB.
> 

Why per-section memory offlining is provided is for allowing good success-rate of
memory offlining. Because memory-hotplug has to "migrate or free" all used page
under a section, possibility of memory unplug depends on usage of memory.
If a section contains unmovable page(kernel page), we can't offline sectin.

For example, comparing
  1. offlining 128MB of memory at once
  2. offlining 8 chunks of 16MB memory
"2" can get very good possibility and system-busy time can be much reduced.

IIUC, ppc's 1st requirement is "resizing" not "hot-removing some memory device",
"2" is much welcomed. So, some fine-grained interface to section_size is
appreciated. So, "multiple operations" is much better than single operation.

As I posted show/hide patch, I'm writing it in configfs. I think it meets IBM's
requirements.
_But_, it's IBM's issue not Fujitsu's. So, final decistion will depend on you guys.

Anyway, I don't like a too fancy interface as "split".

Thanks,
-Kame

