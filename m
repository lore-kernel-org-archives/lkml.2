Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2CDMsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 07:48:16 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43422 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2CDMsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 07:48:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Mar 2012 13:48:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire-sbp2: Initialise sbp2_orb->rcode for
 management ORBs
Message-ID: <20120304134802.2ed6fbd6@stein>
In-Reply-To: <1329600949-55157-1-git-send-email-bootc@bootc.net>
References: <1329600949-55157-1-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18 Chris Boot wrote:
> When sending ORBs the struct sbp2_orb->rcode field should be initialised
> to -1 otherwise complete_transaction() assumes the request is successful
> (RCODE_COMPLETE is 0). When sending managament ORBs, such as LOGIN or
> LOGOUT, this was not done and so the initiator would wait for the
> request to time out before trying again.
> 
> Without this, LOGINs are only retried when the management ORB times out,
> rather than the initiator noticing an error occurred and retrying soon
> after. For targets that advertise more than one LUN per unit, and can
> only accept one management request at a time, this means LUNs are only
> logged in one per timeout period.
> 
> Signed-off-by: Chris Boot <bootc@bootc.net>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/sbp2.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
> index b12c6ba..7776c18 100644
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -572,6 +572,9 @@ static int sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
>  	if (dma_mapping_error(device->card->device, orb->response_bus))
>  		goto fail_mapping_response;
>  
> +	/* Initialize rcode to something not RCODE_COMPLETE. */
> +	orb->base.rcode = -1;
> +
>  	orb->request.response.high = 0;
>  	orb->request.response.low  = cpu_to_be32(orb->response_bus);
>  

I left this hanging in my inbox for too long, sorry...

While I agree that the current initialization of orb->base.rcode with 0 is
wrong, I don't think your change alone is sufficient:

Consider the case that a login request to LU 0 causes the target to pull
out the hardware behind that LU out of a powered-down state --- which may
take a very long time --- and login requests to LU 1 would be aborted by
the target with resp_conflict_error on any Management_Agent write
request.  Of course a reasonably clever target would accept login before
full power-up, but you never now.

We retry login 5 times in 0.2 seconds intervals, and this 1 s in total may
not be enough.

--------
And a few notes to myself, to be done on top of the above:

a) Turn the magic value -1 into a defined constant.  Use that constant
in the two ORB initializers and in the SBP-2 status write handler.

b) The reconnect failure handling seems a bit simplistic.  I changed it
from Kristian's original retry loop to a shortcut to re-login in commit
ce896d95cc7886ae05859c5b409a7b2f3b606ec1.  While re-login instead of
reconnect during management-agent-busy situations works too, retrying
the reconnect at least during reconnect-hold period may be more robust in
such situations.

So the generation check should be replaced by checks for 1394 transaction
completion with RCODE_CONFLICT_ERROR or RCODE_BUSY, and maybe for some
other types of 1394 transaction failure or SBP-2 transaction failure.

c) Perhaps retry logout in sbp2_remove() if we clearly detect a
management-agent-busy situation.

d) Reduce log spam of the sort of "management write failed" or "failed to
reconnect" in situations where we know that we deal with such failures
correctly.
-- 
Stefan Richter
-=====-===-- --== --=--
http://arcgraph.de/sr/
