Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab2L3LAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 06:00:50 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:37000 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2L3LAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 06:00:47 -0500
Date: Sun, 30 Dec 2012 15:00:40 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
Message-ID: <20121230110040.GA4351@cachalot>
References: <20121228175627.GA7683@cachalot>
 <87wqw15wqb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqw15wqb.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 20:05 -0800, Eric W. Biederman wrote:
> > A related issue which is NOT FIXED HERE is limits for all resources
> > available for containerized pseudo roots.  E.g. I succeeded creating
> > thousands of veth network devices without problems by a non-root user,
> > there seems no limit in number of network devices.  I suspect it is
> > possible to setup routing and net_ns'es the way it will be very
> > time-consuming for kernel to handle IP packets inside of ksoftirq, which
> > is not counted as this user scheduler time.   I suppose the issue is not
> > veth-specific, almost all newly available for unprivileged users code
> > pathes are vulnerable to DoS attacks.
> 
> veth at least should process packets synchronously so I don't see how
> you will get softirq action.

What do you mean -- synchronously?  From my limited understanding of
veth job, it is handled like every network packet in system, via:

    veth_xmit() -> dev_forward_skb() -> netif_rx() -> enqueue_to_backlog()

enqueue_to_backlog() adds the packet to softnet_data->input_pkt_queue. 

Then inside of softirq process_backlog() moves ->input_pkt_queue to
->process_queue and calls __netif_receive_skb(), which does all networking
stack magic.

AFAICS, one could create user_ns, net_ns inside of it, and setup routing
tables and netfilter to infinitely pass few network packets from and to
veth, abusing ksoftirq.

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
