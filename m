Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2DNKtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:49:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60883 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2DNKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:49:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Apr 2012 12:49:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH 09/11] firewire-sbp-target: Add sbp_target_agent.{c,h}
Message-ID: <20120414124909.0615aa2a@stein>
In-Reply-To: <1334154043-69076-10-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1334154043-69076-1-git-send-email-bootc@bootc.net>
	<1334154043-69076-10-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 11 Chris Boot wrote:
> +static int tgt_agent_rw_agent_state(struct fw_card *card, int tcode, void *data,
> +		struct sbp_target_agent *agent)
> +{
> +	__be32 state;
> +
> +	switch (tcode) {
> +	case TCODE_READ_QUADLET_REQUEST:
> +		pr_debug("tgt_agent AGENT_STATE READ\n");
> +
> +		spin_lock_bh(&agent->lock);
> +		state = cpu_to_be32(agent->state);
> +		spin_unlock_bh(&agent->lock);
> +		memcpy(data, &state, sizeof(state));
> +
> +		return RCODE_COMPLETE;
> +
> +	case TCODE_WRITE_QUADLET_REQUEST:
> +		/* ignored */
> +		return RCODE_COMPLETE;
> +
> +	default:
> +		return RCODE_TYPE_ERROR;
> +	}
> +}

agent->state is an int; reading an int is atomic.  Hence the access on
its own does not benefit from lock acquisition.

The memcpy can be simplified to

	*(__be32 *)data = cpu_to_be32(agent->state);

if data is always at least quadlet aligned.  Thy type cast is only to tell
code checkers like sparse that we know what we are doing.  If data may be
unaligned, you could use

	put_unaligned_be32(agent->state, data);
-- 
Stefan Richter
-=====-===-- -=-- -===-
http://arcgraph.de/sr/
