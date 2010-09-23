Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0IWUbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:31:36 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:57117 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755224Ab0IWUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:31:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lGXJ0+ZDtRxxz7j46tdbcGns4H1UzJXwH1S2u7UI7cfQIlnIrW0fWp2zRyzROKQJ3q/qMJ4EdPM/IENybTML7Q7GQbRjluoB2pOqkN4VfAbauou5xtv+5TJ2oySv+pxd;
Date: Thu, 23 Sep 2010 13:31:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joe Perches <joe@perches.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
Message-ID: <20100923133132.3faae5b3@jbarnes-desktop>
In-Reply-To: <1282962104.1946.179.camel@Joe-Laptop>
References: <Pine.LNX.4.30.1008261631410.13713-100000@mail.perches.com>
	<4C770299.6000708@cesarb.net>
	<1282869660.1836.5.camel@Joe-Laptop>
	<4C77171E.6060008@cesarb.net>
	<1282894751.1836.41.camel@Joe-Laptop>
	<4C784650.2030200@cesarb.net>
	<1282962104.1946.179.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 19:21:44 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2010-08-27 at 20:12 -0300, Cesar Eduardo Barros wrote:
> > Em 27-08-2010 04:39, Joe Perches escreveu:
> > > On Thu, 2010-08-26 at 22:38 -0300, Cesar Eduardo Barros wrote:
> > >> - The first "MCP power limit exceeded" seems very bogus.
> > >> - What do you mean, core_power_limit is zero?
> > > I added a logging message whenever the turbo limits change
> > > and logging messages for power/temp on MCH for completeness.
> > > Maybe this will show something useful like when/how
> > > CPU power limit gets set to 0.
> 
> > Running with it right now, did not help much:
> > 
> > $ dmesg | fgrep 'intel ips'
> > intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match expected value 
> > (found 25, expected 35)
> > intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> > intel ips 0000:00:1f.6: IPS driver initialized, MCP temp limit 65535
> > intel ips 0000:00:1f.6: MCP power limit 65535 exceeded: cpu:8058 + 
> > mch:23392829
> > intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 5675
> > intel ips 0000:00:1f.6: CPU power limit 0 exceeded: 6369
> 
> I believe all these limits should always have non-zero values.
> So I still think you've hardware problems, but I suppose it
> could be the driver not reading the right registers or some
> such.  It seems odd that the driver never printed a logging
> message for either of the polling or irq methods to read the
> device cpu and thermal limits.
> 
> Jesse or any Intel folk, can you verify or suggest anything
> better?
> 
> If cpu_power_limit, or any _limit, is not set perhaps changing
> the test style to verify limit and adding a printed_once alert
> for each 0 value limit.  At least that'd shut up the continuous
> logging but at least give a notification message.
> 
> if (limit) {
> 	if (measured_val > limit)
> 		dev_info(foo)
> } else
> 	dev_alert_once()
> 
> Maybe something like this:
> 
>  drivers/platform/x86/intel_ips.c |  160 +++++++++++++++++++++++++++++++++-----
>  1 files changed, 140 insertions(+), 20 deletions(-)

Yes, we do need something like this.  It turns out the BIOS can
optionally program several of these values, and we need to sanity check
them.  If they're not valid (e.g. a core power limit of 0 or MCP temp
limit of 0xffff) we need to use the default values in the limit structs.

I think the programmed limits are valid if they're nonzero and less
than one of the available default limits.  If they're not valid, we
should just use the default values.  I was thinking something like the
below for MCP, but Joe you may want to just update your patch instead
since it's more complete.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 9024480..ec72e80 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -662,6 +662,17 @@ static bool mch_exceeded(struct ips_driver *ips)
 	return ret;
 }
 
+static void clamp_mcp_temp_limit(struct ips_driver *ips)
+{
+	/*
+	 * BIOS may or may not program an MCP limit.  Clamp it to the
+	 * lowest available value.
+	 */
+	if (ips->mcp_temp_limit < ips->core_temp_limit ||
+	    ips->mcp_temp_limit < ips->mch_temp_limit)
+		ips->mcp_temp_limit = min(ips->core_temp_limit, ips->mch_temp_limit);
+}
+
 /**
  * update_turbo_limits - get various limits & settings from regs
  * @ips: IPS driver struct
@@ -686,6 +697,7 @@ static void update_turbo_limits(struct ips_driver *ips)
 	ips->mcp_temp_limit = thm_readw(THM_PTL);
 	ips->mcp_power_limit = thm_readw(THM_MPPC);
 
+	clamp_mcp_temp_limit(ips);
 	/* Ignore BIOS CPU vs GPU pref */
 }
 
@@ -1155,6 +1167,7 @@ static irqreturn_t ips_irq_handler(int irq, void *arg)
 				STS_PTL_SHIFT;
 			ips->mcp_power_limit = (tc1 & STS_PPL_MASK) >>
 				STS_PPL_SHIFT;
+			clamp_mcp_temp_limit(ips);
 			spin_unlock(&ips->turbo_status_lock);
 
 			thm_writeb(THM_SEC, SEC_ACK);

