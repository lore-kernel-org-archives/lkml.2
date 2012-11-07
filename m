Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2KGD6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 22:58:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26787 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2KGD6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 22:58:20 -0500
Message-ID: <5099DC30.1060407@oracle.com>
Date: Tue, 06 Nov 2012 22:57:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Bob Liu <lliubbo@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, hughd@google.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm: NULL ptr deref in anon_vma_interval_tree_verify
References: <508086DA.3010600@oracle.com> <5089A05E.7040000@gmail.com> <CA+1xoqf2v_jEapwU68BzXyi4abSRmi_=AiaJVHM3dBbHtsBnqQ@mail.gmail.com> <CAA_GA1d-rw_vkDF98fcf9E0=h86dsp+83-0_RE5b482juxaGVw@mail.gmail.com> <CANN689HXoCMTP4ZRMUNOGAdOBmizKyo6jMqbqAFx8wwPXp+AzQ@mail.gmail.com> <CAA_GA1eYHi4zWZwKp5KGi4gP7V8bfnSF=aLKMiN-Wi5JyLaCdw@mail.gmail.com> <CANN689HfmX8uBa17t38PYv2Ap5d3LPjShq81tbcgET5ZqzjzeQ@mail.gmail.com> <CANN689HM=h2k33sJcoDYys9LHVadv+NaGz00kG7O-OEH=qadvA@mail.gmail.com> <CANN689F6=mkJmgLFbALRPeYKG4RwTef+_r2TsHOLuobAxXbtPg@mail.gmail.com> <CANN689F8ScQdtNFgtREQcQLJEKYDcUGngNFFF6to5eakCz9FnQ@mail.gmail.com>
In-Reply-To: <CANN689F8ScQdtNFgtREQcQLJEKYDcUGngNFFF6to5eakCz9FnQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 10:54 PM, Michel Lespinasse wrote:
> On Tue, Nov 6, 2012 at 12:24 AM, Michel Lespinasse <walken@google.com> wrote:
>> On Mon, Nov 5, 2012 at 5:41 AM, Michel Lespinasse <walken@google.com> wrote:
>>> On Sun, Nov 4, 2012 at 8:44 PM, Michel Lespinasse <walken@google.com> wrote:
>>>> On Sun, Nov 4, 2012 at 8:14 PM, Bob Liu <lliubbo@gmail.com> wrote:
>>>>> Hmm, I attached a simple fix patch.
>>>>
>>>> Reviewed-by: Michel Lespinasse <walken@google.com>
>>>> (also ran some tests with it, but I could never reproduce the original
>>>> issue anyway).
>>>
>>> Wait a minute, this is actually wrong. You need to call
>>> vma_lock_anon_vma() / vma_unlock_anon_vma() to avoid the issue with
>>> vma->anon_vma == NULL.
>>>
>>> I'll fix it and integrate it into my next patch series, which I intend
>>> to send later today. (I am adding new code into validate_mm(), so that
>>> it's easier to have it in the same patch series to avoid merge
>>> conflicts)
>>
>> Hmmm, now I'm getting confused about anon_vma locking again :/
>>
>> As Hugh privately remarked to me, the same_vma linked list is supposed
>> to be protected by exclusive mmap_sem ownership, not by anon_vma lock.
>> So now looking at it a bit more, I'm not sure what race we're
>> preventing by taking the anon_vma lock in validate_mm() ???
> 
> Looking at it a bit more:
> 
> the same_vma linked list is *generally* protected by *exclusive*
> mmap_sem ownership. However, in expand_stack() we only have *shared*
> mmap_sem ownership, so that two concurrent expand_stack() calls
> (possibly on different vmas that have a different anon_vma lock) could
> race with each other. For this reason we do need the validate_mm()
> taking each vma's anon_vma lock (if any) before calling
> anon_vma_interval_tree_verify().
> 
> While this justifies Bob's patch, this does not explain Sasha's
> reports - in both of them the backtrace did not involve
> expand_stack(), and there should be exclusive mmap_sem ownership, so
> I'm still unclear as to what could be causing Sasha's issue.
> 
> Sasha, how reproduceable is this ?

This is pretty hard to reproduce, I've seen this only twice so far.

> 
> Also, would the following change print something when the issue triggers ?

I'll run it with your patch, but as I've mentioned above - it's a PITA
to reproduce.


Thanks,
Sasha
