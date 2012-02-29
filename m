Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2B2Rng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:43:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48935 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2B2Rne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:43:34 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kara <jack@suse.cz>
Cc: Alex Elder <elder@dreamhost.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
	<1329399979-3647-10-git-send-email-jack@suse.cz>
	<1329419084.3121.39.camel@doink> <20120220110006.GA6799@quack.suse.cz>
Date: Wed, 29 Feb 2012 09:46:40 -0800
In-Reply-To: <20120220110006.GA6799@quack.suse.cz> (Jan Kara's message of
	"Mon, 20 Feb 2012 12:00:06 +0100")
Message-ID: <m1vcmp8rcv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+EnJUKUQj3XGPIHz0zd++7Kgr/jrTAXaU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Kara <jack@suse.cz>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 09/11] sysfs: Push file_update_time() into bin_page_mkwrite()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Thu 16-02-12 13:04:44, Alex Elder wrote:
>> On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
>> > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > Signed-off-by: Jan Kara <jack@suse.cz>
>> > ---
>> >  fs/sysfs/bin.c |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> > 
>> > diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
>> > index a475983..6ceb16f 100644
>> > --- a/fs/sysfs/bin.c
>> > +++ b/fs/sysfs/bin.c
>> > @@ -225,6 +225,8 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>> >  	if (!sysfs_get_active(attr_sd))
>> >  		return VM_FAULT_SIGBUS;
>> >  
>> > +	file_update_time(file);
>> > +
>> >  	ret = 0;
>> >  	if (bb->vm_ops->page_mkwrite)
>> >  		ret = bb->vm_ops->page_mkwrite(vma, vmf);
>> 
>> If the filesystem's page_mkwrite() function is responsible
>> for updating the time, can't the call to file_update_time()
>> here be conditional?
>> 
>> I.e:
>> 	ret = 0;
>> 	if (bb->vm_ops->page_mkwrite)
>>  		ret = bb->vm_ops->page_mkwrite(vma, vmf);
>> 	else
>> 		file_update_time(file);
>   Hmm, I didn't look previously where do we get bb->vm_ops. It seems they
> are inherited from vma->vm_ops so what you suggest should be safe without
> any further changes. So I can do that if someone who understands the sysfs
> code likes it more.

I do.  Essentially sysfs is being a stackable filesystem here, because
sysfs needs the ability to remove a file mapping.

In practice we could probably get away without a single
file_update_time(file) here because there are mmio mappings.  Normally
for pci resources, but we might as well use good form since we can.

Eric
