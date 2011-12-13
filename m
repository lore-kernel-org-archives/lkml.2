Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1LMJre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:47:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1LMJrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:47:32 -0500
Date: Tue, 13 Dec 2011 11:47:28 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Liu ping fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, jan.kiszka@web.de
Subject: Re: [PATCH v3] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111213094728.GC12029@redhat.com>
References: <20111209142303.GC31323@redhat.com>
 <1323657683-13934-1-git-send-email-kernelfans@gmail.com>
 <20111212125440.GF31234@redhat.com>
 <CAFgQCTuuSx6jDy_Q-7mrqpQF0sSDiwEV+eZ-7HCV_PLxnDn-RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFgQCTuuSx6jDy_Q-7mrqpQF0sSDiwEV+eZ-7HCV_PLxnDn-RA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 05:29:50PM +0800, Liu ping fan wrote:
> On Mon, Dec 12, 2011 at 8:54 PM, Gleb Natapov <gleb@redhat.com> wrote:
> > On Mon, Dec 12, 2011 at 10:41:23AM +0800, Liu Ping Fan wrote:
> >> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> >>
> >> Currently, vcpu can be destructed only when kvm instance destroyed.
> >> Change this to vcpu's destruction taken when its refcnt is zero,
> >> and then vcpu MUST and CAN be destroyed before kvm's destroy.
> >>
> > Please drop all printks that you add. You do not use rcu_assign_pointer()
> > during vcpu creation and BTW the code there is incorrect now. It assumed
> > that online_vcpus is never decremented so it is OK to put newly created
> > vcpu into kvm->vcpus[kvm->online_vcpus], but now it is not longer true.
> > We even have BUG_ON() to catch that which I believe you can trigger with
> > this patch by creating 3 vcpus, removing second one and then adding one
> > more. Moving to rculist would solve this of course, and will simplify
> > code that iterates over all vcpus too.
> >
> OK, it seems unavoidable to use rculist now :-).  Just one more question, is it
> useless for "case HV_X64_MSR_VP_INDEX" after adopting rculist?
> 
Windows does not support cpu hot-unplug IIRC. Just return the index of
the vcpu in the vcpus list there.

--
			Gleb.
