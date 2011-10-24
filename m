Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab1JXPHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:07:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42175 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab1JXPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:07:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fujita.tomonori@lab.ntt.co.jp, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <m1lisj48q1.fsf@fess.ebiederm.org>
	<20111021004031.GB13687@phenom.dumpdata.com>
Date: Mon, 24 Oct 2011 08:07:31 -0700
In-Reply-To: <20111021004031.GB13687@phenom.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Thu, 20 Oct 2011 20:40:31 -0400")
Message-ID: <m1ty6yig24.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX181okM+gIGkDW/W4U2HPjGR9C9MmdYZUB0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 1/2] x86 swiotlb: Verify we can perform the remapping requested.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Mon, Oct 17, 2011 at 02:19:18PM -0700, Eric W. Biederman wrote:
>> 
>> Recently I had a driver try with a peculiar 2G dma memory limit.
>> It failed in weird and strange ways because my bounce buffers were
>> being allocated above 2G where the driver could not reach, and
>> no error was reported when the mappings were setup.
>
> OK, so the overflow buffer was used instead.. which presumarily
> also was allocated above the 2G? That seems to point that
> alloc_bootmem_low_pages is not doing its job?

I just looked alloc_bootmem_low_pages allocates memory below
ARCH_ADDRESS_LIMIT which for everything except s390 is 4G.

I know I was mostly using the amd gart driver.  So I may be mistaken
that the swiotlb driver had the same issue.  However my only solution
at the time was to boot with mem=2G.  So I believe the swiotlb did
have this issue.

Mostly the patch was.  Hmm.  That looks stupid not wiring up the
swiotlb address space limit check when someone has already written it.

>> Use the swiotlb_dma_supported to avoid silent problems like this
>> in the future.
>
> Which driver was it that had this limit?

An unmerged driver.  The driver has since been fixed to use it's
hardware in a way that doesn't hit this limit.

At the time that I looked drivers in the kernel with a dma limit
above 16MB and blow 4GB only existed on exotic architectures in
very special cases.

Unfortunately I no longer have access to this hardware to test with.

Eric
