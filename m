Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062Ab1F3ETW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:19:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:51684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1F3ETS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:19:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,447,1304319600"; 
   d="scan'208";a="24579264"
Message-ID: <4E0BF945.4080102@linux.intel.com>
Date: Wed, 29 Jun 2011 21:19:17 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Shawn Bohrer <sbohrer@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, mingo@elte.hu
Subject: Re: [PATCH v4] futex: Fix regression with read only mappings
References: <4E0A6A0F.9020004@linux.intel.com> <1309360644-24079-1-git-send-email-sbohrer@rgmadvisors.com> <alpine.LFD.2.02.1106300129130.2917@ionos>
In-Reply-To: <alpine.LFD.2.02.1106300129130.2917@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/29/2011 04:38 PM, Thomas Gleixner wrote:
> On Wed, 29 Jun 2011, Shawn Bohrer wrote:
>>
>> While fixing the regression this patch opens up a possible bad
>> scenarios as identified by KOSAKI Motohiro:
>>
>> This patch also allows FUTEX_WAIT on RO private mappings which have
>> the following corner case.
> 
> These two sentences make no sense at all. We really need a very
> accurate description of this change. That code is subtle and we really
> want to have a very clear and understandable changelog.
> 
> Your changelog fails the basic test by mentioning "corner case" simply
> because the whole futex code consists only of corner cases.
> 
> Thanks,
> 
> 	tglx

Yeah, those messages are quotes from Kosaki, but that isn't apparent without
having all the context. They are confusing. The language needs to be cleaned up
a bit as well.

Shawn, I apologize for this as it was my idea to begin with, but after rereading
all of the previous patches from Kosaki, I realized that the rw parameter was
part of the original design (and not newly introduced by your patch) and that
cramming the FLAGS_RO flag into the flags variables muddies the meaning of
flags. flags is meant to modify a particular futex call and ensure that call is
correctly restarted after a signal. The RO/RW bit pertains to the calling
function and does not vary from call to call. We should revert back to the rw
parameter using VERIFY_READ and VERIFY_WRITE.

How about this for a header (I'll leave it to Shawn to
incorporate, adjust, and resend):

commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw parameter
from get_futex_key()) in 2.6.33 introduced a user-mode regression in that it
broke futex operations on read-only memory maps in addition to preventing a loop
when encountering a ZERO_PAGE.  For example, this breaks workloads that have one
or more reader processes doing a FUTEX_WAIT on a futex within a read only shared
file mapping, and a writer processes that has a writable mapping issuing the
FUTEX_WAKE.

This fixes the regression for valid futex operations on RO mappings by trying a
RO get_user_pages_fast() when the RW get_user_pages_fast() fails. This change
makes it necessary to also check for invalid use cases, such as anonymous RO
mappings (which can never change) and the ZERO_PAGE which the commit referenced
above was written to address.

This patch does restore the original behavior with RO private mappings which
suffer from the following corner case.

  Thread-A: call futex(FUTEX_WAIT, memory-region-A).
            get_futex_key() returns an inode based key.
            sleep on the key
  Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
  Thread-B: write memory-region-A.
            This process's memory-region-A gets remapped to a
            COWed PageAnon=1 page.
  Thread-B: call futex(FUETX_WAKE, memory-region-A).
            get_futex_key() returns an mm based key.
            Thread-A is never woken as it is waiting on a different key.

Checking for a private mapping requires walking the vmas and was deemed too
costly to avoid a userspace hang in a nonsensical use case.

This Patch is based on Peter Zijlstra's initial patch with modifications to only
allow RO mappings for futex operations that need VERIFY_READ access.


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
