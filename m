Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0I0HLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:11:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63136 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0I0HLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EZkzCQku7PKAIlrHD3MJnmUFIdCRkAxAjBoDEdPlIu2HwS88lt5ewafrSOJpGRFObC
         3VI0lfvd4b0baaNmoFk3atNwMjCpFRxPB88yYROiUwy4WTT7M4TDamQcmNt+hxOlDchs
         WLPiUivMStLITcCW60TbUKnulJjrTmhrpjPRE=
MIME-Version: 1.0
In-Reply-To: <m1zkv37kil.fsf@fess.ebiederm.org>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
	<m1iq1t9z3y.fsf@fess.ebiederm.org>
	<AANLkTin4DKGhcZ4=os1-NxrQ65pEDZ+USG1xpW54y4_T@mail.gmail.com>
	<AANLkTinHGKK-14jq=D__+Q20egPw07qFHg6iQo+aFC9R@mail.gmail.com>
	<m1zkv37kil.fsf@fess.ebiederm.org>
Date: Mon, 27 Sep 2010 10:11:20 +0300
X-Google-Sender-Auth: 0PkCrdORUXvvJ6lJZwtuHRHebFc
Message-ID: <AANLkTinrhzKSTwzLCsHmGXr5Q5kfi=j0Zvh0rsmsAJ4m@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: Consolidate vma destruction into remove_vma.
From: Pekka Enberg <penberg@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 9:37 AM, Pekka Enberg <penberg@kernel.org> wrote:
>>> On Sun, Sep 26, 2010 at 2:34 AM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>> Consolidate vma destruction in remove_vma.   This is slightly
>>>> better for code size and for code maintenance.  Avoiding the pain
>>>> of 3 copies of everything needed to tear down a vma.
>>>>
>>>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>>>> ---
>>>>  mm/mmap.c |   21 +++++----------------
>>>>  1 files changed, 5 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>>> index 6128dc8..17dd003 100644
>>>> --- a/mm/mmap.c
>>>> +++ b/mm/mmap.c
>>>> @@ -643,16 +643,10 @@ again:                    remove_next = 1 + (end > next->vm_end);
>>>>                spin_unlock(&mapping->i_mmap_lock);
>>>>
>>>>        if (remove_next) {
>>>> -               if (file) {
>>>> -                       fput(file);
>>>> -                       if (next->vm_flags & VM_EXECUTABLE)
>>>> -                               removed_exe_file_vma(mm);
>>>> -               }
>>>>                if (next->anon_vma)
>>>>                        anon_vma_merge(vma, next);
>>>> +               remove_vma(next);
>>>
>>> remove_vma() does vma->vm_ops->close() but we don't do that here. Are
>>> you sure the conversion is safe?
>
> Definitely.  It actually isn't possible to reach that point with a
> vma that has a close method.
>
> Until I had traced through all of the code paths I suspect calling
> remove_vma there might have been a bug fix.

Can we amend that to the changelog, please? Otherwise

Acked-by: Pekka Enberg <penberg@kernel.org>

                        Pekka
