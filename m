Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1IVHvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:51:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41000 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1IVHvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:51:20 -0400
Date: Thu, 22 Sep 2011 09:51:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI0=?=
	=?utf-8?Q?=3A?= 3.1-rc6+ rtl8192se issue
Message-ID: <20110922075115.GA17640@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	=?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	'LKML' <linux-kernel@vger.kernel.org>
References: <20110915124406.GA14374@gere.osrc.amd.com>
 <4E721871.7040901@lwfinger.net>
 <20110916180323.GA1988@gere.osrc.amd.com>
 <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
 <20110921185816.GA2036@gere.osrc.amd.com>
 <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn>
 <4E7AAB8B.40900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E7AAB8B.40900@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 10:29:15PM -0500, Larry Finger wrote:
> On 09/21/2011 08:24 PM, 李朝明 wrote:
> > Dear Sir:
> > 
> > 	I can't find _rtl_pci_lps_leave_tasklet in my driver, So I want to
> > kown which driver did you use.
> > 	Would you like to try this new driver with ips =0 and lps = 0, or
> > some combination of these two functions.
> 
> It is not in my driver either. Where did that driver come from?

That's actually _rtl_pci_ips_leave_tasklet with an "i"
in "_ips_" and it is a wrapper around rtl_lps_leave() in
<drivers/net/wireless/rtlwifi/pci.c>

Basically, that's the tasklet handler for ips_leave_tasklet regged in
_rtl_pci_init_struct():

        tasklet_init(&rtlpriv->works.ips_leave_tasklet,
                     (void (*)(unsigned long))_rtl_pci_ips_leave_tasklet,
                     (unsigned long)hw);


The sluggishness is consistent with the tasklet choking on something,
from looking at rtl_lps_leave() it grabs some spinlocks and then enables
IRQs in the middle of it with a very explanatory comment /* FIXME */
ontop of it which looks very suspicious to me:

/*Leave the leisure power save mode.*/
void rtl_lps_leave(struct ieee80211_hw *hw)
{
        struct rtl_priv *rtlpriv = rtl_priv(hw);
        struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
        struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));

        spin_lock(&rtlpriv->locks.lps_lock);

        if (ppsc->fwctrl_lps) {
                if (ppsc->dot11_psmode != EACTIVE) {

                        /*FIX ME */
                        rtlpriv->cfg->ops->enable_interrupt(hw);
...

But since I don't know anything about networking drivers, I'm actually
hoping that you guys could have an idea here.

HTH.

-- 
Regards/Gruss,
    Boris.
