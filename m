Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0H1XFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 19:05:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53047 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0H1XFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 19:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=syxRhiHFsQAjgbalwaPTJT+WK+TQcdGiNTEpjHOh8hLDn69JQzN+yVbxnmrmgbApkW
         sv6TdwAid+i7vyoo9gWVgGrmj5Z/kA6GrbR3EuNOe2YyDwmXZcMvxNoDRaaJ/YfXVvwm
         d3m4STTVK5aw+JY6AUyyU7+G6ak910mRjQP68=
Date: Sat, 28 Aug 2010 16:05:20 -0700
From: mark gross <markgross@thegnar.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
Message-ID: <20100828230520.GB12402@gvim.org>
Reply-To: markgross@thegnar.org
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
 <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
 <87hbigqg8d.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbigqg8d.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 07:31:46AM -0700, Kevin Hilman wrote:
> Saravana Kannan <skannan@codeaurora.org> writes:
> 
> > Some drivers/devices might need some minimum system bus performance to
> > provide acceptable service. Provide a PM QoS parameter to send these requests
> > to.
> >
> > The new parameter is named "system bus performance" since it is generic enough
> > for the unit of the request to be frequency, bandwidth or something else that
> > might be appropriate. It's up to each implementation of the QoS provider to
> > define what the unit of the request would be.
> >
> > Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> 
> With this current design, only one system-wide bus would be managed.
> What if a platform has more than one independently scalable bus?
> 
> I think the only scalable way to handle this kind of thing is to have
> per-device QoS constraints that can then be combined/aggregated by parent
> devices/busses.


I'm just realizing that Saravana may not be talking about a power
management problem.  I think she is talking about QoS, not constraining
the throttling of some platform bus or device. (i.e. not pm_qos)

I think its important to keep requirements clear. Are your ideas around
doing proper throttling constraints or are they about QoS proper?

I see a need for both but, as a QoS facility will likely call into
pm_qos to help grantee a qos it will be fundamentally different form
pm_qos.  

PM_QoS is a best effort API to constrain power state throttling.

So, what are you thinking about?  QoS or constraining power state
throttling?

--mark

> At LPC this year, I've proposed per-device QoS constraints[1] as a topic
> for the PM mini-conf.  I hope some folks from the MSM camp can be there
> for these discussions.
> 
> Kevin
> 
> [1] http://www.linuxplumbersconf.org/2010/ocw/proposals/819
> 
> > ---
> >  kernel/pm_qos_params.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index 996a4de..1a44a67 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -93,12 +93,21 @@ static struct pm_qos_object network_throughput_pm_qos = {
> >  	.type = PM_QOS_MAX,
> >  };
> >  
> > +static BLOCKING_NOTIFIER_HEAD(system_bus_performance_notifier);
> > +static struct pm_qos_object system_bus_performance_pm_qos = {
> > +	.requests = PLIST_HEAD_INIT(system_bus_performance_pm_qos.requests, pm_qos_lock),
> > +	.notifiers = &system_bus_performance_notifier,
> > +	.name = "system_bus_performance",
> > +	.default_value = 0,
> > +	.type = PM_QOS_MAX,
> > +};
> >  
> >  static struct pm_qos_object *pm_qos_array[] = {
> >  	&null_pm_qos,
> >  	&cpu_dma_pm_qos,
> >  	&network_lat_pm_qos,
> >  	&network_throughput_pm_qos
> > +	&system_bus_performance_pm_qos
> >  };
> >  
> >  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
