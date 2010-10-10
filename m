Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab0JJMid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 08:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429Ab0JJMic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 08:38:32 -0400
Message-ID: <4CB1B3B9.4030205@redhat.com>
Date: Sun, 10 Oct 2010 14:38:17 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com,
        linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
References: <20101010115941.GA8539@basil.fritz.box>
In-Reply-To: <20101010115941.GA8539@basil.fritz.box>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/10/2010 01:59 PM, Andi Kleen wrote:
> DM-CRYPT: Scale to multiple CPUs v3
> 
> [Due to popular demand this is a port of the dm-crypt scalability
> patch to 2.6.36-rc7.  The 2.6.35 and .32 patches were widely used by
> lots of users with good results. 
> 

Hi Andi,

please can you check split patches in
http://mbroz.fedorapeople.org/dm-crypt/2.6.36-devel/

is there some change in your new version?

Can I send this to dm-devel instead? 
(It is better for review.)

I know that I fixed some small bug there and these are heavily
tested by me.

Alasdair, _please_ can you include it in dm-tree?
I asked you at least 5 times already, my last info is that
you are planning this for 2.6.37, right?


>  static void kcryptd_queue_io(struct dm_crypt_io *io)
>  {
> -	struct crypt_config *cc = io->target->private;
> +	int cpu;
> +
> +	/*
> +	 * Since we only have a single worker per CPU in extreme
> +	 * cases there might be nesting (dm-crypt on another dm-crypt)
> +	 * To avoid deadlock run the work directly then.
> +	 */
> +	cpu = get_cpu();
> +	if (per_cpu(io_wq_cpu, cpu) == current && !in_interrupt()) {
> +		put_cpu();
> +		kcryptd_io(&io->work);
> +		return;
> +	}

This is only place where I see problem - if running in crypto async mode,
callback is called in interrupt mode (please correct me if I am wrong).

So with async crypto and nested dm-crypt mapping this deadlock
prevention doesn't work - so is there still possibility of deadlock?

(I think we can ignore it for now, I tried create some "real world" deadlocky
mappings some time ago and was not able to catch it even on high memory pressure.)

Milan
