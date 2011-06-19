Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1FSUDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 16:03:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51637 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab1FSUDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 16:03:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Sun, 19 Jun 2011 22:02:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Nicolas Pitre <nico@fluxnic.net>,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>
References: <Pine.LNX.4.44L0.1106191453200.14586-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106191453200.14586-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192202.23989.arnd@arndb.de>
X-Provags-ID: V02:K0:P1tA0h0Jm1ZJTDHu2ZTihh9p7BNc7GhvDXecPCyWJDv
 sn5cf6eCvr4b18q/Ea90aoL+vafZm2SoXQ0XAz0G3Bva/BxNvd
 u6StOxtzWYmdKH7vVSIyb4AasIOg0/rZYDwqco9oEq9fOS55nT
 EtHCFNhk9pdUzBLG5yq6f45VijRMpi7FRjL2EKslO/LW6YufDT
 czhs7WHwwfLHi5T8+LAaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 21:00:01 Alan Stern wrote:
> On Sun, 19 Jun 2011, Nicolas Pitre wrote:
> > On Thu, 16 Jun 2011, Arnd Bergmann wrote:
> > > On Thursday 16 June 2011 22:10:53 Alexander Holler wrote:
> > > At least I would be happier without the patch. I'm trying to convince
> > > people to not use these attributes unless required because too much
> > > harm is done when they are used without understanding the full
> > > consequences. I also recommend using __packed as localized as possible,
> > > i.e. set it for the members that need it, not the entire struct.
> > > 
> > > I agree that your patch is harmless, it's just the opposite of
> > > a cleanup in my opinion.
> > 
> > The question is: does the structure really has to be packed?
> 
> What do you mean?  The structure really does need to be allocated
> without padding between the fields; is that the same thing?  So do a
> bunch of other structures that currently have no annotations at all.

I guess the issue is that some ABIs actually require a minimum alignment,
like the old ARM ABI that you can still use to build the kernel.

If a structure is not a multiple of four bytes in size, that ABI
will add padding at the end, e.g. in

struct s {
	char c[2];
};

struct t {
	struct s t1;
	unsigned short t2[3];
};

On most architectures, struct s will be two bytes in size and one byte
aligned, while struct t is eight bytes and two byte aligned.

On ARM oABI, struct s ends up with four byte size and alignment while
struct t is twelve bytes long. All this is ok for regular structures,
but not when they are used to describe memory layout of hardware
registers on on-wire packets.

> > If it does, then the follow-up question is: is a packing on word 
> > boundaries sufficient?
> 
> > If the answer is yes in both cases, then having packed,aligned(4) is not 
> > a frivolity but rather a correctness issue.
> 
> Why so?  Current systems work just fine without it.

I think Nicolas got it backwards here, adding both packed and
aligned(4) would make a structure like the one above consistently
incorrect when used to describe a tightly packed hardware structure.

In this case, we would have to do

struct s {
	char c[2];
} __packed;

struct t {
	struct s t1;
	unsigned short t2[3] __aligned(2);
} __packed;

To tell the compiler that t2 is indeed aligned, while struct t
is packed to include no padding around t.
 
I actually recently stumbled over code that gets this wrong,
see

http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=commit;h=284cef173aafd531a708f48e71a9cc7249fc8a98

> >  We can of course provide a 
> > define in include/linux/compiler-gcc.hto hide the ugliness of it 
> > somewhat:
> > 
> > #define __packed_32  __attribute__((packed,aligned(4)))
> > 
> > I suspect that the vast majority of the __packed uses in the kernel 
> > would be better with this __packed_32 instead, the actual need and 
> > intent would be more clearly expressed, and the generated code in the 
> > presence of those GCC changes would then be way more efficient and still 
> > correct.
> 
> What if the intent is that the structure should be 4-byte aligned on 
> 32-bit systems and 8-byte aligned on 64-bit systems?  The compiler 
> already does this sort of thing automatically, why mess with it?

Different issue.

	Arnd
