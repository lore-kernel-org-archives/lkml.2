Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1C2MiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:38:24 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36562 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1C2MiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:38:23 -0400
Subject: Re: [patch v2 1/3] This patch adds support for hardware based
 sampling on System z processors (models z10 and up)
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
In-Reply-To: <20110325110013.GW31407@erda.amd.com>
References: <20110121100651.821690659@linux.vnet.ibm.com>
	 <20110121100841.879534437@linux.vnet.ibm.com>
	 <20110325110013.GW31407@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 14:38:04 +0200
Message-ID: <1301402284.3343.27.camel@BR8HFPP0.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 12:00 +0100, Robert Richter wrote: 
> On 21.01.11 05:06:52, Heinz Graalfs wrote:
> > From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> > 
> > System z's hardware sampling is described in detail in:
> > 
> >    SA23-2260-01 "The Load-Program-Parameter and CPU-Measurement Facilities"
> > 
> > The patch introduces
> >  - support for System z's hardware sampler in OProfile's kernel module
> >  - it adds functions that control all hardware sampling related operations as
> >   - checking if hardware sampling feature is available
> >     - ie: on System z models z10 and up, in LPAR mode only, and authorised during LPAR activation
> >   - allocating memory for the hardware sampling feature
> >   - starting/stopping hardware sampling
> > 
> > All functions required to start and stop hardware sampling have to be
> > invoked by the oprofile kernel module as provided by the other patches of this patch set.
> > 
> > In case hardware based sampling cannot be setup standard timer based sampling is used by OProfile.
> > 
> > Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> > Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
> > Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> > ---
> >  arch/Kconfig                   |    3
> >  arch/s390/Kconfig              |    1
> >  arch/s390/oprofile/hwsampler.c | 1256 +++++++++++++++++++++++++++++++++++++++++
> >  arch/s390/oprofile/hwsampler.h |  113 +++
> >  4 files changed, 1373 insertions(+)
> 
> > +int hwsampler_setup()
> > +{
> > +       int rc;
> > +       int cpu;
> > +       struct hws_cpu_buffer *cb;
> > +
> > +       mutex_lock(&hws_sem);
> > +
> > +       rc = -EINVAL;
> > +       if (hws_state)
> > +               goto setup_exit;
> > +
> > +       hws_state = HWS_INIT;
> 
> hws_state is never set to zero again, so we will pass this point only
> one time, even after hwsampler_shutdown(). Is this intended? Only
> loading and unloading this as module would work.
> 
> Maybe we clear hws_state in hwsampler_shutdown()?
> 
> -Robert
> 
yes, the intent is:
hwsampler_setup() is called on module load - oprofile_arch_init()
and 
hwsampler_shutdown() is called on unload - oprofile_arch_exit()

hws_state is reset in hwsampler_shutdown()

hwsampler_shutdown processing only succeeds if we are in states
HWS_DEALLOCATED or HWS_STOPPED.
Usually this is ensured by the current approach the functions are
called, and in this case hws_state is also reset to HWS_INIT.

In case hwsampler_shutdown is called in other 'invalid states' it should
return -EINVAL.
However, in this case, the unregister_cpu_notifier() would be executed,
which is not good and should be avoided.

Although, current processing, never calls hwsampler_shutdown() in
invalid states, I suppose, it might better if we do the unregister call
as intended only if hwsampler_shutdown succeeds.

I will submit a separate patch.

Heinz

> > +
> > +       init_all_cpu_buffers();
> > +
> > +       rc = check_hardware_prerequisites();
> > +       if (rc)
> > +               goto setup_exit;
> > +
> > +       rc = check_qsi_on_setup();
> > +       if (rc)
> > +               goto setup_exit;
> > +
> > +       rc = -EINVAL;
> > +       hws_wq = create_workqueue("hwsampler");
> > +       if (!hws_wq)
> > +               goto setup_exit;
> > +
> > +       register_cpu_notifier(&hws_cpu_notifier);
> > +
> > +       for_each_online_cpu(cpu) {
> > +               cb = &per_cpu(sampler_cpu_buffer, cpu);
> > +               INIT_WORK(&cb->worker, worker);
> > +               rc = smp_ctl_qsi(cpu);
> > +               WARN_ON(rc);
> > +               if (min_sampler_rate != cb->qsi.min_sampl_rate) {
> > +                       if (min_sampler_rate) {
> > +                               printk(KERN_WARNING
> > +                                       "hwsampler: different min sampler rate values.\n");
> > +                               if (min_sampler_rate < cb->qsi.min_sampl_rate)
> > +                                       min_sampler_rate =
> > +                                               cb->qsi.min_sampl_rate;
> > +                       } else
> > +                               min_sampler_rate = cb->qsi.min_sampl_rate;
> > +               }
> > +               if (max_sampler_rate != cb->qsi.max_sampl_rate) {
> > +                       if (max_sampler_rate) {
> > +                               printk(KERN_WARNING
> > +                                       "hwsampler: different max sampler rate values.\n");
> > +                               if (max_sampler_rate > cb->qsi.max_sampl_rate)
> > +                                       max_sampler_rate =
> > +                                               cb->qsi.max_sampl_rate;
> > +                       } else
> > +                               max_sampler_rate = cb->qsi.max_sampl_rate;
> > +               }
> > +       }
> > +       register_external_interrupt(0x1407, hws_ext_handler);
> > +
> > +       hws_state = HWS_DEALLOCATED;
> > +       rc = 0;
> > +
> > +setup_exit:
> > +       mutex_unlock(&hws_sem);
> > +       return rc;
> > +}
> > +
> > +int hwsampler_shutdown()
> > +{
> > +       int rc;
> > +
> > +       mutex_lock(&hws_sem);
> > +
> > +       rc = -EINVAL;
> > +       if (hws_state == HWS_DEALLOCATED || hws_state == HWS_STOPPED) {
> > +               mutex_unlock(&hws_sem);
> > +
> > +               if (hws_wq)
> > +                       flush_workqueue(hws_wq);
> > +
> > +               mutex_lock(&hws_sem);
> > +
> > +               if (hws_state == HWS_STOPPED) {
> > +                       smp_ctl_clear_bit(0, 5); /* set bit 58 CR0 off */
> > +                       deallocate_sdbt();
> > +               }
> > +               if (hws_wq) {
> > +                       destroy_workqueue(hws_wq);
> > +                       hws_wq = NULL;
> > +               }
> > +
> > +               unregister_external_interrupt(0x1407, hws_ext_handler);
> > +               hws_state = HWS_INIT;
> > +               rc = 0;
> > +       }
> > +       mutex_unlock(&hws_sem);
> > +
> > +       unregister_cpu_notifier(&hws_cpu_notifier);
> > +
> > +       return rc;
> > +}
> 



