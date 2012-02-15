Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2BOTtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:49:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39031 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2BOTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:49:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 15 Feb 2012 20:48:36 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 07/11] firewire-sbp-target: add
 sbp_management_agent.{c,h}
Message-ID: <20120215204836.063bbd36@stein>
In-Reply-To: <1329317248-94128-8-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-8-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15 Chris Boot wrote:
> --- /dev/null
> +++ b/drivers/target/sbp/sbp_management_agent.c
[...]
> +static void sbp_mgt_agent_rw(struct fw_card *card,
> +	struct fw_request *request, int tcode, int destination, int source,
> +	int generation, unsigned long long offset, void *data, size_t length,
> +	void *callback_data)
> +{
> +	struct sbp_management_agent *agent = callback_data;
> +	struct sbp2_pointer *ptr = data;
> +
> +	if (!agent->tport->enable) {
> +		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
> +		return;
> +	}
> +
> +	if ((offset != agent->handler.offset) || (length != 8)) {
> +		fw_send_response(card, request, RCODE_ADDRESS_ERROR);
> +		return;
> +	}
> +
> +	if (tcode == TCODE_WRITE_BLOCK_REQUEST) {
> +		struct sbp_management_request *req;
> +		int ret;
> +
> +		smp_wmb();
> +		if (atomic_cmpxchg(&agent->state,
> +					MANAGEMENT_AGENT_STATE_IDLE,
> +					MANAGEMENT_AGENT_STATE_BUSY) !=
> +				MANAGEMENT_AGENT_STATE_IDLE) {
> +			pr_notice("ignoring management request while busy\n");
> +
> +			fw_send_response(card, request, RCODE_CONFLICT_ERROR);
> +			return;
> +		}

There is a rule of thumb which says:  If you add a memory barrier anywhere
in your code, also add a comment saying which accesses this barrier is
meant to bring into order.

So after the write barrier is apparently the agent->state access.  What
access is before the barrier?

And how does the read side look like?

These questions are mostly rhetoric.  It is quite likely that this code is
better off with a plain and simple mutex serialization.

[...]
> +void sbp_management_agent_unregister(struct sbp_management_agent *agent)
> +{
> +	if (atomic_read(&agent->state) != MANAGEMENT_AGENT_STATE_IDLE)
> +		flush_work_sync(&agent->work);
> +
> +	fw_core_remove_address_handler(&agent->handler);
> +	kfree(agent);
> +}

I still have yet to test-apply all your patches, look at the sum of the
code and understand what the execution contexts and critical sections
are.  So I really should not yet ask the next, uninformed question.

Looking at this function, I wonder:  Can the agent->state change after you
read it, and what would happen then?
-- 
Stefan Richter
-=====-===-- --=- -====
http://arcgraph.de/sr/
