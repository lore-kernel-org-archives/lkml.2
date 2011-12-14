Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1LNMTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:19:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab1LNMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:19:42 -0500
Date: Wed, 14 Dec 2011 10:11:24 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Avi Kivity <avi@redhat.com>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5 V5] Add functions to check if the host has stopped
 the vm
Message-ID: <20111214121124.GA18317@amt.cnet>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <1323116344-17911-3-git-send-email-emunson@mgebm.net>
 <4EDF78C5.8060908@redhat.com>
 <20111208152310.GB6301@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208152310.GB6301@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 10:23:10AM -0500, Eric B Munson wrote:
> On Wed, 07 Dec 2011, Avi Kivity wrote:
> 
> > On 12/05/2011 10:19 PM, Eric B Munson wrote:
> > > When a host stops or suspends a VM it will set a flag to show this.  The
> > > watchdog will use these functions to determine if a softlockup is real, or the
> > > result of a suspended VM.
> > >  
> > > +bool kvm_check_and_clear_guest_paused(int cpu)
> > > +{
> > > +	bool ret = false;
> > > +	struct pvclock_vcpu_time_info *src;
> > > +
> > > +	/*
> > > +	 * per_cpu() is safe here because this function is only called from
> > > +	 * timer functions where preemption is already disabled.
> > > +	 */
> > > +	WARN_ON(!in_atomic());
> > > +	src = &per_cpu(hv_clock, cpu);
> > 
> > __get_cpu_var(); drop the cpu argument
> > 
> 
> Will change for V6.
> 
> > > +	if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
> > > +		src->flags = src->flags & (~PVCLOCK_GUEST_STOPPED);
> > 
> > Isn't this racy?  Between reading and writing src->flags, we can exit to
> > the hypervisor and add/remove new flags.  The write then overrides those
> > new flags.
> > 
> 
> If I understand (please correct me if this is wrong) because this is only
> called from the watchdog, which disables preemption, we should be protected
> from something else writing to these flags.

The host can write, but in that case race is harmless.

