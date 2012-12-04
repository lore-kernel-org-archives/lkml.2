Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2LDXuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 18:50:24 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:38481 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2LDXuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 18:50:22 -0500
Message-ID: <50BE8C38.80002@converseincode.com>
Date: Wed, 05 Dec 2012 00:50:16 +0100
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Felipe Balbi <balbi@ti.com>, davem@davemloft.net,
        linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Compiling the Linux Kernel with Clang/LLVM 
	<llvmlinux@lists.linuxfoundation.org>
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com> <1351631937-21455-3-git-send-email-behanw@converseincode.com> <20121031132838.GQ10998@arwen.pp.htv.fi> <509144C0.8000601@converseincode.com> <20121101072116.GA32013@arwen.pp.htv.fi> <20121203115706.GA4760@breakpoint.cc> <50BCF61D.5000707@converseincode.com> <20121204222438.GA7624@breakpoint.cc>
In-Reply-To: <20121204222438.GA7624@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-04 11:24 PM, Sebastian Andrzej Siewior wrote:
> On Mon, Dec 03, 2012 at 07:57:33PM +0100, Behan Webster wrote:
>> However, in order to approximate what gcc is doing in code, obviously
>> some math is required. The thought was that macros would hide the
>> worst of it, trying not to obfuscate what was actually being done.
> Why hide? The thing that is done here is setting up pointers and keep this
> struct as a container. It is never used again, just freed. Therefore I would
> suggest to remove and do something different.
Fair enough. That works too.

>> I've been profiling some sample code around this implementation
>> comparing it between compilers, and it approximates the code size and
>> speed of using VLAIS in gcc (especially with -O2). It actually
>> performs better than the previously proposed macros.
> I'm not concerned about speed here. This is an one time setup.
Which is all good in the case of the gadget code.

However VLAIS is used in other places too where code size and speed are 
very important. The proposal was for something which might be used for 
more than just the gadget code. VLAIS is used in only a handful of 
places in the kernel. They just happen to be in important parts of the 
kernel which was why the approach was to change as little as necessary.

>> But certainly if anyone has a solution which works for everyone, then
>> I'm more than happy to adopt it. The LLVM community has made quite a
>> few changes in order to help get Linux working with clang. However,
> That is nice to hear. Besides gcc there is the icc.
Lots of people have brought up icc. Although in the same breath most 
also say nobody is using it anymore. However, I have no idea whether 
that is true. The difference is that clang is widely available in most 
distros; icc is not.

>> VLAIS is not something they are willing to accept (for various
>> reasons). There are other patches to LLVM that are still working
> Is this not described in C99 6.7.2.1p16?
You're thinking of "Flexible Array Members". Essentially the last 
element in a structure can be the equivalent of a zero length array; 
something which both gcc and clang support today.

 From C99 6.7.2.1p16:
> 16 As a special case, the last element of a structure with more than 
> one named member may
> have an incomplete array type; this is called a ﬂexible array member. 
> In most situations,
> the ﬂexible array member is ignored. In particular, the size of the 
> structure is as if the
> ﬂexible array member were omitted except that it may have more 
> trailing padding than
> the omission would imply. Howev er, when a . (or ->) operator has a 
> left operand that is
> (a pointer to) a structure with a ﬂexible array member and the right 
> operand names that
> member, it behaves as if that member were replaced with the longest 
> array (with the same
> element type) that would not make the structure larger than the object 
> being accessed; the
> offset of the array shall remain that of the ﬂexible array member, 
> even if this would differ
> from that of the replacement array. If this array would have no 
> elements, it behaves as if
> it had one element but the behavior is undeﬁned if any attempt is made 
> to access that
> element or to generate a pointer one past it.

However if we're considering the C99 standard, it also explicitly 
disallows the use of VLAs in structs (VLAIS).

 From C99 6.7.2.1 p2:
> 2 A structure or union shall not contain a member with incomplete or 
> function type (hence,
> a structure shall not contain an instance of itself, but may contain a 
> pointer to an instance
> of itself), except that the last member of a structure with more than 
> one named member
> may have incomplete array type; such a structure (and any union 
> containing, possibly
> recursively, a member that is such a structure) shall not be a member 
> of a structure or an
> element of an array.
 From C99 6.7.5.2 p4:
> 4 If the size is not present, the array type is an incomplete type. <snip>
Essentially all arrays in a structure must not be variable length except 
the last member of the array which can be a zero length array (which can 
be used to approximate a VLA at the end). It also says that a struct 
which uses a flexible array member can't be used inside another struct.

>> their way upstream that are required to be able to compile Linux as
>> well.
> I hope the other are "simple" to get in :)
I hope so too. But like the Linux kernel community, the LLVM community 
have standards and procedures for getting code accepted which take time.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

