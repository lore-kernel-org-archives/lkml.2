Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab2EYKeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:34:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:35724 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2EYKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:34:00 -0400
Date: Fri, 25 May 2012 12:33:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Beulich <JBeulich@suse.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: clear HPET configuration registers on startup
In-Reply-To: <4FBF792D02000078000861BD@nat28.tlf.novell.com>
Message-ID: <alpine.LFD.2.02.1205251230550.3231@ionos>
References: <4F79D0BB020000780007C02D@nat28.tlf.novell.com> <alpine.LFD.2.02.1205242352460.3231@ionos> <4FBF792D02000078000861BD@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Jan Beulich wrote:
> >>> On 25.05.12 at 00:06, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 2 Apr 2012, Jan Beulich wrote:
> > 
> > Sorry for ignoring this for so long.
> > 
> >> +	cfg = hpet_readl(HPET_CFG);
> >> +	hpet_boot_cfg = kmalloc((last + 2) * sizeof(*hpet_boot_cfg),
> >> +				GFP_KERNEL);
> >> +	if (hpet_boot_cfg)
> >> +		*hpet_boot_cfg = cfg;
> >> +	else
> >> +		pr_warn("HPET initial state will not be saved\n");
> >> +	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
> >> +	hpet_writel(cfg, HPET_Tn_CFG(i));
> > 
> > This wants to be  
> > 
> >> +	hpet_writel(cfg, HPET_CFG);
> > 
> > Right ?
> 
> Oh yes, absolutely.
> 
> >> @@ -923,14 +952,28 @@ fs_initcall(hpet_late_init);
> >>  void hpet_disable(void)
> >>  {
> >>  	if (is_hpet_capable() && hpet_virt_address) {
> >> -		unsigned int cfg = hpet_readl(HPET_CFG);
> >> +		unsigned int cfg = hpet_readl(HPET_CFG), id, last;
> >>  
> >> -		if (hpet_legacy_int_enabled) {
> >> +		if (hpet_boot_cfg)
> >> +			cfg = *hpet_boot_cfg;
> > 
> > That restores the setting which you recorded at init time. Why do you
> > want to do that? There is no point to restore to an eventually borked
> > state. If we shut down the thing, then we better leave it in a
> > consistent state rather than something dubious, really.
> 
> The problem is that we can't - forward compatibly - say what
> is "borked" and what is merely beyond the knowledge of the
> kernel. Given the system was able to boot with the original
> settings, restoring them seems the safest approach to me.
> 
> Besides that it's not the purpose of the patch to get around
> firmware bugs, but instead to get the hardware back into
> boot-time like state. So I'd really like to merely correct the
> error above that you pointed out (which also would seem to
> be the most appropriate route given that Linus already
> merged the patch), and leave a decision whether you agree
> with my position here (or whether you want to further
> tweak that code) to you.

I can see the point, but what I really don't like is restoring to an
eventually enabled state instead of doing it proper and keep the thing
shut down.

Thanks,

	tglx
