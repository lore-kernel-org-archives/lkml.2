Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2DNKSK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:18:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60618 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2DNKSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:18:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 14 Apr 2012 12:17:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH 08/11] firewire-sbp-target: Add sbp_login.{c,h}
Message-ID: <20120414121743.30d46a77@stein>
In-Reply-To: <1334154043-69076-9-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1334154043-69076-1-git-send-email-bootc@bootc.net>
	<1334154043-69076-9-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 11 Chris Boot wrote:
> +static void session_check_for_reset(struct sbp_session *sess)
> +{
> +	bool card_valid = false;
> +
> +	spin_lock_bh(&sess->lock);
> +
> +	if (sess->card) {
> +		spin_lock_irq(&sess->card->lock);
> +		card_valid = (sess->card->local_node != NULL);
> +		spin_unlock_irq(&sess->card->lock);
> +
> +		if (!card_valid) {
> +			fw_card_put(sess->card);
> +			sess->card = NULL;
> +		}
> +	}
> +
> +	if (!card_valid || (sess->generation != sess->card->generation)) {
> +		pr_info("Waiting for reconnect from node: %016llx\n",
> +				sess->guid);
> +
> +		sess->node_id = -1;
> +		sess->reconnect_expires = get_jiffies_64() +
> +			((sess->reconnect_hold + 1) * HZ);
> +	}
> +
> +	spin_unlock_bh(&sess->lock);
> +}

The card->local_node != NULL test by itself is atomic, it does not benefit
from being wrapped by card->lock acquisition.

Well, OK, the lock effectively forces the compiler to determine the value
of card_valid only once.  If the lock weren't there I guess the compiler
might feel entitled to reload card->local_node in the second !card_valid
test.  But even if you lose ACCESS_ONCE behavior by removing the card->lock
acquisition, I can't see how that could be detrimental relative to the
current code.

I am wondering on the other hand if there isn't actually a dependency
between this local_node test and something else, e.g. the generation test.
I.e. might the locking be incomplete?  Not sure about that.  I think I
rather want to look at that again when I received the code through
mainline.

BTW "card_valid" sounds rather generic; maybe call it "topology_valid"?
Either way, it can turn valid or invalid any time when firewire-core gets
to handle a self-ID-complete event.
-- 
Stefan Richter
-=====-===-- -=-- -===-
http://arcgraph.de/sr/
