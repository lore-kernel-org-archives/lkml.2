Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0FVS2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:28:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44203 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0FVS2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=A1c5gFnGusraF+YLDR3IHKTb8hysBwZGywJRPk73yG0oZJKqwr0qg9S8DpgPe4T5za
         UZzIXWIsy7nlmOLAsZ1g8LYT9lQtBFacNf+sc8OyWBMZWDV9U+Cy9cHgXffRw9xN9YCo
         zyebLGnt8lYyBys9VKBa76H9f/XcyB4mPCwGI=
MIME-Version: 1.0
In-Reply-To: <20100622175058.GA23499@srcf.ucam.org>
References: <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> 
	<1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> 
	<AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> 
	<20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com> 
	<20100622165213.GA21842@srcf.ucam.org> <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com> 
	<20100622172545.GA22680@srcf.ucam.org> <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com> 
	<20100622175058.GA23499@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Jun 2010 11:28:20 -0700
Message-ID: <AANLkTinE0BiOa5cpcIerbias7K-aDzj3x4qaeDpzy2CQ@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>,
       Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:50 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 22, 2010 at 10:40:15AM -0700, Luis R. Rodriguez wrote:
>> On Tue, Jun 22, 2010 at 10:25 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > Right, which we have to deal with by having drivers disable ASPM on
>> > broken devices.
>>
>> Agreed, but then the assumption would be drivers are ASPM bug free
>> which is expect to be false with Video and 802.11 given that only a
>> handful of vendors do actually get involved with their drivers
>> upstream. Safe thing of course is to just disable it, of course, but
>> if you are going to use pcie_aspm=force good luck!
>
> People who use "force" deserve whatever they get,

Heh, this whole patch and thread was started because Jussi tested
ath5k with  pcie_aspm=force (on a pre PCIE 1.1 device (?)) . I have
been trying to explain all along why this is a terrible idea to the
point we should probably just remove that code from the kernel. Hence
my side rants and explanations to justify my reasonings.

> but "powersave" really ought to work.

Interesting, as per Documentation/kernel-parameters.txt we have:

        pcie_aspm=      [PCIE] Forcibly enable or disable PCIe Active
State Power
                        Management.
                off     Disable ASPM.
                force   Enable ASPM even on devices that claim not to
support it.
                        WARNING: Forcing ASPM on may cause system lockups.

I was unaware of a "powersave" option to the pcie_aspm kernel
parameter. In fact:

static int __init pcie_aspm_disable(char *str)
{
        if (!strcmp(str, "off")) {
                aspm_disabled = 1;
                printk(KERN_INFO "PCIe ASPM is disabled\n");
        } else if (!strcmp(str, "force")) {
                aspm_force = 1;
                printk(KERN_INFO "PCIe ASPM is forcedly enabled\n");
        }
        return 1;
}

__setup("pcie_aspm=", pcie_aspm_disable);

Where is "powersave"?

I do see a "powersave" but its an ASPM policy string and it implies
you want to enable L1 and L0s when the device's LinkCap supports it,
see pcie_config_aspm_link() and its users. So in other words powersave
seems to imply you are using pcie_aspm=force, no?

> Fedora's defaulted to that for a while now - we've hit
> issues with aacraid, but that's pretty much it in terms of cases where
> the heuristics don't work. Maxim's problems wouldn't be triggered
> because CONFIG_PCIE_ASPM disables it on pre-1.1 devices regardless of
> the BIOS setup.

I don't expect all distributions to have CONFIG_PCIE_ASPM enabled, in
fact I was unaware of this sanity check being included as part of
CONFIG_PCIE_ASPM, I recommend we consider just enabling the sanity
check all the time. The fact that CONFIG_PCIE_ASPM is even an option
seems confusing to me given that apart from this sanity check the only
other thing that I see useful in it is the forcing of ASPM settings
and as I noted I think pcie_aspm=force is pretty dangerous.

>> > Having looked into this, Windows will enable ASPM on external
>> > controllers unless there's some reason for it not to - where that may be
>> > either the appropriate bit in the FADT being set, the device not being
>> > PCIe 1.1 or later, there being no _OSC method on the appropriate root
>> > bridge or the _OSC method not giving it full control over PCIe, the
>> > driver disabling ASPM or the device not advertising it in the first
>> > place.
>>
>> I was unaware of all this root complex sanity checks on Windows,
>> thanks for sharing.
>
> With the patch I've just sent, they should also all be used for Linux as
> well.

Oh nice! It'll be part of 2.6.36?

>> I suspect these tweaks will go away as the industry produces cards
>> with both L1 and L0s enabled all the time (devices being produced
>> today), but for devices caught in that middle of time between whether
>> or not L0s would be *required*  (last 2 years) I suspect we'll run
>> into these issues.
>
> If the same problems would appear under Windows then it's not a problem
> that I'm hugely concerned about as yet

Yes, these issues would also be part of Windows. But should also note
this also means for those people working on their own BIOSes it means
you also have to take these things into more serious consideration.

> - we'll wait a bit longer and
> then change the ASPM defaults to be more aggressive under Linux, and if
> it turns out to be a significant problem in the real world we'll have to
> reconsider it.

The problem is the tweaks in question are device specific. I can see
if I can get you concrete examples.

> But I don't think we should be depending on userspace
> bashing hardware registers in order to be able to enable power
> management.

Me neither, ASPM should just work with default settings, which is why
I also do not like that the sanity check on the PCIE 1.1 spec is done
through CONFIG_PCIE_ASPM, it makes no sense given that ASPM *will*
work even if you do not have CONFIG_PCIE_ASPM but the device has
functional ASPM.

I do think we should be depending on userspace to do development
testing and forcing ASPM on, because the only other alternative is
pcie_aspm=force and as noted this is just not a good idea unless you
*seriously* know what you are doing.

  Luis
