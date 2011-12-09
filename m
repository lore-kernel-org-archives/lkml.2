Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1LIXRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:17:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47449 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1LIXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:17:44 -0500
Message-ID: <4EE296F0.3020100@zytor.com>
Date: Fri, 09 Dec 2011 15:17:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Brian Gerst <brgerst@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Blechmann <tim@klingt.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [20/80] ALSA: lx6464es - fix device communication via command
 bus
References: <20111207161256.GA7736@kroah.com> <20111207160824.268488820@clark.kroah.org> <CA+55aFwzdXwLJjUL_i247exawkzqdoCULXg81qzG4Ewn7ysn3A@mail.gmail.com> <4EDFA9D6.5050907@zytor.com> <CA+55aFxykes2Vk2YqGN=o=MkJukMBRcpQTN+tjmuTX_3xTstZA@mail.gmail.com>
In-Reply-To: <CA+55aFxykes2Vk2YqGN=o=MkJukMBRcpQTN+tjmuTX_3xTstZA@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply.  With baby prep and everything going on I'm a
bit ADD.

On 12/07/2011 10:09 AM, Linus Torvalds wrote:
> On Wed, Dec 7, 2011 at 10:00 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I agree in principle, although I am really not happy about the idea of
>> disallowing 64-bit writes from device drivers that haven't explicitly
>> indicated they won't support it.
> 
> I'd really prefer going in the other direction. Especially since
> 64-bit writes would be optional *anyway* (ie impossible on 32-bit
> hosts). So a driver should explicitly say "I can do 64-bit stuff"
> rather than having to say "I cannot do it".
> 
> And if a driver *has* to have 64-bit accesses, it had better do them
> all by hand, using "writeq()" and being dependent on the architecture
> actually having that support. No "memcpy_toio" and friends at all.
> 
> So adding a "memcpy_toio64()" that defaults to the normal 32-bit max
> but *might* do 64-bit copies sounds fine to me. But we really should
> default to something that is consistent across architectures, and that
> is not 64-bit accesses.

I feel a bit funny about memcpy_toio64() being able to *not* to 64-bit
copies... it feels like it really violates the assumptions.

What I would suggest, technically is:

- memcpy_toio() becomes a legacy alias for memcpy_toio32().
- memcpy_toio32() and memcpy_toio64() are defined to do exactly
  those reference sizes.  If the platform can't do 64-bit I/O
  then memcpy_toio64 is undefined (like readq/writeq).
- we introduce memcpy_toio_fast() which is explicitly allowed to do any
  kind of references, including larger than 64 bits if supported in
  future CPUs.

However, I *also* found that we have a metric boatload of partially
overlapping redundant aliases:

iowrite{8,16,32}_rep()
	[but iowrite64_rep() is missing]

__iowrite{32,64}_copy()

memcpy_toio()

What I have proposed to memcpy_toio{32,64}() pretty much matches
__iowrite_{32,64}_copy() and those functions should probably be
renamed... not sure what the sane thing to do with the iowrite functions
is here.

	-hpa
