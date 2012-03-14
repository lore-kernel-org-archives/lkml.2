Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893Ab2CNLMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:12:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34688 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760875Ab2CNLMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:12:02 -0400
X-IronPort-AV: E=Sophos;i="4.73,583,1325433600"; 
   d="scan'208";a="4533884"
Message-ID: <4F607D72.90303@cn.fujitsu.com>
Date: Wed, 14 Mar 2012 19:13:54 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F5DD0FD.9070904@redhat.com> <20120313091843.GB3800@redhat.com> <4F5F25BF.7060100@redhat.com> <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com> <20120314103755.GD2708@amit.redhat.com> <4F607857.50402@cn.fujitsu.com> <20120314105234.GV2304@redhat.com> <4F6079B7.1080507@cn.fujitsu.com> <20120314105817.GW2304@redhat.com>
In-Reply-To: <20120314105817.GW2304@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 19:09:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 19:09:59,
	Serialize complete at 2012-03-14 19:09:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/14/2012 06:58 PM, Gleb Natapov Wrote:
> On Wed, Mar 14, 2012 at 06:57:59PM +0800, Wen Congyang wrote:
>> At 03/14/2012 06:52 PM, Gleb Natapov Wrote:
>>> On Wed, Mar 14, 2012 at 06:52:07PM +0800, Wen Congyang wrote:
>>>> At 03/14/2012 06:37 PM, Amit Shah Wrote:
>>>>> On (Wed) 14 Mar 2012 [17:53:00], Wen Congyang wrote:
>>>>>> At 03/14/2012 05:24 PM, Avi Kivity Wrote:
>>>>>>> On 03/14/2012 10:29 AM, Wen Congyang wrote:
>>>>>>>> At 03/13/2012 06:47 PM, Avi Kivity Wrote:
>>>>>>>>> On 03/13/2012 11:18 AM, Daniel P. Berrange wrote:
>>>>>>>>>> On Mon, Mar 12, 2012 at 12:33:33PM +0200, Avi Kivity wrote:
>>>>>>>>>>> On 03/12/2012 11:04 AM, Wen Congyang wrote:
>>>>>>>>>>>> Do you have any other comments about this patch?
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Not really, but I'm not 100% convinced the patch is worthwhile.  It's
>>>>>>>>>>> likely to only be used by Linux, which has kexec facilities, and you can
>>>>>>>>>>> put talk to management via virtio-serial and describe the crash in more
>>>>>>>>>>> details than a simple hypercall.
>>>>>>>>>>
>>>>>>>>>> As mentioned before, I don't think virtio-serial is a good fit for this.
>>>>>>>>>> We want something that is simple & guaranteed always available. Using
>>>>>>>>>> virtio-serial requires significant setup work on both the host and guest.
>>>>>>>>>
>>>>>>>>> So what?  It needs to be done anyway for the guest agent.
>>>>>>>>>
>>>>>>>>>> Many management application won't know to make a vioserial device available
>>>>>>>>>> to all guests they create. 
>>>>>>>>>
>>>>>>>>> Then they won't know to deal with the panic event either.
>>>>>>>>>
>>>>>>>>>> Most administrators won't even configure kexec,
>>>>>>>>>> let alone virtio serial on top of it. 
>>>>>>>>>
>>>>>>>>> It should be done by the OS vendor, not the individual admin.
>>>>>>>>>
>>>>>>>>>> The hypercall requires zero host
>>>>>>>>>> side config, and zero guest side config, which IMHO is what we need for
>>>>>>>>>> this feature.
>>>>>>>>>
>>>>>>>>> If it was this one feature, yes.  But we keep getting more and more
>>>>>>>>> features like that and we bloat the hypervisor.  There's a reason we
>>>>>>>>> have a host-to-guest channel, we should use it.
>>>>>>>>>
>>>>>>>>
>>>>>>>> I donot know how to use virtio-serial.
>>>>>>>
>>>>>>> I don't either, copying Amit.
>>>>>>>
>>>>>>>> I start vm like this:
>>>>>>>> qemu ...\
>>>>>>>>    -device virtio-serial \
>>>>>>>>   -chardev socket,path=/tmp/foo,server,nowait,id=foo \
>>>>>>>>   -device virtserialport,chardev=foo,name=port1 ...
>>>>>>>>
>>>>>>>> You said that there are too many channels. Does it mean /tmp/foo is a channel?
>>>>>>>
>>>>>>> Probably.
>>>>>>
>>>>>> Hmm, if we use virtio-serial, the guest kernel writes something into the channel when
>>>>>> the os is panicked. Is it right?
>>>>>
>>>>> Depends on how you want to use it.  It could be the kernel, or it
>>>>> could be a userspace program which monitors syslogs for panic
>>>>> information and passes on that info to the virtio-serial channel.
>>>>
>>>> When the kernel is panicked, we cannot use userspace program.
>>>>
>>>>>
>>>>>> If so, is this channel visible to guest userspace? If the channle is visible to guest
>>>>>> userspace, the program running in userspace may write the same message to the channel.
>>>>>
>>>>> Access control is via permissions.  You can have udev scripts assign
>>>>> whatever uid and gid to the port of your interest.  By default, all
>>>>> ports are only accessible to the root user.
>>>>
>>>> We should also prevent root user writing message to this channel if it is
>>>> used for panicked notification.
>>>>
>>> Why? Root user can also call panic hypercall if he wishes so.
>>
>> IIRC, the instruction vmcall needs to run on ring0. The root user is in ring3.
>>
> And who will stop the root from loading kernel module?

Yes, I forgot this.

Thanks
Wen Congyang

>  
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

