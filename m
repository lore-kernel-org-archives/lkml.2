Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0FYOvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:51:46 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59767 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0FYOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:51:44 -0400
Message-ID: <4C24C279.3050206@austin.ibm.com>
Date: Fri, 25 Jun 2010 09:51:37 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug disable boot option
References: <4C24012B.9030506@austin.ibm.com>	<20100625105340.803C.A69D9226@jp.fujitsu.com> <87d3vfeage.fsf@basil.nowhere.org>
In-Reply-To: <87d3vfeage.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 04:19 AM, Andi Kleen wrote:
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
> 
>>> Proposed patch to disable memory hotplug via a boot option,
>>> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
>>> prevents the creation of the memory sysfs directories for memory sections.
>>>
>>> This patch is meant to help alleviate very long boot times on systems with
>>> large memory (1+ TB) and many memory sections (10's of thousands).
>>
>> Why making simple /sys file is so slowly? Couldn't we fix such performance
>> problem?

The issue is the large number of sysfs memory directories that get created.
On a system with 1 TB of memory I am seeing ~63,00 directories.  The long
creation time is due to the string compare check in sysfs code to ensure
we are not creating a directory with a duplicate name.

> 
> Yes I agree this really needs to be fixed properly, not hacked around
> with an option. Nathan can you please post some profile logs of the long
> boot times?  
> 

At this point the only profiling data I have is from adding a printk before
and after the creation of the memory sysfs files in drivers/base/memory.c and
booting with printk.time=1.

With 250 GB of memory: 10 seconds
[    0.539562] Memory Start
[   10.450409] Memory End

With 1 TB of memory: 9.1 minutes
[   31.680168] Memory Start
[  584.186500] Memory End

I am hoping to get access to a machine with 2 TB of memory sometime soon and
can post data for boot times on an unpatched kernel.

I posted a patch earlier that updated sysfs to use reb-black trees to store
the sysfs dirent structs (though the patch has issues with namespaces).  Using
this patch on a 1 TB system the memory sysfs dir creation dropped to 2.2 minutes.

[    1.295874] Memory Start
[  137.293510] Memory End

On a system with 2 TB of memory, the reb-black tree patch dropped the sysfs file
creation time down to 33 minutes and total boot time to 1 hour 15 minutes. I
haven't measured an unpatched kernel, but total boot of an unpatched kernel
is just over 8 hours.

With 2 TB and patched kernel: 33 minutes
[    3.241679] Memory Start
[ 1986.973324] Memory End
 
I am open to other ideas on a solution for this.  With this many memory sections
I feel that the sysfs memory directory really isn't human readable, not with
10's or 100's of thousands of entries.  Perhaps moving to a flat file representation
and not create all the directories?

-Nathan
