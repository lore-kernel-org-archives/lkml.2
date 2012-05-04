Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab2EDMWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:22:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56596 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755909Ab2EDMWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:22:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDi1cJ=HmjoLdMG1hMU5GZNDV5ysXqvCT9PP09rEi342w@mail.gmail.com>
References: <1336114210-25687-1-git-send-email-alex.shi@intel.com>
	<1336114210-25687-4-git-send-email-alex.shi@intel.com>
	<CAJd=RBDi1cJ=HmjoLdMG1hMU5GZNDV5ysXqvCT9PP09rEi342w@mail.gmail.com>
Date: Fri, 4 May 2012 20:22:37 +0800
Message-ID: <CAJd=RBCowwbYuj3OGmGV4TfTL-q3CNKja7E+D3Xn1X7DoUVmiA@mail.gmail.com>
Subject: Re: [PATH v2 3/5] x86/tlb: fall back to flush all when meet a THP
 large page
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q44CMjI0002523

On Fri, May 4, 2012 at 8:11 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Hi Alex,
>
> On Fri, May 4, 2012 at 2:50 PM, Alex Shi <alex.shi@intel.com> wrote:
>> We don't need to flush large pages by PAGE_SIZE step, that just waste
>> time. and actually, large page don't need 'invlpg' optimizing according
>> to our macro benchmark. So, just flush whole TLB is enough for them.
>>
>> The following result is tested on a 2CPU * 4cores * 2HT NHM EP machine,
>> with THP 'always' setting.
>>
>> Multi-thread testing, '-t' paramter is thread number:
>>                       without this patch       with this patch
>> ./mprotect -t 1         14ns                       13ns
>> ./mprotect -t 2         13ns                       13ns
>> ./mprotect -t 4         12ns                       11ns
>> ./mprotect -t 8         14ns                       10ns
>> ./mprotect -t 16        28ns                       28ns
>> ./mprotect -t 32        54ns                       52ns
>> ./mprotect -t 128       200ns                      200ns
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  arch/x86/mm/tlb.c |   27 +++++++++++++++++++++++++++
>>  1 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
>> index c4e694d..4f709e6 100644
>> --- a/arch/x86/mm/tlb.c
>> +++ b/arch/x86/mm/tlb.c
>> @@ -316,12 +316,35 @@ void flush_tlb_mm(struct mm_struct *mm)
>>
>>  #define FLUSHALL_BAR   16
>>
>> +static inline int has_large_page(struct mm_struct *mm,
>> +                                unsigned long start, unsigned long end)
>> +{
>> +       pgd_t *pgd;
>> +       pud_t *pud;
>> +       pmd_t *pmd;
>> +       unsigned long addr;
>> +       for (addr = start; addr <= end; addr += HPAGE_SIZE) {
>> +               pgd = pgd_offset(mm, addr);
>> +               if (likely(!pgd_none(*pgd))) {
>> +                       pud = pud_offset(pgd, addr);
>> +                       if (likely(!pud_none(*pud))) {
>> +                               pmd = pmd_offset(pud, addr);
>> +                               if (likely(!pmd_none(*pmd)))
>> +                                       if (pmd_large(*pmd))
>> +                                               return 1;
>> +                       }
>> +               }
>> +       }
>> +       return 0;
>> +}
>> +
>>  void flush_tlb_range(struct vm_area_struct *vma,
>>                                   unsigned long start, unsigned long end)
>>  {
>>        struct mm_struct *mm;
>>
>>        if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
>> +flush_all:
>>                flush_tlb_mm(vma->vm_mm);
>>                return;
>>        }
>> @@ -344,6 +367,10 @@ void flush_tlb_range(struct vm_area_struct *vma,
>>                        if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
>>                                local_flush_tlb();
>>                        else {
>> +                               if (has_large_page(mm, start, end)) {
>> +                                       preempt_enable();
>> +                                       goto flush_all;
>> +                               }
>>                                for (addr = start; addr <= end;
>>                                                addr += PAGE_SIZE)
>>                                        __flush_tlb_single(addr);
>> --
>>
> Perhaps huge pages could be handled alternatively, tho dunno the
> point to flush tlb manually.
>
> --- a/x86-mm-tlb.c      Fri May  4 19:53:40 2012
> +++ b/x86-mm-tlb.c      Fri May  4 20:01:36 2012
> @@ -2,7 +2,7 @@ void flush_tlb_range(struct vm_area_stru
>  {
>        struct mm_struct *mm;
>
> -       if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB) {
> +       if (!cpu_has_invlpg) {
>                flush_tlb_mm(vma->vm_mm);
>                return;
>        }
> @@ -13,6 +13,7 @@ void flush_tlb_range(struct vm_area_stru
>                if (current->mm) {
>                        unsigned long addr, vmflag = vma->vm_flags;
>                        unsigned act_entries, tlb_entries = 0;
> +                       unsigned long pg_sz;
>
>                        if (vmflag & VM_EXEC)
>                                tlb_entries = tlb_lli_4k[ENTRIES];
> @@ -22,11 +23,15 @@ void flush_tlb_range(struct vm_area_stru
>                        act_entries = tlb_entries > mm->total_vm ?
>                                        mm->total_vm : tlb_entries;
>
> -                       if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
> +                       pg_sz = (transparent_hugepage_enabled(vma) ||
> +                                               is_vm_hugetlb_page(vma)) ?
> +                               HPAGE_SIZE : PAGE_SIZE;
> +
> +                       if ((end - start)/pg_sz > act_entries/FLUSHALL_BAR)
>                                local_flush_tlb();
>                        else {
>                                for (addr = start; addr <= end;
> -                                               addr += PAGE_SIZE)
> +                                               addr += pg_sz)
>                                        __flush_tlb_single(addr);
>
>                                if (cpumask_any_but(mm_cpumask(mm),
> --
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
