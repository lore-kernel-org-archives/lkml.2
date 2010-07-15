Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887Ab0GORZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 13:25:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56693 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab0GORZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 13:25:42 -0400
X-Authority-Analysis: v=1.1 cv=g9Y3NohClm0xo0Au7hiKM/lwvZwqTqjWC8eysRFNA3U= c=1 sm=0 a=o1FYtcTXQFcA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=Vk531U1CpUxeBF5tW5IA:9 a=KPruExL9g3-SffmKkeQA:7 a=s9lOLjFBCBVujjoSpKJYnNLPlbgA:4 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 15 Jul 2010 12:27:57 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 11/13] AppArmor: LSM interface, and security module
 initialization
Message-ID: <20100715172757.GA26839@hallyn.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
 <1279154621-25868-12-git-send-email-john.johansen@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279154621-25868-12-git-send-email-john.johansen@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting John Johansen (john.johansen@canonical.com):
> AppArmor hooks to interface with the LSM, module parameters and module
> initialization.
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>

Thanks, John - looks good overall.  Comments:

...

> +static int apparmor_ptrace_access_check(struct task_struct *child,
> +					unsigned int mode)
> +{
> +	int rc;
> +
> +	rc = cap_ptrace_access_check(child, mode);
> +	if (rc)
> +		return rc;
> +
> +	return aa_ptrace(current, child, mode);
> +}
> +
> +static int apparmor_ptrace_traceme(struct task_struct *parent)
> +{

Just curious - why aren't you calling cap_ptrace_traceme() first here?

> +	return aa_ptrace(parent, current, PTRACE_MODE_ATTACH);
> +}
> +
> +/* Derived from security/commoncap.c:cap_capget */
> +static int apparmor_capget(struct task_struct *target, kernel_cap_t *effective,
> +			   kernel_cap_t *inheritable, kernel_cap_t *permitted)
> +{
> +	struct aa_profile *profile;
> +	const struct cred *cred;
> +
> +	rcu_read_lock();
> +	cred = __task_cred(target);
> +	profile = aa_cred_profile(cred);
> +
> +	*effective = cred->cap_effective;
> +	*inheritable = cred->cap_inheritable;
> +	*permitted = cred->cap_permitted;
> +
> +	if (!unconfined(profile))
> +		*effective = cap_intersect(*effective, profile->caps.allow);

Should you mask permitted too?  Otherwise you might confuse a userspace
lib which assumes it's caller previously culled pE, and that it can
nwo refill it from pP.

> +	rcu_read_unlock();
> +
> +	return 0;
> +}
> +
> +static int apparmor_capable(struct task_struct *task, const struct cred *cred,
> +			    int cap, int audit)
> +{
> +	struct aa_profile *profile;
> +	/* cap_capable returns 0 on success, else -EPERM */
> +	int error = cap_capable(task, cred, cap, audit);

jinkeys, it might be just me, but i'd have spend 2 mins less looking
at this if you'd done

	if (error)
		return error;

here, simplifying the condition below.

> +
> +	profile = aa_cred_profile(cred);
> +	if (!error  && !unconfined(profile))
> +		error = aa_capable(task, profile, cap, audit);
> +
> +	return error;
> +}

-serge
