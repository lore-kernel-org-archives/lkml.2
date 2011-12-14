Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab1LNMTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:19:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab1LNMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:19:43 -0500
Date: Wed, 14 Dec 2011 10:16:22 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111214121622.GB18317@amt.cnet>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <4EDF7B0D.4060001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDF7B0D.4060001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:41:17PM +0200, Avi Kivity wrote:
> On 12/05/2011 10:18 PM, Eric B Munson wrote:
> > Changes from V4:
> > Rename KVM_GUEST_PAUSED to KVMCLOCK_GUEST_PAUSED
> > Add description of KVMCLOCK_GUEST_PAUSED ioctl to api.txt
> >
> > Changes from V3:
> > Include CC's on patch 3
> > Drop clear flag ioctl and have the watchdog clear the flag when it is reset
> >
> > Changes from V2:
> > A new kvm functions defined in kvm_para.h, the only change to pvclock is the
> > initial flag definition
> >
> > Changes from V1:
> > (Thanks Marcelo)
> > Host code has all been moved to arch/x86/kvm/x86.c
> > KVM_PAUSE_GUEST was renamed to KVM_GUEST_PAUSED
> >
> > When a guest kernel is stopped by the host hypervisor it can look like a soft
> > lockup to the guest kernel.  This false warning can mask later soft lockup
> > warnings which may be real.  This patch series adds a method for a host
> > hypervisor to communicate to a guest kernel that it is being stopped.  The
> > final patch in the series has the watchdog check this flag when it goes to
> > issue a soft lockup warning and skip the warning if the guest knows it was
> > stopped.
> >
> > It was attempted to solve this in Qemu, but the side effects of saving and
> > restoring the clock and tsc for each vcpu put the wall clock of the guest behind
> > by the amount of time of the pause.  This forces a guest to have ntp running
> > in order to keep the wall clock accurate.
> 
> Having this controlled from userspace means it doesn't work for SIGSTOP
> or for long scheduling delays.  What about doing this automatically
> based on preempt notifiers?

Long scheduling delays should be considered hangups from the guest
perspective.

About SIGSTOP, that is a corner case. Unsure if its even properly supported 
by QEMU.

