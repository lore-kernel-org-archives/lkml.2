Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2HVG14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:27:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54841 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab2HVG1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:27:52 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336320000"; 
   d="scan'208";a="5691496"
Message-ID: <50347D24.6070808@cn.fujitsu.com>
Date: Wed, 22 Aug 2012 14:33:08 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
        Yan Vugenfirer <yvugenfi@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH v8] kvm: notify host when the guest is panicked
References: <5021D235.4050800@cn.fujitsu.com> <20120813182132.GB25268@amt.cnet> <20120814085619.GA32708@redhat.com> <502A2B7A.3070801@siemens.com> <86E2467F-0EA3-4A03-BD89-58E41F7DB808@redhat.com> <20120814154237.GA21284@amt.cnet> <87boidgvaq.fsf@codemonkey.ws> <20120814191927.GA6058@amt.cnet> <87txw5clmh.fsf@codemonkey.ws> <20120814205339.GA14172@amt.cnet>
In-Reply-To: <20120814205339.GA14172@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/22 14:27:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/22 14:27:51,
	Serialize complete at 2012/08/22 14:27:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 08/15/2012 04:53 AM, Marcelo Tosatti Wrote:
> On Tue, Aug 14, 2012 at 02:35:34PM -0500, Anthony Liguori wrote:
>> Marcelo Tosatti <mtosatti@redhat.com> writes:
>>
>>> On Tue, Aug 14, 2012 at 01:53:01PM -0500, Anthony Liguori wrote:
>>>> Marcelo Tosatti <mtosatti@redhat.com> writes:
>>>>
>>>>> On Tue, Aug 14, 2012 at 05:55:54PM +0300, Yan Vugenfirer wrote:
>>>>>>
>>>>>> On Aug 14, 2012, at 1:42 PM, Jan Kiszka wrote:
>>>>>>
>>>>>>> On 2012-08-14 10:56, Daniel P. Berrange wrote:
>>>>>>>> On Mon, Aug 13, 2012 at 03:21:32PM -0300, Marcelo Tosatti wrote:
>>>>>>>>> On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
>>>>>>>>>> We can know the guest is panicked when the guest runs on xen.
>>>>>>>>>> But we do not have such feature on kvm.
>>>>>>>>>>
>>>>>>>>>> Another purpose of this feature is: management app(for example:
>>>>>>>>>> libvirt) can do auto dump when the guest is panicked. If management
>>>>>>>>>> app does not do auto dump, the guest's user can do dump by hand if
>>>>>>>>>> he sees the guest is panicked.
>>>>>>>>>>
>>>>>>>>>> We have three solutions to implement this feature:
>>>>>>>>>> 1. use vmcall
>>>>>>>>>> 2. use I/O port
>>>>>>>>>> 3. use virtio-serial.
>>>>>>>>>>
>>>>>>>>>> We have decided to avoid touching hypervisor. The reason why I choose
>>>>>>>>>> choose the I/O port is:
>>>>>>>>>> 1. it is easier to implememt
>>>>>>>>>> 2. it does not depend any virtual device
>>>>>>>>>> 3. it can work when starting the kernel
>>>>>>>>>
>>>>>>>>> How about searching for the "Kernel panic - not syncing" string 
>>>>>>>>> in the guests serial output? Say libvirtd could take an action upon
>>>>>>>>> that?
>>>>>>>>
>>>>>>>> No, this is not satisfactory. It depends on the guest OS being
>>>>>>>> configured to use the serial port for console output which we
>>>>>>>> cannot mandate, since it may well be required for other purposes.
>>>>>>>
>>>>>> Please don't forget Windows guests, there is no console and no "Kernel Panic" string ;)
>>>>>>
>>>>>> What I used for debugging purposes on Windows guest is to register a bugcheck callback in virtio-net driver and write 1 to VIRTIO_PCI_ISR register.
>>>>>>
>>>>>> Yan. 
>>>>>
>>>>> Considering whether a "panic-device" should cover other OSes is also \
>>>
>>>>> something to consider. Even for Linux, is "panic" the only case which
>>>>> should be reported via the mechanism? What about oopses without panic? 
>>>>>
>>>>> Is the mechanism general enough for supporting new events, etc.
>>>>
>>>> Hi,
>>>>
>>>> I think this discussion is gone of the deep end.
>>>>
>>>> Forget about !x86 platforms.  They have their own way to do this sort of
>>>> thing.  
>>>
>>> The panic function in kernel/panic.c has the following options, which
>>> appear to be arch independent, on panic:
>>>
>>> - reboot 
>>> - blink
>>
>> Not sure the semantics of blink but that might be a good place for a
>> pvops hook.
>>
>>>
>>> None are paravirtual interfaces however.
>>>
>>>> Think of this feature like a status LED on a motherboard.  These
>>>> are very common and usually controlled by IO ports.
>>>>
>>>> We're simply reserving a "status LED" for the guest to indicate that it
>>>> has paniced.  Let's not over engineer this.
>>>
>>> My concern is that you end up with state that is dependant on x86.
>>>
>>> Subject: [PATCH v8 3/6] add a new runstate: RUN_STATE_GUEST_PANICKED
>>>
>>> Having the ability to stop/restart the guest (and even introducing a 
>>> new VM runstate) is more than a status LED analogy.
>>
>> I must admit, I don't know why a new runstate is necessary/useful.  The
>> kernel shouldn't have to care about the difference between a halted guest
>> and a panicked guest.  That level of information belongs in userspace IMHO.
>>
>>> Can this new infrastructure be used by other architectures?
>>
>> I guess I don't understand why the kernel side of this isn't anything
>> more than a paravirt op hook that does a single outb() with the
>> remaining logic handled 100% in QEMU.
> 
>>From the patch description:
> 
> "Another purpose of this feature is: management app(for example:
> libvirt) can do auto dump when the guest is panicked. If management
> app does not do auto dump, the guest's user can do dump by hand if
> he sees the guest is panicked."
> 
> Wen, auto dump means dump of guest memory?

Yes.

> 
> In that case, the notification should obviously stop the guest 
> otherwise the guest might be reset by the time memdump from QEMU 
> monitor runs.

Yes, the guest is stopped while auto dumping.

> 
> But kexec supports dumping of memory already (i suppose it can 
> do automatic dump+{reboot,shutdown}).

It can be easily done in management app.

Thanks
Wen Congyang

> 
>>> Do you consider allowing support for Windows as overengineering?
>>
>> I don't think there is a way to hook BSOD on Windows so attempting to
>> engineer something that works with Windows seems odd, no?
> 
> Unsure about hooking at BSOD time. But Windows has configurable 
> memory dump/reset/reboot, so yes it should not necessary.
> 
>>
>> Regards,
>>
>> Anthony Liguori
>>
>>>
>>>> Regards,
>>>>
>>>> Anthony Liguori
>>>>
>>>>>
>>>>>>
>>>>>>> Well, we have more than a single serial port, even when leaving
>>>>>>> virtio-serial aside...
>>>>>>>
>>>>>>> Jan
>>>>>>>
>>>>>>> -- 
>>>>>>> Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
>>>>>>> Corporate Competence Center Embedded Linux
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

