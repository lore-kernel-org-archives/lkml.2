Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2HMRqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:46:24 -0400
Received: from nm1-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.27]:24892
	"HELO nm1-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751586Ab2HMRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:46:23 -0400
X-Yahoo-Newman-Id: 750591.46906.bm@smtp106.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aH6bi7kVM1mFpt5LiNkvpo607ecm_Wb5eS1B8XNECrf.PPm
 avr7JkyFHbJKj3EQMXVBdY3cSrPtBwAMoh2f7lMPoxJair3h81SSaUjUCxOT
 erR19804aLLXcCE3XIWTA4Mh_jRBFshhKVzVVRCBz0w14bj06gwNprMLejBY
 1yQm5OEhS5XMeIQVT3mWb_MMgZicbSOS5NEKoB8cq8O.t4OCM9oOcQ62KgEP
 JxZonF3jc3HlUpCNnwlrnAz9sZ4jT_0NrPVD68c.PT4WKiIe_Akr3EDI7qE.
 CUkL40slkufV0x0HLXqX14ImMpZW2IskbTaXuGCbwDfLW.0cVWwD5KoS.t_I
 0CVmlu3l11xQ5kQsOinSOn9aFI6f5Fd71PbA0UTI9tfn1L730t8Wz9RgXlyl
 abM0MMs7jjZr1x8_BhhKt1GsRYpVsuMnRlWqgkvYLWzR12eJLGQ5E1gs7ulo
 wSZhWHJ93XZ.Fh5I4iaaIgutNxBegD2InH8JvNpHTlFV44K7jDlzNRBnNUUN
 NsAv882vfQBNWkLn4ZEb1c.Il3cMbE3DIURKkqn3nd9jnFD.xYZF5
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50293D6C.2000900@schaufler-ca.com>
Date: Mon, 13 Aug 2012 10:46:20 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: remove task_wait() hook.
References: <1324452052-5793-1-git-send-email-jarkko.sakkinen@intel.com> <502459EE.10906@schaufler-ca.com> <20120813114530.GA4474@jsakkine-mobl1>
In-Reply-To: <20120813114530.GA4474@jsakkine-mobl1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2012 4:45 AM, Jarkko Sakkinen wrote:
> On Thu, Aug 09, 2012 at 05:46:38PM -0700, Casey Schaufler wrote:
>> On 12/20/2011 11:20 PM, Jarkko Sakkinen wrote:
>>> Allow SIGCHLD to be passed to child process without
>>> explicit policy. This will help to keep the access
>>> control policy simple and easily maintainable with
>>> complex applications that require use of multiple
>>> security contexts. It will also help to keep them
>>> as isolated as possible.
>>>
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
>> I have a slightly different version that applies to the
>> current smack-next tree.
>>
>> Allow SIGCHLD to be passed to child process without
>> explicit policy. This will help to keep the access
>> control policy simple and easily maintainable with
>> complex applications that require use of multiple
>> security contexts. It will also help to keep them
>> as isolated as possible.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

Applied to git://git.gitorious.org/smack-next/kernel.git

