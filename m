Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2BCTo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:44:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab2BCToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:44:25 -0500
Date: Fri, 3 Feb 2012 11:44:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 3/6] ipmi: use a tasklet for handling received messages
Message-Id: <20120203114414.0f9ae99a.akpm@linux-foundation.org>
In-Reply-To: <1328284079-5489-3-git-send-email-cminyard@mvista.com>
References: <1328284079-5489-1-git-send-email-cminyard@mvista.com>
	<1328284079-5489-3-git-send-email-cminyard@mvista.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Feb 2012 09:47:56 -0600
Corey Minyard <cminyard@mvista.com> wrote:

> The IPMI driver would release a lock, deliver a message, then relock.
> This is obviously ugly, and this patch converts the message handler
> interface to use a tasklet to schedule work.  This lets the receive
> handler be called from an interrupt handler with interrupts enabled.
> 
> ...
>
> +/*
> + * If there are messages in the queue or pretimeouts, handle them.
> + */
> +static void handle_new_recv_msgs(ipmi_smi_t intf)
> +{
> +	struct ipmi_smi_msg  *smi_msg;
> +	unsigned long        flags = 0;
> +	int                  rv;
> +	int                  run_to_completion = intf->run_to_completion;
> +
> +	/* See if any waiting messages need to be processed. */
> +	if (!run_to_completion)
> +		spin_lock_irqsave(&intf->waiting_msgs_lock, flags);
> +	while (!list_empty(&intf->waiting_msgs)) {
> +		smi_msg = list_entry(intf->waiting_msgs.next,
> +				     struct ipmi_smi_msg, link);
> +		list_del(&smi_msg->link);
> +		if (!run_to_completion)
> +			spin_unlock_irqrestore(&intf->waiting_msgs_lock, flags);

Yikes, what's going on here?  How is the list protected if the spinlock
isn't taken?

I went to the comment over ipmi_smi.run_to_completion but it doesn't
explain how it governs the locking strategy at all.  If there's some
other way in which the reader is supposed to grok IPMI locking, please
clue me in ;)

>
> ...
>
