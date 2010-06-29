Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0F2VnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:43:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33340 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0F2VnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100629110324.2756cc02@debian>
References: <20100628215407.2017bf2f@debian> <20100628220037.5744c207@debian> 
	<AANLkTilN3_ntG7AWKi-8LM9X_dZJPPlWM6xRM_V_00xU@mail.gmail.com> 
	<20100629110324.2756cc02@debian>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 29 Jun 2010 15:42:54 -0600
X-Google-Sender-Auth: 6lfVkjOm2mEjTsn64L5u_2gnXes
Message-ID: <AANLkTinPsrqxj5oQirEDRvVOuOeWgWSdljsMRbw8wn8V@mail.gmail.com>
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building code 
	out into drivers/of
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 9:03 AM, Andres Salomon <dilinger@queued.net> wrote:
> On Tue, 29 Jun 2010 00:50:08 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> On Mon, Jun 28, 2010 at 7:00 PM, Andres Salomon <dilinger@queued.net> wrote:
>> >
>> > Stick code into drivers/of/pdt.c (Prom Device Tree) that other
>> > architectures with OpenFirmware resident in memory can make use of.
>> >
>> > Signed-off-by: Andres Salomon <dilinger@queued.net>
>>
>> Hi Andres,
>>
>> The patch itself looks fine, but there are currently two methods for
>> extracting the device tree from open firmware; one in arch/powerpc
>> using the flattened format, and one in arch/sparc.  I don't want to
>> end up maintaining both methods in drivers/of, and there has also some
>> discussions on moving the powerpc version into common code.  I've been
>> thinking about using the powerpc approach to support ARM platforms
>> using both the flat tree and real OFW.
>>
>> Ben, what say you?  Before I do anything I'd like to have your opinion.
>>
>
> So you're saying that you want ARM (and sparc, and OLPC) to generate a
> flat tree by calling into OFW?

ARM: yes, it will use the same mechanism as powerpc and microblaze.
Direct usage of the flat representation will be more common that
machines with real OFW.  I'm following the powerpc lead here because
the powerpc approach already supports both the flat tree and OFW in
the same kernel.

Sparc: I don't have a strong opinion.  Sparc and PowerPC have a lot of
shared code, but they've diverged quite a bit.  I have no intention to
force a model changes onto sparc.  For a lot of the merge work that
I'm doing I'm leaving the sparc code as-is in the arch/sparc tree with
the assumption that support for new architectures will use the common
code in drivers/of.

There of course is a gap when it comes to talking to OFW in that both
the current powerpc and sparc variants still remain in arch code.

x86:  I've also just received patches that make use of the flattened
representation on x86 for FPGA add in boards.  It is conceivable that
a single kernel will want support for both OFW and FDT.  Since PowerPC
already supports this use case, my preference is for the powerpc
implementation of OFW.

I'm squeamish about having both the powerpc and sparc methods in
common drivers/of code, but I'm not saying no.  I want to hear from
Ben and David who are more familiar with the history before I make a
decision.  I do know that Ben has been talking about generalizing the
powerpc version of the code, and I definitely don't want two methods
for extracting the OFW device tree in drivers/of.

>  Sparc and OLPC have very similar
> mechanisms for getting device tree info from OFW, so it makes sense to
> share code between them.

Other than the flattened tree step; is the powerpc method dissimilar
from the Sparc and OLPC method for talking to OFW?  (This is not a
rhetorical question, I'm want to know if I'm missing some details).
The main difference I know about is that OFW can still kept alive at
runtime for sparc, which powerpc does not do.  However, keeping OFW
callable is a separate issue from how to extract the device tree.

g.
