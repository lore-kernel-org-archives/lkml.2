Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1BWQbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:31:13 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41680 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1BWQbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:31:12 -0500
Date: Wed, 23 Feb 2011 08:31:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 14/14] rcu: Add boosting to
 TREE_PREEMPT_RCU tracing
Message-ID: <20110223163106.GM2163@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D6479E8.3030800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6479E8.3030800@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:07:20AM +0800, Lai Jiangshan wrote:
> On 02/23/2011 09:39 AM, Paul E. McKenney wrote:
> >  	rcudir = debugfs_create_dir("rcu", NULL);
> > -	if (!rcudir)
> > +	if (IS_ERR_VALUE(rcudir))
> >  		goto free_out;
> 
> if !defined(CONFIG_DEBUG_FS)
> 	debugfs_create_xxx() returns ERR_PTR(-ENODEV);
> else
> 	debugfs_create_xxx() returns NULL when failed.
> 
> Since TREE_RCU_TRACE selects DEBUG_FS, "if (!rcudir)" is correct,
> we don't need to change it.

Yeah, but this really needs to be less fragile.  And yes, I do appear
to have broken it in the NULL-pointer case.  And who came up with the
API above, anyway?  It is an accident waiting to happen.

All whining aside, I need something like the following, correct?

#define IS_ERR_VALUE_OR_NULL(x) \
	unlikely((x) - 1 >= (unsigned long)(-MAX_ERRNO-1)

							Thanx, Paul

> >  	retval = debugfs_create_file("rcudata", 0444, rcudir,
> >  						NULL, &rcudata_fops);
> > -	if (!retval)
> > +	if (IS_ERR_VALUE(retval))
> >  		goto free_out;
> >  
> >  	retval = debugfs_create_file("rcudata.csv", 0444, rcudir,
> >  						NULL, &rcudata_csv_fops);
> > -	if (!retval)
> > +	if (IS_ERR_VALUE(retval))
> > +		goto free_out;
> > +
> > +	retval = rcu_boost_trace_create_file(rcudir);
> > +	if (retval)
> >  		goto free_out;
> >  
> >  	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
> > -	if (!retval)
> > +	if (IS_ERR_VALUE(retval))
> >  		goto free_out;
> >  
> >  	retval = debugfs_create_file("rcuhier", 0444, rcudir,
> >  						NULL, &rcuhier_fops);
> > -	if (!retval)
> > +	if (IS_ERR_VALUE(retval))
> >  		goto free_out;
> >  
> >  	retval = debugfs_create_file("rcu_pending", 0444, rcudir,
> >  						NULL, &rcu_pending_fops);
> > -	if (!retval)
> > +	if (IS_ERR_VALUE(retval))
> >  		goto free_out;
> >  	return 0;
> >  free_out:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
