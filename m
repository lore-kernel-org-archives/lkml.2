Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab2IJUeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:34:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46440 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab2IJUd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:33:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: Re: [PATCH 1/3] devfreq: core updates to support devices which can idle
Date: Mon, 10 Sep 2012 22:40:17 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1346682578-24312-1-git-send-email-rajagopal.venkat@linaro.org> <201209092346.39877.rjw@sisk.pl> <CA+Z25wW1RoqiWNa1K8Gox+MX4jHuRRo0RPTijXWLTiz0iKnRXw@mail.gmail.com>
In-Reply-To: <CA+Z25wW1RoqiWNa1K8Gox+MX4jHuRRo0RPTijXWLTiz0iKnRXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209102240.17916.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 10, 2012, Rajagopal Venkat wrote:
> On 10 September 2012 03:16, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, September 03, 2012, Rajagopal Venkat wrote:
> >> Prepare devfreq core framework to support devices which
> >> can idle. When device idleness is detected perhaps through
> >> runtime-pm, need some mechanism to suspend devfreq load
> >> monitoring and resume back when device is online. Present
> >> code continues monitoring unless device is removed from
> >> devfreq core.
> >>
> >> This patch introduces following design changes,
> >>
> >> - use per device work instead of global work to monitor device
> >>   load. This enables suspend/resume of device devfreq and
> >>   reduces monitoring code complexity.
> >> - decouple delayed work based load monitoring logic from core
> >>   by introducing helpers functions to be used by governors. This
> >>   provides flexibility for governors either to use delayed work
> >>   based monitoring functions or to implement their own mechanism.
> >> - devfreq core interacts with governors via events to perform
> >>   specific actions. These events include start/stop devfreq.
> >>   This sets ground for adding suspend/resume events.
> >>
> >> The devfreq apis are not modified and are kept intact.
> >>
> >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> >
> > This one looks like a nice simplification.  I wonder if everyone in the CC list
> > is fine with it?
> >
> > One remark below.
> >
> >> ---
> >>  drivers/devfreq/devfreq.c                 | 376 ++++++++++--------------------
> >>  drivers/devfreq/governor.h                |   9 +
> >>  drivers/devfreq/governor_performance.c    |  16 +-
> >>  drivers/devfreq/governor_powersave.c      |  16 +-
> >>  drivers/devfreq/governor_simpleondemand.c |  33 +++
> >>  drivers/devfreq/governor_userspace.c      |  23 +-
> >>  include/linux/devfreq.h                   |  31 +--
> >>  7 files changed, 220 insertions(+), 284 deletions(-)
> >>
> >> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> >> index b146d76..be524c7 100644
> >> --- a/drivers/devfreq/devfreq.c
> >> +++ b/drivers/devfreq/devfreq.c
> >> @@ -30,17 +30,11 @@
> >>  struct class *devfreq_class;
> >>
> >>  /*
> >> - * devfreq_work periodically monitors every registered device.
> >> - * The minimum polling interval is one jiffy. The polling interval is
> >> - * determined by the minimum polling period among all polling devfreq
> >> - * devices. The resolution of polling interval is one jiffy.
> >> + * devfreq core provides delayed work based load monitoring helper
> >> + * functions. Governors can use these or can implement their own
> >> + * monitoring mechanism.
> >>   */
> >> -static bool polling;
> >>  static struct workqueue_struct *devfreq_wq;
> >> -static struct delayed_work devfreq_work;
> >> -
> >> -/* wait removing if this is to be removed */
> >> -static struct devfreq *wait_remove_device;
> >>
> >>  /* The list of all device-devfreq */
> >>  static LIST_HEAD(devfreq_list);
> >> @@ -72,6 +66,8 @@ static struct devfreq *find_device_devfreq(struct device *dev)
> >>       return ERR_PTR(-ENODEV);
> >>  }
> >>
> >> +/* Load monitoring helper functions for governors use */
> >> +
> >>  /**
> >>   * update_devfreq() - Reevaluate the device and configure frequency.
> >>   * @devfreq: the devfreq instance.
> >> @@ -121,6 +117,90 @@ int update_devfreq(struct devfreq *devfreq)
> >>  }
> >>
> >>  /**
> >> + * devfreq_monitor() - Periodically poll devfreq objects.
> >> + * @work: the work struct used to run devfreq_monitor periodically.
> >> + *
> >> + */
> >> +static void devfreq_monitor(struct work_struct *work)
> >> +{
> >> +     int err;
> >> +     struct devfreq *devfreq = container_of(work,
> >> +                                     struct devfreq, work.work);
> >> +
> >> +     mutex_lock(&devfreq->lock);
> >> +     err = update_devfreq(devfreq);
> >> +     mutex_unlock(&devfreq->lock);
> >> +     if (err)
> >> +             dev_err(&devfreq->dev, "dvfs failed with (%d) error\n", err);
> >> +
> >> +     queue_delayed_work(devfreq_wq, &devfreq->work,
> >> +                             msecs_to_jiffies(devfreq->profile->polling_ms));
> >> +}
> >> +
> >> +/**
> >> + * devfreq_monitor_start() - Start load monitoring of devfreq instance
> >> + *                   using default delayed work
> >> + * @devfreq: the devfreq instance.
> >> + *
> >> + * Returns 0 if monitoring started, non-zero otherwise.
> >> + * Note: This function is exported for governors.
> >> + */
> >> +int devfreq_monitor_start(struct devfreq *devfreq)
> >> +{
> >> +     INIT_DEFERRABLE_WORK(&devfreq->work, devfreq_monitor);
> >> +     return !queue_delayed_work(devfreq_wq, &devfreq->work,
> >> +                     msecs_to_jiffies(devfreq->profile->polling_ms));
> >> +}
> >> +
> >> +/**
> >> + * devfreq_monitor_stop() - Stop load monitoring of a devfreq instance
> >> + * @devfreq: the devfreq instance.
> >> + *
> >> + * Note: This function is exported for governors.
> >> + */
> >> +void devfreq_monitor_stop(struct devfreq *devfreq)
> >> +{
> >> +     cancel_delayed_work_sync(&devfreq->work);
> >> +}
> >> +
> >> +/**
> >> + * devfreq_monitor_suspend() - Suspend load monitoring of a devfreq instance
> >> + * @devfreq:    the devfreq instance.
> >> + *
> >> + * Note: This function is exported for governors.
> >> + */
> >
> > It would be good to say in the kerneldoc comment what the idea is, because it
> > is not particularly clear from the code.  In particular, why can't
> > devfreq_monitor_suspend() be the same as devfreq_monitor_stop()?
> Ok. Kerneldoc comment will be added here.
> 
> The idea is,
> devfreq_monitor_suspend() - called to suspend device devfreq during device
> idleness.
> 
> devfreq_monitor_stop() - called when device is removed from the devfreq
> framework.
> 
> Though these two functions can be same, intentionally I kept them separate
> to provide hooks for collecting transition statistics.

In that case it looks like there is a race below:

> >> +int devfreq_monitor_suspend(struct devfreq *devfreq)
> >> +{
> >> +     int ret = -EPERM;
> >> +
> >> +     if (delayed_work_pending(&devfreq->work)) {

Don't you need to check the timer here too?  It is possible that the work
isn't pending yet, but the timer has already been set.

> >> +             cancel_delayed_work_sync(&devfreq->work);
> >> +             ret = 0;
> >> +     }
> >> +
> >> +     return ret;
> >> +}

BTW, why do you want to return -EPERM on error?

Rafael
