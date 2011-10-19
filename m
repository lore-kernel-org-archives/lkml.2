Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1JSTOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 15:14:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1JSTOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 15:14:35 -0400
Message-ID: <4E9F2180.6030207@redhat.com>
Date: Wed, 19 Oct 2011 17:14:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        EDAC devel <linux-edac@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] x86, RAS: Start reorganizing RAS features support
References: <1319035866-29570-1-git-send-email-bp@amd64.org> <1319035866-29570-3-git-send-email-bp@amd64.org> <987664A83D2D224EAE907B061CE93D5301F19DBDB5@orsmsx505.amr.corp.intel.com> <4E9F0753.1010206@redhat.com> <20111019181141.GA6346@aftab>
In-Reply-To: <20111019181141.GA6346@aftab>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-10-2011 16:11, Borislav Petkov escreveu:
> On Wed, Oct 19, 2011 at 01:22:27PM -0400, Mauro Carvalho Chehab wrote:
>> Em 19-10-2011 15:13, Luck, Tony escreveu:
>>>> Start relocating RAS features into a centralized location under
>>>> arch/x86/kernel/cpu/ras/. Readjust Kconfig items and makefiles
>>>> accordingly.
>>>
>>> Not all ras features are "cpu" orientated ... should we really be
>>> moving to "arch/x86/kernel/ras"?
>>
>> I think that it makes sense to move MCA bits into arch/x86, but I agree
>> with Tony: generally speaking, RAS is not even x86 specific.
> 
> But we are :-)
> 
>> It seems to make more sense to rename drivers/edac to drivers/ras and put
>> the RAS menu there, even if the actual support for the AMD and Intel MCA
>> RAS stuff is kept inside arch/x86/...
> 
> drivers/edac/ contains other architectures too, patches for which we
> cannot (and probably don't want to) test so the whole deal has to be
> x86-centric.

Most drivers there are for memory controller chipsets, so, even the x86 specific 
drivers there won't fit well inside arch/. It might even be possible to have a
MC driver used on more than one architecture (it just doesn't occur, in practice,
because the MC is generally inside a north bridge chip that is sold to match some
features found on some CPU family).

> I don't consider MCE decoding and injection drivers but rather MCA
> functionality extensions or something, so those should go to arch/x86/
> IMHO.

Agreed. MCE decoders and MCE error injection fit better together with
MCA bits. I think they could just be moved to be into the same directory where 
the MCE driver is located.

> And the DRAM error decoding things, aka EDAC, should stay where they
> are, although I cannot call them real drivers, either. We can't move
> them yet anyway because they use the whole EDAC infrastructure.

True.

>From someone that wants to select the RAS features however, it makes sense 
to put everything together at the same menu when selecting the RAS options.

There are some tricks that could be used, like, for example, having something
like:

menuconfig RAS_FEATURES
	bool "Enable RAS features"

if RAS_REATURES

config RAS_MCE
	bool "turn on Memory Channel Architecture Error logic for AMD CPU's"
	depends on X86
	select X86_MCE_AMD

config RAS_MCE
	bool "turn on Memory Channel Architecture Error logic for Intel CPU's"
	depends on X86
	select X86_MCE_INTEL

source "drivers/edac"

endif

at a /drivers/ras Kconfig (or at /ras)

This would allow putting everything together at the same Kconfig menu.

Regards,
Mauro


> 
> Hmm...
> 

