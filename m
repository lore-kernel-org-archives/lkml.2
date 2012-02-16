Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2BPK2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:28:45 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:46660 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2BPK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:28:42 -0500
Message-ID: <4F3CDA54.3030905@bootc.net>
Date: Thu, 16 Feb 2012 10:28:36 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 07/11] firewire-sbp-target: add sbp_management_agent.{c,h}
References: <1328989452-20921-1-git-send-email-bootc@bootc.net> <1329317248-94128-1-git-send-email-bootc@bootc.net> <1329317248-94128-8-git-send-email-bootc@bootc.net> <20120215204836.063bbd36@stein>
In-Reply-To: <20120215204836.063bbd36@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/2012 19:48, Stefan Richter wrote:
> On Feb 15 Chris Boot wrote:
>> --- /dev/null
>> +++ b/drivers/target/sbp/sbp_management_agent.c
> [...]
>> +static void sbp_mgt_agent_rw(struct fw_card *card,
>> +	struct fw_request *request, int tcode, int destination, int source,
>> +	int generation, unsigned long long offset, void *data, size_t length,
>> +	void *callback_data)
>> +{
>> +	struct sbp_management_agent *agent = callback_data;
>> +	struct sbp2_pointer *ptr = data;
>> +
>> +	if (!agent->tport->enable) {
>> +		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
>> +		return;
>> +	}
>> +
>> +	if ((offset != agent->handler.offset) || (length != 8)) {
>> +		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
>> +		return;
>> +	}
>> +
>> +	if (tcode == TCODE_WRITE_BLOCK_REQUEST) {
>> +		struct sbp_management_request *req;
>> +		int ret;
>> +
>> +		smp_wmb();
>> +		if (atomic_cmpxchg(&agent->state,
>> +					MANAGEMENT_AGENT_STATE_IDLE,
>> +					MANAGEMENT_AGENT_STATE_BUSY) !=
>> +				MANAGEMENT_AGENT_STATE_IDLE) {
>> +			pr_notice("ignoring management request while busy\n");
>> +
>> +			fw_send_response(card, request, RCODE_CONFLICT_ERROR);
>> +			return;
>> +		}
>
> There is a rule of thumb which says:  If you add a memory barrier anywhere
> in your code, also add a comment saying which accesses this barrier is
> meant to bring into order.
>
> So after the write barrier is apparently the agent->state access.  What
> access is before the barrier?
>
> And how does the read side look like?
>
> These questions are mostly rhetoric.  It is quite likely that this code is
> better off with a plain and simple mutex serialization.

Well as I mentioned in my previous messages atomics and locking are 
pretty new ideas to me. Having only really done threading in PERL 
before, the world of doing it in the kernel is rather different! :-) The 
memory barriers are there after I looked in Documentation/atomic_ops.txt 
and clearly misunderstood the entire thing.

Reading about mutexes though I see I can't use them from interrupt 
context, but doesn't the FireWire address handler execute in interrupt 
context? I have to check the state of the management agent in the 
address handler to properly reject requests from the initiator when the 
agent is busy. I guess a spinlock is called for in this situation, 
possibly using spin_trylock() in the address handler to avoid blocking?

> [...]
>> +void sbp_management_agent_unregister(struct sbp_management_agent *agent)
>> +{
>> +	if (atomic_read(&agent->state) != MANAGEMENT_AGENT_STATE_IDLE)
>> +		flush_work_sync(&agent->work);
>> +
>> +	fw_core_remove_address_handler(&agent->handler);
>> +	kfree(agent);
>> +}
>
> I still have yet to test-apply all your patches, look at the sum of the
> code and understand what the execution contexts and critical sections
> are.  So I really should not yet ask the next, uninformed question.
>
> Looking at this function, I wonder:  Can the agent->state change after you
> read it, and what would happen then?

The agent state could change between the read and before the address 
handler is unregistered, this would require an initiator to keep sending 
management requests long after the FW unit descriptor is removed though.

I guess to solve this in a bulletproof manner I need a kref in struct 
sbp_management_agent and a spinlock(?), and a new state to say the agent 
is going away. That way if I happen to receive requests while the agent 
is being removed it can reply with address errors before the address 
handler is fully removed. I'd also need something similar in the target 
agent.

-- 
Chris Boot
bootc@bootc.net
