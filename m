Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2ARA22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:28:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41942 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2ARA20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:28:26 -0500
MIME-Version: 1.0
In-Reply-To: <1326771731.26116.29.camel@pasglop>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
 <1326313337-24603-14-git-send-email-grant.likely@secretlab.ca>
 <4F0DFC0F.2090005@gmail.com> <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
 <4F0F7B60.5040701@gmail.com> <4F14E05C.30207@codeaurora.org> <1326771731.26116.29.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Jan 2012 17:28:05 -0700
X-Google-Sender-Auth: 3waGDbwfIheLOfO4uusmFzfILmE
Message-ID: <CACxGe6ufk+BUoXZBKm5Q-O1Aj1j=18fJ5KjOC-fKQMbpw4z=mw@mail.gmail.com>
Subject: Re: [RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of the
 ppc one
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Bohan <mbohan@codeaurora.org>, Rob Herring <robherring2@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, Russell King <linux@arm.linux.org.uk>,
        sfr@canb.auug.org.au,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 8:42 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2012-01-16 at 18:43 -0800, Michael Bohan wrote:
>>
>> I was planning on sending these patches out, but it seems like with
>> Grant's patches, they may no longer be up to date. I was curious if any
>> thought was given to supporting configurations like this the one I
>> mentioned with the advent of these patches. I am happy to help test if
>> you can steer me in the right direction.
>
> I haven't had a chance to look in detail at what Grant is doing in his
> latest series, but the ppc domain scheme that he's basing it on has the
> concept of sparse interrupt domains.
>
> For these, we use a radix tree for the reverse map (we do not rely on a
> linear range) and we "allocate" linux IRQ numbers on-demand as we create
> mapping for individual HW interrupts.

My latest patches are primarily a direct port of the ppc code to be
generic for all architectures, and it does pretty much what you want.
As Ben suggests, you should look at the radix revmap code.  Use the
irq_domain_add_tree() function for creating the irq_domain, and there
is no need to even pre-allocate the number of hwirqs that you want to
support.  It uses a radix tree to manage arbitrary mappings from hwirq
number to linux numbers.

The other option is the linear map which maintains a static array with
one entry per hwirq number.  Use irq_domain_add_linear() to create one
and pass in the maximum number of hwirqs supported by the controller.
It will allocate an array of irq_desc* so that irq_descs can be
allocated dynamically.

It is also important to note that for both these revmaps, the actual
virq number is irrelevant.  The irq_domain is entirely responsible for
allocation and management.  There will be no need for a 'chunk of
virqs' assigned to an irq controller.

BTW: Ben, if you can carve out some time, I'd appreciate a look over
my series and make sure you're okay with it.  Once it's had some
testing by arm and ppc folks, I want to get it into linux-next.

g.
