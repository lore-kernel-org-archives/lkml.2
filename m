Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2EYKUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:20:33 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58539 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2EYKUc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 25 May 2012 06:20:32 -0400
Message-Id: <4FBF792D02000078000861BD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 25 May 2012 11:21:01 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: clear HPET configuration registers on startup
References: <4F79D0BB020000780007C02D@nat28.tlf.novell.com>
 <alpine.LFD.2.02.1205242352460.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205242352460.3231@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.05.12 at 00:06, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 2 Apr 2012, Jan Beulich wrote:
> 
> Sorry for ignoring this for so long.
> 
>> +	cfg = hpet_readl(HPET_CFG);
>> +	hpet_boot_cfg = kmalloc((last + 2) * sizeof(*hpet_boot_cfg),
>> +				GFP_KERNEL);
>> +	if (hpet_boot_cfg)
>> +		*hpet_boot_cfg = cfg;
>> +	else
>> +		pr_warn("HPET initial state will not be saved\n");
>> +	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
>> +	hpet_writel(cfg, HPET_Tn_CFG(i));
> 
> This wants to be  
> 
>> +	hpet_writel(cfg, HPET_CFG);
> 
> Right ?

Oh yes, absolutely.

>> @@ -923,14 +952,28 @@ fs_initcall(hpet_late_init);
>>  void hpet_disable(void)
>>  {
>>  	if (is_hpet_capable() && hpet_virt_address) {
>> -		unsigned int cfg = hpet_readl(HPET_CFG);
>> +		unsigned int cfg = hpet_readl(HPET_CFG), id, last;
>>  
>> -		if (hpet_legacy_int_enabled) {
>> +		if (hpet_boot_cfg)
>> +			cfg = *hpet_boot_cfg;
> 
> That restores the setting which you recorded at init time. Why do you
> want to do that? There is no point to restore to an eventually borked
> state. If we shut down the thing, then we better leave it in a
> consistent state rather than something dubious, really.

The problem is that we can't - forward compatibly - say what
is "borked" and what is merely beyond the knowledge of the
kernel. Given the system was able to boot with the original
settings, restoring them seems the safest approach to me.

Besides that it's not the purpose of the patch to get around
firmware bugs, but instead to get the hardware back into
boot-time like state. So I'd really like to merely correct the
error above that you pointed out (which also would seem to
be the most appropriate route given that Linus already
merged the patch), and leave a decision whether you agree
with my position here (or whether you want to further
tweak that code) to you.

Jan

