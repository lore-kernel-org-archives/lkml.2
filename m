Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2FLQRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:17:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55433 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2FLQRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:17:32 -0400
Message-ID: <4FD76B99.9070901@wwwdotorg.org>
Date: Tue, 12 Jun 2012 10:17:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl/nomadik: add STn8815 ASIC support
References: <1339146426-20697-1-git-send-email-linus.walleij@linaro.org> <4FD22ABA.6010607@wwwdotorg.org> <CACRpkdZyirEvBH7yDXCW2h54oEKueJh4fnmDrPLPH2B00m=YSg@mail.gmail.com>
In-Reply-To: <CACRpkdZyirEvBH7yDXCW2h54oEKueJh4fnmDrPLPH2B00m=YSg@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 05:28 AM, Linus Walleij wrote:
> On Fri, Jun 8, 2012 at 6:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/08/2012 03:07 AM, Linus Walleij wrote:
>>> This adds support for the STN8815 ASIC for the Nomadik pin
>>> controller.
>>
>>> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
>>
>>> @@ -1717,6 +1717,8 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
>>>                       of_match_device(nmk_pinctrl_match, &pdev->dev)->data;
>>>
>>>       /* Poke in other ASIC variants here */
>>> +     if (version == PINCTRL_NMK_STN8815)
>>> +             nmk_pinctrl_stn8815_init(&npct->soc);
>>>       if (version == PINCTRL_NMK_DB8500)
>>>               nmk_pinctrl_db8500_init(&npct->soc);
>>
>> One comment that came up in other reviews is that we shouldn't have a
>> single driver that switches on the SoC type it's running on and then
>> dispatches to different ${soc}_init() functions, but rather should have
>> multiple separate drivers, where each probe calls some utility function
>> with the appropriate SoC parameterization structures/tables.
> 
> I discussed this with Arnd, the patch doesn't give the context of where this
> identifier comes from:
> 
> static const struct platform_device_id nmk_pinctrl_id[] = {
>         { "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
>         { "pinctrl-db8500", PINCTRL_NMK_DB8500 },
> };
> 
> static struct platform_driver nmk_pinctrl_driver = {
>         .driver = {
>                 .owner = THIS_MODULE,
>                 .name = "pinctrl-nomadik",
>                 .of_match_table = nmk_pinctrl_match,
>         },
>         .probe = nmk_pinctrl_probe,
>         .id_table = nmk_pinctrl_id,
> };
> 
> And the probe looks like so:
> 
> static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
> {
>         const struct platform_device_id *platid = platform_get_device_id(pdev);
> (...)
>         if (platid)
>                 version = platid->driver_data;
> 
> So the same driver handles several platform device names, then
> the name is used to select a variant. IIRC I asked Arnd about this
> and he preferred this, and I was told by Mark Brown in the past
> to do things this way (c.f. drivers/mfs/ab8500-core.c).

Hmm. I believe that's the exact opposite of what Arnd said during review
of the SPEAr pinctrl driver! Maybe there's some other aspect of the
design that caused this scheme to be perceived as worse for SPEAr,
beyond just this simple issue.

Still, I only raised this comment because I recalled it being made on
the SPEAr review. I'm not particularly attached to doing it one way or
the other, so don't count this sub-thread as NAKing the patch or
anything like that.

> Doing it the other way is also possible but leads to a proliferation
> of probe() calls and struct platform_driver blocks, and result in
> more lines of code.
> 
> Both ways have precedents in the kernel so I actually think both
> are OK, there is two ways to skin this cat simply and I'm not that
> sensitive to which one is used.
> 
> Yours,
> Linus Walleij
