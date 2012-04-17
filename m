Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2DQMfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:35:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2DQMfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:35:08 -0400
X-IronPort-AV: E=Sophos;i="4.75,434,1330876800"; 
   d="scan'208";a="4773998"
Message-ID: <4F8D530C.3050908@cn.fujitsu.com>
Date: Tue, 17 Apr 2012 19:25:00 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: zhangyanfei <zhangyanfei@cn.fujitsu.com>, mtosatti@redhat.com,
        ebiederm@xmission.com, luto@mit.edu, joerg.roedel@amd.com,
        dzickus@redhat.com, paul.gortmaker@windriver.com, gregkh@suse.de,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F8D1F46.3090901@redhat.com> <4F8D4B4C.8070705@cn.fujitsu.com> <4F8D4D1C.4010400@redhat.com>
In-Reply-To: <4F8D4D1C.4010400@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/17 19:20:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/04/17 19:21:26
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 04/17/2012 06:59 PM, Avi Kivity Wrote:
> On 04/17/2012 01:51 PM, zhangyanfei wrote:
>> 于 2012年04月17日 15:44, Avi Kivity 写道:
>>> On 04/11/2012 04:39 AM, zhangyanfei wrote:
>>>> This patch set exports offsets of VMCS fields as note information for
>>>> kdump. We call it VMCSINFO. The purpose of VMCSINFO is to retrieve
>>>> runtime state of guest machine image, such as registers, in host
>>>> machine's crash dump as VMCS format. The problem is that VMCS
>>>> internal is hidden by Intel in its specification. So, we reverse
>>>> engineering it in the way implemented in this patch set. Please note
>>>> that this processing never affects any existing kvm logic. The
>>>> VMCSINFO is exported via sysfs to kexec-tools just like VMCOREINFO.
>>>>
>>>> Here is an example:
>>>> Processor: Intel(R) Core(TM)2 Duo CPU     E7500  @ 2.93GHz
>>>>
>>>> $cat /sys/kernel/vmcsinfo
>>>> 1cba8c0 2000
>>>>
>>>> crash> rd -p 1cba8c0 1000
>>>>          1cba8c0:  0000127b00000009 53434d5600000000   ....{.......VMCS
>>>>          1cba8d0:  000000004f464e49 4e4f495349564552   INFO....REVISION
>>>>          1cba8e0:  49460a643d44495f 5f4e495028444c45   _ID=d.FIELD(PIN_
>>>>          1cba8f0:  4d565f4445534142 4f435f434558455f   BASED_VM_EXEC_CO
>>>>          1cba900:  303d294c4f52544e 0a30383130343831   NTROL)=01840180.
>>>>          1cba910:  504328444c454946 5f44455341425f55   FIELD(CPU_BASED_
>>>>          1cba920:  5f434558455f4d56 294c4f52544e4f43   VM_EXEC_CONTROL)
>>>>          1cba930:  393130343931303d 28444c4549460a30   =01940190.FIELD(
>>>>          1cba940:  5241444e4f434553 4558455f4d565f59   SECONDARY_VM_EXE
>>>>          1cba950:  4f52544e4f435f43 30346566303d294c   C_CONTROL)=0fe40
>>>>          1cba960:  4c4549460a306566 4958455f4d562844   fe0.FIELD(VM_EXI
>>>>          1cba970:  4f52544e4f435f54 346531303d29534c   T_CONTROLS)=01e4
>>>>          1cba980:  4549460a30653130 4e455f4d5628444c   01e0.FIELD(VM_EN
>>>>          1cba990:  544e4f435f595254 33303d29534c4f52   TRY_CONTROLS)=03
>>>>          1cba9a0:  460a303133303431 45554728444c4549   140310.FIELD(GUE
>>>>          1cba9b0:  45535f53455f5453 3d29524f5443454c   ST_ES_SELECTOR)=
>>>>          1cba9c0:  4549460a30303530 545345554728444c   0500.FIELD(GUEST
>>>>          1cba9d0:  454c45535f53435f 35303d29524f5443   _CS_SELECTOR)=05
>>>>          ......
>>>>
>>>> TODO:
>>>>   1. In kexec-tools, get VMCSINFO via sysfs and dump it as note information
>>>>      into vmcore.
>>>>   2. Dump VMCS region of each guest vcpu and VMCSINFO into qemu-process
>>>>      core file. To do this, we will modify kernel core dumper, gdb gcore
>>>>      and crash gcore.
>>>>   3. Dump guest image from the qemu-process core file into a vmcore.
>>>>
>>>
>>> Taking a step back, can you describe the problem scenario you're fixing
>>> here?
>>>
>> Considering two scenarios below:
>> 1. Host panics, guests running on that host will also be dumped into
>>    host's vmcore.
>> 2. Qemu process is core dumped (by gdb gcore or kernel core dumper), and
>>    its coresponding guest will be included in the core file.
>>
>> We want to create the guest machine's crash dump from host machine's vmcore
>> or qemu process's core file. Unfortunately, we cannot get the guest's registers
>> values in both scenarios.
>>
>> For scenario 1, some key registers (CR0, CR3...) of the guest machine are stored
>> in VMCS region. But VMCS internal is hidden by Intel specification. So this
>> patch set aims to get offsets of fields in VMCS region and export it as note
>> information for kdump. 
> 
> Okay.  Do you expect it to help in debugging the crash?  Did you have
> cases where it would help?
> 
>>
>> For scenario 2, we also want the guest's registers values to be dumped into
>> qemu process's core file when qemu process crashes. This is the task of TODO-list 2.
> 
> Why?  If qemu crashed it is because of an internal qemu fault.  If any
> guest registers were involved, they would have been decoded by qemu
> previously and would be present in the stack trace (for example mmio
> address/data).

Hmm, IIRC, if qemu meets some critical error, it will call abort() or assert().
The guest registers are stored in the kernel, and qemu does not call
cpu_synchronize_state() to get guest register. So I donot understand
why the registers woubld be present int the stack trace...

Thanks
Wen Congyang

> 
>> Is this what you want?
>>
> 
> Yes.  I'm trying to understand if the feature would be useful in real life.
> 

