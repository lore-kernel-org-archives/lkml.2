Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0HCFde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:33:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55282 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0HCFdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:33:32 -0400
Date: Tue, 3 Aug 2010 11:03:27 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>, peterz@infradead.org, mingo@elte.hu,
        efault@gmx.de
Subject: Re: [PATCH RFC 2/4] Add yield hypercall for KVM guests
Message-ID: <20100803053327.GC29526@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20100726061150.GB21699@linux.vnet.ibm.com>
 <20100726061445.GB8402@linux.vnet.ibm.com>
 <4C4DC3AD.7010404@goop.org>
 <20100728145516.GB27739@linux.vnet.ibm.com>
 <4C568477.4000602@redhat.com>
 <20100803051659.GB29526@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803051659.GB29526@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 10:46:59AM +0530, Srivatsa Vaddagiri wrote:
> On Mon, Aug 02, 2010 at 11:40:23AM +0300, Avi Kivity wrote:
> > >>Can you do a directed yield?
> > >We don't have that support yet in Linux scheduler.
> > 
> > If you think it's useful, it would be good to design it into the
> > interface, and fall back to ordinary yield if the host doesn't
> > support it.
> > 
> > A big advantage of directed yield vs yield is that you conserve
> > resources within a VM; a simple yield will cause the guest to drop
> > its share of cpu to other guest.
> 
> Hmm .. I see possibility of modifying yield to reclaim its "lost" timeslice when
> its scheduled next as well. Basically remember what timeslice we have given
> up and add that as its "bonus" when it runs next. That would keep the dynamics
> of yield donation/reclaim local to the (physical) cpu and IMHO is less complex
> than dealing with directed yield between tasks located across different physical
> cpus. That would also address the fairness issue with yield you are pointing at?

Basically with directed yield, we need to deal with these issues:

- Timeslice inflation of target (lock-holder) vcpu affecting fair-time of other
  guests vcpus.
- Intra-VM fairness - different vcpus could get different fair-time, depending
  on how much of a lock-holder/spinner a vcpu is

By simply educating yield to reclaim its lost share, I feel we can avoid these
complexities and get most of the benefit of yield-on-contention.

CCing other shceduler experts for their opinion of directed yield.

- vatsa
