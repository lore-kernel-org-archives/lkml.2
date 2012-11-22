Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab2KVSgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:36:50 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:36542 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2KVSgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:36:47 -0500
Date: Thu, 22 Nov 2012 17:45:42 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, myungjoo.ham@gmail.com,
        linux-pm@vger.kernel.org, rjw@sisk.pl, keescook@chromium.org,
        serge.hallyn@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / devfreq: missing rcu_read_lock() added for
 find_device_opp()
Message-ID: <20121122174542.GA15651@mail.hallyn.com>
References: <20121121134621.GA30575@mail.hallyn.com>
 <1353566192-7079-1-git-send-email-myungjoo.ham@samsung.com>
 <20121122140928.GA14567@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122140928.GA14567@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting MyungJoo Ham (myungjoo.ham@samsung.com):
> > opp_get_notifier() uses find_device_opp(), which requires to
> > held rcu_read_lock. In order to keep the notifier-header
> > valid, we have added rcu_read_lock().
> > 

Well, to be honest, the opp locking isn't 100% clear to me, but IIUC
(1) things can be added but never removed, (2) opp_get_notifier doesn't
pin a refcount on what it returns, but it returns something which won't
be deleted.

So IIUC what's below is fine, bc it doesn't need to pin the nh for the
nh to remain valid outside of the rcu_read_lock.  If I'm wrong about
that, then the below is not sufficient.

> Reviewed-by: Serge Hallyn <serge.hallyn@canonical.com>
> 
> > Reported-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > ---
> >  drivers/devfreq/devfreq.c |   26 ++++++++++++++++++++------
> >  1 files changed, 20 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > index 1388d46..5275883 100644
> > --- a/drivers/devfreq/devfreq.c
> > +++ b/drivers/devfreq/devfreq.c
> > @@ -1023,11 +1023,18 @@ struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
> >   */
> >  int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
> >  {
> > -	struct srcu_notifier_head *nh = opp_get_notifier(dev);
> > +	struct srcu_notifier_head *nh;
> > +	int ret = 0;
> >  
> > +	rcu_read_lock();
> > +	nh = opp_get_notifier(dev);
> >  	if (IS_ERR(nh))
> > -		return PTR_ERR(nh);
> > -	return srcu_notifier_chain_register(nh, &devfreq->nb);
> > +		ret = PTR_ERR(nh);
> > +	rcu_read_unlock();
> > +	if (!ret)
> > +		ret = srcu_notifier_chain_register(nh, &devfreq->nb);
> > +
> > +	return ret;
> >  }
> >  
> >  /**
> > @@ -1042,11 +1049,18 @@ int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
> >   */
> >  int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
> >  {
> > -	struct srcu_notifier_head *nh = opp_get_notifier(dev);
> > +	struct srcu_notifier_head *nh;
> > +	int ret = 0;
> >  
> > +	rcu_read_lock();
> > +	nh = opp_get_notifier(dev);
> >  	if (IS_ERR(nh))
> > -		return PTR_ERR(nh);
> > -	return srcu_notifier_chain_unregister(nh, &devfreq->nb);
> > +		ret = PTR_ERR(nh);
> > +	rcu_read_unlock();
> > +	if (!ret)
> > +		ret = srcu_notifier_chain_unregister(nh, &devfreq->nb);
> > +
> > +	return ret;
> >  }
> >  
> >  MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
> > -- 
> > 1.7.5.4
