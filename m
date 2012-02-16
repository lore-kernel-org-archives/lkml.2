Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab2BPLZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:25:12 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46956 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2BPLZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:25:10 -0500
Message-ID: <4F3CE791.2090908@bootc.net>
Date: Thu, 16 Feb 2012 11:25:05 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 09/11] firewire-sbp-target: Add sbp_target_agent.{c,h}
References: <1328989452-20921-1-git-send-email-bootc@bootc.net> <1329317248-94128-1-git-send-email-bootc@bootc.net> <1329317248-94128-10-git-send-email-bootc@bootc.net> <20120215222741.6b7388dc@stein>
In-Reply-To: <20120215222741.6b7388dc@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/2012 21:27, Stefan Richter wrote:
> On Feb 15 Chris Boot wrote:
>> --- /dev/null
>> +++ b/drivers/target/sbp/sbp_target_agent.c
> [...]
>> +static int tgt_agent_rw_orb_pointer(struct fw_card *card,
>> +	int tcode, int generation, void *data,
>> +	struct sbp_target_agent *agent)
>> +{
>> +	struct sbp2_pointer *ptr = data;
>> +	int ret;
>> +
>> +	switch (tcode) {
>> +	case TCODE_WRITE_BLOCK_REQUEST:
>> +		smp_wmb();
>> +		atomic_cmpxchg(&agent->state,
>> +				AGENT_STATE_RESET, AGENT_STATE_SUSPENDED);
>> +		smp_wmb();
>> +		if (atomic_cmpxchg(&agent->state,
>> +					AGENT_STATE_SUSPENDED,
>> +					AGENT_STATE_ACTIVE)
>> +				!= AGENT_STATE_SUSPENDED)
>> +			return RCODE_CONFLICT_ERROR;
>> +		smp_wmb();
>
> Why the double state change?

Because the SBP spec differentiates between the RESET state, which 
happens after the agent initialises or is sent an explicit reset 
request, and when it's suspended between requests...

> And as asked at the patch, which writes are the barriers meant to order,
> and how does the corresponding read side look like?  Or are these barriers
> not actually needed after all?

...of course this is another time when my use of atomics and memory 
barriers is entirely wrong. I should most likely be using locking here.

> [...]
>> +void sbp_target_agent_unregister(struct sbp_target_agent *agent)
>> +{
>> +	if (atomic_read(&agent->state) == AGENT_STATE_ACTIVE)
>> +		flush_work_sync(&agent->work);
>> +
>> +	fw_core_remove_address_handler(&agent->handler);
>> +	kfree(agent);
>> +}
>
> So, asking once more without having read the code in full yet:  Are you
> sure that agent->state is not going to change anymore after you tested it
> here?

Nope. At least in this case I can unregister the address handler before 
I check if I need to flush the work item.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net
