Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab1AWNGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 08:06:55 -0500
Received: from www.tglx.de ([62.245.132.106]:46823 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1AWNGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 08:06:53 -0500
Date: Sun, 23 Jan 2011 18:36:36 +0530
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 04/15] x86/dtb: add irq domain abstraction
Message-ID: <20110123130636.GA23058@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-5-git-send-email-bigeasy@linutronix.de> <20110111220317.GA2131@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110111220317.GA2131@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-01-11 15:03:17 [-0700]:

>>  unsigned int irq_create_of_mapping(struct device_node *controller,
>>  		const u32 *intspec, unsigned int intsize)
>>  {
>> -	return intspec[0];
>> +	struct irq_domain *ih;
>> +	u32 virq;
>> +	u32 type;
>> +	int ret;
>>  
>> +	ih = get_ih_from_node(controller);
>> +	if (!ih)
>> +		return -ENODEV;
>
>Return value is an unsigned int.  0 or NO_IRQ is the correct thing to
>return if an IRQ cannot be mapped.
fixed.

>> +	ret = ih->xlate(ih, intspec, intsize, &virq, &type);
>> +	if (ret)
>> +		return ret;
>
>Ditto here.  xlate is also supposed to return a virq number, not an
>error code, so the failure condition must be "if (!ret)" or
are you sure on that? The relevant part of powerpc's
irq_create_of_mapping() looks like:

| if (host->ops->xlate(host, controller, intspec, intsize,
|                           &hwirq, &type))
|       return NO_IRQ;

so xlate here returns 0 on success and hwirq via a pointer. I do the
same thing here except I return directly virq instead of
irq_hw_number_t. I add powerpc's irq_create_mapping() including virq <->
hwirq mapping once it is generic. I shouldn't need unless we use
non-ioapics are irq controllers.

>"if (reg == NO_IRQ)".  The former is preferred since we're trying to
>eliminate references to NO_IRQ, not add more of them.
Okay. So try to get rid of NO_IRQ in my series.

Sebastian
