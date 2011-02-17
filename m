Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1BQXMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:12:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63162 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1BQXMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:12:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=b9PxWD/gHKwgNadTX2nMod9hOjk9h4XgjxftKX+C1xmtqx47vAWDLxoVNyVZSXWfJL
         MeN+DdcjUIkCfGvvyazzlKeDQvXUmMMjeQvyrYnsd6tAA70d7t69SCj5eIqjFNgWfzwQ
         TLHDhKW6EGPPq8viZhlJcQUbxVsFdxTiRxrPo=
MIME-Version: 1.0
In-Reply-To: <4D5D6517.5060600@redhat.com>
References: <4D5D562A0200007800032744@vpn.id2.novell.com>
	<4D5D6517.5060600@redhat.com>
Date: Thu, 17 Feb 2011 15:12:45 -0800
X-Google-Sender-Auth: Z2DcqRw__EIh_JA4xvtecoCDokc
Message-ID: <AANLkTi=SR-HsBuOA0V6GPtD4wY+s663_6TT9aJVVjjrK@mail.gmail.com>
Subject: Re: [PATCH, resend] x86/PCI: don't export a __devinit function
From: Yinghai Lu <yinghai@kernel.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, arozansk@redhat.com, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 10:12 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 17-02-2011 14:08, Jan Beulich escreveu:
>> Exporting a __devinit function (pcibios_scan_specific_bus()) isn't
>> correct. (Michal, any reason why modpost only warns about exported
>> __init functions?) Short of being able to think of a better solution,
>> and short of making the whole call tree (reaching into the arch-
>> independent part of the PCI subsystem) non-__devinit, export the
>> symbol only when HOTPLUG is enabled (which is always the case for non-
>> expert configurations), use section mismatch avoidance annotations for
>> that case (knowing that __devinit functions will not be discarded),
>> and mark the symbol __devinit only in the !HOTPLUG case.
>>
>> Consequently, EDAC_I7CORE (consuming the export) then has to depend on
>> HOTPLUG.
>
> Having the entire i7core_edac driver depending on HOTPLUG, just because
> a few BIOSes want to hide the non-core PCI devices doesn't seem nice.
> One alternative would be to enclose the code that needs this function
> with #ifdef CONFIG_HOTPLUG.
>
>> A fundamental question of course if whether this driver has
>> to use that function in the first place (i.e. whether it wouldn't be
>> better to just remove the export) - the problem it tries to address
>> happens on other systems too, but the PCI bus the devices in question
>> live on isn't necessarily bus 255. For the affected system I have, the
>> alternative approach is to set pcibios_last_bus from __pci_mmcfg_init()
>> based on the highest bus number on segment 0 being covered by MCFG.
>
> I received a few days ago a report that some BIOSes that hide those
> PCI devices also use a different address for the last bus (0x3f, instead
> of 0xff). So, it seems that the better would be to use an alternative
> way to retrieve the last bus.

just append "pci=lastbus=255" will get all those devices.

Yinghai
