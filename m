Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3AHDN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:13:57 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39083 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3AHDN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:13:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yinghai@kernel.org>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<20130107152622.GD3219@phenom.dumpdata.com>
	<CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
	<CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
Date: Mon, 07 Jan 2013 19:13:46 -0800
In-Reply-To: <CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
	(Yinghai Lu's message of "Mon, 7 Jan 2013 19:01:02 -0800")
Message-ID: <87y5g4z7rp.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+gZ4k1XUf6i/6RZux8b2Q0u3eNlKxO0M8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3742]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not enough ram for it
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On Mon, Jan 7, 2013 at 6:22 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Yinghai I sat down and read your patch and the approach you are taking
>> is totally wrong.
>
> Thanks for check the patch, did you check v3?

I looked at the version of the patch you had as an attachment.  I don't
know the version number but it was the latest version of the patch I saw
in this thread.

After looking at things having a function enoung_mem_for_swiotlb()
in pci_swiotlb_detect_override() and pic_swiotlb_detect_4gb is brittle
hack.

>> The problem is that swiotlb_init() in lib/swiotlb.c does not know how to
>> fail without panic'ing the system.
>
> I did not put panic in swiotlb, now I put panic in amd_iommu ops init
> when it need extra
> swiotlb for unhandled devices by AMD IOMMU.

But the only reason you need to touch this code at all is that
swiotlb_init() calls panic() if you don't have 64MB of memory below 4G.

>> Which leaves two valid approaches.
>> - Create a variant of swiotlb_init that can fail for use on x86 and
>>   handle the failure.
>> - Delay initializing the swiotlb until someone actually needs a mapping
>>   from it.
>>
>> Delaying the initialization of the swiotlb is out because the code
>> needs an early memory allocation to get a large chunk of contiguous
>> memory for the bounce buffers.
>
> ok.
>
>>
>> Which means the panics that occurr in swiotlb_init() need to be delayed
>> until someone something actually needs bounce buffers from the swiotlb.
>>
>> Although arguably what should actually happen instead of panic() is that
>> swiotlb_map_single should simply fail early when it was not possible to
>> preallocate bounce buffers.
>
> do you mean: actually needed dma buffer is much less than swiotlb
> buffer aka 64M?


I meant we should detect failure to allocate bounce buffers in in
swiotlb_init() instead of panicing.

I meant swiotlb_map_single() should either panic or simply fail.

If I have read lib/swiotlb.c correctly the only place we allocate a
bounce buffer is in swiotlb_map_single.  If there are more places we can
allocate bounce buffers those need to be handled as well.

Eric
