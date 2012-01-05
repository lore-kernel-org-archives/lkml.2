Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2AESSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:18:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab2AESS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:18:29 -0500
Date: Thu, 5 Jan 2012 13:17:53 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86, reboot: Use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20120105181753.GH5650@redhat.com>
References: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
 <tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
 <CAE9FiQWX_2bV1phLCUrEpiPSfo24xWEv3Y+DZnwmi9JJgJHbmQ@mail.gmail.com>
 <20111221145928.GP5650@redhat.com>
 <CAE9FiQUW5tf5-Fbn0a_8s58P+7rXbG6iWPaDeHOuhxw4TZE+hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUW5tf5-Fbn0a_8s58P+7rXbG6iWPaDeHOuhxw4TZE+hQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 10:24:53AM -0800, Yinghai Lu wrote:
> On Wed, Dec 21, 2011 at 6:59 AM, Don Zickus <dzickus@redhat.com> wrote:
> > On Tue, Dec 20, 2011 at 02:38:39PM -0800, Yinghai Lu wrote:
> >> > @@ -230,7 +285,7 @@ struct smp_ops smp_ops = {
> >> >        .smp_prepare_cpus       = native_smp_prepare_cpus,
> >> >        .smp_cpus_done          = native_smp_cpus_done,
> >> >
> >> > -       .stop_other_cpus        = native_stop_other_cpus,
> >> > +       .stop_other_cpus        = native_nmi_stop_other_cpus,
> >> >        .smp_send_reschedule    = native_smp_send_reschedule,
> >> >
> >> >        .cpu_up                 = native_cpu_up,
> >>
> >> this broke kexec on our intel nehalem, westmere and sandbridge platforms.
> >> system get reset while try to kexec second kernel.
> >
> >
> > Hmm. Ok.  Does the reboot path work correctly?
> 
> Yes.
> 
> > Vivek showed me that the
> > kexec and reboot paths do the same shutdowns.  Perhaps the second kernel
> > has trouble dealing with cpus spinning in an NMI context and can't
> > properly reset them.
> 
> not sure.
> when use nonmi_ipi in first kernel, it will work well.

Hi Yinghai,

Sorry for the delay.  I figured out the problem, one of those brown paper
bag moments. :-(

I think this patch should fix your issue (it did on my system).

--->8----
From: Don Zickus <dzickus@redhat.com>
Date: Thu, 5 Jan 2012 13:06:58 -0500
Subject: [PATCH] x86, reboot: typo in nmi reboot path

It was brought to my attention that my x86 change to use NMI in the
reboot path broke Intel Nehalem and Westmere boxes when using kexec.

I realized I had mistyped the if statement in commit
3603a2512f9e69dc87914ba922eb4a0812b21cd6 and stuck the ')' in
the wrong spot.  Putting it in the right spot fixes kexec again.

Doh.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index e72b175..3f3d3f0 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -176,7 +176,7 @@ static void native_nmi_stop_other_cpus(int wait)
 	 */
 	if (num_online_cpus() > 1) {
 		/* did someone beat us here? */
-		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id() != -1))
+		if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
 			return;
 
 		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
-- 
1.7.7.4

