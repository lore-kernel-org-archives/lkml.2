Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1IWQzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:55:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52895 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1IWQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:55:31 -0400
Message-ID: <4E7CB9FF.5020401@gmail.com>
Date: Fri, 23 Sep 2011 09:55:27 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
References: <20110922184614.25419.84606.stgit@ponder>	<20110922212909.49966cf4@lxorguk.ukuu.org.uk>	<4E7BA661.7070903@cavium.com> <20110922234737.05dff9f8@lxorguk.ukuu.org.uk>
In-Reply-To: <20110922234737.05dff9f8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2011 03:47 PM, Alan Cox wrote:
>> How would a given driver know that something else is waiting for it?  Or
>> would we add the explicit kick to each and every driver in the tree?
>
> I think there are very very few drivers that have this property and don't
> already implicitly cause a probe by creating a new bus or device.
>

These are precisely the drivers of concern.  However it is not 
individual drivers, but whole classes of drivers.  In my case we are 
talking about GPIO drivers.

If there is a dependency on GPIO devices, we don't know which 
device/driver will be providing the GPIO services, so at a minimum *all* 
GPIO drivers would have to add the explicit kick.

> Those drivers that set something up for another device really should
> know what is going on because they are making a guarantee that they are
> ready for the other device to call into them or whatever is going on at
> some point, either explicitly in the kick or implicitly in returning from
> their probe method.

Really the driver framework is there to do all this already.  Once the 
probe method is called, the device is usually presented as 'ready' in 
some sense.

The problem this patch solves is to make it work when there are ad hoc 
relationships between the devices that cannot be represented in a tree 
like structure presented by the bus/driver topology of the driver framework.

If there are no deferred probes necessary, the only overhead is a single 
check to see if work needs to be done.  Since in this case, nothing 
needs to be done...  Nothing is done.


>
> I know which I think is clearer and easier for a 3rd party to see and not
> miss completely when updating code.

?? I don't understand that statement.

A handful of lines of code in the driver core vs. having to wonder, and 
then get it right, for each and every driver if there could be a 
dependency outside of the bus framework.

