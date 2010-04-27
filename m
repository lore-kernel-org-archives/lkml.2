Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0D0MFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:05:44 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39773 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0D0MFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <j2t1ba2fa241004270418hd37b1fdk83f31d4f608584f9@mail.gmail.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com> 
	<20100419145934.GA10893@kroah.com> <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com> 
	<20100425163711.GA20196@kroah.com> <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com> 
	<20100425193658.GA24039@kroah.com> <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com> 
	<o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com> 
	<1272295140.2434.8.camel@yio.site> <j2t1ba2fa241004270418hd37b1fdk83f31d4f608584f9@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 27 Apr 2010 14:05:25 +0200
Message-ID: <s2yac3eb2511004270505g4ded10f5k5322850e8b58790f@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
To: Tomas Winkler <tomasw@gmail.com>
Cc: Greg KH <greg@kroah.com>, Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 13:18, Tomas Winkler <tomasw@gmail.com> wrote:

> The difference between vfree and vunmap is that vfree request for
> deallocating the pages while vunmap leaves the  pages allocated.

No, that's not the problem, as described in the earlier mail. Only if
the are vmalloc'd they will ever get free'd. The kernel will not take
over custom pages you just mapped. They will never get touched by
vfree. The page count in the vm area will always be zero.

> I
> don't think you can replace vfree with vunmap the way you did.
> The transition from vmalloc to alloc_pages were done by the patch
> bellow.

Sure, if you do vmap, you need to do vunmap, not vfree. But the pages
you need to take care of yourself, like you have allocated them. vfree
in that context makes only sense if you use vmalloc.

The patch I posted makes the issue go away. It's still not the right
fix, because the pages are only get freed when the device id cleaned
up, not on calling release_firmware. But it should illustrate the
underlying issue, and that there is no leaked memory anymore.

>  I think this needs some more review.

If David does not fix it, it probably just needs to be reverted. And
instead of implementing our own "memory management", we should rather
add a vrealloc(), and the firmware loader should use that.

Thanks,
Kay
