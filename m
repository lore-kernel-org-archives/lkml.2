Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2IREmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:42:18 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38814 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2IREmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:42:16 -0400
Date: Mon, 17 Sep 2012 21:42:11 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: myungjoo.ham@samsung.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "khilman@ti.com" <khilman@ti.com>,
        "markgross@thegnar.org" <markgross@thegnar.org>,
        "jean.pihet@newoldbits.com" <jean.pihet@newoldbits.com>,
        "mturquette@ti.com" <mturquette@ti.com>,
        =?utf-8?B?7J207KKF7ZmU?= <jonghwa3.lee@samsung.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v3 1/2] PM / devfreq: add global PM QoS support
Message-ID: <20120918044211.GA19417@MGROSS-X220VM>
Reply-To: markgross@thegnar.org
References: <24667979.34981347880276536.JavaMail.weblogic@epml25>
 <201209172310.09622.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209172310.09622.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 11:10:09PM +0200, Rafael J. Wysocki wrote:
> On Monday, September 17, 2012, MyungJoo Ham wrote:
> > Sender : Rafael J. Wysocki<rjw@sisk.pl>
> > Date : 2012-09-09 07:20 (GMT+09:00)
> > Title : Re: [PATCH v3 1/2] PM / devfreq: add global PM QoS support
> > > On Thursday, August 30, 2012, MyungJoo Ham wrote:
> > > > Even if the performance of a device is controlled properly with devfreq,
> > > > sometimes, we still need to get PM-QoS inputs in order to meet the
> > > > required performance.
> > > > 
> > > > In our testbed of Exynos4412, which has on-chip various DMA devices, the
> > > > memory interface and system bus are controlled according to their
> > > > utilization by devfreq. However, in some multimedia applications
> > > > including video-playing with MFC (multi-function codec) H/W and
> > > > photo/video-capturing with FIMC H/W, we have observed issues due to
> > > > insufficient DMA throughput or latency.
> > > > 
> > > > In such applications, there are deadlines: less than 16.6ms with 60Hz.
> > > > With shorter polling intervals (5 ~ 15ms), the frequencies fluctuate
> > > > within a frame and we get missing frames and distorted pictures.
> > > > With longer polling intervals (20 ~ 100ms), the response time is not
> > > > sufficient and we get distorted or broken images. In other words,
> > > > regardless of polling interval, we get poor results with hard-deadline
> > > > H/Ws. They, in fact, have a preset requirement on DMA throughput.
> > > > 
> > > > Thus, we need PM-QoS capabilities in devfreq. (Note that for general
> > > > user applications, devfreq for bus/memory works fine. They are not so
> > > > sensitive to tens of ms in performance increasing responses in general.
> > > > 
> > > > In order to express how to handle QoS requests in devfreq devices,
> > > > the devfreq device drivers only need to express the mappings of
> > > > QoS value and frequency pairs with QoS class along with
> > > > devfreq_add_device() call.
> > > > 
> > > > As a side effect of the implementation, which happens to be positive,
> > > > min/max freq is now enforced regardless of governor implementation.
> > > 
> > > Can you please explain in a few words how this is supposed to work in
> > > practice?
> > 
> > Ah.. this "side effect" has been neutralized by the patch
> > 
> > ab5f299f51259fd2466cf35c89d79bd960e0fc32
> > PM / devfreq: add relation of recommended frequency.
> > 
> > I should've removed that comment.
> 
> OK
> 
> > > > Tested on Exynos4412 machines with memory/bus frequencies and multimedia
> > > > H/W blocks. (camera, video decoding, and video encoding)
> > > > 
> > > > Signed-off-by: MyungJoo Ham 
> > > > Signed-off-by: Kyungmin Park 
> > > 
> > > I'm not entirely convinced yet, but a few comments follow.
> > > 
> > > > ---
> > > > Changed from V2-resend
> > > > - Removed dependencies on global pm-qos class definitions
> > > > - Revised data structure handling pm-qos (being ready for dev-pm-qos)
> > > > 
> > > > Changes from V2
> > > > - Rebased
> > > > 
> > > > Changes from V1
> > > > - Error handling at devfreq_add_device()
> > > > - Handling pm_qos_max information
> > > > - Styly update
> > > > ---
> > []
> > > > @@ -136,8 +137,13 @@ int update_devfreq(struct devfreq *devfreq)
> > > >   * List from the highest proiority
> > > >   * max_freq (probably called by thermal when it's too hot)
> > > >   * min_freq
> > > > + * qos_min_freq
> > > >   */
> > > >  
> > > > + if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
> > > > + freq = devfreq->qos_min_freq;
> > > > + flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> > > 
> > > What exactly is the purpose of this last line?
> > 
> > It says target callback to use "qos_min_freq" as its greatest lower bound;
> > use any values that are "qos_min_freq" or above.
> > And it can be overriden by min_freq and max_freq.
> 
> I see.
> 
> > > > + }
> > > >   if (devfreq->min_freq && freq < devfreq->min_freq) {
> > > >   freq = devfreq->min_freq;
> > > >   flags &= ~DEVFREQ_FLAG_LEAST_UPPER_BOUND; /* Use GLB */
> > > > @@ -164,12 +170,12 @@ int update_devfreq(struct devfreq *devfreq)
> > > >   * devfreq_notifier_call() - Notify that the device frequency requirements
> > > >   *    has been changed out of devfreq framework.
> > > >   * @nb the notifier_block (supposed to be devfreq->nb)
> > > > - * @type not used
> > > > + * @val not used.
> > > >   * @devp not used
> > > >   *
> > > >   * Called by a notifier that uses devfreq->nb.
> > > >   */
> > > > -static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
> > > > +static int devfreq_notifier_call(struct notifier_block *nb, unsigned long val,
> > > >   void *devp)
> > > >  {
> > > >   struct devfreq *devfreq = container_of(nb, struct devfreq, nb);
> > > 
> > > The above change is only a cleanup unrelated to the rest of modifications.
> > > Please push it separately (if you _really_ think it's necessary).
> > 
> > oops.. yes..
> > 
> > > 
> > > > @@ -183,6 +189,49 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
> > > >  }
> > > >  
> > > >  /**
> > > > + * devfreq_qos_notifier_call() -
> > > 
> > > This looks like a missing kerneldoc comment?
> > 
> > yes..  I'd either remove the comment or fill it in.
> 
> Please add the comment.
> 
> > > > + */
> > > > +static int devfreq_qos_notifier_call(struct notifier_block *nb,
> > > > +      unsigned long value, void *devp)
> > > > +{
> > > > + struct devfreq *devfreq = container_of(nb, struct devfreq, qos_nb);
> > > > + int ret;
> > > > + int i;
> > > > + s32 default_value = PM_QOS_DEFAULT_VALUE;
> > > > + struct devfreq_pm_qos_table *qos_list = devfreq->profile->qos_list;
> > > > + bool qos_use_max = devfreq->profile->qos_use_max;
> > > > +
> > > > + if (!qos_list)
> > > > + return NOTIFY_DONE;
> > > > +
> > > > + mutex_lock(&devfreq->lock);
> > > > +
> > > > + if (value == default_value) {
> > > > + devfreq->qos_min_freq = 0;
> > > > + goto update;
> > > > + }
> > > > +
> > > > + for (i = 0; qos_list[i].freq; i++) {
> > > > + /* QoS Met */
> > > > + if ((qos_use_max && qos_list[i].qos_value >= value) ||
> > > > +     (!qos_use_max && qos_list[i].qos_value <= value)) {
> > > > + devfreq->qos_min_freq = qos_list[i].freq;
> > > > + goto update;
> > > > + }
> > > 
> > > What about:
> > > 
> > > if (qos_use_max) {
> > > if (qos_list[i].qos_value < value)
> > > continue;
> > > } else {
> > > if (qos_list[i].qos_value > value)
> > > continue;
> > > }
> > > devfreq->qos_min_freq = qos_list[i].freq;
> > > goto update;
> > 
> > Fine, I'll clean it up.
> > 
> > > 
> > > > + }
> > > > +
> > > > + /* Use the highest QoS freq */
> > > > + if (i > 0)
> > > 
> > > Given the sanity checks in devfreq_add_device(), this is always true.
> > > So perhaps you don't even need the "update" label?
> > 
> > Ok. If it's fine to rely on the sanity check results here,
> > I can remove the label and restruct the function.
> > 
> > > 
> > > > + devfreq->qos_min_freq = qos_list[i - 1].freq;
> > > > +
> > > > +update:
> > > > + ret = update_devfreq(devfreq);
> > > > + mutex_unlock(&devfreq->lock);
> > > > +
> > > > + return ret;
> > > > +}
> > > > +
> > > > +/**
> > > >   * _remove_devfreq() - Remove devfreq from the device.
> > > >   * @devfreq: the devfreq struct
> > > >   * @skip: skip calling device_unregister().
> > > > @@ -219,6 +268,10 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
> > > >  
> > > >   devfreq->being_removed = true;
> > > >  
> > > > + if (devfreq->profile->qos_type)
> > > > + pm_qos_remove_notifier(devfreq->profile->qos_type,
> > > > +        &devfreq->qos_nb);
> > > > +
> > > >   if (devfreq->profile->exit)
> > > >   devfreq->profile->exit(devfreq->dev.parent);
> > > >  
> > > > @@ -390,7 +443,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > > >      void *data)
> > > >  {
> > > >   struct devfreq *devfreq;
> > > > - int err = 0;
> > > > + int err = 0, i;
> > > >  
> > > >   if (!dev || !profile || !governor) {
> > > >   dev_err(dev, "%s: Invalid parameters.\n", __func__);
> > > > @@ -429,6 +482,61 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > > >   devfreq->next_polling = devfreq->polling_jiffies
> > > >         = msecs_to_jiffies(devfreq->profile->polling_ms);
> > > >   devfreq->nb.notifier_call = devfreq_notifier_call;
> > > > + devfreq->qos_nb.notifier_call = devfreq_qos_notifier_call;
> > > > +
> > > > + /* Check the sanity of qos_list/qos_type */
> > > 
> > > Any chance to move the sanity checks below to a separate function?
> > 
> > Not a problem.
> > 
> > > 
> > > > + if (profile->qos_type || profile->qos_list) {
> > > > +
> > > > + if (WARN(!profile->qos_type || !profile->qos_list,
> > > > + "QoS requirement partially omitted for %s.\n",
> > > > + dev_name(dev))) {
> > > > +
> > > > + err = -EINVAL;
> > > > + goto err_dev;
> > > > + }
> > > > +
> > > > + if (WARN(!profile->qos_list[0].freq,
> > > > + "The first QoS requirement is the end of list for %s.\n",
> > > > + dev_name(dev))) {
> > > > +
> > > > + err = -EINVAL;
> > > > + goto err_dev;
> > > > + }
> > > > +
> > > > + for (i = 1; profile->qos_list[i].freq; i++) {
> > > > + if (WARN(profile->qos_list[i].freq <=
> > > > + profile->qos_list[i - 1].freq,
> > > > + "%s's qos_list[].freq not sorted in the ascending order. ([%d]=%lu, [%d]=%lu)\n",
> > > > + dev_name(dev), i - 1,
> > > > + profile->qos_list[i - 1].freq, i,
> > > > + profile->qos_list[i].freq)) {
> > > > +
> > > > + err = -EINVAL;
> > > > + goto err_dev;
> > > > + }
> > > > +
> > > > + /*
> > > > + * If QoS type is throughput(PM_QOS_MAX)-like, qos_value
> > > > + * should be sorted in the ascending order.
> > > > + * If QoS type is latency(PM_QOS_MIN)-like, qos_value
> > > > + * should be sorted in the descending order.
> > > > + */
> > > > + if (WARN((profile->qos_use_max &&
> > > > +   profile->qos_list[i - 1].qos_value >
> > > > +   profile->qos_list[i].qos_value) ||
> > > > + (!profile->qos_use_max &&
> > > > +   profile->qos_list[i - 1].qos_value <
> > > > +   profile->qos_list[i].qos_value),
> > > > + "%s's qos_list[].qos_value is not sorted according to its QoS class.\n",
> > > > + dev_name(dev))) {
> > > > +
> > > > + err = -EINVAL;
> > > > + goto err_dev;
> > > > + }
> > > > + }
> > > > +
> > > > + pm_qos_add_notifier(profile->qos_type, &devfreq->qos_nb);
> > > 
> > > What QoS types do you think could be used here?
> > 
> > I don't think the devfreq core needs to care of it.
> > Whatever the device driver wants could be available here.
> 
> That's a bit of a problem.  I don't want device drivers to use the global
> QoS types, because they aren't sufficiently well defined (units are kind of
> unknown in some cases, for example).
> 
> In my opinion it would be better to add performance device PM QoS in analogy
> with the existing latency device PM QoS.  The unit might be percentage of full
> performance (0 - 100).
> 
> Of course, that only would cover device performance, but there also is the
> problem of interconnect throughput that may depend on what frequencies are
> used by devices on it.
>

Paul W. and I where talking about a boost interface I think may be worth
considering.

We need to take a step back at this point.  What type of algebra is
needed WRT the device pm_qos analogy?  do we need an ordered set or even
partial ordering?  Do we need to be able to tell one state is more
performing than another at all?

The use cases of these performance levels tend to be platform and device
specific AFAICT so far.  The units of performance are not portable
across ISA's and they're interpretation varies from device to device.

What if we didn't think of it in terms of an ordered field of some sort?
What if we had a per device boost hash who's meaning is defined by the
board / device level module but, the interface and use is defined in the
common code?  If the platform code didn't implement any then those are
NOOPs if the platform code cares about that device qos then it
implements and interprets the specific boost qos as needed.

So in practice when a driver or use case needed qos, it would request a
qos hash from the platform code to use and that platform code would need
to interpret that hash in a platform specific way.

This would remove the portability problem from drivers requested QoS
levels from assorted devices.  the QoS levels will be a hash, to be
interpreted by platform code.

there are a lot of details to work out but I think something could be
done along these lines.


--mark



