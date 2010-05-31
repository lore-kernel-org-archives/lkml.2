Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0EaTJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:09:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52827 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab0EaTJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:09:52 -0400
Message-ID: <4C040981.8030002@vflare.org>
Date: Tue, 01 Jun 2010 00:39:53 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com, avi@redhat.com,
       pavel@ucw.cz, konrad.wilk@oracle.com
Subject: Re: [PATCH V2 0/4] Frontswap (was Transcendent Memory): overview
References: <20100528174020.GA28150@ca-server1.us.oracle.com 4C02AB5A.5000706@vflare.org> <a38d5a97-1517-46c4-9b2f-27e16aba58f2@default>
In-Reply-To: <a38d5a97-1517-46c4-9b2f-27e16aba58f2@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 05/31/2010 10:44 PM, Dan Magenheimer wrote:
>> On 05/28/2010 11:10 PM, Dan Magenheimer wrote:
>>> [PATCH V2 0/4] Frontswap (was Transcendent Memory): overview
>>>
>>> Changes since V1:
>>> - Rebased to 2.6.34 (no functional changes)
>>> - Convert to sane types (per Al Viro comment in cleancache thread)
>>> - Define some raw constants (Konrad Wilk)
>>> - Performance analysis shows significant advantage for frontswap's
>>>   synchronous page-at-a-time design (vs batched asynchronous
>> speculated
>>>   as an alternative design).  See http://lkml.org/lkml/2010/5/20/314
>>>
>>
>> I think zram (http://lwn.net/Articles/388889/) is a more generic
>> solution
>> and can also achieve swap-to-hypervisor as a special case.
>>
>> zram is a generic in-memory compressed block device. To get frontswap
>> functionality, such a device (/dev/zram0) can be exposed to a VM as
>> a 'raw disk'. Such a disk can be used for _any_ purpose by the guest,
>> including use as a swap disk.
> 

> 
> Though I agree zram is cool inside Linux, I don't see that it can
> be used to get the critical value of frontswap functionality in a
> virtual environment, specifically the 100% dynamic control by the
> hypervisor of every single page attempted to be "put" to frontswap.
> This is the key to the "intelligent overcommit" discussed in the
> previous long thread about frontswap.
>

Yes, zram cannot return write/put failure for arbitrary pages but other
than that what additional benefits does frontswap bring? Even with frontswap,
whatever pages are once given out to hypervisor just stay there till guest
reads them back. Unlike cleancache, you cannot free them at any point. So,
it does not seem anyway more flexible than zram.

One point I can see is additional block layer overhead in case of zram.
For this, I have not yet done detailed measurements.

 
> Further, by doing "guest-side compression" you are eliminating
> possibilities for KSM-style sharing, right?
> 

With zram, whether compression happens within guest or on the host,
depends on how it is used.

When zram device(s) are exported as raw disk(s) to a guest, pages
written to them are sent to host and they are compressed on host an
not within the guest. Also, I'm planning to include de-duplication
support for zram too (which will be separate from KSM).

> So while zram may be a great feature, it is NOT a more generic
> solution than frontswap, just a different solution that has a
> different set of objectives.
> 

frontswap is a particular use case of zram disks. However, we still
need to work on some issues with zram:
 - zram cannot return write/put failures for arbitrary pages. OTOH,
frontswap can consult host before every put and may forward pages to
in-guest swap device when put fails.
 - When a swap slot is freed, the notification from guest does
not reach zram device(s) as exported from host. OTOH, frontswap calls
frontswap_flush() which frees corresponding page from host memory.
 - Being a block device, it is potentially slower than frontswap
approach. But being a generic device, its useful for all kinds
of guest OS (including windows etc).

Thanks,
Nitin
