Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269Ab0GPMCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:02:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34709 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965049Ab0GPMCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:02:50 -0400
Date: Fri, 16 Jul 2010 15:02:48 +0300 (EEST)
From: "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@melkinpaasi.cs.helsinki.fi
To: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fehrmann, Henning" <henning.fehrmann@aei.mpg.de>,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Re: oops in tcp_xmit_retransmit_queue() w/ v2.6.32.15
In-Reply-To: <4C3F053F.7090704@nets.rwth-aachen.de>
Message-ID: <alpine.DEB.2.00.1007161448330.13946@melkinpaasi.cs.helsinki.fi>
References: <4C358AAA.9080400@kernel.org> <alpine.DEB.2.00.1007111825510.15736@melkinpaasi.cs.helsinki.fi> <4C3EF7EA.2040900@nets.rwth-aachen.de> <1279195528.2496.2.camel@edumazet-laptop> <4C3F053F.7090704@nets.rwth-aachen.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Lennart Schulte wrote:

> Since tcp_xmit_retransmit_queue also gets skb == NULL I'm pretty sure it is
> the same bug.
> Up to now I only experienced the problem with ACK loss (without ACK loss the
> test ran about 30min without problems, with ACK loss it had paniced within
> 10min).
> The data sender only has a HTB queue for traffic shaping (set to 20 Mbit/s).
> The ACK loss is done by another router.
> The setup looks like this. This way it seems to be the most realistic.
> 
> o sender with HTB
> |
> |
> o netem queue for forward path delay
> |
> o netem queue for a queue limit
> |
> o netem queue for backward path delay
> |
> o netem queue for ACK loss
> |
> |
> o receiver with HTB
> 
> Perhaps now it is a little big clearer.

> > > [ 2754.413150] NULL head, pkts 0
> > > [ 2754.413156] Errors caught so far 1

Thanks for reporting the results.

Could you post the oops too or double check do the timestamps really match 
(and there wasn't more "Errors caught" prints in between)? Since this 
condition doesn't seem to crash the kernel as also send_head should be 
NULL, which saves the day here exiting the loop (unless send head would 
too be corrupt). ...However, I don't like too much anyway that we can end 
up into tcp_xmit_retransmit_queue loop with packets_out being zero and 
only send_head check side-effect causes proper action.

Besides, Tejun has also found that it's hint->next ptr which is NULL in 
his case so this won't solve his case anyway. Tejun, can you confirm 
whether it was retransmit_skb_hint->next being NULL on _entry time_ to 
tcp_xmit_retransmit_queue() or later on in the loop after the updates done 
by the loop itself to the hint (or that your testing didn't conclude 
either)?

-- 
 i.
