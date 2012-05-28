Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab2E1F2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 01:28:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab2E1F16 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 01:27:58 -0400
X-IronPort-AV: E=Sophos;i="4.75,669,1330876800"; 
   d="scan'208";a="5050542"
Message-ID: <4FC30C40.80500@cn.fujitsu.com>
Date: Mon, 28 May 2012 13:25:20 +0800
From: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <4FB92D5A.3060507@redhat.com> <4FB9A92D.7050108@cn.fujitsu.com> <4FB9FE08.4050905@redhat.com> <4FBA05F6.8070804@cn.fujitsu.com> <4FBA0C8A.2050003@redhat.com> <4FBB0ACA.2040907@cn.fujitsu.com>
In-Reply-To: <4FBB0ACA.2040907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/28 13:26:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/28 13:26:10
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

于 2012年05月22日 11:40, Yanfei Zhang 写道:
> 于 2012年05月21日 17:36, Avi Kivity 写道:
>> On 05/21/2012 12:08 PM, Yanfei Zhang wrote:
>>> 于 2012年05月21日 16:34, Avi Kivity 写道:
>>>> On 05/21/2012 05:32 AM, Yanfei Zhang wrote:
>>>>> 于 2012年05月21日 01:43, Avi Kivity 写道:
>>>>>> On 05/16/2012 10:50 AM, zhangyanfei wrote:
>>>>>>> This patch set exports offsets of VMCS fields as note information for
>>>>>>> kdump. We call it VMCSINFO. The purpose of VMCSINFO is to retrieve
>>>>>>> runtime state of guest machine image, such as registers, in host
>>>>>>> machine's crash dump as VMCS format. The problem is that VMCS internal
>>>>>>> is hidden by Intel in its specification. So, we slove this problem
>>>>>>> by reverse engineering implemented in this patch set. The VMCSINFO
>>>>>>> is exported via sysfs to kexec-tools just like VMCOREINFO.
>>>>>>>
>>>>>>> Here are two usercases for two features that we want.
>>>>>>>
>>>>>>> 1) Create guest machine's crash dumpfile from host machine's crash dumpfile
>>>>>>>
>>>>>>> In general, we want to use this feature on failure analysis for the system
>>>>>>> where the processing depends on the communication between host and guest
>>>>>>> machines to look into the system from both machines's viewpoints.
>>>>>>>
>>>>>>> As a concrete situation, consider where there's heartbeat monitoring
>>>>>>> feature on the guest machine's side, where we need to determine in
>>>>>>> which machine side the cause of heartbeat stop lies. In our actual
>>>>>>> experiments, we encountered such situation and we found the cause of
>>>>>>> the bug was in host's process schedular so guest machine's vcpu stopped
>>>>>>> for a long time and then led to heartbeat stop.
>>>>>>>
>>>>>>> The module that judges heartbeat stop is on guest machine, so we need
>>>>>>> to debug guest machine's data. But if the cause lies in host machine
>>>>>>> side, we need to look into host machine's crash dump.
>>>>>>
>>>>>> Do you mean, that a heartbeat failure in the guest lead to host panic?
>>>>>>
>>>>>> My expectation is that a problem in the guest will cause the guest to
>>>>>> panic and perhaps produce a dump; the host will remain up.
>>>>>>
>>>>>
>>>>> The point is that before our investigation, we didn't know which side 
>>>>> leads to this buggy situation. Maybe a bug in host machine or the guest
>>>>> machine itself causes a heartbeat failure.
>>>>
>>>> How can a guest bug cause a host panic?
>>>>
>>>>> So we want to get both host machine's crash dump and guest machine's
>>>>> crash dump *at the same time*. Then we could use userspace tools to
>>>>> get guest machine crash dump from host machine's and analyse them
>>>>> separately to find which side causes the problem.
>>>>>
>>>>
>>>> If the guest caused the problem, there would be no panic; therefore
>>>> there was a host bug.
>>>>
>>>
>>> Yes, a guest bug cannot cause a host panic. When heartbeat stops in guest
>>> machine, we could trigger the host dump mechanism to work. This is because
>>> we want to get the status of both host and guest machine at the same time
>>> when heartbeat stops in guest machine. Then we can look for bug reasons
>>> from both host machine's and guest machine's views.
>>
>> That sounds like a bad idea. Can you explain in what situation it makes
>> sense for a guest to stop the host (and all other guests running on it)
>> rather than just restarting the failed services (on the host or other
>> guests)?
>>
> 
> We never do this on customer's environment which maybe a host with many guests
> running on it. We do this on another environment to reproduce the buggy
> situation; or we do this in testing phase on development environment towards
> production one on the customer's site.
> 
>>>>>>> Without this feature, we first create guest machine's dump and then
>>>>>>> create host mahine's, but there's only a short time between two
>>>>>>> processings, during which it's unlikely that buggy situation remains.
>>>>>>>
>>>>>>> So, we think the feature is useful to debug both guest machine's and
>>>>>>> host machine's sides at the same time, and expect we can make failure
>>>>>>> analysis efficiently.
>>>>>>>
>>>>>>> Of course, we believe this feature is commonly useful on the situation
>>>>>>> where guest machine doesn't work well due to something of host machine's.
>>>>>>>
>>>>>>> 2) Get offsets of VMCS information on the CPU running on the host machine
>>>>>>>
>>>>>>> If kdump doesn't work well, then it means we cannot use kvm API to get
>>>>>>> register values of guest machine and they are still left on its vmcs
>>>>>>> region. In the case, we use crash dump mechanism running outside of
>>>>>>> linux kernel, such as sadump, a firmware-based crash dump. Then VMCS
>>>>>>> information is then necessary.
>>>>>>
>>>>>> Shouldn't sadump then expose the VMCS offsets? Perhaps bundling them
>>>>>> into its dump file?
>>>>>>
>>>>>
>>>>> Firmware-based crash dump doesn't concern the os running on the machine.
>>>>> So it will not do any os handling when machine crashes.
>>>>
>>>> Seems to me the VMCS offsets are OS independent.
>>>>
>>> Hmm, you mean we could get VMCS offsets in sadump itself?
>>> But I think if we just export VMCS offsets in kernel, we could use the current
>>> existing dump tools with no or just very tiny change. I think this could be
>>> a more general mechanism than making changes in all kinds of dump tools.
>>
>> The sadump tool generates a core file with the OS image, right? Can it
>> not attach the offsets to a note, just like you propose for kdump?
>>
> 
> Both are right.


Dou you have any comments about this patch set?

Thanks
Zhang Yanfei
