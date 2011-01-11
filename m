Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1AKGgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 01:36:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50088 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab1AKGgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 01:36:09 -0500
Message-ID: <4D2BF9F3.5080709@kernel.org>
Date: Mon, 10 Jan 2011 22:34:27 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/4] pci, usb:  Make usb handoff func all take base
 remapping
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org>	 <4D2BA8FE.9090204@kernel.org> <4D2BAA75.60001@kernel.org>	 <20110111010714.GB32585@kroah.com>  <4D2BB048.2050509@kernel.org> <1294723290.17779.349.camel@pasglop>
In-Reply-To: <1294723290.17779.349.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 09:21 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2011-01-10 at 17:20 -0800, Yinghai Lu wrote:
>>
>> for early access, can not use udelay yet, it will take some one.
>> Also msleep will cause crash, because it needs scheduler there.
> 
> Right, and that's for such special cases (hopefully rare) that we have
> system_state... Much better than your function pointers I reckon.

system_state does not work.
it only have BOOTING and RUNNING ...
RUNNING is set in init/main.c::init_post().
so early_quirk and pci_quirk all with BOOTING stage...

 slab_is_available() could be used, but looks alike abuse.

> 
> We could even wrap it into a safe_delay() function or whatever (in fact
> why not make msleep() itself safe ? It's not like it was timing critical
> code :-)

like 
void safe_udelay(unsigned long usecs)
{
	if (slab_is_available())
		udelay(usecs)
	else
		early_udelay(usecs);
}

or wonder if you are happy with

void __weak safe_udelay(unsigned long usecs)
{
	udelay(usecs);
}

and will have x86 have it's own safe_udelay...


Yinghai
