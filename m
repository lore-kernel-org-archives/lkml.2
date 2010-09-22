Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab0IVV7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:59:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51037 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0IVV7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:59:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Hugh Dickins <hughd@google.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
References: <m1aanc3l3e.fsf@fess.ebiederm.org>
	<m1vd6026gg.fsf@fess.ebiederm.org>
	<alpine.LSU.2.00.1009221231251.29127@tigran.mtv.corp.google.com>
Date: Wed, 22 Sep 2010 14:59:15 -0700
In-Reply-To: <alpine.LSU.2.00.1009221231251.29127@tigran.mtv.corp.google.com>
	(Hugh Dickins's message of "Wed, 22 Sep 2010 12:49:51 -0700 (PDT)")
Message-ID: <m1zkv9v3rg.fsf@fess.ebiederm.org>
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
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Hugh Dickins <hughd@google.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] sysfs: only access bin file vm_ops with the active lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hughd@google.com> writes:

> On Mon, 20 Sep 2010, Eric W. Biederman wrote:
>> 
>> bb->vm_ops is a cached copy of the vm_ops of the underlying
>> sysfs bin file, which means that after sysfs_bin_remove_file
>> completes it is only longer valid to deference bb->vm_ops.
>> 
>> So move all of the tests of bb->vm_ops inside of where
>> we hold the sysfs active lock.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> Good point.  There's a couple of cases (the ones below) where you've
> changed the return value from success to failure when the entry point
> didn't exist for an object that is no longer active; but on reflection,
> I accept that's just not worth worrying about.

Good spotting and thanks for the review.

Thinking about this it looks like bin_set_policy should only ever
error if the underlying function errors, and that will clear up
one inconsistency.

As for bin_page_mkwrite if sysfs_get_active fails there is no mapping
because we have called unmap_mapping_range to zap everything, so
page_mkwrite should simply not be called.  However there is the
interesting case what should page_mkwrite return if there are no
vm_ops at all.

I expect the right choice for page_mkwrite it to simply have to
different sets of vm_ops and only write of page_mkwrite in one
of them and to simply call VM_FAULT_NOPAGE on error.  Implementing
page_mkwrite when it isn't needed appears to have all kinds of
interesting side effects where we do a lot more work than we other
wise would.  Lock dropping and regrabbing, as well as some extra
dirty page balancing logic gets triggered.

I will see if I can cook up a patch to that effect.

Eric
