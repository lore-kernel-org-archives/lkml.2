Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab0I0GpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:45:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34825 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab0I0Go7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:44:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>
References: <m1sk0x9z62.fsf@fess.ebiederm.org>
	<m1iq1t9z3y.fsf@fess.ebiederm.org>
	<AANLkTin4DKGhcZ4=os1-NxrQ65pEDZ+USG1xpW54y4_T@mail.gmail.com>
	<AANLkTinHGKK-14jq=D__+Q20egPw07qFHg6iQo+aFC9R@mail.gmail.com>
Date: Sun, 26 Sep 2010 23:44:50 -0700
In-Reply-To: <AANLkTinHGKK-14jq=D__+Q20egPw07qFHg6iQo+aFC9R@mail.gmail.com>
	(Pekka Enberg's message of "Mon, 27 Sep 2010 09:39:46 +0300")
Message-ID: <m1zkv37kil.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMMoneyMeta_00 Subject Contains Money Spam
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pekka Enberg <penberg@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] mm: Consolidate vma destruction into remove_vma.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@kernel.org> writes:

> (Fixing Hugh's email address.)

Sorry about that somehow a typo crept it.

> On Mon, Sep 27, 2010 at 9:37 AM, Pekka Enberg <penberg@kernel.org> wrote:
>> Hi Eric,
>>
>> On Sun, Sep 26, 2010 at 2:34 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Consolidate vma destruction in remove_vma.   This is slightly
>>> better for code size and for code maintenance.  Avoiding the pain
>>> of 3 copies of everything needed to tear down a vma.
>>>
>>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>>> ---
>>>  mm/mmap.c |   21 +++++----------------
>>>  1 files changed, 5 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>> index 6128dc8..17dd003 100644
>>> --- a/mm/mmap.c
>>> +++ b/mm/mmap.c
>>> @@ -643,16 +643,10 @@ again:                    remove_next = 1 + (end > next->vm_end);
>>>                spin_unlock(&mapping->i_mmap_lock);
>>>
>>>        if (remove_next) {
>>> -               if (file) {
>>> -                       fput(file);
>>> -                       if (next->vm_flags & VM_EXECUTABLE)
>>> -                               removed_exe_file_vma(mm);
>>> -               }
>>>                if (next->anon_vma)
>>>                        anon_vma_merge(vma, next);
>>> +               remove_vma(next);
>>
>> remove_vma() does vma->vm_ops->close() but we don't do that here. Are
>> you sure the conversion is safe?

Definitely.  It actually isn't possible to reach that point with a
vma that has a close method.

Until I had traced through all of the code paths I suspect calling
remove_vma there might have been a bug fix.

Eric
