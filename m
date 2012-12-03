Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2LCTOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:14:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab2LCTOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:14:15 -0500
Date: Mon, 3 Dec 2012 14:14:12 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 5/5] device_cgroup: propagate local changes down the
 hierarchy
Message-ID: <20121203191411.GE32112@redhat.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193503.114004167@napanee.usersys.redhat.com>
 <20121203180145.GJ19802@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203180145.GJ19802@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:01:45AM -0800, Tejun Heo wrote:
> On Tue, Nov 27, 2012 at 02:35:06PM -0500, Aristeu Rozanski wrote:
> > This patch makes all changes propagate down in hierarchy respecting when
> > possible local configurations.
> > 
> > Behavior changes will clean up exceptions in all the children except when the
> > parent changes the behavior from allow to deny and the child's behavior was
> > already deny, in which case the local exceptions will be reused. The inverse
> > is not possible: you can't have a parent with behavior deny and a child with
> > behavior accept.
> > 
> > New exceptions allowing additional access to devices won't be propagated, but
> > it'll be possible to add an exception to access all of part of the newly
> > allowed device(s).
> > 
> > New exceptions disallowing access to devices will be propagated down and the
> > local group's exceptions will be revalidated for the new situation.
> 
> I think the inheritance policy needs to be documented in detail
> listing the possible cases and the implemented behavior preferably
> with rationale.  Can you please do that?

ok, will do

> > +/**
> > + * __revalidate_exceptions - walks through the exception list and revalidates
> > + *			     the exceptions based on parents' behavior and
> > + *			     exceptions. Called with devcgroup_mutex held.
> 
> new line

ok

> > + * @devcg: cgroup which exceptions will be checked
> > + * returns: 0 in success, -ENOMEM in case of out of memory
> > + */
> > +static int __revalidate_exceptions(struct dev_cgroup *devcg)
> 
> Why __?

hm. I think I had a version with locking in the past, forgot to take
those out. will fix that too

> > +/**
> > + * propagate_behavior - propagates a change in the behavior to the children
> > + * @devcg: device cgroup that changed behavior
> > + *
> > + * returns: 0 in case of success, != 0 in case of error
> > + */
> > +static int propagate_behavior(struct dev_cgroup *devcg)
> > +{
> > +	struct cgroup *root = devcg->css.cgroup, *pos, *saved = NULL,
> > +			*prev = NULL;
> > +	struct dev_cgroup *parent;
> > +	int rc = 0;
> > +
> > +	while (1) {
> > +		rcu_read_lock();
> > +		cgroup_for_each_descendant_pre(pos, root) {
> > +			if (saved && prev != saved) {
> > +				prev = pos;
> > +				continue;
> > +			}
> > +			break;
> > +		}
> > +		rcu_read_unlock();
> 
> Hmmm... this can race with new cgroup creation and a new child can
> escape propagation.  devcg currently inherits from css_alloc() at
> which it isn't visible to cgroup_for_each_*() iteration.  The
> inheriting step should be moved to css_online() with explicit online
> marking.  Please take a look at the recently posted cpuset for an
> example.

ok, will do
> > +/**
> > + * propagate_exception - propagates a new exception to the children
> > + * @devcg: device cgroup that added a new exception
> > + *
> > + * returns: 0 in case of success, != 0 in case of error
> > + */
> > +static int propagate_exception(struct dev_cgroup *devcg)
> > +{
> > +	struct cgroup *root = devcg->css.cgroup, *pos, *saved = NULL,
> > +			*prev = NULL;
> > +	struct dev_cgroup *parent;
> > +	int rc = 0;
> > +
> > +	while(1) {
> > +		rcu_read_lock();
> > +		cgroup_for_each_descendant_pre(pos, root) {
> > +			if (saved && prev != saved) {
> > +				prev = pos;
> > +				continue;
> > +			}
> > +			break;
> > +		}
> > +		rcu_read_unlock();
> 
> Ditto.  Racy.
> 
> > +		if (!pos)
> > +			break;
> > +
> > +		devcg = cgroup_to_devcgroup(pos);
> > +		parent = cgroup_to_devcgroup(pos->parent);
> > +
> > +		__dev_exception_clean(&devcg->exceptions);
> > +		if (devcg->behavior == parent->behavior) {
> > +			rc = dev_exceptions_copy(&devcg->exceptions, &parent->exceptions);
> > +			if (rc) {
> > +				devcg->behavior = DEVCG_DEFAULT_DENY;
> > +				break;
> > +			}
> > +			rc = __revalidate_exceptions(devcg);
> > +			if (rc)
> > +				break;
> > +		} else {
> > +			/* we never give more permissions to the child */
> > +			WARN_ONCE(devcg->behavior == DEVCG_DEFAULT_ALLOW,
> > +				  "devcg: parent/child behavior is inconsistent");
> > +			rc = __revalidate_exceptions(devcg);
> > +			if (rc)
> > +				break;
> > +		}
> > +		saved = pos;
> > +	}
> > +	return rc;
> > +}
> 
> Maybe I'm misunderstanding something but the behavior seems a bit
> inconsistent.  So, you can't add an exception which isn't allowed by
> your parent, right?  But, if your parent disallows an existing
> exception, you get to keep it?  I think it would be more consistent to
> go either
> 
> * Allow all settings but apply only as allowed by the parent.
> 
> * Deny settings disallowed by the parent.  If parent's config changes,
>   delete configs which fall outside the new config.

I prefer this one, in fact that's what was happening before and you
suggested to not remove local preferences when they're not valid
anymore.

In this case, Serge is right about not propagating 'allow' exceptions.

-- 
Aristeu

