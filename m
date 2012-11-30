Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284Ab2K3UnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:43:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab2K3Um5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:42:57 -0500
Date: Fri, 30 Nov 2012 18:42:40 -0200
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
Subject: Re: Re: Re: Re: Re: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC
 offset
Message-ID: <20121130204240.GC22662@amt.cnet>
References: <20121116191537.GB28622@amt.cnet>
 <50AB5D31.7060305@hitachi.com>
 <20121120225148.GA6027@amt.cnet>
 <50ADB650.8080502@hitachi.com>
 <20121123224608.GA23093@amt.cnet>
 <50B34CE6.9070207@hitachi.com>
 <20121126231653.GA20391@amt.cnet>
 <50B49BBB.1020204@hitachi.com>
 <20121129225126.GA28555@amt.cnet>
 <50B80DAB.4030908@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B80DAB.4030908@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 10:36:43AM +0900, Yoshihiro YUNOMAE wrote:
> Hi Marcelo,
> 
> >>>Can you please write a succint but complete description of the method
> >>>so it can be verified?
> >>
> >>Sure.
> >>
> >>- Prerequisite
> >>1. the host TSC is synchronized and stable.
> >>2. kvm_write_tsc_offset events include previous and next TSC offset
> >>    values.
> >>3. Every event's trace_clock is TSC.
> >>
> >>- Assumption for the sake of ease
> >>1. One VCPU
> >>2. The guest executes no write_tsc or write_tsc only once.
> >>
> >>- Configuration
> >>1. On the host, kvm_exit/entry events are recorded in the buffer A and
> >>    kvm_write_tsc_offset events are recorded in the buffer B.
> >>2. Boot a guest
> >>
> >>- Sort method
> >>1.
> >>  Confirm which the kvm_write_tsc_offset events are recorded except for
> >>boot. Note that a vcpu thread writes TSC offset when boot as an initial
> >>operation.
> >>
> >>1-1.
> >>  If not recorded, it means that the guest did not execute write_tsc.
> >>So, we convert the guest TSC to the host TSC using TSC offset of boot.
> >>=> END
> >>
> >>1-2.
> >>  If recorded, it means that the guest executed write_tsc.
> >>So, we use new kvm_write_tsc_offset event information.
> >>
> >>2.
> >>We convert the host TSC(Th) of the kvm_write_tsc_offset event to
> >>the guest TSC(Tg) using previous_tsc_offset value:
> >>     Tg = Th + previous_tsc_offset
> >>
> >>3.
> >>To search the point where the guest executed write_tsc, we find "n"
> >>which satisfies the condition Tn < Tg < Tn+1 or Tn+1 < Tn < Tg from
> >>older events of the guest.
> >>The former condition means trace data of
> >>the guest were recorded monotonically. On the other hand, the latter
> >>condition means trace data of the guest moved backward.
> >>4.
> >>We convert the guest TSC of trace data to the host TSC using
> >>previous_tsc_offset value before "n" and using next_tsc_offset value
> >>after "n+1".
> >>=> END
> >>
> >>- Note
> >>We assumed one vcpu and no write_tsc or write_tsc only once for the
> >>sake of ease. For other conditions, we will use similar method.
> >>
> >>Thanks,
> >
> >There is no certainty. Consider the following information available
> >
> >guest trace			host trace
> >				100: guest_tsc_write (tsc_offset=-100 => guest_tsc = 0)
> >				104: guest_tsc_write (tsc_offset=-104 => guest_tsc = 0)
> >				108: guest_tsc_write (tsc_offset=-108 => guest_tsc = 0)
> >1: eventA 			
> >2: eventB
> >3: eventC
> >1: eventD
> >2: eventE
> >3: eventF
> >
> >How can you tell which tsc_offset to use for eventD ? It could be either
> >-104 or -108. The notion of "next_tsc_offset" is subject to such
> >issue.
> >
> >I suppose its fine to restrict the interface as follows: the tool will
> >accept one trace of events with monotonic timestamps and the user is
> >responsible for correlating that to a host trace.
> 
> OK, I'll add the restriction, which trace data must have monotonic
> timestamps to use this feature. I think guests seldom will execute
> write_tsc, so in many cases, timestamps will be monotonically recorded
> in trace data.
> 
> >That is, you can't feed distinct instances of guest kernel trace.
> 
> I'm not clear for "distinct instances". Is this about SMP or multiple
> guests? Would you explain about this?

Distinct boot instances. If the guest reboots TSC can be written to.

