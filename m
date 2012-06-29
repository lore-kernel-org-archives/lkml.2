Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2F2Pa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:30:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43491 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2F2Paz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:30:55 -0400
Message-ID: <4FEDCA2B.3060204@wwwdotorg.org>
Date: Fri, 29 Jun 2012 09:30:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: fixed: support deferred probe for DT GPIOs
References: <1340922692-24092-1-git-send-email-swarren@wwwdotorg.org> <20120629012507.GL28922@opensource.wolfsonmicro.com>
In-Reply-To: <20120629012507.GL28922@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 07:25 PM, Mark Brown wrote:
> On Thu, Jun 28, 2012 at 04:31:32PM -0600, Stephen Warren wrote:
> 
>> static struct fixed_voltage_config * 
>> -of_get_fixed_voltage_config(struct device *dev) 
>> +of_get_fixed_voltage_config(struct device *dev, bool
>> *defer_probe)
> 
> This is pretty contorted, we should just be able to pass the
> return value back more directly and of course ideally gpiolib would
> be doing the -EPROBE_DEFER for us anyway (I did send a patch for
> this, Grant didn't apply it due to a mostly unrelated issue in the
> current probe deferral implementation).  Or just defer if we don't
> get a config passed back or something.

I did consider making of_get_fixed_voltage_config() return a result
code, but then it needs some other way of returning the pointer, so
that seemed just as convoluted. Oh, I suppose it could use ERR_PTR()
to do that; that'd be nice and simple. Would that do?

Re: gpiolib doing it: How is that possible? of_get_named_gpio()
certainly can return -EPROBE_DEFER, but the caller would still need to
check it. The ideal case might be to just do:

ret = gpio_request(of_get_named_gpio(...));
if (ret)
    return ret;

and have gpio_request pass -EPROBE_DEFER from input to output.

i.e. only check the gpio_request() result code, not the
of_get_named_gpio() result code, and rely on gpio_request() to do
validation later.

But gpio_request takes an unsigned int, so the error code wouldn't
survive the translation:-(
