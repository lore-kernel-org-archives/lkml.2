Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1BJEvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:51:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:29722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab1BJEve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:51:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,450,1291622400"; 
   d="scan'208";a="656266803"
Date: Wed, 9 Feb 2011 20:51:33 -0800
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Paul Menage <menage@google.com>, akpm@linux-foundation.org,
        rdunlap@xenotime.net, Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [PATCH 1/1, v6] cgroup/freezer: add per freezer duty ratio
 control
Message-ID: <20110209205133.5146a9fb@jacob-laptop>
In-Reply-To: <4D52050F.3060907@cn.fujitsu.com>
References: <1297213541-18156-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<4D52050F.3060907@cn.fujitsu.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Feb 2011 11:07:59 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:


> >  
> > +#define FREEZER_KH_PREFIX  "freezer_"
> > +static int freezer_write_param(struct cgroup *cgroup, struct
> > cftype *cft,
> > +		u64 val)
> > +{
> > +	struct freezer *freezer;
> > +	char thread_name[32];
> > +	int ret = 0;
> > +
> > +	freezer = cgroup_freezer(cgroup);
> > +
> > +	if (!cgroup_lock_live_group(cgroup))
> > +		return -ENODEV;
> > +
> > +	switch (cft->private) {
> > +	case FREEZER_DUTY_RATIO:
> > +		if (val >= 100 || val < 0) {
> 
> val will never < 0.
good point, I will fix it.

> 
> > +			ret = -EINVAL;
> > +			goto exit;
> > +		}
> > +		freezer->duty.ratio = val;
> > +		break;
> > +	case FREEZER_PERIOD:
> > +		if (val)
> > +			do_div(val, 100);
> 
> Is 0 an invalid value for do_div()?
0 is valid. I was thinking about divide by 0 by mistake. will fix it.

> 
> > +			freezer->duty.period_pct_ms = val;
> > +		break;
> > +	default:
> > +		BUG();
> > +	}
> > +
> > +	/* start/stop management kthread as needed, the rule is
> > that
> > +	 * if both duty ratio and period values are zero, then no
> > management
> > +	 * kthread is created. when both are non-zero, we create a
> > kthread
> > +	 * for the cgroup. When user set zero to duty ratio and
> > period again
> > +	 * the kthread is stopped.
> > +	 */
> > +	if (freezer->duty.ratio && freezer->duty.period_pct_ms) {
> > +		if (!freezer->fkh) {
> > +			snprintf(thread_name, 32, "%s%s",
> > FREEZER_KH_PREFIX,
> > +				cgroup->dentry->d_name.name);
> > +			freezer->fkh = kthread_run(freezer_kh,
> > (void *)cgroup,
> > +						thread_name);
> > +			if (IS_ERR(freezer_task)) {
> 
> You mean IS_ERR(freezer->fkh)?
Right, same bug for PTR_ERR. will fix.

thanks.
