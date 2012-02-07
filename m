Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2BGM0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:26:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45337 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab2BGM0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:26:21 -0500
Date: Tue, 7 Feb 2012 12:23:17 +0000
From: "Carlos R. Mafra" <crmafra@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] [3.3-rc2+] Thousands of ath9k warnings on dmesg
 before laptop froze
Message-ID: <20120207122317.GA2289@Pilar.site>
References: <20120206002907.GA1899@Pilar.site>
 <20120206175702.3a41ffc4@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206175702.3a41ffc4@mj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Feb 2012 at 17:57:02 -0500, Pavel Roskin wrote:
> On Mon, 6 Feb 2012 00:29:07 +0000
> "Carlos R. Mafra" <crmafra@gmail.com> wrote:
> 
> > 
> > I'm testing the latest kernel 3.3.0-rc2+ I pulled from git 
> > this morning.
> > 
> > My laptop just froze, and when I rebooted I noticed
> > that /var/log/messages contained 48 thousand (!) warnings coming from
> > ath9k since a few hours ago. I'm pasting the first one:
> 
> > 
> >  ------------[ cut here ]------------
> >  WARNING:
> > at /home/mafra/linux-2.6/drivers/net/wireless/ath/ath9k/rc.c:697
> > ath_rc_get_highest_rix+0x156/0x210 [ath9k]() Hardware name: VPCEB4X1E
> 
> I believe I found a solution for this today.  Please see this bug
> tracker: https://bugzilla.redhat.com/show_bug.cgi?id=768639
> 
> While Fedora users report a warning, I've seen panic reports in the
> list.  It's a memory corruption bug, so it can manifest in different
> ways.  Please test the latest patch (attached).
> 
> Here's my comment to the patch:
> 
> This patch is based on my analysis of printk() output I added to the
> ath9k driver.  I didn't have a chance to test the patch, so testing
> would be greatly appreciated.
> 
> The corruption must be happening in ath_debug_stat_rc(), which is given
> the result of ath_rc_get_rateindex().  ath_rc_get_rateindex() can
> return -1, which causes ath_debug_stat_rc() to increment the value that
> lies 16 bytes before rcstats in struct ath_rate_priv.  On 64-bit
> systems, that happens to be rate_table.  Once the rate_table pointer is
> incremented, all data there becomes invalid, which leads to the
> warning.  On 32-bit systems, the corruption should happen in
> neg_ht_rates.
> 
> The -1 value of idx in struct ieee80211_tx_rate is described in
> net/mac80211.h. I don't know why we have -1 there and how to reproduce
> the problem reliably. But -1 can be there and ath9k has no checks for
> it.
> 
> The patch introduces two protections: ath_rc_get_rateindex() never
> returns a negative value and ath_debug_stat_rc() checks the array
> bounds.
> 
> It may not be good enough for the kernel, but it may be good enough for
> Fedora.


Thanks for the link to the bugzilla and for the attached patch. 

I'm currently testing it, and so far so good.



> Prevent memory corruption in ath9k rate control algorithm
> 
> From: Pavel Roskin <proski@gnu.org>
> 
> Check final_rate in ath_debug_stat_rc().  Don't return negative values
> from ath_rc_get_rateindex(), callers don't expect it.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
> 
>  drivers/net/wireless/ath/ath9k/rc.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index 635b592..afe22f4 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -385,6 +385,11 @@ static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
>  	int rix = 0, i = 0;
>  	static const int mcs_rix_off[] = { 7, 15, 20, 21, 22, 23 };
>  
> +	if (rate->idx < 0) {
> +		printk(KERN_ERR "%s: rate->idx = %d\n", __func__, rate->idx);
> +		return 0;
> +	}
> +
>  	if (!(rate->flags & IEEE80211_TX_RC_MCS))
>  		return rate->idx;
>  
> @@ -1324,6 +1329,11 @@ static void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
>  {
>  	struct ath_rc_stats *stats;
>  
> +	if (final_rate < 0 || final_rate >= RATE_TABLE_SIZE) {
> +		printk(KERN_ERR "%s: invalid final_rate: %d\n", __func__,
> +		       final_rate);
> +		return;
> +	}
>  	stats = &rc->rcstats[final_rate];
>  	stats->success++;
>  }

