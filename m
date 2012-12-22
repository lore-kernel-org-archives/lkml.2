Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2LVUbb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 15:31:31 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44951 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LVUb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 15:31:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
References: <87d2y2elbi.fsf@xmission.com> <871ueiel9d.fsf@xmission.com>
	<20121222165438.GA19680@redhat.com>
Date: Sat, 22 Dec 2012 12:31:21 -0800
In-Reply-To: <20121222165438.GA19680@redhat.com> (Oleg Nesterov's message of
	"Sat, 22 Dec 2012 17:54:38 +0100")
Message-ID: <87bodlbzhi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19NRCHA0ErxyjF0Y8pajPUV9d3dxNXtF8c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0203]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 2/3] pidns: Stop pid allocation when init dies
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 12/21, Eric W. Biederman wrote:
>>
>> --- a/include/linux/pid_namespace.h
>> +++ b/include/linux/pid_namespace.h
>> @@ -21,7 +21,7 @@ struct pid_namespace {
>>  	struct kref kref;
>>  	struct pidmap pidmap[PIDMAP_ENTRIES];
>>  	int last_pid;
>> -	int nr_hashed;
>> +	unsigned int nr_hashed;
>>  	struct task_struct *child_reaper;
>>  	struct kmem_cache *pid_cachep;
>>  	unsigned int level;
>> @@ -42,6 +42,8 @@ struct pid_namespace {
>>
>>  extern struct pid_namespace init_pid_ns;
>>
>> +#define PIDNS_HASH_ADDING (1U << 31)
>
> Yes, agreed. We can't rely on PF_EXITING/whatever, we need the explicit
> flag.

The simpler and more comprehensible we can make this code the better. 
We have had too many surprises in this code because of complex failure
modes.

> 1/2 looks fine too. Only one nit about init_pid_ns below...

Then I will add your acked-by to the first patch.

>> @@ -319,7 +318,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>>
>>  	upid = pid->numbers + ns->level;
>>  	spin_lock_irq(&pidmap_lock);
>> -	if (ns->nr_hashed < 0)
>> +	if (ns->nr_hashed < PIDNS_HASH_ADDING)
>
> I won't insist, but perhaps if "(!(nr_hashed & PIDNS_HASH_ADDING))"
> looks more understandable.

I will stare at it both ways and post an updated patch.

I'm not certain which form I like better.  Certainly the decrements
are doing a double duty.

>> +void disable_pid_allocation(struct pid_namespace *ns)
>> +{
>> +	spin_lock_irq(&pidmap_lock);
>> +	if (ns->nr_hashed >= PIDNS_HASH_ADDING)
>
> Do we really need this check? It seems that PIDNS_HASH_ADDING
> bit must be always set when disable_pid_allocation() is called.
>
>> +		ns->nr_hashed -= PIDNS_HASH_ADDING;
>
> Anyway, nr_hashed &= ~PIDNS_HASH_ADDING looks simpler and doesn't
> need a check.

That I agree with.

> But again, I won't insist this is minor and subjective.
>
>>  struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
>>  {
>>  	struct hlist_node *elem;
>> @@ -584,7 +591,7 @@ void __init pidmap_init(void)
>>  	/* Reserve PID 0. We never call free_pidmap(0) */
>>  	set_bit(0, init_pid_ns.pidmap[0].page);
>>  	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
>> -	init_pid_ns.nr_hashed = 1;
>> +	init_pid_ns.nr_hashed = 1 + PIDNS_HASH_ADDING;
>
> The obly chunk which doesn't look exactly correct to me, although this
> doesn't really matter. Hmm, actually the code was already wrong before
> this patch.
>
> I think init_pid_ns.nr_hashed should be PIDNS_HASH_ADDING, we should not
> add 1 to account the unused zero pid, and kernel_thread(kernel_init) was
> not called yet.

Good point because the zero pid does not get hashed.  Who knows perhaps
with a little more evolution create_pid_ns can be used to create the
initial pid namespace.

I am also going to add "BUILD_BUG_ON(PID_MAX_LIMIT >= PIDNS_HASH_ADDING);"
to document that the pid values and PIDNS_HASH_ADDING can't overlap.

Eric	

