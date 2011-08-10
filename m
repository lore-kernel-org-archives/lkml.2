Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1HJMuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:50:22 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:47417 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1HJMuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:50:21 -0400
Message-ID: <4E427E89.8010700@ge.com>
Date: Wed, 10 Aug 2011 13:50:17 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: vme: allow explicit assignment of bus numbers
References: <1312968830-13377-1-git-send-email-manohar.vanga@cern.ch> <1312968830-13377-2-git-send-email-manohar.vanga@cern.ch> <4E425725.7080305@ge.com> <20110810104143.GA14060@becoht-mvanga>
In-Reply-To: <20110810104143.GA14060@becoht-mvanga>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2011 12:47:00.0093 (UTC) FILETIME=[989C6AD0:01CC575B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 11:41, Manohar Vanga wrote:
> Hey Martyn,
> 
>> I'm sorry, I'm still simply not convinced by this patch:
>>
>> 1) For a single bus driver (i.e. in the situation where we have 2 bridges of
>> the same type), the numbering of the buses is still dependent on the order
>> that they are found in the scan.
> 
> Yes this is still a bug. But this patch doesn't address this case.
> 
>> 2) If the bridge drivers are loaded as modules, I have a feeling they will be
>> loaded sequentially and therefore the order of the bridges would only change
>> if the order of the loading of the drivers changed.
> 
> And this is a major problem when it comes to multiple bridges of differing
> types. What I'm saying is that this patch simply fixes this one problematic
> case. We can move this out as soon as we have a more robust implementation.
> 
> As of now however, I think applying this is useful as we have a decent
> workaround to the problem. If you want I can make the fact of it being
> applicable only to cases with differing bridges explicit in the commit
> message.
> 

The problem is, I'm not convinced that this is the correct approach to take. I
think this should be parsed from sysfs dynamically (which may require some
work). I shall use the ethernet devices on my machine as an example:

I have 2 ethernet devices (and lo) on my machine:

$ ls /sys/class/net/
eth0  eth1  lo
$

These are symlinks and I can quite quickly find out which each of these
devices in (based on topology):
$ ls -l /sys/class/net/
total 0
lrwxrwxrwx 1 root root 0 2011-08-10 11:56 eth0 ->
../../devices/pci0000:00/0000:00:19.0/net/eth0
lrwxrwxrwx 1 root root 0 2011-08-10 11:56 eth1 ->
../../devices/pci0000:00/0000:00:1c.1/0000:03:00.0/net/eth1
lrwxrwxrwx 1 root root 0 2011-08-10 11:56 lo -> ../../devices/virtual/net/lo
$

I'd think that this contains the information that you have in the config file
(based on the previous discussion we had) and would allow you to map the bus
numbering after booting.

To do this, I think we need to register a class called "vme", I guess in
vme_init() and add a call to class_device_register in vme_register_bridge and
a call to class_device_unregister in vme_unregister_bridge.

Greg: Is that right?

I'm really not convinced that the solution presented in this patch is suitable
for inclusion upstream.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
