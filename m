Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2KWXDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 18:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab2KWXDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 18:03:32 -0500
Date: Fri, 23 Nov 2012 20:46:08 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
Message-ID: <20121123224608.GA23093@amt.cnet>
References: <20121114013611.5338.15086.stgit@yunodevel>
 <1352858437.18025.47.camel@gandalf.local.home>
 <CAJL_ekvb89saY9F0F3ip-8xipuuRyJ1_M8hOyThu_0Q2=5sXgA@mail.gmail.com>
 <1352860305.18025.48.camel@gandalf.local.home>
 <50A355A2.5040101@hitachi.com>
 <20121116191537.GB28622@amt.cnet>
 <50AB5D31.7060305@hitachi.com>
 <20121120225148.GA6027@amt.cnet>
 <50ADB650.8080502@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ADB650.8080502@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 02:21:20PM +0900, Yoshihiro YUNOMAE wrote:
> Hi Marcelo,
> 
> (2012/11/21 7:51), Marcelo Tosatti wrote:
> >On Tue, Nov 20, 2012 at 07:36:33PM +0900, Yoshihiro YUNOMAE wrote:
> >>Hi Marcelo,
> >>
> >>Sorry for the late reply.
> >>
> >>(2012/11/17 4:15), Marcelo Tosatti wrote:
> >>>On Wed, Nov 14, 2012 at 05:26:10PM +0900, Yoshihiro YUNOMAE wrote:
> >>>>Thank you for commenting on my patch set.
> >>>>
> >>>>(2012/11/14 11:31), Steven Rostedt wrote:
> >>>>>On Tue, 2012-11-13 at 18:03 -0800, David Sharp wrote:
> >>>>>>On Tue, Nov 13, 2012 at 6:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >>>>>>>On Wed, 2012-11-14 at 10:36 +0900, Yoshihiro YUNOMAE wrote:
> >>>>>>>
> >>>>>>>>To merge the data like previous pattern, we apply this patch set. Then, we can
> >>>>>>>>get TSC offset of the guest as follows:
> >>>>>>>>
> >>>>>>>>$ dmesg | grep kvm
> >>>>>>>>[   57.717180] kvm: (2687) write TSC offset 18446743360465545001, now clock ##
> >>>>>>>>                      ^^^^                   ^^^^^^^^^^^^^^^^^^^^            |
> >>>>>>>>                      PID                         TSC offset                 |
> >>>>>>>>                                                            HOST TSC value --+
> >>>>>>>>
> >>>>>>>
> >>>>>>>Using printk to export something like this is IMO a nasty hack.
> >>>>>>>
> >>>>>>>Can't we create a /sys or /proc file to export the same thing?
> >>>>>>
> >>>>>>Since the value changes over the course of the trace, and seems to be
> >>>>>>part of the context of the trace, I think I'd include it as a
> >>>>>>tracepoint.
> >>>>>>
> >>>>>
> >>>>>I'm fine with that too.
> >>>>
> >>>>Using some tracepoint is a nice idea, but there is one problem. Here,
> >>>>our discussion point is "the event which TSC offset is changed does not
> >>>>frequently occur, but the buffer must keep the event data."
> >>>>
> >>>>There are two ideas for using tracepoint. First, we define new
> >>>>tracepoint for changed TSC offset. This is simple and the overhead will
> >>>>be low. However, this trace event stored in the buffer will be
> >>>>overwritten by other trace events because this TSC offset event does
> >>>>not frequently occur. Second, we add TSC offset information to the
> >>>>tracepoint frequently occured. For example, we assume that TSC offset
> >>>>information is added to arguments of trace_kvm_exit().
> >>>
> >>>The TSC offset is in the host trace. So given a host trace with two TSC
> >>>offset updates, how do you know which events in the guest trace
> >>>(containing a number of events) refer to which tsc offset update?
> >>>
> >>>Unless i am missing something, you can't solve this easily (well, except
> >>>exporting information to the guest that allows it to transform RDTSC ->
> >>>host TSC value, which can be done via pvclock).
> >>
> >>As you say, TSC offset events are in the host trace, but we don't need
> >>to notify guests of updating TSC offset. The offset event will output
> >>the next TSC offset value and the current TSC value, so we can
> >>calculate the guest TSC (T1) for the event. Guest TSCs since T1 can be
> >>converted to host TSC using the TSC offset, so we can integrate those
> >>trace data.
> >
> >Think of this scenario:
> >
> >host trace
> >1h. event tsc write tsc_offset=-1000
> >3h. vmenter
> >4h. vmexit
> >... (event sequence)
> >99h. vmexit
> >100h. event tsc_write tsc_offset=-2000
> >101h. vmenter
> >... (event sequence).
> >500h. event tsc_write tsc_offset=-3000
> >
> >Then a guest trace containing events with a TSC timestamp.
> >Which tsc_offset to use?
> >
> >(that is the problem, which unless i am mistaken can only be solved
> >easily if the guest can convert RDTSC -> TSC of host).
> 
> There are three following cases of changing TSC offset:
>  1. Reset TSC at guest boot time
>  2. Adjust TSC offset due to some host's problems
>  3. Write TSC on guests
> The scenario which you mentioned is case 3, so we'll discuss this case.
> Here, we assume that a guest is allocated single CPU for the sake of
> ease.
> 
> If a guest executes write_tsc, TSC values jumps to forward or backward.
> For the forward case, trace data are as follows:
> 
> <    host   >               <   guest   >
> cycles    events           cycles   events
>  3000   tsc_offset=-2950
>  3001   kvm_enter
>                              53     eventX
>                                      ....
>                             100     (write_tsc=+900)
>  3060   kvm_exit
>  3075   tsc_offset=-2050
>  3080   kvm_enter
>                            1050     event1
>                            1055     event2
>                                      ...
> 
> 
> This case is simple. The guest TSC of the first kvm_enter is calculated
> as follows:
> 
>   (host TSC of kvm_enter) + (current tsc_offset) = 3001 - 2950 = 51
> 
> Similarly, the guest TSC of the second kvm_enter is 130. So, the guest
> events between 51 and 130, that is, 53 eventX is inserted between the
> first pair of kvm_enter and kvm_exit. To insert events of the guests
> between 51 and 130, we convert the guest TSC to the host TSC using TSC
> offset 2950.
> 
> For the backward case, trace data are as follows:
> 
> <    host   >               <   guest   >
> cycles    events           cycles   events
>  3000   tsc_offset=-2950
>  3001   kvm_enter
>                              53     eventX
>                                      ....
>                             100     (write_tsc=-50)
>  3060   kvm_exit
>  3075   tsc_offset=-2050
>  3080   kvm_enter
>                              90     event1
>                              95     event2
>                                      ...

   3400		               100    (write_tsc=-50)

				90    event3
				95    event4

