Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2KVSbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:31:32 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:38522 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2KVSbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:31:06 -0500
X-AuditID: b753bd60-91ec3ba0000047ca-a8-50adb651721c
X-AuditID: b753bd60-91ec3ba0000047ca-a8-50adb651721c
Message-ID: <50ADB650.8080502@hitachi.com>
Date: Thu, 22 Nov 2012 14:21:20 +0900
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
Subject: Re: Re: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
References: <20121114013611.5338.15086.stgit@yunodevel> <1352858437.18025.47.camel@gandalf.local.home> <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com> <1352860305.18025.48.camel@gandalf.local.home> <50A355A2.5040101@hitachi.com> <20121116191537.GB28622@amt.cnet> <50AB5D31.7060305@hitachi.com> <20121120225148.GA6027@amt.cnet>
In-Reply-To: <20121120225148.GA6027@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

(2012/11/21 7:51), Marcelo Tosatti wrote:
> On Tue, Nov 20, 2012 at 07:36:33PM +0900, Yoshihiro YUNOMAE wrote:
>> Hi Marcelo,
>>
>> Sorry for the late reply.
>>
>> (2012/11/17 4:15), Marcelo Tosatti wrote:
>>> On Wed, Nov 14, 2012 at 05:26:10PM +0900, Yoshihiro YUNOMAE wrote:
>>>> Thank you for commenting on my patch set.
>>>>
>>>> (2012/11/14 11:31), Steven Rostedt wrote:
>>>>> On Tue, 2012-11-13 at 18:03 -0800, David Sharp wrote:
>>>>>> On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>>>>>> On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
>>>>>>>
>>>>>>>> To merge the data like previous pattern, we apply this patch set. Then, we can
>>>>>>>> get TSC offset of the guest as follows:
>>>>>>>>
>>>>>>>> $ dmesg | grep kvm
>>>>>>>> [   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
>>>>>>>>                       ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
>>>>>>>>                       PID                         TSC offset                 |
>>>>>>>>                                                             HOST TSC value --+
>>>>>>>>
>>>>>>>
>>>>>>> Using printk to export something like this is IMO a nasty hack.
>>>>>>>
>>>>>>> Can't we create a /sys or /proc file to export the same thing?
>>>>>>
>>>>>> Since the value changes over the course of the trace, and seems to be
>>>>>> part of the context of the trace, I think I'd include it as a
>>>>>> tracepoint.
>>>>>>
>>>>>
>>>>> I'm fine with that too.
>>>>
>>>> Using some tracepoint is a nice idea, but there is one problem. Here,
>>>> our discussion point is "the event which TSC offset is changed does not
>>>> frequently occur, but the buffer must keep the event data."
>>>>
>>>> There are two ideas for using tracepoint. First, we define new
>>>> tracepoint for changed TSC offset. This is simple and the overhead will
>>>> be low. However, this trace event stored in the buffer will be
>>>> overwritten by other trace events because this TSC offset event does
>>>> not frequently occur. Second, we add TSC offset information to the
>>>> tracepoint frequently occured. For example, we assume that TSC offset
>>>> information is added to arguments of trace_kvm_exit().
>>>
>>> The TSC offset is in the host trace. So given a host trace with two TSC
>>> offset updates, how do you know which events in the guest trace
>>> (containing a number of events) refer to which tsc offset update?
>>>
>>> Unless i am missing something, you can't solve this easily (well, except
>>> exporting information to the guest that allows it to transform RDTSC ->
>>> host TSC value, which can be done via pvclock).
>>
>> As you say, TSC offset events are in the host trace, but we don't need
>> to notify guests of updating TSC offset. The offset event will output
>> the next TSC offset value and the current TSC value, so we can
>> calculate the guest TSC (T1) for the event. Guest TSCs since T1 can be
>> converted to host TSC using the TSC offset, so we can integrate those
>> trace data.
>
> Think of this scenario:
>
> host trace
> 1h. event tsc write tsc_offset=-1000
> 3h. vmenter
> 4h. vmexit
> ... (event sequence)
> 99h. vmexit
> 100h. event tsc_write tsc_offset=-2000
> 101h. vmenter
> ... (event sequence).
> 500h. event tsc_write tsc_offset=-3000
>
> Then a guest trace containing events with a TSC timestamp.
> Which tsc_offset to use?
>
> (that is the problem, which unless i am mistaken can only be solved
> easily if the guest can convert RDTSC -> TSC of host).

There are three following cases of changing TSC offset:
  1. Reset TSC at guest boot time
  2. Adjust TSC offset due to some host's problems
  3. Write TSC on guests
The scenario which you mentioned is case 3, so we'll discuss this case.
Here, we assume that a guest is allocated single CPU for the sake of
ease.

If a guest executes write_tsc, TSC values jumps to forward or backward.
For the forward case, trace data are as follows:

