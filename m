Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3ADVCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:02:21 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:40363 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3ADVCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:02:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
Date: Fri, 4 Jan 2013 14:02:18 -0700
Message-ID: <CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Shuah Khan <shuahkhan@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 1:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jan 4, 2013 at 9:50 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
>>
>> This change doesn't take into account what swiolb was when
>> pci_swiotlb_detect_override() is called. Instead of returning
>> use_swiotlb like the original code did, it returns swiotlb which could
>> be zero, if !enough_mem_for_swiotlb().
>>
>> Might work fine on Intel platforms, but not on systems where the IOMMU
>> driver wants to enable swiotlb for some devices as in the case of AMD.
>>
>> AMD IOMMU driver enables swiotlb for devices that are not specified in
>> IVRs and/or not in the AMD IOMMU scope, after it successfully
>> initializes IOMMU. It will explicitely set switolb=1 to make sure
>> reserved swiotlb memory is not released. This change will break that
>> case.
>
> in that case, we have to panic....
>
> please check attached patch.
>
> Also for those kind of systems, users must specify crashkernel_low=72M or
> what ever for kdump.

Pani'cing the system doesn't sound like a good option to me in this
case. This change to disable swiotlb is made for kdump. However, with
this change several system fail to boot, unless crashkernel_low=72M is
specified.

I would the say the right approach to solve this would be to not
change the current pci_swiotlb_detect_override() behavior and treat
swiotlb =1 upon entry equivalent to swiotlb_force set.

Thanks,
-- Shuah
