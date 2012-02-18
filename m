Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2BRPGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 10:06:07 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:58041 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab2BRPGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 10:06:02 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1426\))
Subject: Re: [PATCH v2 09/11] firewire-sbp-target: Add sbp_target_agent.{c,h}
From: Chris Boot <bootc@bootc.net>
In-Reply-To: <20120218155910.72ab30ca@stein>
Date: Sat, 18 Feb 2012 15:05:54 +0000
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1BDF59F2-4EFE-4E6B-9958-FD056CA3120B@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net> <1329317248-94128-1-git-send-email-bootc@bootc.net> <1329317248-94128-10-git-send-email-bootc@bootc.net> <20120215222741.6b7388dc@stein> <4F3CE791.2090908@bootc.net> <20120218155910.72ab30ca@stein>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
X-Mailer: Apple Mail (2.1426)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Feb 2012, at 14:59, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> On Feb 16 Chris Boot wrote:
>> On 15/02/2012 21:27, Stefan Richter wrote:
>>> On Feb 15 Chris Boot wrote:
>>>> --- /dev/null
>>>> +++ b/drivers/target/sbp/sbp_target_agent.c
>>> [...]
>>>> +static int tgt_agent_rw_orb_pointer(struct fw_card *card,
>>>> +	int tcode, int generation, void *data,
>>>> +	struct sbp_target_agent *agent)
>>>> +{
>>>> +	struct sbp2_pointer *ptr = data;
>>>> +	int ret;
>>>> +
>>>> +	switch (tcode) {
>>>> +	case TCODE_WRITE_BLOCK_REQUEST:
>>>> +		smp_wmb();
>>>> +		atomic_cmpxchg(&agent->state,
>>>> +				AGENT_STATE_RESET, AGENT_STATE_SUSPENDED);
>>>> +		smp_wmb();
>>>> +		if (atomic_cmpxchg(&agent->state,
>>>> +					AGENT_STATE_SUSPENDED,
>>>> +					AGENT_STATE_ACTIVE)
>>>> +				!= AGENT_STATE_SUSPENDED)
>>>> +			return RCODE_CONFLICT_ERROR;
>>>> +		smp_wmb();
>>> 
>>> Why the double state change?
>> 
>> Because the SBP spec differentiates between the RESET state, which 
>> happens after the agent initialises or is sent an explicit reset 
>> request, and when it's suspended between requests...
> 
> OK, right, there are the state transitions Reset-->Active and
> Suspended-->Active.  Though you implement the former as a swift
> Reset-->Suspended-->Active.  Which does indeed work, provided that there
> is no other concurrent context which could transition from Suspended to
> Anything-but-Active.

I'll rewrite this bit to use a lock to protect the state struct member so it isn't so strange. That would also avoid the unusual double state change.

>>> And as asked at the patch, which writes are the barriers meant to order,
>>> and how does the corresponding read side look like?  Or are these barriers
>>> not actually needed after all?
>> 
>> ...of course this is another time when my use of atomics and memory 
>> barriers is entirely wrong. I should most likely be using locking here.
>> 
>>> [...]
>>>> +void sbp_target_agent_unregister(struct sbp_target_agent *agent)
>>>> +{
>>>> +	if (atomic_read(&agent->state) == AGENT_STATE_ACTIVE)
>>>> +		flush_work_sync(&agent->work);
>>>> +
>>>> +	fw_core_remove_address_handler(&agent->handler);
>>>> +	kfree(agent);
>>>> +}
>>> 
>>> So, asking once more without having read the code in full yet:  Are you
>>> sure that agent->state is not going to change anymore after you tested it
>>> here?
>> 
>> Nope. At least in this case I can unregister the address handler before 
>> I check if I need to flush the work item.
> 
> Yep, first unregister the handler, then wait for the work to finish, then
> free the data.
> 
> And as discussed off-list today, firewire-core should be improved to
> guarantee you that the handler isn't still running anywhere when
> fw_core_remove_address_handler() returns.

Great, thanks for clearing that up.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net

