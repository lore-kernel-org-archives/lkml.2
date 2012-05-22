Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2EVK7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978Ab2EVK7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:59:32 -0400
Message-ID: <4FBB7185.6040105@redhat.com>
Date: Tue, 22 May 2012 13:59:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
References: <20120521163727.GA13337@redhat.com> <alpine.LFD.2.02.1205211940030.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205211940030.3231@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 12:04 AM, Thomas Gleixner wrote:
> >  
> > +static u8 count_vectors(void *bitmap)
> > +{
> > +	u32 *word = bitmap;
> > +	int word_offset;
> > +	u8 count = 0;
> > +	for (word_offset = 0; word_offset < MAX_APIC_VECTOR >> 5; ++word_offset)
> > +		count += hweight32(word[word_offset << 2]);
> > +	return count;
> > +}
>
> Why do you need to reimplement bitmap_weight()?
>
> Because your bitmap is not a bitmap, but a set of 32bit registers
> which have an offset of 4 words each. I really had to twist my brain
> around this function and the test_and_clr/set ones above just because
> the name bitmap is so horribly misleading. Add an extra bonus for
> using void pointers.
>
> Yes, I know, the existing code is full of this, but that's not an
> excuse to add more of it.
>
> This emulation is just silly. Nothing in an emulation where the access
> to the emulated hardware is implemented with vmexits is requiring a
> 1:1 memory layout. It's completely irrelevant whether the hardware has
> an ISR regs offset of 0x10 or not. Nothing prevents the emulation to
> use a consecutive bitmap for the vector bits instead of reimplementing
> a boatload of bitmap operations.
>
> The only justification for having the same layout as the actual
> hardware is when you are going to map the memory into the guest space,
> which is not the case here.
>
>

The APIC page is in fact mapped  to the hardware (not the guest, but vmx
microcode does access it).  Only one register, the TPR, is ever used. 
It's possible to re-layout the data structure so that the TPR stays in
the same place while everything else becomes contiguous, but we'll have
to do it again if the hardware starts mapping more registers.

-- 
error compiling committee.c: too many arguments to function

