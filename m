Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2K2WwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:52:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab2K2WwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:52:06 -0500
Date: Thu, 29 Nov 2012 20:51:26 -0200
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
Subject: Re: Re: Re: Re: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
Message-ID: <20121129225126.GA28555@amt.cnet>
References: <1352860305.18025.48.camel@gandalf.local.home>
 <50A355A2.5040101@hitachi.com>
 <20121116191537.GB28622@amt.cnet>
 <50AB5D31.7060305@hitachi.com>
 <20121120225148.GA6027@amt.cnet>
 <50ADB650.8080502@hitachi.com>
 <20121123224608.GA23093@amt.cnet>
 <50B34CE6.9070207@hitachi.com>
 <20121126231653.GA20391@amt.cnet>
 <50B49BBB.1020204@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B49BBB.1020204@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 07:53:47PM +0900, Yoshihiro YUNOMAE wrote:
> Hi Marcelo,
> 
> (2012/11/27 8:16), Marcelo Tosatti wrote:
> >On Mon, Nov 26, 2012 at 08:05:10PM +0900, Yoshihiro YUNOMAE wrote:
> >>>>>500h. event tsc_write tsc_offset=-3000
> >>>>>
> >>>>>Then a guest trace containing events with a TSC timestamp.
> >>>>>Which tsc_offset to use?
> >>>>>
> >>>>>(that is the problem, which unless i am mistaken can only be solved
> >>>>>easily if the guest can convert RDTSC -> TSC of host).
> >>>>
> >>>>There are three following cases of changing TSC offset:
> >>>>  1. Reset TSC at guest boot time
> >>>>  2. Adjust TSC offset due to some host's problems
> >>>>  3. Write TSC on guests
> >>>>The scenario which you mentioned is case 3, so we'll discuss this case.
> >>>>Here, we assume that a guest is allocated single CPU for the sake of
> >>>>ease.
> >>>>
> >>>>If a guest executes write_tsc, TSC values jumps to forward or backward.
> >>>>For the forward case, trace data are as follows:
> >>>>
> >>>><    host   >               <   guest   >
> >>>>cycles    events           cycles   events
> >>>>  3000   tsc_offset=-2950
> >>>>  3001   kvm_enter
> >>>>                              53     eventX
> >>>>                                      ....
> >>>>                             100     (write_tsc=+900)
> >>>>  3060   kvm_exit
> >>>>  3075   tsc_offset=-2050
> >>>>  3080   kvm_enter
> >>>>                            1050     event1
> >>>>                            1055     event2
> >>>>                                      ...
> >>>>
> >>>>
> >>>>This case is simple. The guest TSC of the first kvm_enter is calculated
> >>>>as follows:
> >>>>
> >>>>   (host TSC of kvm_enter) + (current tsc_offset) = 3001 - 2950 = 51
> >>>>
> >>>>Similarly, the guest TSC of the second kvm_enter is 130. So, the guest
> >>>>events between 51 and 130, that is, 53 eventX is inserted between the
> >>>>first pair of kvm_enter and kvm_exit. To insert events of the guests
> >>>>between 51 and 130, we convert the guest TSC to the host TSC using TSC
> >>>>offset 2950.
> >>>>
> >>>>For the backward case, trace data are as follows:
> >>>>
> >>>><    host   >               <   guest   >
> >>>>cycles    events           cycles   events
> >>>>  3000   tsc_offset=-2950
> >>>>  3001   kvm_enter
> >>>>                              53     eventX
> >>>>                                      ....
> >>>>                             100     (write_tsc=-50)
> >>>>  3060   kvm_exit
> >>>>  3075   tsc_offset=-2050
> >>>>  3080   kvm_enter
> >>>>                              90     event1
> >>>>                              95     event2
> >>>>                                      ...
> >>>
> >>>    3400		               100    (write_tsc=-50)
> >>>
> >>>				90    event3
> >>>				95    event4
> >>>
> >>>>As you say, in this case, the previous method is invalid. When we
> >>>>calculate the guest TSC value for the tsc_offset=-3000 event, the value
> >>>>is 75 on the guest. This seems like prior event of write_tsc=-50 event.
> >>>>So, we need to consider more.
> >>>>
> >>>>In this case, it is important that we can understand where the guest
> >>>>executes write_tsc or the host rewrites the TSC offset. write_tsc on
> >>>>the guest equals wrmsr 0x00000010, so this instruction induces vm_exit.
> >>>>This implies that the guest does not operate when the host changes TSC
> >>>>offset on the cpu. In other words, the guest cannot use new TSC before
> >>>>the host rewrites the new TSC offset. So, if timestamp on the guest is
> >>>>not monotonically increased, we can understand the guest executes
> >>>>write_tsc. Moreover, in the region where timestamp is decreasing, we
> >>>>can understand when the host rewrote the TSC offset in the guest trace
> >>>>data. Therefore, we can sort trace data in chronological order.
> >>>
> >>>This requires an entire trace of events. That is, to be able
> >>>to reconstruct timeline you require the entire trace from the moment
> >>>guest starts. So that you can correlate wrmsr-to-tsc on the guest with
> >>>vmexit-due-to-tsc-write on the host.
> >>>
> >>>Which means that running out of space for trace buffer equals losing
> >>>ability to order events.
> >>>
> >>>Is that desirable? It seems cumbersome to me.
> >>
> >>As you say, tracing events can overwrite important events like
> >>kvm_exit/entry or write_tsc_offset. So, Steven's multiple buffer is
> >>needed by this feature. Normal events which often hit record the buffer
> >>A, and important events which rarely hit record the buffer B. In our
> >>case, the important event is write_tsc_offset.
> >>>Also the need to correlate each write_tsc event in the guest trace
> >>>with a corresponding tsc_offset write in the host trace means that it
> >>>is _necessary_ for the guest and host to enable tracing simultaneously.
> >>>Correct?
> >>>
> >>>Also, there are WRMSR executions in the guest for which there is
> >>>no event in the trace buffer. From SeaBIOS, during boot.
> >>>In that case, there is no explicit event in the guest trace which you
> >>>can correlate with tsc_offset changes in the host side.
> >>
> >>I understand that you want to say, but we don't correlate between
> >>write_tsc event and write_tsc_offset event directly. This is because
> >>the write_tsc tracepoint (also WRMSR instruction) is not prepared in
> >>the current kernel. So, in the previous mail
> >>(https://lkml.org/lkml/2012/11/22/53), I suggested the method which we
> >>don't need to prepare the write_tsc tracepoint.
> >>
> >>In the method, we enable ftrace before the guest boots, and we need to
> >>keep all write_tsc_offset events in the buffer. If we forgot enabling
> >>ftrace or we don't use multiple buffers, we don't use this feature.
> >
> >Yoshihiro,
> >
> >Better have a single method to convert guest TSC to host TSC.
> >
> >Ok, if you keep both TSC offset write events and guest TSC writes (*)
> >in separate buffers which are persistent, then you can convert
> >guest-tsc-events to host-tsc.
> >
> >Can you please write a succint but complete description of the method
> >so it can be verified?
> 
> Sure.
> 
> - Prerequisite
> 1. the host TSC is synchronized and stable.
> 2. kvm_write_tsc_offset events include previous and next TSC offset
>    values.
> 3. Every event's trace_clock is TSC.
> 
> - Assumption for the sake of ease
> 1. One VCPU
> 2. The guest executes no write_tsc or write_tsc only once.
> 
> - Configuration
> 1. On the host, kvm_exit/entry events are recorded in the buffer A and
>    kvm_write_tsc_offset events are recorded in the buffer B.
> 2. Boot a guest
> 
> - Sort method
> 1.
>  Confirm which the kvm_write_tsc_offset events are recorded except for
> boot. Note that a vcpu thread writes TSC offset when boot as an initial
> operation.
> 
> 1-1.
>  If not recorded, it means that the guest did not execute write_tsc.
> So, we convert the guest TSC to the host TSC using TSC offset of boot.
> => END
> 
> 1-2.
>  If recorded, it means that the guest executed write_tsc.
> So, we use new kvm_write_tsc_offset event information.
> 
> 2.
> We convert the host TSC(Th) of the kvm_write_tsc_offset event to
> the guest TSC(Tg) using previous_tsc_offset value:
>     Tg = Th + previous_tsc_offset
> 
> 3.
> To search the point where the guest executed write_tsc, we find "n"
> which satisfies the condition Tn < Tg < Tn+1 or Tn+1 < Tn < Tg from
> older events of the guest. 
> The former condition means trace data of
> the guest were recorded monotonically. On the other hand, the latter
> condition means trace data of the guest moved backward.
> 4.
> We convert the guest TSC of trace data to the host TSC using
> previous_tsc_offset value before "n" and using next_tsc_offset value
> after "n+1".
> => END
> 
> - Note
> We assumed one vcpu and no write_tsc or write_tsc only once for the
> sake of ease. For other conditions, we will use similar method.
> 
> Thanks,

There is no certainty. Consider the following information available

guest trace			host trace
				100: guest_tsc_write (tsc_offset=-100 => guest_tsc = 0)
				104: guest_tsc_write (tsc_offset=-104 => guest_tsc = 0)
				108: guest_tsc_write (tsc_offset=-108 => guest_tsc = 0)
1: eventA 			
2: eventB
3: eventC
1: eventD
2: eventE
3: eventF

How can you tell which tsc_offset to use for eventD ? It could be either
-104 or -108. The notion of "next_tsc_offset" is subject to such
issue.

I suppose its fine to restrict the interface as follows: the tool will
accept one trace of events with monotonic timestamps and the user is
responsible for correlating that to a host trace.

That is, you can't feed distinct instances of guest kernel trace.

