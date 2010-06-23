Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab0FWRoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:44:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60338 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab0FWRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=j2BQzkDQ2NmMzIVfHnv/Rqa4V30Bu5SGmAIH5L5UkVsocy+pA430S4/Qd89P6PbzRz
         74Ou/a5IbCJD4lGfbVsGMLtEmF74oKCtJpxXsK+HScP52H6uoXY9eQCN1l7MP79nlJki
         KQkJqvt9UBRwjE9xHY7BT4Tffn2OFl42VXm90=
Message-ID: <4C224804.7030809@gmail.com>
Date: Wed, 23 Jun 2010 19:44:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, adobriyan@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH v3 06/11] rlimits: do security check under task_lock
References: <20100513155621.51ca77a4.akpm@linux-foundation.org> <1275855783-27316-1-git-send-email-jslaby@suse.cz> <20100607180855.GA6689@redhat.com> <4C222644.4040601@gmail.com> <20100623161254.GA10098@redhat.com>
In-Reply-To: <20100623161254.GA10098@redhat.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 06:12 PM, Oleg Nesterov wrote:
> On 06/23, Jiri Slaby wrote:
>>
>> On 06/07/2010 08:08 PM, Oleg Nesterov wrote:
>>> On 06/06, Jiri Slaby wrote:
>>>> @@ -1339,13 +1364,19 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
>>>>
>>>>  	rlim = tsk->signal->rlim + resource;
>>>>  	task_lock(tsk->group_leader);
>>>> +again:
>>>> +	retval = 0;
>>>>  	if (new_rlim) {
>>>>  		if ((new_rlim->rlim_max > rlim->rlim_max) &&
>>>>  					!capable(CAP_SYS_RESOURCE))
>>
>> BTW this capable() has the exactly same problem with being called with
>> task_lock held. Is it OK to move it completely out of critical section?
>> I'm asking because it sets a current->flags SU bit used for accounting.
>> If I move it out of the section, it will set the bit always.
> 
> Well, with all these delays I do not know what "exactly same problem"
> means ;) Please explain?

As I wrote: that the capable() is called with task_lock held. With
security enabled, capable() goes through all the avc_has_perm_noaudit,
avc_audit and similar (in selinux), the same as security_task_setrlimit
which we were writing about -- Andrew complaining about doing very long
security checks while holding spinlocks.

I mean we should do either none of capable and selinux_task_setrlimit
under task_lock or both :).

>>> Finally. selinux_task_setrlimit(p) uses __task_cred(p) for the check.
>>> This looks a bit strange, different threads can have different creds
>>> but obviously rlimits are per-process.
>>
>> Sorry I can't see it. Could you point out in which function this is done?
> 
> selinux_task_setrlimit()->current_has_perm()->current_sid()->current_cred()

I still see no way how this is wrong. We want to check whether current
thread has capabilities to change (someone else's) rlimits. Maybe I'm
missing something?

thanks,
-- 
js
