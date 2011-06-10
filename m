Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab1FJM26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:28:58 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:36825 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755770Ab1FJM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:28:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAPYM8k1Ld/sX/2dsb2JhbAAMR4RJ2FuQaIErg26BCgSZC4gT
X-IronPort-AV: E=Sophos;i="4.65,347,1304308800"; 
   d="scan'208";a="115999237"
Message-ID: <4DF20E03.9030502@teksavvy.com>
Date: Fri, 10 Jun 2011 08:28:51 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <20110423005610.GC1576@mtj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C775549E4@gretna.indigovision.com> <20110425162242.GB30828@mtj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554BDC@gretna.indigovision.com> <20110426135027.GI878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com> <20110426155229.GM878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com> <20110430140109.GJ29280@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com> <20110525094127.GF10146@htj.dyndns.org>
In-Reply-To: <20110525094127.GF10146@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-05-25 05:41 AM, Tejun Heo wrote:
> Hello, sorry about the long delay.
> 
> On Tue, May 17, 2011 at 04:30:20PM +0100, Bruce Stenning wrote:
>> __ata_port_freeze: ata4 port frozen
>> ata4: hard resetting link
>> sata_link_hardreset: ENTER
>> ata4: COMRESET failed (errno=-32)
>> sata_link_hardreset: EXIT, rc=-32
>> ata4: reset failed (errno=-32), retrying in 33 secs
>> __ata_port_freeze: ata4 port frozen
>> ata4: hard resetting link
>> sata_link_hardreset: ENTER
>> ata4: COMRESET failed (errno=-32)
>> sata_link_hardreset: EXIT, rc=-32
>> ata4: reset failed, giving up
>> ata_eh_recover: EXIT, rc=-32
>> ata4.00: disabled
>> ata4: EH complete
>> ata_scsi_error: EXIT
>>
>> The IRQ for that port is masked off afterwards.
> 
> This is a different issue.  libata EH plugs the port if reset fails
> repeatedly.  This behavior was implemented to avoid causing continuous
> resets on a port in case it has flaky PHY state reporting; however, it
> seems to cause more trouble than fixing issues - ie. plugging in a
> broken device may end up plugging the port even after the offending
> device is removed until manual rescan or reboot.  I've been pondering
> about changing the behavior like the following.
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index dfb6e9d..05797fe 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2885,8 +2885,17 @@ int ata_eh_reset(struct ata_link *link, int classify,
>  	    sata_scr_read(link, SCR_STATUS, &sstatus))
>  		rc = -ERESTART;
>  
> -	if (rc == -ERESTART || try >= max_tries)
> +	if (rc == -ERESTART || try >= max_tries) {
> +		/*
> +		 * Thaw host port even if reset failed, so that the port
> +		 * can be retried on the next phy event.  This risks
> +		 * repeated EH runs but seems to be a better tradeoff than
> +		 * shutting down a port after a botched hotplug attempt.
> +		 */
> +		if (ata_is_host_link(link))
> +			ata_eh_thaw_port(ap);
>  		goto out;
> +	}
>  
>  	now = jiffies;
>  	if (time_before(now, deadline)) {


Tejun, did this ever go upstream and to -stable ??
I'm asking because I see the same issue with other SATA controllers,
in particular with sata_sil boards.  Hot plug generally works _once_
per port, and then stops working.
