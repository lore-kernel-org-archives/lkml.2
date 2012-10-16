Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2JPQiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:38:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:49482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249Ab2JPQiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:38:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?7J207KKF7ZmU?= <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH v4 2/3] devfreq: Add suspend and resume apis
Date: Tue, 16 Oct 2012 18:42:03 +0200
Message-ID: <1977565.F3Xz7jGOYl@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <12788576.101631350369619343.JavaMail.weblogic@epml27>
References: <12788576.101631350369619343.JavaMail.weblogic@epml27>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 of October 2012 06:40:19 MyungJoo Ham wrote:
> > On Monday 08 of October 2012 10:48:24 MyungJoo Ham wrote:
> > > > On 8 October 2012 03:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > On Thursday 04 of October 2012 14:58:33 Rajagopal Venkat wrote:
> > > > >> Add devfreq suspend/resume apis for devfreq users. This patch
> > > > >> supports suspend and resume of devfreq load monitoring, required
> > > > >> for devices which can idle.
> > > > >>
> > > > >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > > > >> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > > > >
> > > > > Well, I wonder if this may be tied in to the runtime PM framework, so that,
> > > > > for example, pm_runtime_suspend() will automatically suspend devfreq on
> > > > > success (and the runtime resume of the device will resume devfreq)?
> > > > 
> > > > That's a good idea. If you agree, we can handle this as separate patch on
> > > > top this patchset.
> > 
> > Sure.
> > 
> > > I guess implementing the idea may be not so obvious; thus, seperating
> > > the patchset would be appropriate.
> > > 
> > > When we implement the idea, we may need to implement at the
> > > pm_runtime core. Because devfreq->dev is a child of the target dev, not
> > > a parent, runtime-pm event of the target dev does not automatically
> > > invoke a cascaded action on the devfreq->dev.
> > 
> > I'm not exactly sure what you mean, care to explain?
> 
> When a device "p" creates devfreq, devfreq->dev->parent = p.

This is wrong.  It shouldn't have been designed this way in the first place
and it was my mistake to merge it, apparently.

> And, devfreq's functions need to react to the "p"'s runtime-pm events.
>
> However, when "p"'s runtime-pm-suspend is being invoked,
> devfreq->dev's runtime-pm-suspend won't be automatically invoked.

Well, the parent should not be able to suspend at all before the children
have suspended and your design doesn't seem to match that principle.

> Thus, we will need a mechanism that invokes devfreq->dev's runtime-pm
> callbacks when p's runtime-pm is invoked. (at the runtime-pm core)

No, this would be going backwards.

> Or
> A mechanism that one can notify others (including its children) when
> the one's runtime-pm is invoked. (probably at the runtime-pm core, too)

You don't appear to understand how the runtime PM framework works.

There's no need to notify a child about the parent's runtime suspend,
because normally the parent won't be suspended before all of its children
have been suspended.

> Without such support, it appears that the current implementation
> (calling runtime-pm suspend/resume equivalent devfreq functions
> manually at device drivers) seems to be inevitable.

Which only means that the devfreq design in incorrect, so please fix it.

> Anyway, if devfreq->dev is a parent of "p", runtime-pm core will
> do the required task automatically; however, it isn't and I don't
> think it'd be appropriate.

No, it wouldn't.  Actually, I'm not sure what you need the dev in struct
devfreq for at all.

As for finding the given device's devfreq structure, for now we can just
walk the devfreq_list.  To avoid doing that for devices that don't have a
struct devfreq attached to them, we can add a devfreq_in_use flag in
struct dev_pm_info.  That may even help some functions in devfreq.c as far
as I can say.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
