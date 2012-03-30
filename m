Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094Ab2C3Kqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:46:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2C3Kq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:46:27 -0400
Message-ID: <4F758EF6.3060505@redhat.com>
Date: Fri, 30 Mar 2012 07:46:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Greg K H <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com> <1333040821-6253-2-git-send-email-mchehab@redhat.com> <20120329220300.GA16491@kroah.com> <4F74EDEC.5020804@redhat.com> <20120329234037.GA16094@kroah.com> <4F7516B3.8070505@redhat.com> <20120330091146.GB29854@aftab>
In-Reply-To: <20120330091146.GB29854@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-03-2012 06:11, Borislav Petkov escreveu:
> On Thu, Mar 29, 2012 at 11:13:07PM -0300, Mauro Carvalho Chehab wrote:
>> However, every time this patch series is submitted, someone come up with a 
>> bright idea to ask me to add more work to the scope, delaying its addition 
>> forever.
>>
>> While I'm not convinced that moving from a single memory allocation into a 
>> series of k*alloc is a good thing for a subsystem that is there to detect
>> memory errors (as having everything altogether into a single page can
>> reduce the chances of errors at the EDAC data), I can work latter on a 
>> patchset to fix this issue for EDAC MC, but I'll do it only after merging 
>> this series, as it is counter-productive to do it otherwise, having to 
>> repeat the same set of tests on 10 machines (and compile the entire series 
>> of patches on 8 different archs/sub-archs).
>>
>> So, I really want to move this ahead. So, please, first things first: let's
>> first fix the more serious bug. Then, we can fix the other minor stuff
>> that aren't so far causing any noticeable harm.
> 
> Dude, stop complaining - this is the kernel not some pet project of
> yours. You either do things right or you don't do them at all. Others
> have to do the same iterations with patches and intergrate maintainer
> change requests until everything is done properly.
> 
> Btw, this patch is
> 
>  5 files changed, 432 insertions(+), 717 deletions(-)
> 
> It is 1500+ lines and huuuuge! How do you think anyone can review this?

If you consider this a big patch, you can imagine how bigger it will be if
it would have there the re-write the edac_mc_alloc() function, in order to break
it into a per-struct-device function, likely patching all drivers/edac/*.c 
to use the new way.

As I said: merging the allocation fix on this patch is a very bad idea:
it should be a separate changeset, applied after this one, as the
subsequent changesets simplify the sysfs logic, helping to write a changeset
to fix the kobject issue.

Applying it before would just do a lot of changes on some code that will 
be dropped by this series, making harder for busy reviewers to inspect
the changes.

So, as I said, the way to move is to apply this changeset, and then to
go ahead and cleanup the potential problem [1] of having multiple kobj 
references for the same memory block.

[1] I never saw any bugzilla complaining about an EDAC failure due to the
usage of multiple kobjects at the same memory block. The reason is probably
because, in practice, once this module is loaded to monitor the memory errors,
this module is never unloaded. Also, module unload/reload works, before
and after this changeset. So, AFAIKT, nobody ever noticed this existing
bug before yesterday.

> Also, I told already: if you wanna fix one thing, then fix it with a
> smaller patchset which easier to review by people instead of throwing at
> them humongous patch bombs which are supposed to fix _everything_ and
> expecting everyone to understand immediately what you mean. And don't
> tell me these huge patches cannot be split, I'm not buying it.

This patch does the absolute minimum stuff to replace kobj by struct device.
Nothing more, nothing less.

I took the care to put all needed driver changes and API changes
on separate patchsets.

The edac_mc_sysfs.c file has just one thing there: the sysfs logic, based
on kobj raw allocation.

Replacing it by struct device means to rewrite the entire code. Period.

Breaking it into smaller pieces would break git bisect, and will make it
even harder for reviewers, as this atomic change unit would be broken
into several patches.

Btw, both Greg and Aris reviewed it yesterday. So, it seems that this is
not as complex as you think.

Mauro.
