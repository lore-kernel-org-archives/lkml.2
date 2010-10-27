Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0J0SLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:11:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:54289 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab0J0SLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,247,1286175600"; 
   d="scan'208";a="851601529"
Message-ID: <4CC86B4A.2050408@linux.intel.com>
Date: Wed, 27 Oct 2010 11:11:22 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org> <4CC8649F.5060408@linux.intel.com> <4CC866B0.8000802@goop.org>
In-Reply-To: <4CC866B0.8000802@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 10:51 AM, Jeremy Fitzhardinge wrote:
>>
>> This is what makes me absolutely hate paravirt with a passion...
>> "let's hid things away in<obscure place>  and make it absolutely
>> impossible to either follow the code flow or figure out what the
>> intended semantics are supposed to be."
>
> Its not really an obscure place; it's where x86-32 does the rest of its
> boot-time pagetable adjustments (like cleaning out the low identity
> maps, etc).  Having those clone_pgd_ranges() floating around in
> setup_arch() is out of place.
>

"Cleaning out the low identity maps" is part of what this patchset 
eliminates.  This is exactly a good reason why paravirt_ops damages the 
kernel -- it makes it impossible to make forward process.

>> (Let not even get me started on how ill-defined the semantics of some
>> of the paravirt operations are.)  In this case, at the most you need a
>> single flag of state... or you could even just ignore this low-level
>> data structure that you will never use in the first place.  Ian's
>> message just mentioned "a failure" and never described in any way what
>> kind of "failure" it was.
>
> It would be a pagefault from Xen preventing a direct write to the pgd
> level of an active pagetable.  At the point in setup_arch() where it
> does the first clone_pgd_range() we're already running on swapper_pg_dir
> and the copy from initial_page_table is outright wrong.
>
> As Ian suggests, we could switch Xen to use initial_page_table at boot
> then move to swapper_pg_dir in the same way native does.

Once the failure was explained, it makes more sense.  Either that or 
just skip this setting if we're already running on swapper_pg_dir.

Let me state this clearly: if Xen is going to continue to live as a 
merged platform, it has to have an obligation to follow changes on the 
native platform.  This is not unique to Xen, but rather a universal rule 
for integrated platforms.  Xen is more widely used than a lot of the 
other minority platforms, which means it legitimately gets allowed more 
slack, but that is moderated by its tremendous invasiveness.

Quite frankly, the single biggest thing you could improve is to improve 
documentation about what you expect in terms of semantics of various 
entry points.  There are a number of cleanups which we currently cannot 
do because they are directly mapped to paravirt_ops which unclear or 
nonsensical semantics.  Having a more explicit description of the design 
space would help there.

paravirt_ops is fundamentally misdesigned as a large monolithic 
driverization layer which combines a lot of unrelated things.  In a 
whole lot of cases it directly duplicates driverization layers already 
in the kernel, meaning we take the cost both in cost clarity and 
performance multiple times.  The patching technology is nice, and it 
would be good to have that available to other platform layers as well, 
but paravirt_ops as it currently sits is going to have to go at some point.

	-hpa
