Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab2IQT5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:57:43 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab2IQT5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:57:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Subject: Re: [PATCH v2 3/3] devfreq: Add current freq callback in device profile
Date: Mon, 17 Sep 2012 22:04:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <23597048.34281347878091187.JavaMail.weblogic@epml25>
In-Reply-To: <23597048.34281347878091187.JavaMail.weblogic@epml25>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201209172204.09150.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012, MyungJoo Ham wrote:
> > From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > 
> > Devfreq returns governor predicted frequency as current frequency
> > via sysfs interface. But device may not support all frequencies
> > that governor predicts. So add a callback in device profile to get
> > current freq from driver. Also add a new sysfs node to expose
> > governor predicted next target frequency.
> > 
> > Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

OK, I'm taking this as an acked-by (signed-off-by would be appropriate if
the patch went through your hands).

Does it apply to [3/3] only or to all of the patches in the series?

Rafael


> > ---
> >  Documentation/ABI/testing/sysfs-class-devfreq | 11 ++++++++++-
> >  drivers/devfreq/devfreq.c                     | 14 ++++++++++++++
> >  include/linux/devfreq.h                       |  3 +++
> >  3 files changed, 27 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
> > index 89283b1..e6cf08e 100644
> > --- a/Documentation/ABI/testing/sysfs-class-devfreq
> > +++ b/Documentation/ABI/testing/sysfs-class-devfreq
> > @@ -19,7 +19,16 @@ Date:		September 2011
> >  Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
> >  Description:
> >  		The /sys/class/devfreq/.../cur_freq shows the current
> > -		frequency of the corresponding devfreq object.
> > +		frequency of the corresponding devfreq object. Same as
> > +		target_freq when get_cur_freq() is not implemented by
> > +		devfreq driver.
> > +
> > +What:		/sys/class/devfreq/.../target_freq
> > +Date:		September 2012
> > +Contact:	Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > +Description:
> > +		The /sys/class/devfreq/.../target_freq shows the next governor
> > +		predicted target frequency of the corresponding devfreq object.
> >  
> >  What:		/sys/class/devfreq/.../polling_interval
> >  Date:		September 2011
> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > index 309c46e..049e273 100644
> > --- a/drivers/devfreq/devfreq.c
> > +++ b/drivers/devfreq/devfreq.c
> > @@ -401,6 +401,19 @@ static ssize_t show_governor(struct device *dev,
> >  static ssize_t show_freq(struct device *dev,
> >  			 struct device_attribute *attr, char *buf)
> >  {
> > +	unsigned long freq;
> > +	struct devfreq *devfreq = to_devfreq(dev);
> > +
> > +	if (devfreq->profile->get_cur_freq &&
> > +		!devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq))
> > +			return sprintf(buf, "%lu\n", freq);
> > +
> > +	return sprintf(buf, "%lu\n", devfreq->previous_freq);
> > +}
> > +
> > +static ssize_t show_target_freq(struct device *dev,
> > +			struct device_attribute *attr, char *buf)
> > +{
> >  	return sprintf(buf, "%lu\n", to_devfreq(dev)->previous_freq);
> >  }
> >  
> > @@ -504,6 +517,7 @@ static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
> >  static struct device_attribute devfreq_attrs[] = {
> >  	__ATTR(governor, S_IRUGO, show_governor, NULL),
> >  	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
> > +	__ATTR(target_freq, S_IRUGO, show_target_freq, NULL),
> >  	__ATTR(polling_interval, S_IRUGO | S_IWUSR, show_polling_interval,
> >  	       store_polling_interval),
> >  	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
> > diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> > index 7c7e179..d12ed41 100644
> > --- a/include/linux/devfreq.h
> > +++ b/include/linux/devfreq.h
> > @@ -66,6 +66,8 @@ struct devfreq_dev_status {
> >   *			explained above with "DEVFREQ_FLAG_*" macros.
> >   * @get_dev_status	The device should provide the current performance
> >   *			status to devfreq, which is used by governors.
> > + * @get_cur_freq	The device should provide the current frequency
> > + *			at which it is operating.
> >   * @exit		An optional callback that is called when devfreq
> >   *			is removing the devfreq object due to error or
> >   *			from devfreq_remove_device() call. If the user
> > @@ -79,6 +81,7 @@ struct devfreq_dev_profile {
> >  	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
> >  	int (*get_dev_status)(struct device *dev,
> >  			      struct devfreq_dev_status *stat);
> > +	int (*get_cur_freq)(struct device *dev, unsigned long *freq);
> >  	void (*exit)(struct device *dev);
> >  };
> >  
> 

