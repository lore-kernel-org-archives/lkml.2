Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0J0Rv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:51:59 -0400
Received: from claw.goop.org ([74.207.240.146]:45438 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab0J0Rv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:51:57 -0400
Message-ID: <4CC866B0.8000802@goop.org>
Date: Wed, 27 Oct 2010 10:51:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Borislav Petkov <bp@alien8.de>, Ian Campbell <ian.campbell@citrix.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com> <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org> <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org> <4CC8649F.5060408@linux.intel.com>
In-Reply-To: <4CC8649F.5060408@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/27/2010 10:42 AM, H. Peter Anvin wrote:
> On 10/27/2010 10:31 AM, Jeremy Fitzhardinge wrote:
>>   On 10/27/2010 10:18 AM, H. Peter Anvin wrote:
>>> On 10/27/2010 9:50 AM, Jeremy Fitzhardinge wrote:
>>>>
>>>> This never used to be a problem.  Perhaps we can change how
>>>> clone_pgd_range is used at boot time to avoid it in the Xen case
>>>> (since
>>>> we don't care about the secondary pagetable)?
>>>>
>>>
>>> Xen shouldn't have any users of this, since it's used for low-level
>>> operations like SMP bootstrap, suspend to RAM, reboot and low-level
>>> BIOS functionality.
>>>
>>
>> Right, but it is being called smack in the middle of setup_arch().  It
>> looks like they could be hidden away in
>> native_pagetable_setup_start/done though.
>>
>
> This is what makes me absolutely hate paravirt with a passion...
> "let's hid things away in <obscure place> and make it absolutely
> impossible to either follow the code flow or figure out what the
> intended semantics are supposed to be."

Its not really an obscure place; it's where x86-32 does the rest of its
boot-time pagetable adjustments (like cleaning out the low identity
maps, etc).  Having those clone_pgd_ranges() floating around in
setup_arch() is out of place.

> (Let not even get me started on how ill-defined the semantics of some
> of the paravirt operations are.)  In this case, at the most you need a
> single flag of state... or you could even just ignore this low-level
> data structure that you will never use in the first place.  Ian's
> message just mentioned "a failure" and never described in any way what
> kind of "failure" it was.

It would be a pagefault from Xen preventing a direct write to the pgd
level of an active pagetable.  At the point in setup_arch() where it
does the first clone_pgd_range() we're already running on swapper_pg_dir
and the copy from initial_page_table is outright wrong.

As Ian suggests, we could switch Xen to use initial_page_table at boot
then move to swapper_pg_dir in the same way native does.

    J
