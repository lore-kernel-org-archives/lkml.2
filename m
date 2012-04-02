Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2DBEqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 00:46:11 -0400
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:64668 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2DBEqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 00:46:08 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2012 00:46:07 EDT
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=hNLpKMTrts1AMurHRPQF3jd8x6CSfokvRnHybgtttQKL2t1N88uT0yp5
   UdIjXaaMYeMFgNyWd1j13pWMVpHdE34amj9nX6sN3PLpN/SF7JKhhoqyl
   2nFhO+tjb1YJIgusuaa5MTqLOl32GVJTpT/6Unt6wfAJevzrfUggJ01uQ
   n/ULTJUikZD4V9oDsYCgbXKlJIO/I3IgvOYZgaKR7pQ8VMkSvGILzyXSZ
   8A+KVgGXOklnM7cuxU9vi2YCX/yF0;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.75,355,1330902000"; 
   d="scan'208";a="106495614"
X-IronPort-AV: E=Sophos;i="4.75,355,1330902000"; 
   d="scan'208";a="131759793"
Message-ID: <4F792CBA.1010402@ts.fujitsu.com>
Date: Mon, 02 Apr 2012 06:36:10 +0200
From: Juergen Gross <juergen.gross@ts.fujitsu.com>
Organization: Fujitsu Technology Solutions
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Attilio Rao <attilio.rao@citrix.com>, Ingo Molnar <mingo@elte.hu>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Subject: Re: [Xen-devel] [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>	<4F7616F5.4070000@zytor.com> <alpine.LFD.2.02.1203302333560.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1203302333560.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 12:07 AM, Thomas Gleixner wrote:
> On Fri, 30 Mar 2012, H. Peter Anvin wrote:
>
>> What is the current status of this patchset?  I haven't looked at it too
>> closely because I have been focused on 3.4 up until now...
> The real question is whether these heuristics are the correct approach
> or not.
>
> If I look at it from the non virtualized kernel side then this is ass
> backwards. We know already that we are holding a spinlock which might
> cause other (v)cpus going into eternal spin. The non virtualized
> kernel solves this by disabling preemption and therefor getting out of
> the critical section as fast as possible,
>
> The virtualization problem reminds me a lot of the problem which RT
> kernels are observing where non raw spinlocks are turned into
> "sleeping spinlocks" and therefor can cause throughput issues for non
> RT workloads.
>
> Though the virtualized situation is even worse. Any preempted guest
> section which holds a spinlock is prone to cause unbound delays.
>
> The paravirt ticketlock solution can only mitigate the problem, but
> not solve it. With massive overcommit there is always a way to trigger
> worst case scenarious unless you are educating the scheduler to cope
> with that.
>
> So if we need to fiddle with the scheduler and frankly that's the only
> way to get a real gain (the numbers, which are achieved by this
> patches, are not that impressive) then the question arises whether we
> should turn the whole thing around.
>
> I know that Peter is going to go berserk on me, but if we are running
> a paravirt guest then it's simple to provide a mechanism which allows
> the host (aka hypervisor) to check that in the guest just by looking
> at some global state.
>
> So if a guest exits due to an external event it's easy to inspect the
> state of that guest and avoid to schedule away when it was interrupted
> in a spinlock held section. That guest/host shared state needs to be
> modified to indicate the guest to invoke an exit when the last nested
> lock has been released.
>
> Of course this needs to be time bound, so a rogue guest cannot
> monopolize the cpu forever, but that's the least to worry about
> problem simply because a guest which does not get out of a spinlocked
> region within a certain amount of time is borked and elegible to
> killing anyway.
>
> Thoughts ?

I used this approach in 2008:

http://lists.xen.org/archives/html/xen-devel/2008-12/msg00740.html

It worked very well, but it was rejected at that time. I wouldn't mind trying
it again if there is some support from your side. :-)


Juergen

-- 

Juergen Gross                 Principal Developer Operating Systems
PDG ES&S SWE OS6                       Telephone: +49 (0) 89 3222 2967
Fujitsu Technology Solutions              e-mail: juergen.gross@ts.fujitsu.com
Domagkstr. 28                           Internet: ts.fujitsu.com
D-80807 Muenchen                 Company details: ts.fujitsu.com/imprint.html

