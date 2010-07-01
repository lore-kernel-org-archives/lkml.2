Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0GADRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 23:17:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35062 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab0GADRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 23:17:42 -0400
Message-ID: <4C2C08CF.4040901@austin.ibm.com>
Date: Wed, 30 Jun 2010 22:17:35 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Greg KH <gregkh@suse.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] memory hotplug disable boot option
References: <20100628154455.GA13918@suse.de>	<1277769867.8354.531.camel@nimitz>	<20100629115232.38BC.A69D9226@jp.fujitsu.com>	<1277827384.8354.3413.camel@nimitz>	<20100629180415.GB1240@suse.de>	<20100630093251.a30ed1e0.kamezawa.hiroyu@jp.fujitsu.com>	<20100630154755.GB12158@suse.de> <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100701093130.c5e2b564.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 07:31 PM, KAMEZAWA Hiroyuki wrote:
> On Wed, 30 Jun 2010 08:47:55 -0700
> Greg KH <gregkh@suse.de> wrote:
>>> and adding a scalable interface for large scale machines ?
>>> I'd like to consider something..
>>
>> Dynamically changing the layout on big memory boxes makes sense to me,
>> how about you?
>>
> 
> like this ?
> ==
> boot option:
> memory_sysfs_layout=compact
> memory_sysfs_layout=auto (default)
> memory_sysfs_layout=full
> 
> Considering briefly, how about this compact layout ?
> 
> /sys/devices/system/memory/:
>                             list, hide, show, memoryX...
> 
> list: // show available memory index list.
>   #cat list
>    0 1 2 ....10000...
> 
> show: //an interface to enable the interface.
>   #echo INDEX > memory_index
>   will create memoryINDEX diretory.
> 
> hide: //an interface to hide the interface.
>   #echo INDEX > memory_hide
>   will remove memoryINDEX sysfs directory.
> 
> 
> In compact mode, all memoryX interface are hidden at boot.
> In full mode, all memoryX interaface are shown.
> The Boot option just affects status at boot. If users want, he can make
> all memory sysfs in shown state.

Do we need to make something as complicated as dynamically adding and removing
the sysfs directories?  Why not a compact layout that just takes the files
that currently reside in the memoryXX dirs and move them up to the memory
directory. This would be state (which should probably be split into an
'online' and 'offline' file), removable, phys_index, and phys_device.

Doing a cat on each of these files would simply report the appropriate
information for all of the memory sections present.  We could even go
as far storing the online status and removable status as a bitmap instead
of putting it in the memory_block struct and use th in-kernel routines
for printing bitmaps.

Users could then do memory hotplug by echo'ing the memory section to 
online to the 'online' file, and echo'ing the section number to the
'offline' file to offline a section.

In this mode ew would skip the creation of all of the sysfs nodes and
completely remove the performance issue seen.

Since this new layout and possible mdification to the memory_block
structure would not easily allow switching between he different layouts,
perhaps this should be set via a config option.

-Nathan


