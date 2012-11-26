Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab2KZLFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:05:17 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34872 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2KZLFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:05:15 -0500
X-AuditID: b753bd60-96de5ba000004744-16-50b34ce73bd2
X-AuditID: b753bd60-96de5ba000004744-16-50b34ce73bd2
Message-ID: <50B34CE6.9070207@hitachi.com>
Date: Mon, 26 Nov 2012 20:05:10 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: Re: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
References: <20121114013611.5338.15086.stgit@yunodevel> <1352858437.18025.47.camel@gandalf.local.home> <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com> <1352860305.18025.48.camel@gandalf.local.home> <50A355A2.5040101@hitachi.com> <20121116191537.GB28622@amt.cnet> <50AB5D31.7060305@hitachi.com> <20121120225148.GA6027@amt.cnet> <50ADB650.8080502@hitachi.com> <20121123224608.GA23093@amt.cnet>
In-Reply-To: <20121123224608.GA23093@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

(2012/11/24 7:46), Marcelo Tosatti wrote:
> On Thu, Nov 22, 2012 at 02:21:20PM +0900, Yoshihiro YUNOMAE wrote:
>> Hi Marcelo,
>>
>> (2012/11/21 7:51), Marcelo Tosatti wrote:
>>> On Tue, Nov 20, 2012 at 07:36:33PM +0900, Yoshihiro YUNOMAE wrote:
>>>> Hi Marcelo,
>>>>
>>>> Sorry for the late reply.
>>>>
>>>> (2012/11/17 4:15), Marcelo Tosatti wrote:
>>>>> On Wed, Nov 14, 2012 at 05:26:10PM +0900, Yoshihiro YUNOMAE wrote:
>>>>>> Thank you for commenting on my patch set.
>>>>>>
>>>>>> (2012/11/14 11:31), Steven Rostedt wrote:
>>>>>>> On Tue, 2012-11-13 at 18:03 -0800, David Sharp wrote:
>>>>>>>> On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>>>>>>>> On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
>>>>>>>>>
>>>>>>>>>> To merge the data like previous pattern, we apply this patch set. Then, we can
>>>>>>>>>> get TSC offset of the guest as follows:
>>>>>>>>>>
>>>>>>>>>> $ dmesg | grep kvm
>>>>>>>>>> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
>>>>>>>>>>                       ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
>>>>>>>>>>                       PID                         TSC offset                 |
>>>>>>>>>>                                                             HOST TSC value --+
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Using printk to export something like this is IMO a nasty hack.
>>>>>>>>>
>>>>>>>>> Can't we create a /sys or /proc file to export the same thing?
>>>>>>>>
>>>>>>>> Since the value changes over the course of the trace, and seems to be
>>>>>>>> part of the context of the trace, I think I'd include it as a
>>>>>>>> tracepoint.
>>>>>>>>
>>>>>>>
>>>>>>> I'm fine with that too.
>>>>>>
>>>>>> Using some tracepoint is a nice idea, but there is one problem. Here,
>>>>>> our discussion point is "the event which TSC offset is changed does not
>>>>>> frequently occur, but the buffer must keep the event data."
>>>>>>
>>>>>> There are two ideas for using tracepoint. First, we define new
>>>>>> tracepoint for changed TSC offset. This is simple and the overhead will
>>>>>> be low. However, this trace event stored in the buffer will be
>>>>>> overwritten by other trace events because this TSC offset event does
>>>>>> not frequently occur. Second, we add TSC offset information to the
>>>>>> tracepoint frequently occured. For example, we assume that TSC offset
>>>>>> information is added to arguments of trace_kvm_exit().
>>>>>
>>>>> The TSC offset is in the host trace. So given a host trace with two TSC
>>>>> offset updates, how do you know which events in the guest trace
>>>>> (containing a number of events) refer to which tsc offset update?
>>>>>
>>>>> Unless i am missing something, you can't solve this easily (well, except
>>>>> exporting information to the guest that allows it to transform RDTSC ->
>>>>> host TSC value, which can be done via pvclock).
>>>>
>>>> As you say, TSC offset events are in the host trace, but we don't need
>>>> to notify guests of updating TSC offset. The offset event will output
>>>> the next TSC offset value and the current TSC value, so we can
>>>> calculate the guest TSC (T1) for the event. Guest TSCs since T1 can be
>>>> converted to host TSC using the TSC offset, so we can integrate those
>>>> trace data.
>>>
>>> Think of this scenario:
>>>
>>> host trace
>>> 1h. event tsc write tsc_offset=-1000
>>> 3h. vmenter
>>> 4h. vmexit
>>> ... (event sequence)
>>> 99h. vmexit
>>> 100h. event tsc_write tsc_offset=-2000
>>> 101h. vmenter
>>> ... (event sequence).
>>> 500h. event tsc_write tsc_offset=-3000
>>>
>>> Then a guest trace containing events with a TSC timestamp.
>>> Which tsc_offset to use?
>>>
>>> (that is the problem, which unless i am mistaken can only be solved
>>> easily if the guest can convert RDTSC -> TSC of host).
>>
>> There are three following cases of changing TSC offset:
>>   1. Reset TSC at guest boot time
>>   2. Adjust TSC offset due to some host's problems
>>   3. Write TSC on guests
>> The scenario which you mentioned is case 3, so we'll discuss this case.
>> Here, we assume that a guest is allocated single CPU for the sake of
>> ease.
>>
>> If a guest executes write_tsc, TSC values jumps to forward or backward.
>> For the forward case, trace data are as follows:
>>
>> <    host   >               <   guest   >
>> cycles    events           cycles   events
>>   3000   tsc_offset=-2950
>>   3001   kvm_enter
>>                               53     eventX
>>                                       ....
>>                              100     (write_tsc=+900)
>>   3060   kvm_exit
>>   3075   tsc_offset=-2050
>>   3080   kvm_enter
>>                             1050     event1
>>                             1055     event2
>>                                       ...
>>
>>
>> This case is simple. The guest TSC of the first kvm_enter is calculated
>> as follows:
>>
>>    (host TSC of kvm_enter) + (current tsc_offset) = 3001 - 2950 = 51
>>
>> Similarly, the guest TSC of the second kvm_enter is 130. So, the guest
>> events between 51 and 130, that is, 53 eventX is inserted between the
>> first pair of kvm_enter and kvm_exit. To insert events of the guests
>> between 51 and 130, we convert the guest TSC to the host TSC using TSC
>> offset 2950.
>>
>> For the backward case, trace data are as follows:
>>
>> <    host   >               <   guest   >
>> cycles    events           cycles   events
>>   3000   tsc_offset=-2950
>>   3001   kvm_enter
>>                               53     eventX
>>                                       ....
>>                              100     (write_tsc=-50)
>>   3060   kvm_exit
>>   3075   tsc_offset=-2050
>>   3080   kvm_enter
>>                               90     event1
>>                               95     event2
>>                                       ...
>
>     3400		               100    (write_tsc=-50)
>
> 				90    event3
> 				95    event4
>
>> As you say, in this case, the previous method is invalid. When we
>> calculate the guest TSC value for the tsc_offset=-3000 event, the value
>> is 75 on the guest. This seems like prior event of write_tsc=-50 event.
>> So, we need to consider more.
>>
>> In this case, it is important that we can understand where the guest
>> executes write_tsc or the host rewrites the TSC offset. write_tsc on
>> the guest equals wrmsr 0x00000010, so this instruction induces vm_exit.
>> This implies that the guest does not operate when the host changes TSC
>> offset on the cpu. In other words, the guest cannot use new TSC before
>> the host rewrites the new TSC offset. So, if timestamp on the guest is
>> not monotonically increased, we can understand the guest executes
>> write_tsc. Moreover, in the region where timestamp is decreasing, we
>> can understand when the host rewrote the TSC offset in the guest trace
>> data. Therefore, we can sort trace data in chronological order.
>
> This requires an entire trace of events. That is, to be able
> to reconstruct timeline you require the entire trace from the moment
> guest starts. So that you can correlate wrmsr-to-tsc on the guest with
> vmexit-due-to-tsc-write on the host.
>
> Which means that running out of space for trace buffer equals losing
> ability to order events.
>
> Is that desirable? It seems cumbersome to me.

