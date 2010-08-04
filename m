Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab0HDXfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:35:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759272Ab0HDXfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:35:19 -0400
Date: Wed, 4 Aug 2010 16:34:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCHv3 15/16] pps: add parallel port PPS client
Message-Id: <20100804163430.a87027c6.akpm@linux-foundation.org>
In-Reply-To: <5d5d3c3916cb79104160467035603093ea4f623f.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	<5d5d3c3916cb79104160467035603093ea4f623f.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Aug 2010 01:06:52 +0400
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> Add parallel port PPS client. It uses a standard method for capturing
> timestamps for assert edge transitions: getting a timestamp soon after
> an interrupt has happened. This is not a very precise source of time
> information due to interrupt handling delays. However, timestamps for
> clear edge transitions are much more precise because the interrupt
> handler continuously polls hardware port until the transition is done.
> Hardware port operations require only about 1us so the maximum error
> should not exceed this value. This was my primary goal when developing
> this client.
> Clear edge capture could be disabled using clear_wait parameter.
> 
>
> ...
>
> +
> +#define SIGNAL_IS_SET(port) \
> +	((port->ops->read_status(port) & PARPORT_STATUS_ACK) != 0)

This could (and hence should) be implemented in a regular old C
function.

>
> ...
>
> +{
> +	struct pps_client_pp *device;
> +	struct pps_source_info info = {
> +		.name		= DRVNAME,
> +		.path		= "",
> +		.mode		= PPS_CAPTUREBOTH | \
> +				  PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
> +				  PPS_ECHOASSERT | PPS_ECHOCLEAR | \
> +				  PPS_CANWAIT | PPS_TSFMT_TSPEC,
> +		.echo		= pps_echo,
> +		.owner		= THIS_MODULE,
> +		.dev		= NULL
> +	};
> +
> +	device = kzalloc(sizeof(struct pps_client_pp), GFP_KERNEL);
> +	if (!device) {
> +		pr_err(DRVNAME ": memory allocation failed, not attaching\n");
> +		return;

eww.  parport_driver.attach() returns void so there's no way to
propagate the error code back.  That sucks a bit.

>
> ...
>
