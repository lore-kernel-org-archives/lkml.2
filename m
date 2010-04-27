Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0D0Nee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:34:34 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52053 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab0D0Ned convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <1272372187.5484.3981.camel@macbook.infradead.org>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com> 
	<20100425163711.GA20196@kroah.com> <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com> 
	<20100425193658.GA24039@kroah.com> <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com> 
	<o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com> 
	<1272295140.2434.8.camel@yio.site> <j2t1ba2fa241004270418hd37b1fdk83f31d4f608584f9@mail.gmail.com> 
	<s2yac3eb2511004270505g4ded10f5k5322850e8b58790f@mail.gmail.com> 
	<1272372187.5484.3981.camel@macbook.infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 27 Apr 2010 15:34:15 +0200
Message-ID: <r2iac3eb2511004270634q31ad5aa2ne5f6de21355f1a36@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
To: David Woodhouse <dwmw2@infradead.org>
Cc: dhowells@redhat.com, Tomas Winkler <tomasw@gmail.com>,
       Greg KH <greg@kroah.com>, Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 14:43, David Woodhouse <dwmw2@infradead.org> wrote:
> On Tue, 2010-04-27 at 14:05 +0200, Kay Sievers wrote:
>>
>> The patch I posted makes the issue go away. It's still not the right
>> fix, because the pages are only get freed when the device id cleaned
>> up, not on calling release_firmware. But it should illustrate the
>> underlying issue, and that there is no leaked memory anymore.
>>
>> >  I think this needs some more review.
>>
>> If David does not fix it, it probably just needs to be reverted. And
>> instead of implementing our own "memory management", we should rather
>> add a vrealloc(), and the firmware loader should use that.
>
> The whole point was to avoid the vrealloc(). We really don't want to be
> screwing with page tables, globally, for each page written from
> userspace.

Yeah. I guess the problem with the old code before you made if faster
was that it was doing vmalloc()->memcpy()->vfree() in a loop. A
vrealloc(), which we don't have today, could be made reasonable fast,
I guess.

> This untested patch attempts to put the page array into the 'struct
> firmware' so that we can free it from release_firmware().

Looks good. Seems to work without problems and without leaking memory.

Misses only the member in the struct firmware though. :)

> It would actually be nice if we could make that the _primary_ method of
> returning data to drivers, and we could ditch the vmap() requirement
> altogether... drivers which really need it to be virtually contiguous
> can depend on CONFIG_MMU and do the vmap() for themselves.

Yeah, we could just do that in a firmware_get_data() accessor function
and call vmap() there on-demand. That way we would just account and
copy pages in the firmware class until the data is actually accessed.
Existing users would just need to change the direct ->data access to
firmware_get_data().

Thanks,
Kay
