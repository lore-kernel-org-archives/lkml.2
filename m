Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1I0CgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:36:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45722 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1I0CgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:36:23 -0400
Message-ID: <4E813639.10907@oracle.com>
Date: Mon, 26 Sep 2011 19:34:33 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
References: <s5hmxdzyyzx.wl%tiwai@suse.de> <201109212048.23074.rjw@sisk.pl> <CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com> <201109270024.55418.rjw@sisk.pl>
In-Reply-To: <201109270024.55418.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090201.4E81364B.003D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 03:24 PM, Rafael J. Wysocki wrote:

> On Thursday, September 22, 2011, Yinghai Lu wrote:
>> On Wed, Sep 21, 2011 at 11:48 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> It looks like init_memory_mapping() is sometimes called with "end"
>>> beyond the last mapped PFN and it explodes when we try to write stuff to
>>> that address during image restoration.
>>>
>>> IOW, the Yinghai's assumption that init_memory_mapping() would always be
>>> called with a "good end" on x86_64 was overomptimistic.
>>
>> for 64bit x86, kernel_physical_mapping_init() will use
>> map_low_page()/call early_memmap() to access ram for page_table that is above
>> rather last mapped PFN.
>>
>> the point is:
>> on system with 64g, usable ram will be [0,2048m), [4g, 64g)
>> init_memory_mapping will be called two times for them.
>> before putting page_table high,
>> page table will be two parts: one is just below 512M, and one below 2048m.
>> after putting page_table high,
>> page table will be two parts: one is just below 2048M, and one below 64G.
>>
>> one of the purposes is finding biggest continuous big range under
>> 1024m for kdump.
> 
> This is all fine so long as we can ensure that the "end" value we're
> passing to init_memory_mapping() will always be a valid address, which
> evidently is not the case sometimes.


I don't understand why end is not valid could happen.

end should be always valid address. one is max_low_pfn under 4g, and another one is max_pfn...


> 
> So, in my opinion we should simply apply the Takashi's patch at this
> point and revisit the kdump issue later, when we actually know how to do
> the right thing.


Takashi said: 2.6.37 with that commit is ok, only 2.6.39 somehow has the 1/20 chance has the reset problem.

so that commit should not the cause. could be some hidden assumption from restore code ? 

Yinghai
