Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2EJP7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:59:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58970 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2EJP7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:59:18 -0400
Message-ID: <4FABE5D3.9040706@wwwdotorg.org>
Date: Thu, 10 May 2012 09:59:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Hiroshi DOYU <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] Driver Core: don't oops with unregistered driver in
 driver_find_device()
References: <1336635302-29260-1-git-send-email-hdoyu@nvidia.com> <20120510141130.GA20373@kroah.com>
In-Reply-To: <20120510141130.GA20373@kroah.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 08:11 AM, Greg Kroah-Hartman wrote:
> On Thu, May 10, 2012 at 10:35:02AM +0300, Hiroshi DOYU wrote:
>> driver_find_device() can be called with an unregistered driver.
> 
> Who does that?  Where in the kernel?  Why would you try to do that?
> 
>> Need to check driver_private to see if it's populated or not,
>> especially under deferrable probe.
> 
> Hm, I don't know if this will really catch a driver that was registered
> and then was unregistered, right?  It seems like moving the real problem
> somewhere else, why not fix the original issue instead?
> 
>> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
>> ---
>> In [PATCHv5 2/3] ARM: tegra: Add SMMU enabler in AHB:
>>   http://article.gmane.org/gmane.linux.ports.tegra/4658
>>
>> "tegra_ahb_driver" may not be populated when it's called.
> 
> It can?  I don't see that in that patch.

I think this is what's happening:

The Tegra SMMU driver is registered using subsys_initcall().

The Tegra AHB driver is registered using module_platform_driver, so
module_init().

The device objects for both are registered at basically the same time
during the machine's initialization call, which I think happens before
both or some of the above two calls.

So, SMMU ends up getting probed before the AHB driver has even been
registered.

That's why in patch Hiroshi linked, in tegra_ahb_enable_smmu(), the AHB
driver hasn't (or may not have) been registered, so driver_find_device()
can experience the issue this patch attempts to solve.
