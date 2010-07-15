Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985Ab0GOSEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:04:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46666 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730Ab0GOSEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:04:50 -0400
Message-ID: <4C3F4DBC.7010200@canonical.com>
Date: Thu, 15 Jul 2010 11:04:44 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 11/13] AppArmor: LSM interface, and security module initialization
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com> <1279154621-25868-12-git-send-email-john.johansen@canonical.com> <20100715172757.GA26839@hallyn.com>
In-Reply-To: <20100715172757.GA26839@hallyn.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 10:27 AM, Serge E. Hallyn wrote:
> Quoting John Johansen (john.johansen@canonical.com):
>> AppArmor hooks to interface with the LSM, module parameters and module
>> initialization.
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
> 
> Thanks, John - looks good overall.  Comments:
> 
> ...
> 
>> +static int apparmor_ptrace_access_check(struct task_struct *child,
>> +					unsigned int mode)
>> +{
>> +	int rc;
>> +
>> +	rc = cap_ptrace_access_check(child, mode);
>> +	if (rc)
>> +		return rc;
>> +
>> +	return aa_ptrace(current, child, mode);
>> +}
>> +
>> +static int apparmor_ptrace_traceme(struct task_struct *parent)
>> +{
> 
> Just curious - why aren't you calling cap_ptrace_traceme() first here?
> 
err, we should be.  I'm not sure where that got dropped.  I'll go through
and re audit all of these.

thanks
>> +	return aa_ptrace(parent, current, PTRACE_MODE_ATTACH);
>> +}
>> +
>> +/* Derived from security/commoncap.c:cap_capget */
>> +static int apparmor_capget(struct task_struct *target, kernel_cap_t *effective,
>> +			   kernel_cap_t *inheritable, kernel_cap_t *permitted)
>> +{
>> +	struct aa_profile *profile;
>> +	const struct cred *cred;
>> +
>> +	rcu_read_lock();
>> +	cred = __task_cred(target);
>> +	profile = aa_cred_profile(cred);
>> +
>> +	*effective = cred->cap_effective;
>> +	*inheritable = cred->cap_inheritable;
>> +	*permitted = cred->cap_permitted;
>> +
>> +	if (!unconfined(profile))
>> +		*effective = cap_intersect(*effective, profile->caps.allow);
> 
> Should you mask permitted too?  Otherwise you might confuse a userspace
> lib which assumes it's caller previously culled pE, and that it can
> nwo refill it from pP.
> 
yes indeed thanks

>> +	rcu_read_unlock();
>> +
>> +	return 0;
>> +}
>> +
>> +static int apparmor_capable(struct task_struct *task, const struct cred *cred,
>> +			    int cap, int audit)
>> +{
>> +	struct aa_profile *profile;
>> +	/* cap_capable returns 0 on success, else -EPERM */
>> +	int error = cap_capable(task, cred, cap, audit);
> 
> jinkeys, it might be just me, but i'd have spend 2 mins less looking
> at this if you'd done
> 
> 	if (error)
> 		return error;
> 
> here, simplifying the condition below.
> 
>> +
>> +	profile = aa_cred_profile(cred);
>> +	if (!error  && !unconfined(profile))
>> +		error = aa_capable(task, profile, cap, audit);
>> +
>> +	return error;
>> +}
> 
yeah, that is better

thanks Serge
