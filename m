Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129Ab0FRMQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:16:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50507 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761109Ab0FRMQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:16:53 -0400
Message-ID: <4C1B63AB.8060200@mev.co.uk>
Date: Fri, 18 Jun 2010 13:16:43 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg KH <greg@kroah.com>, Frank Mori Hess <fmhess@users.sourceforge.net>,
       Mark Rankilor <reodge@gmail.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       =?UTF-8?B?SGVucmkgSMOka2tpbmVu?= <henuxd@gmail.com>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "andrea.gelmini@gelma.net" <andrea.gelmini@gelma.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>	 <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>	 <1276405626.1449.26.camel@Joe-Laptop.home>	 <1276407050.1449.28.camel@Joe-Laptop.home>	 <20100617225108.GA32334@kroah.com>	 <1276816558.1005.93.camel@Joe-Laptop.home>	 <20100617232810.GA6821@kroah.com> <1276818421.1005.99.camel@Joe-Laptop.home>
In-Reply-To: <1276818421.1005.99.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/10 00:47, Joe Perches wrote:
> On Thu, 2010-06-17 at 16:28 -0700, Greg KH wrote:
>> On Thu, Jun 17, 2010 at 04:15:58PM -0700, Joe Perches wrote:
>>> On Thu, 2010-06-17 at 15:51 -0700, Greg KH wrote:
>>>> On Sat, Jun 12, 2010 at 10:30:50PM -0700, Joe Perches wrote:
>>>>> On Sat, 2010-06-12 at 22:07 -0700, Joe Perches wrote:
>>>>>> 2: Create some comedi logging functions or macros like:
>>>>>>    	comedi_<level>(fmt, arg...) (ie: comedi_info, comedi_err, etc)
>>>>>>    where "comedi:" is always prefixed and an
>>>>>>    optional #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>>>>>>    could be used.
>>>
>>>> I would prefer the conversion of everything over to the dev_printk()
>>>> versions instead of creating a new macro for every individual subsystem.
>>>> That way you get the advantage of logging everything in the common
>>>> format and the dynamic debug functionality as well.
>>>
>>> What I posted has dynamic_debug.
>>>
>>> +#elif defined(CONFIG_DYNAMIC_DEBUG)
>>> +/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
>>> +#define comedi_debug(fmt, ...)                         \
>>> +       dynamic_pr_debug(fmt, ##__VA_ARGS__)
>>>
>>> As far as I know, comedi doesn't always take a struct device *.
>>> I believe it's only used when there's a DMA.
>>
>> No, there's a struct device down in the device almost always.
>>
>>> In struct comedi_device, there are two struct device *'s.
>>>
>>> 	struct device *class_dev;
>>> ...
>>> 	struct device *hw_dev;
>>
>> hw_dev is what we want to use.
> 
> Perhaps Ian or Frank might clarify if
> that's reasonable.  It doesn't look like
> it to me.
> 
> Look at comedi_set_hw_dev.
> See how often it's used?

It's only set by a few drivers currently.  Perhaps it should be set by
comedi_alloc_board_minor() using the 'hardware_device' parameter.
However, in the case of "legacy" comedi devices (the ones not configured
automatically via comedi_auto_config()), that parameter will be NULL.

On a side note, if comedi_alloc_board_minor() were changed to call
comedi_set_hw_dev(), then the driver "_attach" routines could be changed
to check that they really are attaching to the correct hardware device
rather than relying on the struct comedi_devconfig options array values
(which aren't set anyway for auto-configured USB devices).
comedi_set_hw_dev() also ought to return early if the new hw_dev value
is the same as the previous value.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
