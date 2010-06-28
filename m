Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0F1CUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 22:20:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35193 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0F1CUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 22:20:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Cc: kosaki.motohiro@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <4C24C279.3050206@austin.ibm.com>
References: <87d3vfeage.fsf@basil.nowhere.org> <4C24C279.3050206@austin.ibm.com>
Message-Id: <20100628110658.387B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 28 Jun 2010 11:20:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/25/2010 04:19 AM, Andi Kleen wrote:
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> writes:
> > 
> >>> Proposed patch to disable memory hotplug via a boot option,
> >>> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
> >>> prevents the creation of the memory sysfs directories for memory sections.
> >>>
> >>> This patch is meant to help alleviate very long boot times on systems with
> >>> large memory (1+ TB) and many memory sections (10's of thousands).
> >>
> >> Why making simple /sys file is so slowly? Couldn't we fix such performance
> >> problem?
> 
> The issue is the large number of sysfs memory directories that get created.
> On a system with 1 TB of memory I am seeing ~63,00 directories.  The long
> creation time is due to the string compare check in sysfs code to ensure
> we are not creating a directory with a duplicate name.

Ah, I see. probably this is sysfs issue. So Let's cc Greg and Eric.
Greg, I have dumb question. Why sysfs call strcmp() so heavily? I mean why sysfs
don't have hash based name dupliation check?

 - kosaki


> > 
> > Yes I agree this really needs to be fixed properly, not hacked around
> > with an option. Nathan can you please post some profile logs of the long
> > boot times?  
> > 
> 
> At this point the only profiling data I have is from adding a printk before
> and after the creation of the memory sysfs files in drivers/base/memory.c and
> booting with printk.time=1.
> 
> With 250 GB of memory: 10 seconds
> [    0.539562] Memory Start
> [   10.450409] Memory End
> 
> With 1 TB of memory: 9.1 minutes
> [   31.680168] Memory Start
> [  584.186500] Memory End
> 
> I am hoping to get access to a machine with 2 TB of memory sometime soon and
> can post data for boot times on an unpatched kernel.
> 
> I posted a patch earlier that updated sysfs to use reb-black trees to store
> the sysfs dirent structs (though the patch has issues with namespaces).  Using
> this patch on a 1 TB system the memory sysfs dir creation dropped to 2.2 minutes.
> 
> [    1.295874] Memory Start
> [  137.293510] Memory End
> 
> On a system with 2 TB of memory, the reb-black tree patch dropped the sysfs file
> creation time down to 33 minutes and total boot time to 1 hour 15 minutes. I
> haven't measured an unpatched kernel, but total boot of an unpatched kernel
> is just over 8 hours.
> 
> With 2 TB and patched kernel: 33 minutes
> [    3.241679] Memory Start
> [ 1986.973324] Memory End
>  
> I am open to other ideas on a solution for this.  With this many memory sections
> I feel that the sysfs memory directory really isn't human readable, not with
> 10's or 100's of thousands of entries.  Perhaps moving to a flat file representation
> and not create all the directories?
> 
> -Nathan


