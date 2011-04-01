Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab1DATcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:32:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56417 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1DATco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:32:44 -0400
Message-ID: <4D962837.2070300@kernel.org>
Date: Fri, 01 Apr 2011 12:32:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop> <4D95F80D.7070201@kernel.org> <4D95FBDD.9050901@zytor.com> <alpine.DEB.2.00.1104011729000.16492@kaball-desktop> <4D961FBC.2030105@zytor.com>
In-Reply-To: <4D961FBC.2030105@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D962844.0116,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 11:55 AM, H. Peter Anvin wrote:
> On 04/01/2011 11:14 AM, Stefano Stabellini wrote:
>>> Why the heck should we save and restore CR4 only for x86-64?
>>
>> AFAICT it has always been the case since the beginning of time (Initial
>> git repository build).
>
> Doesn't change the fact that at least conceptually it's wrong; consider
> bits like NX.  Rafael, do you have any thoughts on this?
>
more info:

in arch/x86/kernel/setup.c  we have
#if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
unsigned long mmu_cr4_features;
#else
unsigned long mmu_cr4_features = X86_CR4_PAE;
#endif


in arch/x86/kernel/head_32.S

/*
  *      New page tables may be in 4Mbyte page mode and may
  *      be using the global pages.
  *
  *      NOTE! If we are on a 486 we may have no cr4 at all!
  *      So we do not try to touch it unless we really have
  *      some bits in it to set.  This won't work if the BSP
  *      implements cr4 but this AP does not -- very unlikely
  *      but be warned!  The same applies to the pse feature
  *      if not equally supported. --macro
  *
  *      NOTE! We have to correct for the fact that we're
  *      not yet offset PAGE_OFFSET..
  */
#define cr4_bits pa(mmu_cr4_features)
         movl cr4_bits,%edx
         andl %edx,%edx
         jz 6f
         movl %cr4,%eax          # Turn on paging options (PSE,PAE,..)
         orl %edx,%eax
         movl %eax,%cr4
...
6:

So for 32 bit, PAE support is not compiled in for old 486 cpus.
mmu_cr4_feautres will be used to make sure head_32.S will not access cr4.

that could be the reason why 32 bit does not do read back at beginning.

Thanks

Yinghai
