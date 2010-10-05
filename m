Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0JEFYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:24:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36658 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0JEFYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:24:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Oct 2010 14:18:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Robin Holt <holt@sgi.com>,
        steiner@sgi.com
Subject: Re: [PATCH 9/9] v3 Update memory hotplug documentation
Message-Id: <20101005141852.66a6e85a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CA62A7D.8030905@austin.ibm.com>
References: <4CA62700.7010809@austin.ibm.com>
	<4CA62A7D.8030905@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Oct 2010 13:37:49 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the memory hotplug documentation to reflect the new behaviors of
> memory blocks reflected in sysfs.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you for your patient work!.



> ---
>  Documentation/memory-hotplug.txt |   47 +++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 16 deletions(-)
> 
> Index: linux-next/Documentation/memory-hotplug.txt
> ===================================================================
> --- linux-next.orig/Documentation/memory-hotplug.txt	2010-09-29 14:56:24.000000000 -0500
> +++ linux-next/Documentation/memory-hotplug.txt	2010-09-30 14:59:47.000000000 -0500
> @@ -126,36 +126,51 @@
>  --------------------------------
>  4 sysfs files for memory hotplug
>  --------------------------------
> -All sections have their device information under /sys/devices/system/memory as
> +All sections have their device information in sysfs.  Each section is part of
> +a memory block under /sys/devices/system/memory as
>  
>  /sys/devices/system/memory/memoryXXX
> -(XXX is section id.)
> +(XXX is the section id.)
>  
> -Now, XXX is defined as start_address_of_section / section_size.
> +Now, XXX is defined as (start_address_of_section / section_size) of the first
> +section contained in the memory block.  The files 'phys_index' and
> +'end_phys_index' under each directory report the beginning and end section id's
> +for the memory block covered by the sysfs directory.  It is expected that all
> +memory sections in this range are present and no memory holes exist in the
> +range. Currently there is no way to determine if there is a memory hole, but
> +the existence of one should not affect the hotplug capabilities of the memory
> +block.
>  
>  For example, assume 1GiB section size. A device for a memory starting at
>  0x100000000 is /sys/device/system/memory/memory4
>  (0x100000000 / 1Gib = 4)
>  This device covers address range [0x100000000 ... 0x140000000)
>  
> -Under each section, you can see 4 files.
> +Under each section, you can see 4 or 5 files, the end_phys_index file being
> +a recent addition and not present on older kernels.
>  
> -/sys/devices/system/memory/memoryXXX/phys_index
> +/sys/devices/system/memory/memoryXXX/start_phys_index
> +/sys/devices/system/memory/memoryXXX/end_phys_index
>  /sys/devices/system/memory/memoryXXX/phys_device
>  /sys/devices/system/memory/memoryXXX/state
>  /sys/devices/system/memory/memoryXXX/removable
>  
> -'phys_index' : read-only and contains section id, same as XXX.
> -'state'      : read-write
> -               at read:  contains online/offline state of memory.
> -               at write: user can specify "online", "offline" command
> -'phys_device': read-only: designed to show the name of physical memory device.
> -               This is not well implemented now.
> -'removable'  : read-only: contains an integer value indicating
> -               whether the memory section is removable or not
> -               removable.  A value of 1 indicates that the memory
> -               section is removable and a value of 0 indicates that
> -               it is not removable.
> +'phys_index'      : read-only and contains section id of the first section
> +		    in the memory block, same as XXX.
> +'end_phys_index'  : read-only and contains section id of the last section
> +		    in the memory block.
> +'state'           : read-write
> +                    at read:  contains online/offline state of memory.
> +                    at write: user can specify "online", "offline" command
> +                    which will be performed on al sections in the block.
> +'phys_device'     : read-only: designed to show the name of physical memory
> +                    device.  This is not well implemented now.
> +'removable'       : read-only: contains an integer value indicating
> +                    whether the memory block is removable or not
> +                    removable.  A value of 1 indicates that the memory
> +                    block is removable and a value of 0 indicates that
> +                    it is not removable. A memory block is removable only if
> +                    every section in the block is removable.
>  
>  NOTE:
>    These directories/files appear after physical memory hotplug phase.
> 
> 
> 

