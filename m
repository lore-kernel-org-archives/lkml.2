Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0L3PwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 10:52:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:54812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab0L3PwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 10:52:14 -0500
Message-ID: <4D1CAAA1.8030106@suse.com>
Date: Thu, 30 Dec 2010 10:52:01 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, Dan Carpenter <error27@gmail.com>,
        balbir@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
References: <4D1BCE58.4000902@suse.com>	<20101229161418.d34bf0d4.akpm@linux-foundation.org>	<4D1C180A.20000@suse.com> <20101229213243.891b0db5.akpm@linux-foundation.org>
In-Reply-To: <20101229213243.891b0db5.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/30/2010 12:32 AM, Andrew Morton wrote:
> On Thu, 30 Dec 2010 00:26:34 -0500 Jeff Mahoney <jeffm@suse.com> wrote:
> 
>> On 12/29/2010 07:14 PM, Andrew Morton wrote:
>>> On Wed, 29 Dec 2010 19:12:08 -0500 Jeff Mahoney <jeffm@suse.com> wrote:
>>>
>>>>  Commit 4be2c95d added a null field to align the taskstats structure but
>>>>  the discussion centered around ia64. The issue exists on other platforms
>>>>  with inefficient unaligned access and adding them piecemeal would be
>>>>  an unmaintainable mess.
>>>>
>>>>  This patch uses Dave Miller's suggestion of using a combination of
>>>>  CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to determine
>>>>  whether alignment is needed.
>>>>
>>>>  Note that this will cause breakage on those platforms with applications
>>>>  like iotop which had hard-coded offsets into the packet to access the
>>>>  taskstats structure.
>>>
>>> That seems a very good reason to not apply the patch.
>>>
>>> Tell us more, please...
>>
>> I don't want to rehash the same discussion
> 
> Please do so.  That discussion went on for a long time over many emails
> and multiple iterations of the patch.  I personally have forgotten the
> reasoning and if I could remember it, I wouldn't remember which version
> of the patch it applied to.
> 
> Applying a patch which is *known* to break *known* userspace
> applications is a quite extraordinary thing to do.  We owe it to people
> to fully explain the reasoning.

Ok, so the gist is that iotop makes what I'd call unreasonable
assumptions about the contents of a netlink genetlink packet containing
generic attributes. They're typed and have headers that specify value
lengths, so the client can (should) identify and skip the ones the
client doesn't understand.

The kernel, as of version 2.6.36, presented a packet like so:
+--------------------------------+
| genlmsghdr - 4 bytes           |
+--------------------------------+
| NLA header - 4 bytes           | /* Aggregate header */
+-+------------------------------+
| | NLA header - 4 bytes         | /* PID header */
| +------------------------------+
| | pid/tgid   - 4 bytes         |
| +------------------------------+
| | NLA header - 4 bytes         | /* stats header */
| + -----------------------------+ <- oops. aligned on 4 byte boundary
| | struct taskstats - 328 bytes |
+-+------------------------------+

The iotop code expects that the kernel will behave as it did then,
assuming that the packet format is set in stone. The format is set in
stone, but the packet offsets are not. There's nothing in the packet
format that guarantees that the packet will be sent in exactly the same
way. The attribute contents are set (or versioned) and the aggregate
contents are set but they can be anywhere in the packet.

The issue here isn't that an unaligned structure gets passed to
userspace, it's that the NLA infrastructure has something of a weakness:
The 4 byte attribute header may force the payload to be unaligned. The
taskstats structure is created at an unaligned location and then 64-bit
values are operated on inside the kernel, so the unaligned access
warnings gets spewed everywhere.

It's possible to use the unaligned access API to operate on the
structure in the kernel but it seems like a wasted effort to work around
userspace code that isn't following the packet format. Any new additions
would also need the be worked around. It's a maintenance nightmare.

The conclusion of the earlier discussion seemed to be "ok fine, if we
have to break it, don't break it on arches that don't have the problem."
Dave pointed out that the unaligned access problem doesn't only exist on
ia64, but also on other 64-bit arches that don't have efficient
unaligned access and it should be fixed there as well. The committed
version of the patch and this addition keep with the conclusion of that
discussion not to break it unnecessarily, which the pid padding and the
packet padding fixes did do. x86_64 and powerpc don't suffer this
problem so they shouldn't suffer the solution. Other 64-bit
architectures do and will, though.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0cqqEACgkQLPWxlyuTD7KOtQCggszltwXS5RZwaJ9GYFI6XKj6
nyUAn30jbAJfICD0NtKLgTswee48V1jI
=WnDa
-----END PGP SIGNATURE-----
