Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab2GJTIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:08:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54325 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2GJTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:08:30 -0400
User-Agent: Microsoft-Entourage/12.32.0.111121
Date: Tue, 10 Jul 2012 20:08:15 +0100
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
From: Keir Fraser <keir.xen@gmail.com>
To: Olaf Hering <olaf@aepfle.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, <xen-devel@lists.xensource.com>,
        <kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Daniel Kiper <dkiper@net-space.pl>
Message-ID: <CC223C2F.3817C%keir.xen@gmail.com>
Thread-Topic: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Thread-Index: Ac1ez1uAufzi7sIrtEiO9chG7TXVoQ==
In-Reply-To: <20120710180953.GB20075@aepfle.de>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2012 19:09, "Olaf Hering" <olaf@aepfle.de> wrote:

>>> Are there more shared areas or is it just the shared info page?
>>> 
>>>> And I am kind of worried that moving it to the .data section won't
>>>> be completly safe - as the decompressor might blow away that part too.
>>> 
>>> The decompressor may just clear the area, but since there is no way to
>>> tell where the shared pages are its always a risk to allocate them at
>>> compile time.
>> 
>> Yeah, and with the hypervisor potentially still updating the "old"
>> MFN before the new kernel has registered the new MFN, we can end up
>> corrupting the new kernel. Ouch.
>> 
>> Would all of these issues disappear if the hypervisor had a hypercall
>> that would stop updating the shared info? or just deregister the MFN?
>> What if you ripped the GMFN out using 'decrease_reservation' hypercall?
>> Would that eliminate the pesky GMFN?
> 
> I'm not sure, most likely the gfn will just disappear from the guest,
> like a ballooned page disappears. Accessing it will likely cause a
> crash.

Best thing to do, is possible, is map the shared-info page in the
xen-platform pci device's BAR memory range. Then it will not conflict with
any RAM.

If you do map it over the top of an existing RAM page, you will have to
repopulate that RAM page before kexec, using populate_physmap hypercall. The
good news is that the populate_physmap hypercall will have the side effect
of unmapping the shared-info page, reayd to be mapped wherever the new
kernel would like it to reside :)

Hope this clears up some of the confusion. ;)

 -- Keir


