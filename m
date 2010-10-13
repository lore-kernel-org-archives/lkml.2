Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0JMSVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:21:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47512 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0JMSVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:21:07 -0400
Message-ID: <4CB5F86C.9030900@zytor.com>
Date: Wed, 13 Oct 2010 11:20:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org>
In-Reply-To: <4CB5DEE8.2020400@goop.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 09:31 AM, Jeremy Fitzhardinge wrote:
>>
>> use ARCH_FIND_MEMBLOCK_AREA to select from them.
> 
> Thanks, that fixes the problem.  I would ideally like to make the the
> Xen code independent of the page allocation ordering, but it looks like
> it will be very tricky since we effectively make use of the pagetable as
> a way of storing one bit of information about each page before there's a
> struct page in place.
> 
> So this patch looks good to me (but there's no need to make it a
> separate config option).
> 

There isn't per se, but I have repeatedly expressed unhappiness about
x86 having a completely different allocation policy -- worse, bottom-up
is the absolutely worst possible allocation policy since low-address
memory is a precious resource for all kinds of odd requirements
(trampoline pages, ZONE_DMA, ZONE_DMA32 and so on.)

Furthermore, I really, really disapprove of interfaces which carry
hidden semantics, such as allocation order.

I have repeatedly asked that we do *not* do this on x86 if we're going
to go to a memblock-everywhere configuration.

Now, if Xen needs it, there are few options that I can see in the short
term, neither of which makes me happy -- I would appreciate

a) Add an explicit interface to allocate bottoms-up, and have Xen use it
because it needs it.  This is appropriate if (and only if) the
allocations in Xen aren't underneath a bunch of extra layers.

b) Add it as a config option and make Xen select it (or depend on it).
Unfortunately this probably would mean using this option on any
paravirtualized kernel too, which would effectively mean Xen is
"infecting" the entire rest of the x86 architecture with a pessimal
allocation policy, which is extremely unfortunate.

c) Just accept it for now with the intent of getting rid of it as soon
as possible.  I'd be fine pushing this for 2.6.37, but I'd like to get a
reasonably firm commitment try to come up with something better within
the next kernel cycle.

Opinions?

	-hpa
