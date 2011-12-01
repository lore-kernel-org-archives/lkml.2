Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1LAVOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:14:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab1LAVOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:14:05 -0500
Date: Thu, 1 Dec 2011 16:13:50 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-ID: <20111201211350.GD2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
 <20111201154036.GA2443@redhat.com>
 <1322756898.4699.30.camel@twins>
 <20111201165009.GB2443@redhat.com>
 <1322761185.4699.47.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322761185.4699.47.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 06:39:45PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-12-01 at 11:50 -0500, Jason Baron wrote:
> 
> > I think its just a matter of reversing the true and false returns.
> > That is, instead of:
> 
> that's the same as !static_branch()
> 
> > jump_label_inc/dec(), don't need to be changed, they just mean reverse
> > the branch on 0, 1 transitions. Although using the same key in both
> > static_branch_true, and static_branch_false, might be confusing. Maybe
> > we rename jump_label_inc/dec to static_branch_reverse_inc()/dec()?
> 
> Right, that's the problem really. That makes it impossible to make the
> control code generic.
> 
> What I'd want is something that doesn't out-of-line the branch, is
> possibly enabled by default, but has the same inc/dec behaviour, not the
> reversed.
> 

I think what you have below should work modulo the no out-of-line
branches and the following change:

> -			if (neg)
> +			if (neg) {
>  				sysctl_sched_features &= ~(1UL << i);
> -			else
> +#ifdef HAVE_JUMP_LABEL
> +				if (!jump_label_enabled(&sched_feat_keys[i]))
> +					jump_label_inc(&sched_feat_keys[i]);
> +#endif

I think here its:
			if (jump_label_enabled())
				jump_label_dec();


> +			} else {
>  				sysctl_sched_features |= (1UL << i);
> +#ifdef HAVE_JUMP_LABEL
> +				if (jump_label_enabled(&sched_feat_keys[i]))
> +					jump_label_dec(&sched_feat_keys[i]);
> +#endif
> +			}

Same here:
			if (!jump_label_enabled())
				jump_label_inc()




The inc/dec behavior we have now, in fact will only mess up in the case
where we define 'static_branch_true()'. Because then, in that case the
jump_label_inc() will cause a jump to the false branch. So as long as we
don't introduce 'static_branch_true()' and do an early setting of those
branches which are true via __init code as you have here, I think things are
correct.

Thanks,

-Jason
