Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1LUPAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:00:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab1LUPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:00:00 -0500
Date: Wed, 21 Dec 2011 09:59:28 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86, reboot: Use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20111221145928.GP5650@redhat.com>
References: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
 <tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
 <CAE9FiQWX_2bV1phLCUrEpiPSfo24xWEv3Y+DZnwmi9JJgJHbmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQWX_2bV1phLCUrEpiPSfo24xWEv3Y+DZnwmi9JJgJHbmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 02:38:39PM -0800, Yinghai Lu wrote:
> > @@ -230,7 +285,7 @@ struct smp_ops smp_ops = {
> >        .smp_prepare_cpus       = native_smp_prepare_cpus,
> >        .smp_cpus_done          = native_smp_cpus_done,
> >
> > -       .stop_other_cpus        = native_stop_other_cpus,
> > +       .stop_other_cpus        = native_nmi_stop_other_cpus,
> >        .smp_send_reschedule    = native_smp_send_reschedule,
> >
> >        .cpu_up                 = native_cpu_up,
> 
> this broke kexec on our intel nehalem, westmere and sandbridge platforms.
> system get reset while try to kexec second kernel.


Hmm. Ok.  Does the reboot path work correctly?  Vivek showed me that the
kexec and reboot paths do the same shutdowns.  Perhaps the second kernel
has trouble dealing with cpus spinning in an NMI context and can't
properly reset them.

Let me grab one of those boxes from our lab and try and reproduce the
problem.

Cheers,
Don

> 
> 3603a2512f9e69dc87914ba922eb4a0812b21cd6 is the first bad commit
> commit 3603a2512f9e69dc87914ba922eb4a0812b21cd6
> Author: Don Zickus <dzickus@redhat.com>
> Date:   Thu Oct 13 15:14:25 2011 -0400
> 
>     x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus
> 
>     A recent discussion started talking about the locking on the
>     pstore fs and how it relates to the kmsg infrastructure.  We
>     noticed it was possible for userspace to r/w to the pstore fs
>     (grabbing the locks in the process) and block the panic path
>     from r/w to the same fs.
> 
>     The reason was the cpu with the lock could be doing work while
>     the crashing cpu is panic'ing.  Busting those spinlocks might
>     cause those cpus to step on each other's data.  Fine, fair
>     enough.
> 
>     It was suggested it would be nice to serialize the panic path
>     (ie stop the other cpus) and have only one cpu running.  This
>     would allow us to bust the spinlocks and not worry about another
>     cpu stepping on the data.
> 
>     Of course, smp_send_stop() does this in the panic case.
>     kmsg_dump() would have to be moved to be called after it.  Easy
>     enough.
> 
>     The only problem is on x86 the smp_send_stop() function calls
>     the REBOOT_VECTOR.  Any cpu with irqs disabled (which pstore and
>     its backend ERST would do), block this IPI and thus do not stop.
>      This makes it difficult to reliably log data to the pstore fs.
> 
>     The patch below switches from the REBOOT_VECTOR to NMI (and
>     mimics what kdump does).  Switching to NMI allows us to deliver
>     the IPI when irqs are disabled, increasing the reliability of
>     this function.
> 
>     However, Andi carefully noted that on some machines this
>     approach does not work because of broken BIOSes or whatever.
> 
>     To help accomodate this, the next couple of patches will run a
>     selftest and provide a knob to disable.
> 
>     V2:
>       uses atomic ops to serialize the cpu that shuts everyone down
>     V3:
>       comment cleanup
> 
>     Signed-off-by: Don Zickus <dzickus@redhat.com>
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Robert Richter <robert.richter@amd.com>
>     Cc: seiji.aguchi@hds.com
>     Cc: vgoyal@redhat.com
>     Cc: mjg@redhat.com
>     Cc: tony.luck@intel.com
>     Cc: gong.chen@intel.com
>     Cc: satoru.moriya@hds.com
>     Cc: avi@redhat.com
>     Cc: Andi Kleen <andi@firstfloor.org>
>     Link:
> http://lkml.kernel.org/r/1318533267-18880-2-git-send-email-dzickus@redhat.com
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 47a646e9ead83f34fb0728d88c786c875fab91dd
> 6f7a6d5ad8ed686199c0dfbc748ee07a0db97cc5 M      arch
