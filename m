Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab2BOV2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:28:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39780 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2BOV2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:28:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 15 Feb 2012 22:27:41 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 09/11] firewire-sbp-target: Add
 sbp_target_agent.{c,h}
Message-ID: <20120215222741.6b7388dc@stein>
In-Reply-To: <1329317248-94128-10-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-10-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15 Chris Boot wrote:
> --- /dev/null
> +++ b/drivers/target/sbp/sbp_target_agent.c
[...]
> +static int tgt_agent_rw_orb_pointer(struct fw_card *card,
> +	int tcode, int generation, void *data,
> +	struct sbp_target_agent *agent)
> +{
> +	struct sbp2_pointer *ptr = data;
> +	int ret;
> +
> +	switch (tcode) {
> +	case TCODE_WRITE_BLOCK_REQUEST:
> +		smp_wmb();
> +		atomic_cmpxchg(&agent->state,
> +				AGENT_STATE_RESET, AGENT_STATE_SUSPENDED);
> +		smp_wmb();
> +		if (atomic_cmpxchg(&agent->state,
> +					AGENT_STATE_SUSPENDED,
> +					AGENT_STATE_ACTIVE)
> +				!= AGENT_STATE_SUSPENDED)
> +			return RCODE_CONFLICT_ERROR;
> +		smp_wmb();

Why the double state change?

And as asked at the patch, which writes are the barriers meant to order,
and how does the corresponding read side look like?  Or are these barriers
not actually needed after all?

[...]
> +void sbp_target_agent_unregister(struct sbp_target_agent *agent)
> +{
> +	if (atomic_read(&agent->state) == AGENT_STATE_ACTIVE)
> +		flush_work_sync(&agent->work);
> +
> +	fw_core_remove_address_handler(&agent->handler);
> +	kfree(agent);
> +}

So, asking once more without having read the code in full yet:  Are you
sure that agent->state is not going to change anymore after you tested it
here?
-- 
Stefan Richter
-=====-===-- --=- -====
http://arcgraph.de/sr/
