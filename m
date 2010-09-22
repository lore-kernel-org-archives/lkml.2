Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0IVVBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:01:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43895 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0IVVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:01:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Hugh Dickins <hughd@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
References: <m1aanc3l3e.fsf@fess.ebiederm.org>
	<m1zkvc26hg.fsf@fess.ebiederm.org>
	<alpine.LSU.2.00.1009221215250.29127@tigran.mtv.corp.google.com>
Date: Wed, 22 Sep 2010 14:01:41 -0700
In-Reply-To: <alpine.LSU.2.00.1009221215250.29127@tigran.mtv.corp.google.com>
	(Hugh Dickins's message of "Wed, 22 Sep 2010 12:31:05 -0700 (PDT)")
Message-ID: <m1k4mdwkzu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Hugh Dickins <hughd@google.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] sysfs: Fail bin file mmap if vma close is implemented.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hughd@google.com> writes:

> On Mon, 20 Sep 2010, Eric W. Biederman wrote:
>> 
>> It is not reasonably possible to wrap vma->close().  To correctly
>> wrap close would imply calling close on any vmas that remain when
>> sysfs_remove_bin_file is called.  Finding the proper lists walking
>> them getting the locking right etc, requires deep knowledge of the
>> mm subsystem and as such would require assistence from the mm
>> subsystem to implement.  That assistence does not currently exist.
>
> Isn't it fair to assume that the call to sysfs_remove_bin_file() would
> come from the module (or whatever) that would be handling the ->mmap,
> ->open, ->close, ->fault etc. calls?

It is.

> In which case, it has been kept up to date with the reference counting
> so far: and if it judges that it's apppropriate now to remove bin file,
> despite having received more mmaps and opens than closes, then I think
> it should be allowed to make that decision (knowing that your sysfs end
> will take care not to call it further), even though it wanted to support
> close while the sysfs bin file was still there.

sysfs is that reference counting layer and removes the burden of that
decision from the drivers.

There are two cases this can happen that are interesting: on rmmod of
the driver, and when the underlying hardware for the driver is removed,
thing usb or pci hotplug.  In those cases the driver really doesn't have
much choice but to clean as best it can, blocking and waiting for
references counts to go to zero is not a good option.

> I think it would be nicer to leave the bin_vma_close() handling as you
> had it before (but repositioning its sysfs_get_active more carefully,
> as in your 2/2).

I definitely agree that allowing an implementing that implements close
would definitely be a good thing.  Especially as 44 out of 99
vm_operations_structs implement close.  To implement close properly
requires finding all of the vmas and calling the underlying close
method, and for that I need support from the mm layer which I don't yet
have.  Close is typically used to either free per vma state, or to
decrement a reference count that open creates, so having mismatched
open and closes really is a problem.

In practice there are only two files that implement the mmap method
of sysfs bin files.

drivers/pci/pci-sysfs.c
arch/alpha/kernel/pci-sysfs.c

Which in their own way implement mmap for the pci memory mapped resource
bars of given platform.   Each arch implements
pci_mmap_legacy_page_range and pci_mmap_resource in their own way.  The
few I have traced come down to io_remap_pfn_range which boils down to
remap_pfn_range.  remap_pfn_range doesn't even install
vm_operations_struct so in practice none of the sysfs vma methods get
exercised.

I complain in mmap in case some arch or some implementation is doing
something strange that I missed, because I really do want to be as
general as possible.

I do have a generic version of this brewing that I hope to replace the
sysfs version with that modifies the mm layer with the support I need,
and I will copy you on that when I post it.  sysfs is not quite perfect
but proc is actively broken in this area, and I don't know how many
other places in the kernel need fixes.

Eric
