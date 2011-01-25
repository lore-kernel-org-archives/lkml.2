Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1AYICr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:02:47 -0500
Received: from a.relay.invitel.net ([62.77.203.3]:43981 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1AYICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:02:45 -0500
Date: Tue, 25 Jan 2011 09:02:15 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH 3/4 v4] video, sm501: add OF binding to support SM501
In-reply-to: <20110125074820.GI11673@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Reply-to: hs@denx.de
Message-id: <4D3E8387.10501@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1295940031-28268-1-git-send-email-hs@denx.de>
 <20110125074820.GI11673@linux-sh.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

Paul Mundt wrote:
> On Tue, Jan 25, 2011 at 08:20:31AM +0100, Heiko Schocher wrote:
>> @@ -1934,7 +1943,29 @@ static int __devinit sm501fb_probe(struct platform_device *pdev)
>>  	}
>>  
>>  	if (info->pdata == NULL) {
>> -		dev_info(dev, "using default configuration data\n");
>> +		int found = 0;
>> +#if defined(CONFIG_OF)
>> +		struct device_node *np = pdev->dev.parent->of_node;
>> +		const u8 *prop;
>> +		const char *cp;
>> +		int len;
>> +
>> +		info->pdata = &sm501fb_def_pdata;
>> +		if (np) {
>> +			/* Get EDID */
>> +			cp = of_get_property(np, "mode", &len);
>> +			if (cp)
>> +				strcpy(fb_mode, cp);
>> +			prop = of_get_property(np, "edid", &len);
>> +			if (prop && len == EDID_LENGTH) {
>> +				info->edid_data = kmemdup(prop, EDID_LENGTH,
>> +							  GFP_KERNEL);
>> +				found = 1;
>> +			}
>> +		}
>> +#endif
>> +		if (!found)
>> +			dev_info(dev, "using default configuration data\n");
>>  	}
>>  
>>  	/* probe for the presence of each panel */
> 
> Starting to get a bit pedantic.. but kmemdup() tries to do a kmalloc(),

No problem!

> and so can fail. Your other patches handle the info->edid_data == NULL
> case, in addition to the kfree(), but you're probably going to want to
> chomp that found assignment incase of the allocation failing and falling
> back on the default mode.
> 
> You also don't really have any need to keep the EDID block around after
> probe as far as I can tell, so you should be able to rework this in to
> something more like:
> 
> 	info->edid_data = kmemdup(..);
> 	...
> 	if (info->edid_data) {
> 		fb_edid_to_monspecs(..);
> 		kfree(info->edid_data);
> 		fb_videomode_to_modelist(..);
> 	}
> 
> 	...

Ok, rework this part, thanks!

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
