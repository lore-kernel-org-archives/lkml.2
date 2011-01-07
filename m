Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab1AGXOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:14:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34503 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1AGXN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jK4/TPCnRh+AOzS8CXxOTtU9/Mjhj1uVI6+Dk1/WYkh92CQRNqUcAwLXt0tV17qOFD
         aX/ktmBKPf42yHmzwFMvh/xF/Xfn5doQmJIyTAzwBng1TzOSfGf3bNuPQHdcIzD7KHYu
         Y46E1A5ALG4Y72E0S1vBrlSnstKE2aD0dhnB4=
Message-ID: <4D279E30.8070706@gmail.com>
Date: Sat, 08 Jan 2011 00:13:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz>	<201101061224.40596.bjorn.helgaas@hp.com>	<4D277B33.1000508@gmail.com> <20110107143741.7b2b2a8d@jbarnes-desktop>
In-Reply-To: <20110107143741.7b2b2a8d@jbarnes-desktop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 11:37 PM, Jesse Barnes wrote:
> On Fri, 07 Jan 2011 21:44:35 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> On 01/06/2011 08:24 PM, Bjorn Helgaas wrote:
>>> Theoretically, ACPI tells us about the GPIO/TCO/etc. regions in a
>>> generic way via namespace devices or something in the static tables.
>>> Is that generic information missing, or is it there and Linux is
>>> ignoring it?  If we're ignoring it, I'd rather fix that.
>>
>> It works for most boxes I would say. Try to google for "claimed by ICH4
>> ACPI/GPIO/TCO", it reports sane ranges like 0400-047f or 4000-407f.
>>
>>> The main reason for claiming I/O regions is to keep us from placing
>>> another device on top of them.  But we've had PCIBIOS_MIN_IO = 0x1000
>>> forever, which should keep us from putting anything below that anyway
>>> (at least for PCI devices).  So there must be some other reason for
>>> claiming space in this quirk.
>>
>> Anyway, this ACPI space may be below 0x1000 as can be seen above. From
>> the ICH standard, it can be anywhere...
> 
> Is there some other resource we should be considering to avoid this
> space?

There are two kinds of address ranges (spaces) in ICH specs. Fixed
(address base is fixed) and Variable (base can be changed). And Fixed
space should not collide (the behaviour is explicitly unpredictable)
with Variable.

This ACPI space is defined as Variable. So it cannot collide with any
Fixed. Most of the Fixed are below 0x180, there is also 0x376, 0x3f6 for
IDE, 0x4D0-0x4D1 for PIC and 0xCF9 for reset generator.

> And we know it won't work if we try to use the IDE controller in the
> LPC allocated space?  Have you checked the ICH4 specs to see what the
> decode rules are on this space? I guess LPC has priority and doesn't
> forward requests through to IDE?

If we read/write to ports 0x170-0x17f, IDE ctrl responds on that
machine. I.e. if I remove the quirk, disks are found. (Otherwise they
are not due to the conflict.)

thanks,
-- 
js
