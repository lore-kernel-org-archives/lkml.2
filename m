Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0H1SPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 14:15:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65005 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab0H1SPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 14:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HnnLOvEUhx/g+DU0t3ExLsuzkQ/MKFXm9XMrJRsV1pWIBqdsvWEX87WBclUF1DzRIL
         6Eruk46ILZQuDuZaJq27URH926d0M2pSFF2326D1sjFh32PddFquKH9gg/yN5XaI+fVN
         XboHpdbnzcrPrGgveYpxx0HAyJjGac0nYmXSk=
Message-ID: <4C795242.80402@gmail.com>
Date: Sat, 28 Aug 2010 20:15:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/4] AppArmor: Fix security_task_setrlimit logic for 2.6.36
 changes
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com> <1282959209-5431-3-git-send-email-john.johansen@canonical.com> <4C794310.1020801@canonical.com>
In-Reply-To: <4C794310.1020801@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 07:10 PM, John Johansen wrote:
> 2.6.36 introduced the abilitiy to specify the task that is having its
> rlimits set.  Update mediation to ensure that confined tasks can only
> set their own group_leader as expected by current policy.
> 
> Add TODO note about extending policy to support setting other tasks
> rlimits.
...
> --- a/security/apparmor/resource.c
> +++ b/security/apparmor/resource.c
...
> @@ -79,18 +80,21 @@ int aa_map_resource(int resource)
>   *
>   * Returns: 0 or error code if setting resource failed
>   */
> -int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
> -		      struct rlimit *new_rlim)
> +int aa_task_setrlimit(struct aa_profile *profile, struct task_struct *task,
> +		      unsigned int resource, struct rlimit *new_rlim)
>  {
>  	int error = 0;
>  
> -	if (profile->rlimits.mask & (1 << resource) &&
> -	    new_rlim->rlim_max > profile->rlimits.limits[resource].rlim_max)
> -
> -		error = audit_resource(profile, resource, new_rlim->rlim_max,
> -			-EACCES);
> +	/* TODO: extend resource control to handle non group leader tasks.
> +	 * AppArmor rules currently have the implicit assumption that
> +	 * the task having its resource set is the group leader.

Why would you want to do that? Limits are per process, so the 'task'
parameter is guaranteed to be the leader.

> +	 */
> +	if ((task != current->group_leader) ||
> +	    (profile->rlimits.mask & (1 << resource) &&
> +	     new_rlim->rlim_max > profile->rlimits.limits[resource].rlim_max))
> +		error = -EACCES;

regards,
-- 
js
