Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1KQXwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:52:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44843 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1KQXwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:52:31 -0500
Message-ID: <4EC59E3C.5070204@gmail.com>
Date: Thu, 17 Nov 2011 15:52:28 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and HPAGE_SIZE
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com> <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com> <20111117153526.f90ee248.akpm@linux-foundation.org> <alpine.DEB.2.00.1111171538540.13555@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111171538540.13555@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 03:44 PM, David Rientjes wrote:
> On Thu, 17 Nov 2011, Andrew Morton wrote:
>
>>> So, just remove the dummy and dangerous definitions since they are no
>>> longer needed and reveals the correct dependencies.  Tested on
>>> architectures using the definitions with allyesconfig: x86 (even with
>>> thp), hppa, mips, powerpc, s390, sh3, sh4, sparc, and sparc64, and
>>> with defconfig on ia64.
>>
>> How could arch/mips/mm/tlb-r4k.c:local_flush_tlb_range() compile OK
>> with this change?
>>
>
> This was tested on Linus' tree, not on Ralf's linux-next tree.  All uses
> of HPAGE_* are protected by CONFIG_HUGETLB_PAGE as it appropriately should
> be in Linus' tree in that file.
>
>> What that function is doing looks reasonable to me.  Why fill the poor
>> thing with an ifdef mess?
>>
>> otoh, catching mistakes is good too.  Doing it at runtime as David
>> proposes is OK.
>>
>
> Nobody else needs it other than Ralf's pending change, and you're
> suggesting we need them in a generic header file when any sane arch that
> uses hugepages (all of them, in the current tree) declares these
> themselves in arch/*/include/asm/page.h where it's supposed to be done?
>
> Why on earth do we have CONFIG_HUGETLB_PAGE for at all, then?  To catch
> code that's operating on hugepages when our kernel doesn't support it.
> I'd much rather break the build than get a runtime BUG() because we want
> to avoid an #ifdef or actually write well-written code like every other
> arch has!  Panicking the code to find errors like this is just insanity.
>

A counter argument would be:

There are hundreds of places in the kernel where dummy definitions are 
selected by !CONFIG_* so that we can do:

    if (test_something()) {
       do_one_thing();
    } else {
       do_the_other_thing();
    }


Rather than:

#ifdef CONFIG_SOMETHING
    if (test_something()) {
       do_one_thing();
    } else
#else
    {
       do_the_other_thing();
    }



We even do this all over the place with dummy definitions selected by 
CONFIG_HUGETLB_PAGE, What exactly makes HPAGE_MASK special and not the 
hundreds of other similar situations?

David Daney

