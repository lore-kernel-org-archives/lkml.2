Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2LUCAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:00:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51353 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2LUCA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:00:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hatayama\, Daisuke" <d.hatayama@jp.fujitsu.com>
Cc: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "cpw\@sgi.com" <cpw@sgi.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>
References: <20121210103913.020858db777e2f48c59713b6@mxc.nes.nec.co.jp>
	<20121219161856.e6aa984f.akpm@linux-foundation.org>
	<20121220112103.d698c09a9d1f27a253a63d37@mxc.nes.nec.co.jp>
	<33710E6CAA200E4583255F4FB666C4E20AB2DEA3@G01JPEXMBYT03>
Date: Thu, 20 Dec 2012 18:00:11 -0800
In-Reply-To: <33710E6CAA200E4583255F4FB666C4E20AB2DEA3@G01JPEXMBYT03> (Daisuke
	Hatayama's message of "Thu, 20 Dec 2012 03:02:56 +0000")
Message-ID: <87licsrwpg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18CSpKC7seXBas+2Y593ExM9RMCFTTopsw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hatayama\, Daisuke" <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] Add the values related to buddy system for filtering free pages.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com> writes:

>> From: kexec-bounces@lists.infradead.org
>> [mailto:kexec-bounces@lists.infradead.org] On Behalf Of Atsushi Kumagai
>> Sent: Thursday, December 20, 2012 11:21 AM
>
>> On Wed, 19 Dec 2012 16:18:56 -0800
>> Andrew Morton <akpm@linux-foundation.org> wrote:
>> 
>> > On Mon, 10 Dec 2012 10:39:13 +0900
>> > Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp> wrote:
>> >
>
>> >
>> > We might change the PageBuddy() implementation at any time, and
>> > makedumpfile will break.  Or in this case, become less efficient.
>> >
>> > Is there any way in which we can move some of this logic into the
>> > kernel?  In this case, add some kernel code which uses PageBuddy() on
>> > behalf of makedumpfile, rather than replicating the PageBuddy() logic
>> > in userspace?
>> 
>> In last month, Cliff Wickman proposed such idea:
>> 
>>   [PATCH v2] makedumpfile: request the kernel do page scans
>>   http://lists.infradead.org/pipermail/kexec/2012-November/007318.html
>> 
>>   [PATCH] scan page tables for makedumpfile, 3.0.13 kernel
>>   http://lists.infradead.org/pipermail/kexec/2012-November/007319.html
>> 
>> In his idea, the kernel does page scans to distinguish unnecessary pages
>> (free pages and others) and returns the list of PFN's which should be
>> excluded for makedumpfile.
>> As a result, makedumpfile doesn't need to consider internal kernel
>> behavior.
>> 
>> I think it's a good idea from the viewpoint of maintainability and
>> performance.

> I also think wide part of his code can be reused in this work. But the bad
> performance is caused by a lot of ioremap, not a lot of copying. See my
> profiling result I posted some days ago. Two issues, ioremap one and filtering
> maintainability, should be considered separately. Even on ioremap issue,
> there is secondary one to consider in memory consumption on the 2nd
> kernel.

Thanks.  I was wondering why moving the code into /proc/vmcore would
make things faster.

> Also, I have one question. Can we always think of 1st and 2nd kernels
> are same?

Not at all.  Distros frequently implement it with the same kernel in
both role but it should be possible to use an old crusty stable kernel
as the 2nd kernel.

> If I understand correctly, kexec/kdump can use the 2nd kernel different
> from the 1st's. So, differnet kernels need to do the same thing as makedumpfile
> does. If assuming two are same, problem is mush simplified.

As a developer it becomes attractive to use a known stable kernel to
capture the crash dump even as I experiment with a brand new kernel.

Eric
