Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1LFUn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:43:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43139 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab1LFUn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:43:56 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112061214590.28251@chino.kir.corp.google.com>
References: <CALCETrW1mpVCz2tO5roaz1r6vnno+srHR-dHA6_pkRi2qiCfdw@mail.gmail.com>
 <CAJd=RBDdirdNiPMVcYLNFO5Ho+pRGCfh_RRA7_re+76Ds+H0pw@mail.gmail.com>
 <CALCETrVL3MUMh2kDPaZ6Z9Lz=eWas_dF0jwWMiF3KvNUcJKXJw@mail.gmail.com> <alpine.DEB.2.00.1112061214590.28251@chino.kir.corp.google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Dec 2011 12:43:34 -0800
Message-ID: <CALCETrW77ZE62dbHJxoL3Ef1gAGeMQaSZrOOiM1_ZrY53zbxUQ@mail.gmail.com>
Subject: Re: hugetlb oops on 3.1.0-rc8-devel
To: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 12:16 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 2 Nov 2011, Andy Lutomirski wrote:
>
>> > --- a/mm/hugetlb.c      Sat Aug 13 11:45:14 2011
>> > +++ b/mm/hugetlb.c      Wed Nov  2 20:12:00 2011
>> > @@ -2422,6 +2422,8 @@ retry_avoidcopy:
>> >         * anon_vma prepared.
>> >         */
>> >        if (unlikely(anon_vma_prepare(vma))) {
>> > +               page_cache_release(new_page);
>> > +               page_cache_release(old_page);
>> >                /* Caller expects lock to be held */
>> >                spin_lock(&mm->page_table_lock);
>> >                return VM_FAULT_OOM;
>> >
>>
>> I'll patch it in.  My test case took over a week to hit it once, so I
>> can't guarantee I'll spot it.
>>
>
> This patch was merged and released in 3.2-rc3 as ea4039a34c4c ("hugetlb:
> release pages in the error path of hugetlb_cow()"), Andy is this issue
> fixed for you?

I haven't seen it again with or without the patch.  I suspect that to
trigger it again I'd have to set up an old, buggy version of my
software to hammer on it for awhile, which I won't have a chance to do
any time soon.  Sorry.

If you're interested, the workload that triggered the problem was,
roughly, two programs.  Both were set up to use libhugetlbfs for
everything, and the first program spawned (presumably via fork as
opposed to any clone magic) copies of the second program frequently.
The second program was very memory intensive.  The result was that,
occasionally, fork had issues because it couldn't find free huge pages
in the pool.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
Office: (310) 553-5322
Mobile: (650) 906-0647
