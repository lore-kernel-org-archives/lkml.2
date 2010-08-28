Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab0H1Ufj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 16:35:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46954 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0H1Ufi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 16:35:38 -0400
Message-ID: <4C797315.7030204@canonical.com>
Date: Sat, 28 Aug 2010 13:35:33 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/4] AppArmor: Fix security_task_setrlimit logic for 2.6.36
 changes
References: <1282959209-5431-1-git-send-email-john.johansen@canonical.com> <1282959209-5431-3-git-send-email-john.johansen@canonical.com> <4C794310.1020801@canonical.com> <4C795242.80402@gmail.com>
In-Reply-To: <4C795242.80402@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 11:15 AM, Jiri Slaby wrote:
> On 08/28/2010 07:10 PM, John Johansen wrote:
>> 2.6.36 introduced the abilitiy to specify the task that is having its
>> rlimits set.  Update mediation to ensure that confined tasks can only
>> set their own group_leader as expected by current policy.
>>
>> Add TODO note about extending policy to support setting other tasks
>> rlimits.
> ...
>> --- a/security/apparmor/resource.c
>> +++ b/security/apparmor/resource.c
> ...
>> @@ -79,18 +80,21 @@ int aa_map_resource(int resource)
>>   *
>>   * Returns: 0 or error code if setting resource failed
>>   */
>> -int aa_task_setrlimit(struct aa_profile *profile, unsigned int resource,
>> -		      struct rlimit *new_rlim)
>> +int aa_task_setrlimit(struct aa_profile *profile, struct task_struct *task,
>> +		      unsigned int resource, struct rlimit *new_rlim)
>>  {
>>  	int error = 0;
>>  
>> -	if (profile->rlimits.mask & (1 << resource) &&
>> -	    new_rlim->rlim_max > profile->rlimits.limits[resource].rlim_max)
>> -
>> -		error = audit_resource(profile, resource, new_rlim->rlim_max,
>> -			-EACCES);
>> +	/* TODO: extend resource control to handle non group leader tasks.
>> +	 * AppArmor rules currently have the implicit assumption that
>> +	 * the task having its resource set is the group leader.
> 
> Why would you want to do that? Limits are per process, so the 'task'
> parameter is guaranteed to be the leader.
> 
That used to be the case,

commit c022a0acad534fd5f5d5f17280f6d4d135e74e81 add the prlimit64 syscall
which

    It also adds a possibility of changing limits of other processes. We
    check the user's permissions to do that and if it succeeds, the new
    limits are propagated online. This is good for large scale
    applications such as SAP or databases where administrators need to
    change limits time by time (e.g. on crashes increase core size). And
    it is unacceptable to restart the service.

so it seems we need to extend the apparmor rules to be able to deal with
this, but ensuring that the current assumption is enforced is enough
for now.

thanks
john
