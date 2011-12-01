Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1LAV1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:27:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab1LAV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:27:13 -0500
Date: Thu, 1 Dec 2011 19:25:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Eric B Munson <emunson@mgebm.net>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "ryanh@linux.vnet.ibm.com" <ryanh@linux.vnet.ibm.com>,
        "aliguori@us.ibm.com" <aliguori@us.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH] Guest stop notification
Message-ID: <20111201212503.GB25290@amt.cnet>
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
 <4ED79138.60603@siemens.com>
 <20111201172244.GB8803@mgebm.net>
 <4ED7BB11.1050309@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED7BB11.1050309@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 06:36:17PM +0100, Jan Kiszka wrote:
> On 2011-12-01 18:22, Eric B Munson wrote:
> > On Thu, 01 Dec 2011, Jan Kiszka wrote:
> > 
> >> On 2011-11-29 22:36, Eric B Munson wrote:
> >>> Often when a guest is stopped from the qemu console, it will report spurious
> >>> soft lockup warnings on resume.  There are kernel patches being discussed that
> >>> will give the host the ability to tell the guest that it is being stopped and
> >>> should ignore the soft lockup warning that generates.
> >>>
> >>> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> >>> Cc: ryanh@linux.vnet.ibm.com
> >>> Cc: aliguori@us.ibm.com
> >>> Cc: mtosatti@redhat.com
> >>> Cc: avi@redhat.com
> >>> Cc: kvm@vger.kernel.org
> >>> Cc: linux-kernel@vger.kernel.org
> >>> ---
> >>>  target-i386/kvm.c |    6 ++++++
> >>>  1 files changed, 6 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> >>> index 5bfc21f..defd364 100644
> >>> --- a/target-i386/kvm.c
> >>> +++ b/target-i386/kvm.c
> >>> @@ -336,12 +336,18 @@ static int kvm_inject_mce_oldstyle(CPUState *env)
> >>>      return 0;
> >>>  }
> >>>  
> >>> +static void kvm_put_guest_paused(CPUState *penv)
> >>> +{
> >>> +    kvm_vcpu_ioctl(penv, KVM_GUEST_PAUSED, 0);
> >>> +}
> >>
> >> I see no need in encapsulating this in a separate function.
> >>
> >>> +
> >>>  static void cpu_update_state(void *opaque, int running, RunState state)
> >>>  {
> >>>      CPUState *env = opaque;
> >>>  
> >>>      if (running) {
> >>>          env->tsc_valid = false;
> >>> +	kvm_put_guest_paused(env);
> >>
> >> checkpatch.pl would have asked you to remove this tab.
> >>
> >> More general:
> >>
> >> Why is this x86-only? If the kernel interface is x86-only, what prevents
> >> making it generic right from the beginning?
> > 
> > Sorry, missed this question on the first pass, this is x86 only because the
> > flag used lives in the pvclock structure.  AFAICT, there aren't any other
> > architectures out there that implement paravirtualized clocks yet.
> 
> That's an implementation "detail" of the kernel. The interface (IOCTL or
> kvm_run field) is generic, no?
> 
> I would just fire this notification from generic code, evaluate the
> error (that was lacking so far), and only report it if it's something
> else than "not supported".

Yes, it should live in hw/kvmclock.c preferably.

