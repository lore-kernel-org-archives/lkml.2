Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1I0Cua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:50:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:64333 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1I0Cu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:50:27 -0400
Message-ID: <4E813986.9040400@oracle.com>
Date: Mon, 26 Sep 2011 19:48:38 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        oneukum@suse.de, x86@kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: S4 resume broken since 2.6.39 (3.1, too)
References: <s5hmxdzyyzx.wl%tiwai@suse.de> <201109212048.23074.rjw@sisk.pl> <CAE9FiQVy4D0NhaN=PvPK_+L4Jv=+7huLy9U--LYW49GFZ9TyaQ@mail.gmail.com> <201109270024.55418.rjw@sisk.pl> <CA+55aFyyeRyvooTY_Gb9xnOHt6AyCoQEtNFW2NPyb=M4gvVshQ@mail.gmail.com>
In-Reply-To: <CA+55aFyyeRyvooTY_Gb9xnOHt6AyCoQEtNFW2NPyb=M4gvVshQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E813999.0055:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 03:47 PM, Linus Torvalds wrote:

> On Mon, Sep 26, 2011 at 3:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> So, in my opinion we should simply apply the Takashi's patch at this
>> point and revisit the kdump issue later, when we actually know how to do
>> the right thing.
> 
> Applying that trivial patch certainly looks fine, especially since it
> also avoids some arbitrary differences between x86-64 and x86-32.
> 
> That said, the whole code looks *very* confusing, and I have to say
> that the commit logs there are also totally unreadable and not very
> explanatory at all.


sorry for that.

> 
> It does seem like the code is simply buggy: it "allocates" the page
> tables from the end of memory, but it seems to want to do that before
> they have been mapped. Which makes perfect sense, since the whole
> point of allocating them is to be *able* to map all the memory.

> 

> So using that
> 
>     good_end = max_pfn_mapped << PAGE_SHIFT;
> 
> would seem to be a good idea regardless. I'm not sure how the old code
> is even supposed to work. That said - why is this a problem only for
> S4 resume?


and for S4 resume, according to Takashi, that commit is ok with 2.6.37. but start to have some problem (1/20 chance) from 2.6.39...

will check if any other early page-table related commit could cause the problem.

the main point for that commit: it will "allocate" range for page-table purpose and will use early_memremap before really accessing them.
so could have the end above already mapped max address.

so We can avoid to put page_table in the middle of low ram ( just below 512m ), and could have bigger continuous range for kdump kernel.

Thanks

Yinghai