> As you say, in this case, the previous method is invalid. When we
> calculate the guest TSC value for the tsc_offset=-3000 event, the value
> is 75 on the guest. This seems like prior event of write_tsc=-50 event.
> So, we need to consider more.
> 
> In this case, it is important that we can understand where the guest
> executes write_tsc or the host rewrites the TSC offset. write_tsc on
> the guest equals wrmsr 0x00000010, so this instruction induces vm_exit.
> This implies that the guest does not operate when the host changes TSC
> offset on the cpu. In other words, the guest cannot use new TSC before
> the host rewrites the new TSC offset. So, if timestamp on the guest is
> not monotonically increased, we can understand the guest executes
> write_tsc. Moreover, in the region where timestamp is decreasing, we
> can understand when the host rewrote the TSC offset in the guest trace
> data. Therefore, we can sort trace data in chronological order.

This requires an entire trace of events. That is, to be able
to reconstruct timeline you require the entire trace from the moment
guest starts. So that you can correlate wrmsr-to-tsc on the guest with
vmexit-due-to-tsc-write on the host.

Which means that running out of space for trace buffer equals losing
ability to order events.

Is that desirable? It seems cumbersome to me.

Also the need to correlate each write_tsc event in the guest trace
with a corresponding tsc_offset write in the host trace means that it 
is _necessary_ for the guest and host to enable tracing simultaneously.
Correct?

Also, there are WRMSR executions in the guest for which there is 
no event in the trace buffer. From SeaBIOS, during boot.
In that case, there is no explicit event in the guest trace which you 
can correlate with tsc_offset changes in the host side.

If the guest had access to the host TSC value, these complications
would disappear.

