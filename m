Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1KNXPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:15:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39379 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab1KNXPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:15:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Subject: Re: [PATCH 1/2] devfreq: fix use after free in devfreq_remove_device
Date: Tue, 15 Nov 2011 00:18:22 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        =?euc-kr?q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>
References: <29486171.446861320912914822.JavaMail.weblogic@epml06>
In-Reply-To: <29486171.446861320912914822.JavaMail.weblogic@epml06>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111150018.22817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 10, 2011, 함명주 wrote:
> Sender : Axel Lin<axel.lin@gmail.com> Date : 2011-11-10 16:28 (GMT+09:00)
> > In devfreq_remove_device, calling _remove_devfreq will also free devfreq.
> > Don't dereference devfreq->governor->no_central_polling after _remove_devfreq.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Thank you for finding that out.
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applied to linux-pm/pm-fixes.

Thanks,
Rafael


> > ---
> > drivers/devfreq/devfreq.c |    8 ++++++--
> > 1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > index d065925..59d24e9 100644
> > --- a/drivers/devfreq/devfreq.c
> > +++ b/drivers/devfreq/devfreq.c
> > @@ -418,10 +418,14 @@ out:
> >   */
> > int devfreq_remove_device(struct devfreq *devfreq)
> > {
> > + bool central_polling;
> > +
> > if (!devfreq)
> > return -EINVAL;
> > 
> > - if (!devfreq->governor->no_central_polling) {
> > + central_polling = !devfreq->governor->no_central_polling;
> > +
> > + if (central_polling) {
> > mutex_lock(&devfreq_list_lock);
> > while (wait_remove_device == devfreq) {
> > mutex_unlock(&devfreq_list_lock);
> > @@ -433,7 +437,7 @@ int devfreq_remove_device(struct devfreq *devfreq)
> > mutex_lock(&devfreq->lock);
> > _remove_devfreq(devfreq, false); /* it unlocks devfreq->lock */
> > 
> > - if (!devfreq->governor->no_central_polling)
> > + if (central_polling)
> > mutex_unlock(&devfreq_list_lock);
> > 
> > return 0;
> 
>  MyungJoo Ham (함명주)
> 
> Mobile Software Platform Lab,
> Digital Media and Communications (DMC) Business
> Samsung Electronics
> cell: +82-10-6714-2858 / office: +82-31-279-8033

