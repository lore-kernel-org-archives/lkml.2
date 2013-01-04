Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3ADW4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:56:44 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:51029 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3ADW4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:56:42 -0500
MIME-Version: 1.0
In-Reply-To: <87k3rslg5a.fsf@xmission.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
	<87k3rslg5a.fsf@xmission.com>
Date: Fri, 4 Jan 2013 15:56:41 -0700
Message-ID: <CAKocOOOXx+65rh4f8_++SwYMZdEO2FaOpLiW=dQ6uXZpwM1PYQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Shuah Khan <shuahkhan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
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

On Fri, Jan 4, 2013 at 3:47 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Shuah Khan <shuahkhan@gmail.com> writes:
>
>> On Fri, Jan 4, 2013 at 3:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Fri, Jan 4, 2013 at 1:02 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>>>> Pani'cing the system doesn't sound like a good option to me in this
>>>> case. This change to disable swiotlb is made for kdump. However, with
>>>> this change several system fail to boot, unless crashkernel_low=72M is
>>>> specified.
>>>
>>> this patchset is new feature to put second kdump kernel above 4G.
>>>
>> I understand this is just one of the patches to implement the new
>> kdump feature. However, I think regression on existing behavior with a
>> panic is a bit of a big hammer. Thie change causes panic on systems
>> even when kdump is not enabled, if I understand it correctly.
>>
>> Granted kdump gets enabled by several distros, but it is not a
>> required feature. However, expecting system to boot with devices that
>> require swiotlb fully functioning is a basic feature. So I would argue
>> that not breaking the basic functionality is a higher priority over
>> enabling kdump in this case.
>
> Yinghai Lu it looks like your autodetection of the problem case in this
> patch is problematic and needs a rethink.  My quick skim says you are
> trying to detect failure too early in the code.  Furthermore having
> kexec on panic sized magic comments without explanation is wrong.
>
> Shuah Khan this is motivated by kdump.  However a correct implementation
> should be about dealing with the case when there is simply not enough
> memory available below 4G for bounce buffers.
>
> If a device needs an iommu, and swiotlb is the only iommu option, and
> there is not enough memory below 4G panic'ing is entirely reasonable.
>
> Do I read this discussion right that we are waisting 64M on systems
> that have the swiotlb code but don't use the swiotlb?
>

No. pci_swiotlb_late_init() does free reserved swiolb buffers on
systems that don't need swiolb. IOMMU drivers turn off swiotlb after
iommu is initialized correctly. It is possible on some systems when
BIOS is incorrect, iommu initialization could fail and swiotlb is left
enabled.

AMD IOMMU driver is using this lever to leave swiotlb enabled when it
detects devices that can't be supported by iommu. My concern is that
this change for kdump removes that handshake ability between iommu and
swiolb.

-- Shuah
