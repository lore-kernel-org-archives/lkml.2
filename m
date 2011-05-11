Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1EKTUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:20:36 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:63067 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab1EKTUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:20:35 -0400
Message-ID: <4DCAE163.2050602@metafoo.de>
Date: Wed, 11 May 2011 12:20:03 -0700
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "'Grant Likely'" <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: Question: GPIO driver how to get irq_base
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com> <4DAFE62A.105@metafoo.de> <20110421134524.GA32725@ponder.secretlab.ca> <4DB03A4B.9040807@metafoo.de> <20110421142422.GC32725@ponder.secretlab.ca> <4C95BE12C2D7458E9D2B54E7C30F712F@hacdom.okisemi.com> <4DB2A6A2.90803@metafoo.de> <614E530848124206BD1A074548078FA8@hacdom.okisemi.com> <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com>
In-Reply-To: <FF5A4B77828A4F1AA77531640E8B37FF@hacdom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 10:54 PM, Tomoya MORINAGA wrote:
> Hi Lars,
> 
> Did you see this email ?
> I'm waiting for your response.
> 

Hi

Well, it looks as if io-apic assumes that IRQ18 is reserved for itself, while
it actually is requested by your driver. But that's all I can say. I'm not
familiar with the x86 irq code, so I've no idea what the proper fix would be.

- Lars


> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.
> 
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org 
>> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>> Tomoya MORINAGA
>> Sent: Monday, April 25, 2011 1:04 PM
>> To: 'Lars-Peter Clausen'
>> Cc: 'Grant Likely'; linux-kernel@vger.kernel.org; 
>> toshiharu-linux@dsn.okisemi.com
>> Subject: RE: Question: GPIO driver how to get irq_base
>>
>> Hi Lars,
>>
>> On Saturday, April 23, 2011 7:15 PM, Lars-Peter Clausen wrote:
>>> It looks as both your driver and IO-APIC have allocated the 
>> same IRQ. 
>>> You could try to add some debug code to 
>> alloc_irq_and_cfg_at to figure 
>>> out what is going wrong.
>>>
>>> - Lars
>>
>> Adding debug code like below.
>>
>> //////////////////////////////////////////////////////////////
>> ///////////////////////////////////
>> static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, 
>> int node) {
>> 	int res = irq_alloc_desc_at(at, node);
>> 	struct irq_cfg *cfg;
>> printk("%s:1 at=%d node=%d res=%d\n", __func__, at, node, res);
>> 	if (res < 0) {
>> printk("%s:2\n", __func__);
>> 		if (res != -EEXIST)
>> 			return NULL;
>> printk("%s:3\n", __func__);
>> 		cfg = get_irq_chip_data(at);
>> printk("%s:4\n", __func__);
>> 		if (cfg)
>> 			return cfg;
>> 	}
>>
>> 	cfg = alloc_irq_cfg(at, node);
>> printk("%s:5cfg=%p\n", __func__, cfg);
>> 	if (cfg)
>> 		set_irq_chip_data(at, cfg);
>> 	else
>> 		irq_free_desc(at);
>> printk("%s:6cfg=%p\n", __func__, cfg);
>> 	return cfg;
>> }
>> //////////////////////////////////////////////////////////////
>> ///////////////////////////////////
>>
>> The following is kernel boot log.
>>
>> alloc_irq_and_cfg_at:1 at=1 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=0 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=3 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=4 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=5 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=6 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=7 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=8 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=9 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=10 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=11 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=12 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=13 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=14 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:1 at=15 node=0 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>>
>> alloc_irq_and_cfg_at:1 at=4 node=-1 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>>
>> alloc_irq_and_cfg_at:1 at=8 node=-1 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>>
>> alloc_irq_and_cfg_at:1 at=13 node=-1 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>>
>> alloc_irq_and_cfg_at:1 at=1 node=-1 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>>
>> alloc_irq_and_cfg_at:1 at=12 node=-1 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>>
>> alloc_irq_and_cfg_at:1 at=16 node=-1 res=16 
>> alloc_irq_and_cfg_at:5cfg=f599c1b0
>> alloc_irq_and_cfg_at:6cfg=f599c1b0
>>
>> alloc_irq_and_cfg_at:1 at=17 node=-1 res=17 
>> alloc_irq_and_cfg_at:5cfg=f599c1a0
>> alloc_irq_and_cfg_at:6cfg=f599c1a0
>>
>> alloc_irq_and_cfg_at:1 at=19 node=-1 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>> alloc_irq_and_cfg_at:5cfg=f5957dc0
>> alloc_irq_and_cfg_at:6cfg=f5957dc0
>>
>> alloc_irq_and_cfg_at:1 at=18 node=-1 res=-17
>> alloc_irq_and_cfg_at:2
>> alloc_irq_and_cfg_at:3
>> alloc_irq_and_cfg_at:4
>>
>>
>> With Best Regards,
>> -----------------------------------------
>> Tomoya MORINAGA
>> OKI SEMICONDUCTOR CO., LTD.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in the body of a message to 
>> majordomo@vger.kernel.org More majordomo info at  
>> http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

