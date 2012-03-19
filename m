Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030794Ab2CSNiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:38:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51065 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2CSNiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:38:10 -0400
Message-ID: <4F6736B9.4070307@monstr.eu>
Date: Mon, 19 Mar 2012 14:38:01 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: remoteproc: Resource table for IRQs
References: <4F5F1657.9090200@monstr.eu> <CAK=WgbamnCRrEGM-xRZGie+ZoiyZx3uudXb-_dopEj7yMQYuUA@mail.gmail.com>
In-Reply-To: <CAK=WgbamnCRrEGM-xRZGie+ZoiyZx3uudXb-_dopEj7yMQYuUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Ohad Ben-Cohen wrote:
> Hi Michal,
> 
> On Tue, Mar 13, 2012 at 11:41 AM, Michal Simek <monstr@monstr.eu> wrote:
>> What do you think?
> 
> I'd really prefer to see some code to make sure I understand exactly
> what you mean.
> 
> Any change you can post something ?
> 
> Maybe even just the hard coded forwarding implementation you have today.

In system I run, cpu0 runs Linux and the second cpu runs any RTOS(let's call it firmware)
 From Linux point of view in ideal case all information which Linux work with
comes from resource table.
An expectation is that firmware will want to use IRQs. For default case all IRQs are forwarded
to cpu0 which runs Linux. That's why currently I have to forward IRQs requested by firmware to cpu1.
(It is done through new private gic function called gic_set_cpu). It is hardcoded in Linux code
that's why I am losing flezibility and I will have to explicitly say before firmware is loaded
which IRQs will be used.

For example:
Linux starts at cpu0
I know that firmware 1 requires IRQs 23.25
that's why I call git_set_cpu(1,23) and git_set_cpu(1,25) to forward IRQs to cpu1.
Then remoteproc is loaded/probed.
Firmware announces services
any work
Remove module and load firmware 2 which requires IRQs (26.28)
then I am stuck because they are not forwarded yet.


There are several solutions which can solve it:
0. Hardcoded all IRQs for all firmware which could run on zynq
con: loosing flezibility

1. Firmware can change gic and forward IRQ to itself
con: Completely out of Linux control - any linux driver can use that IRQ

2. Forward IRQs in module which will target firmware file.
con: Firmware file name could be the same and maybe make sense to be the same because that differences
can be done based on announcement services
con: less error prone because of different firmware versions

3. Do it explicitly based on resource_table which exactly describe what firmware needs
con: Maybe can be useful just for my case

Option 2 is possible to use but seems to me that using resource_table would be better.


We have played with idea that it could be also possible to run Linux in SMP mode
and then when it is request to use firmware switch cpu1 to run firmware and after
that move back SMP mode.

Maybe I am trying to do things more complicated than they are but
I still see that make sense to do it.
What do you think?

Thanks,
Michal




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
