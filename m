Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab0EZXT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:19:26 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:58083 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab0EZXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:19:25 -0400
Message-ID: <4BFDAC75.5070906@cesarb.net>
Date: Wed, 26 May 2010 20:19:17 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Valdis.Kletnieks@vt.edu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
References: <4BF81D87.6010506@cesarb.net>	<20100523140348.GA10843@barrios-desktop>	<4BF974D5.30207@cesarb.net>	<AANLkTil1kwOHAcBpsZ_MdtjLmCAFByvF4xvm8JJ7r7dH@mail.gmail.com>	<4BF9CF00.2030704@cesarb.net>	<AANLkTin_BV6nWlmX6aXTaHvzH-DnsFIVxP5hz4aZYlqH@mail.gmail.com>	<4BFA59F7.2020606@cesarb.net>	<AANLkTikMTwzXt7-vQf9AG2VhwFIGs1jX-1uFoYAKSco7@mail.gmail.com>	<4BFCF645.2050400@cesarb.net>	<20100526153144.GA3650@barrios-desktop>	<22942.1274909335@localhost> <AANLkTikwxCvxHI0-d1hGctEmfGRuDUlZ7wAbEXbrS1WA@mail.gmail.com>
In-Reply-To: <AANLkTikwxCvxHI0-d1hGctEmfGRuDUlZ7wAbEXbrS1WA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-05-2010 19:45, Minchan Kim escreveu:
> On Thu, May 27, 2010 at 6:28 AM,<Valdis.Kletnieks@vt.edu>  wrote:
>> On Thu, 27 May 2010 00:31:44 +0900, Minchan Kim said:
>>> On Wed, May 26, 2010 at 07:21:57AM -0300, Cesar Eduardo Barros wrote:
>>>> far as I can see, does nothing against the disk simply failing to
>>>> write and later returning stale data, since the stale checksum would
>>>> match the stale data.
>>>
>>> Sorry. I can't understand your point.
>>> Who makes stale data? If any layer makes data as stale, integrity is up to
>>> the layer. Maybe I am missing your point.
>>> Could you explain more detail?
>>
>> I'm pretty sure that what Cesar meant was that the following could happen:
>>
>> 1) Write block 11983 on the disk, checksum 34FE9B72.
>> (... time passes.. maybe weeks)
>> 2) Attempt to write block 11983 on disk with checksum AE9F3581. The write fails
>> due to a power failure or something.
>> (... more time passes...)
>> 3) Read block 11983, get back data with checksum 34FE9B72. Checksum matches,
>> and there's no indication that the write in (2) ever failed. The program
>> proceeds thinking it's just read back the most recently written data, when in
>> fact it's just read an older version of that block. Problems can ensue if the
>> data just read is now out of sync with *other* blocks of data - instant data
>> corruption.
>
> Oh, doesn't normal disk support atomicity of sector write?
> I have been thought disk must support atomicity of sector write at least.

It is called a "high fly write" (a write where the disk head was flying 
too high and the data did not get written at all). There are other 
causes than high fly writes for this, of course, but the symptom is the 
same: whatever you were trying to write was not written at all, and the 
old contents are still there.

The write is still atomic: it either did happen completely or did not 
happen at all (in this case, it did not happen at all). You *can* have a 
partial write (with a well-timed power loss, for instance), but the 
disk's own ECC will detect this as a corrupted sector and return an 
error on read.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
