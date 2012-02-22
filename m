Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2BVLVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 06:21:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35804 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab2BVLVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 06:21:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ajeet.yadav.77@gmail.com designates 10.220.157.83 as permitted sender) smtp.mail=ajeet.yadav.77@gmail.com; dkim=pass header.i=ajeet.yadav.77@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAB4K4y7maT1ZQSPKXq6SAng+8fXOFV1kyzVC7AiJGCmgMu5MDg@mail.gmail.com>
References: <1329494160-26942-1-git-send-email-ajeet.yadav.77@gmail.com>
	<20120217171915.GO27825@n2100.arm.linux.org.uk>
	<CAB4K4y7maT1ZQSPKXq6SAng+8fXOFV1kyzVC7AiJGCmgMu5MDg@mail.gmail.com>
Date: Wed, 22 Feb 2012 16:51:04 +0530
Message-ID: <CAB4K4y7FebiFASp2nznpNKfjAXcxdWSE14hCjTuTKPOJfv4Hng@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dma-mapping: fix array out of bound access
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jon Medhurst <tixy@yxit.co.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Naveen Yadav <yad.naveen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 My old replies were from mobile messenger, hence were short, would say sorry
 for the same.
 Please find my response below

 On Fri, Feb 17, 2012 at 10:49 PM, Russell King - ARM Linux
 <linux@arm.linux.org.uk> wrote:
> On Fri, Feb 17, 2012 at 09:26:00PM +0530, Ajeet Yadav wrote:
>> In __dma_alloc_remap(*,size,*,*)/ __dma_free_remap(*,size) functions
>> if virtual address is in the last consistent mapping region
>> i.e idx == ((CONSISTENT_END - base) >> PMD_SHIFT) - 1
>> and off == PTRS_PER_PTE.
>> then we have array out of bound access condition.
>
> How?  Where?
>
> At the first loop, off will _never_ be PTRS_PER_PTE.
>
>                u32 off = CONSISTENT_OFFSET(c->vm_start) &
> (PTRS_PER_PTE-1);
>
> There is _absolutely_ _no_ _way_ that off could ever be PTRS_PER_PTE
> here.

 True, so offset can be off = (PTRS_PER_PTE - 1);
 And say idx = CONSISTENT_PTE_INDEX(c->vm_start); provide us with last vaild
 element in consistent_pte[];
 Also __dma_alloc_remap() request 1 page, i.e size =  PAGE_SIZE.

 Because size, off, idx are vaild values with respect to consistent mapping
 region, and its a do{}while loop, so it will exit loop after first pass. All
 fine

 But their is a catch, we do off++, so
 do{
         do_all_important_stuff
         off++;        >>>>>>>>>>>>>>>>>>>>>>>>>>> now off = PTRS_PER_PTE
           if (off >= PTRS_PER_PTE) {                 >>>>>> condition TRUE
                off = 0;
                pte = consistent_pte[++idx];         >>>>> we did idx++ but
idx was already pointing to last element, so we are trying to access array
 out of bound
          }
 } while (size -= PAGE_SIZE);                      >>>>>>> conditon FALSE,
 but its too late

 The proposed solution, do off++ but move the rest i.e if body from last to
 begining of do{}while.
 In this case we will prevent out of bound acess, without effecting the flow
 on first entry and also exit from do{}while loop.
 Moving the if body to begining of do{}while ensured that on first entry to
 do{}while loop the if condition fails hence not effecting the first entry
 condition.
 on subsequent iternation of do{}while loop the while condition will be
 checked before we execute the if conditon.

 Given functions __dma_alloc_remap()/ __dma_free_remap() already haves
 necessary checks to ensure that size is valid, so again if we analyse from
 given example

 do{
           if (off >= PTRS_PER_PTE) {                 >>>>>> condition FALSE
                off = 0;
                pte = consistent_pte[++idx];           >>>>>> we avoid
 this
          }
         do_all_important_stuff
         off++;        >>>>>>>>>>>>>>>>>>>>>>>>>>> now off = PTRS_PER_PTE
 } while (size -= PAGE_SIZE);                       >>>>>>> condition FAILS,
 we exit the do{}while, effectively prevented the out of bound access of
 consistent_pte[]

  NOTE: size is valid so, in proposed solution while conditon is effectively
 preventing the out of bound array access to occur.
  If we review the code from normal access point of view, we are not changing
 any flow logic, also after the exit from do{}while no access to off, idx is
 performed
 So we do not need to worry about post do{}while statments.

>
> If 'base' is CONSISTENT_END, then we have far bigger problems, because
> it means that we have a zero sized region - it certainly can't be any
> larger than zero size because then we'd be overflowing the DMA region
>> into something else.
>>
>> Plus, we know that 'end of region' allocations work fine, because the
>> code allocates from the top of the region downwards.
>>
>> So, I don't think there's a problem here.
>
>
