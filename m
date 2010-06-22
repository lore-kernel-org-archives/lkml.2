Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0FVRki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:40:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33924 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0FVRkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oyyRetlzrKVnzHzOqzF8HtMNoqHHbiFbRcgtoDi5r5vHfZs3lE8DgHc7lUcyj6SYWL
         ZWQ/ZrJxfcPCmn1k+AXmgpyLg289j3jhDBWiBnLQA8FkisQ7keez2T3Wpv3e3O8Habnh
         OC5aMYS5PFXk7cNsMRD3Gz//LbEg0eDWbwCHY=
MIME-Version: 1.0
In-Reply-To: <20100622172545.GA22680@srcf.ucam.org>
References: <AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> 
	<1277032723.9555.12.camel@maxim-laptop> <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> 
	<1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> 
	<AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> 
	<20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com> 
	<20100622165213.GA21842@srcf.ucam.org> <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com> 
	<20100622172545.GA22680@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Jun 2010 10:40:15 -0700
Message-ID: <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:25 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 22, 2010 at 10:17:11AM -0700, Luis R. Rodriguez wrote:
>> On Tue, Jun 22, 2010 at 9:52 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > Why would you only want to enable ASPM for one device?
>>
>> ASPM doesn't always work for all devices even if they do advertise
>> ASPM capability so turning it on selectively by device is what I
>> recommend since otherwise you may get hangs and you will then have to
>> do the selective enabling.
>
> Right, which we have to deal with by having drivers disable ASPM on
> broken devices.

Agreed, but then the assumption would be drivers are ASPM bug free
which is expect to be false with Video and 802.11 given that only a
handful of vendors do actually get involved with their drivers
upstream. Safe thing of course is to just disable it, of course, but
if you are going to use pcie_aspm=force good luck!

>> Furthermore laptops tend to disable ASPM for cards not built-in to it,
>> an example is Cardbus slots or internal PCI-E slots. This is often
>> done because to enable ASPM for some cards you often need to tune the
>> host controller in addition to enabling ASPM for the endpoint, so this
>> will vary depending on vendor, chipset, and host controller
>> combination. This is documentation that the OEM / ODM typically end up
>> getting, but not end users.
>
> Having looked into this, Windows will enable ASPM on external
> controllers unless there's some reason for it not to - where that may be
> either the appropriate bit in the FADT being set, the device not being
> PCIe 1.1 or later, there being no _OSC method on the appropriate root
> bridge or the _OSC method not giving it full control over PCIe, the
> driver disabling ASPM or the device not advertising it in the first
> place.

I was unaware of all this root complex sanity checks on Windows,
thanks for sharing.

> Are you aware of any other cases where Windows will refuse to
> enable ASPM?

My point was not whether or not ASPM typically got enabled on Windows
Vs Linux, my point was more of the fact that for some endpoint devices
you may have to tweak the root complex to get ASPM properly working
and that these tweaks *are* implemented on the BIOS by the ODM / OEM
for those devices and that the documentation for such tweaks is not
typically public. So, if you are like me and cannot stand the internal
802.11 card on your laptop and want to replace it with something else
you are stuck to hoping such BIOS tweaks are either not required or
figuring out what the tweaks are yourself and doing them through
userspace for the root complex *prior* to enabling ASPM through
userspace as well for the endpoint.

I suspect these tweaks will go away as the industry produces cards
with both L1 and L0s enabled all the time (devices being produced
today), but for devices caught in that middle of time between whether
or not L0s would be *required*  (last 2 years) I suspect we'll run
into these issues.

  Luis