As you say, tracing events can overwrite important events like
kvm_exit/entry or write_tsc_offset. So, Steven's multiple buffer is
needed by this feature. Normal events which often hit record the buffer
A, and important events which rarely hit record the buffer B. In our
case, the important event is write_tsc_offset.

> Also the need to correlate each write_tsc event in the guest trace
> with a corresponding tsc_offset write in the host trace means that it
> is _necessary_ for the guest and host to enable tracing simultaneously.
> Correct?
>
> Also, there are WRMSR executions in the guest for which there is
> no event in the trace buffer. From SeaBIOS, during boot.
> In that case, there is no explicit event in the guest trace which you
> can correlate with tsc_offset changes in the host side.

I understand that you want to say, but we don't correlate between
write_tsc event and write_tsc_offset event directly. This is because
the write_tsc tracepoint (also WRMSR instruction) is not prepared in
the current kernel. So, in the previous mail
(https://lkml.org/lkml/2012/11/22/53), I suggested the method which we
don't need to prepare the write_tsc tracepoint.

In the method, we enable ftrace before the guest boots, and we need to
keep all write_tsc_offset events in the buffer. If we forgot enabling
ftrace or we don't use multiple buffers, we don't use this feature.
So, I think as Peter says, the host should also export TSC offset
information to /proc/pid/kvm/*.

> If the guest had access to the host TSC value, these complications
> would disappear.

As a debugging mode, the TSC offset zero mode will be useful, I think.
(not for the real operation mode)

Thanks,
-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