>>  security/smack/smack_lsm.c |   37 ++++++++-----------------------------
>>  1 files changed, 8 insertions(+), 29 deletions(-)
>>
>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>> index 8221514..ce9273a 100644
>> --- a/security/smack/smack_lsm.c
>> +++ b/security/smack/smack_lsm.c
>> @@ -1691,40 +1691,19 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>>   * smack_task_wait - Smack access check for waiting
>>   * @p: task to wait for
>>   *
>> - * Returns 0 if current can wait for p, error code otherwise
>> + * Returns 0
>>   */
>>  static int smack_task_wait(struct task_struct *p)
>>  {
>> -	struct smk_audit_info ad;
>> -	char *sp = smk_of_current();
>> -	char *tsp = smk_of_forked(task_security(p));
>> -	int rc;
>> -
>> -	/* we don't log here, we can be overriden */
>> -	rc = smk_access(tsp, sp, MAY_WRITE, NULL);
>> -	if (rc == 0)
>> -		goto out_log;
>> -
>>  	/*
>> -	 * Allow the operation to succeed if either task
>> -	 * has privilege to perform operations that might
>> -	 * account for the smack labels having gotten to
>> -	 * be different in the first place.
>> -	 *
>> -	 * This breaks the strict subject/object access
>> -	 * control ideal, taking the object's privilege
>> -	 * state into account in the decision as well as
>> -	 * the smack value.
>> +	 * Allow the operation to succeed.
>> +	 * Zombies are bad.
>> +	 * In userless environments (e.g. phones) programs
>> +	 * get marked with SMACK64EXEC and even if the parent
>> +	 * and child shouldn't be talking the parent still
>> +	 * may expect to know when the child exits.
>>  	 */
>> -	if (smack_privileged(CAP_MAC_OVERRIDE) ||
>> -	    has_capability(p, CAP_MAC_OVERRIDE))
>> -		rc = 0;
>> -	/* we log only if we didn't get overriden */
>> - out_log:
>> -	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>> -	smk_ad_setfield_u_tsk(&ad, p);
>> -	smack_log(tsp, sp, MAY_WRITE, rc, &ad);
>> -	return rc;
>> +	return 0;
>>  }
>>  
>>  /**
>>
>>> ---
>>>  security/smack/smack_lsm.c |   40 ----------------------------------------
>>>  1 files changed, 0 insertions(+), 40 deletions(-)
>>>
>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>> index 7db62b4..cc788f5 100644
>>> --- a/security/smack/smack_lsm.c
>>> +++ b/security/smack/smack_lsm.c
>>> @@ -1685,45 +1685,6 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
>>>  }
>>>  
>>>  /**
>>> - * smack_task_wait - Smack access check for waiting
>>> - * @p: task to wait for
>>> - *
>>> - * Returns 0 if current can wait for p, error code otherwise
>>> - */
>>> -static int smack_task_wait(struct task_struct *p)
>>> -{
>>> -	struct smk_audit_info ad;
>>> -	char *sp = smk_of_current();
>>> -	char *tsp = smk_of_forked(task_security(p));
>>> -	int rc;
>>> -
>>> -	/* we don't log here, we can be overriden */
>>> -	rc = smk_access(tsp, sp, MAY_WRITE, NULL);
>>> -	if (rc == 0)
>>> -		goto out_log;
>>> -
>>> -	/*
>>> -	 * Allow the operation to succeed if either task
>>> -	 * has privilege to perform operations that might
>>> -	 * account for the smack labels having gotten to
>>> -	 * be different in the first place.
>>> -	 *
>>> -	 * This breaks the strict subject/object access
>>> -	 * control ideal, taking the object's privilege
>>> -	 * state into account in the decision as well as
>>> -	 * the smack value.
>>> -	 */
>>> -	if (capable(CAP_MAC_OVERRIDE) || has_capability(p, CAP_MAC_OVERRIDE))
>>> -		rc = 0;
>>> -	/* we log only if we didn't get overriden */
>>> - out_log:
>>> -	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
>>> -	smk_ad_setfield_u_tsk(&ad, p);
>>> -	smack_log(tsp, sp, MAY_WRITE, rc, &ad);
>>> -	return rc;
>>> -}
>>> -
>>> -/**
>>>   * smack_task_to_inode - copy task smack into the inode blob
>>>   * @p: task to copy from
>>>   * @inode: inode to copy to
>>> @@ -3549,7 +3510,6 @@ struct security_operations smack_ops = {
>>>  	.task_getscheduler = 		smack_task_getscheduler,
>>>  	.task_movememory = 		smack_task_movememory,
>>>  	.task_kill = 			smack_task_kill,
>>> -	.task_wait = 			smack_task_wait,
>>>  	.task_to_inode = 		smack_task_to_inode,
>>>  
>>>  	.ipc_permission = 		smack_ipc_permission,
> /Jarkko
>

