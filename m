Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761899Ab0J2UGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:06:09 -0400
Received: from claw.goop.org ([74.207.240.146]:37746 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761588Ab0J2UGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:06:08 -0400
Message-ID: <4CCB292E.9090602@goop.org>
Date: Fri, 29 Oct 2010 13:06:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Vasiliy G Tolstov <v.tolstov@selfip.ru>
Subject: Re: [GIT PULL] Small Xen bugfixes
References: <4CCB1906.4000608@goop.org> <AANLkTi=g5sdiWSaLUHAATQn-1=jPqtc=RL6SpYSMYn98@mail.gmail.com> <4CCB1E71.3060600@goop.org>
In-Reply-To: <4CCB1E71.3060600@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/29/2010 12:20 PM, Jeremy Fitzhardinge wrote:
>  On 10/29/2010 12:08 PM, Linus Torvalds wrote:
>> On Fri, Oct 29, 2010 at 11:57 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>    * fix dom0 boot on systems whose E820 doesn't completely cover the
>>>      ISA address space.  This fixes a crash on a Dell R310.
>> Hmm. This clashes with my current tree.
> Bugger, so it does.  I just did a test merge with no complaint though;
> what happened?
>
> I'll redo the patch anyway to fix the below.
>
>> And that conflict is trivial to fix up, but the thing is, I think the
>> patch that comes from your tree is worse than what is already there.
>>
>> Why is that simple unconditional
>>
>>     e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
>>            E820_RESERVED);
>>
>> not just always the right thing? Why do you have a separate hack for
>> dom0 in xen_release_chunk() instead? That just looks bogus.
> Yes, we actually had this discussion.  I was for making the
> e820_add_region unconditional, and Ian's counter was that it could be
> done in the common code rather than Xen-specific.
>
>> The normal logic we use on PC's is to just always reserve the low 64kB
>> of memory, and the whole ISA space. Why doesn't Xen just do the same?
> The specific issue is that the Xen domain returns any memory that's not
> covered by an E820 entry back to Xen, mostly to make sure that memory
> isn't wasted by being shadowed by PCI devices.  But it was also doing
> this in the sub-1M region, which on all the machines I've tested on is
> completely covered.  But on a Dell R310 there's a little 2-page gap
> where some ACPI stuff is lurking, that was being released back to Xen so
> it couldn't be accessed from Linux any more.
>
> The fix is to just make sure the whole low region is covered (or at
> least the 640k-1M space).

Hm, I see.  This Dell machine stashes the MPS table in 2 pages just
*below* 640k, so the ISA_START_ADDRESS-ISA_END_ADDRESS reserved range
doesn't cover it.

There's three ways to fix this:

    * not free memory below 1M (Ian's current patch)
    * fill any E820 gaps below 1M
    * reserve all memory below 1M

The 3rd is certainly simplest, at the cost of wasting a trivial amount
of memory.  Unfortunately it crashes early.  Sigh, will try and sort it
out this afternoon.

    J