<    host   >               <   guest   >
cycles    events           cycles   events
  3000   tsc_offset=-2950
  3001   kvm_enter
                              53     eventX
                                      ....
                             100     (write_tsc=+900)
  3060   kvm_exit
  3075   tsc_offset=-2050
  3080   kvm_enter
                            1050     event1
                            1055     event2
                                      ...


This case is simple. The guest TSC of the first kvm_enter is calculated
as follows:

   (host TSC of kvm_enter) + (current tsc_offset) = 3001 - 2950 = 51

Similarly, the guest TSC of the second kvm_enter is 130. So, the guest
events between 51 and 130, that is, 53 eventX is inserted between the
first pair of kvm_enter and kvm_exit. To insert events of the guests
between 51 and 130, we convert the guest TSC to the host TSC using TSC
offset 2950.

For the backward case, trace data are as follows:

<    host   >               <   guest   >
cycles    events           cycles   events
  3000   tsc_offset=-2950
  3001   kvm_enter
                              53     eventX
                                      ....
                             100     (write_tsc=-50)
  3060   kvm_exit
  3075   tsc_offset=-2050
  3080   kvm_enter
                              90     event1
                              95     event2
                                      ...

As you say, in this case, the previous method is invalid. When we
calculate the guest TSC value for the tsc_offset=-3000 event, the value
is 75 on the guest. This seems like prior event of write_tsc=-50 event.
So, we need to consider more.

In this case, it is important that we can understand where the guest
executes write_tsc or the host rewrites the TSC offset. write_tsc on
the guest equals wrmsr 0x00000010, so this instruction induces vm_exit.
This implies that the guest does not operate when the host changes TSC
offset on the cpu. In other words, the guest cannot use new TSC before
the host rewrites the new TSC offset. So, if timestamp on the guest is
not monotonically increased, we can understand the guest executes
write_tsc. Moreover, in the region where timestamp is decreasing, we
can understand when the host rewrote the TSC offset in the guest trace
data. Therefore, we can sort trace data in chronological order.

>>> Another issue as mentioned is lack of TSC synchronization in the host.
>>> Should you provide such a feature without the possibility of proper
>>> chronological order on systems with unsynchronized TSC?
>>
>> I think, we cannot support this sorting feature using TSC on systems
>> with unsynchronized TSC. On systems with unsynchronized TSC, it is
>> difficult to sort not only trace data of guests and the host but trace
>> data of a guest or a host using TSC in chronological order. Actually,
>> if we want to output tracing data of ftrace in chronological order with
>> unsynchronized TSC, we will use the "global" mode as the timestamp. The
>> global mode uses wallclock added TSC correction, so the mode guarantees
>> to sort in chronological order for trace data of the guest or of
>> the host. If we use this mode to sort the trace data of guests and the
>> host in chronological order, we need to consider about the difference
>> between the guest and the host and timekeeping of guests and the host,
>> so it is difficult to solve these issues. At least, I haven't came up
>> with the good solution.
>
> I suppose the tradeoff is performance (RDTSC) versus reliability, when
> using ftrace. But then, even ftrace on the host suffers from the
> same problem, with unsynchronized TSCs.

Yes, that's true.

>> We cannot sort the trace data of guests and the host in chronological
>> order with unsynchronized TSC, but if we can set following
>> synchronization events for both guests and the host, we will know where
>> we should sort.
>>
>> First, a guest and the host uses the global mode as the timestamp of
>> ftrace. Next, a user on the guest writes "1" to the synchronization I/F
>> as the ID, then the synchronization event "1" is recorded in a
>> ring-buffer of the guest. The synchronization operation induces
>> hypercall, so the host can handle the event. After the operation moves
>> to the host, the host records the event "1" in a ring-buffer of the
>> host. In the end, the operation returns to the host, and the
>> synchronization is finished.
>>
>> When we integrate tracing data of the guest and the host, we
>> calculate difference of the timestamp between the synchronizing events
>> with the same ID. This value is a temporary "offset". We will convert
>> the timestamp of the guests to the timestamp of the host before the
>> next synchronizing event. If the synchronizing event cycle is very
>> short, we will not need to consider the timekeeping. Then, we can sort
>> the trace data in chronological order.
>>
>> Would you comment for this or do you have another idea?
>
> Performance of any solution across without synchronized TSC will be bad.
> Lets try to reduce coverage of the feature by providing ordering of
> guest/host events on per-vcpu basis (that is, you can only
> chronologically order events on a per-vm basis if the host TSC is
> synchronized).

OK. For the next patch, I'll indicate the restriction, which the host
TSC is synchronized if we use the feature to sort trace data in
chronological order.

> Which depends on the discussion above about multiple tsc offsets
> in the host trace.
>
> BTW, this issue came up during the KVM-RT BOF at KVMForum earlier this
> month. Currently there is no way to correlate (and be able to measure)
> events across host/guest, to profile RT behaviour.

Yes, this feature will be helpful in RT virtualization systsems:)

Thanks,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


