Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3ADWrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:47:47 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56596 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3ADWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:47:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
Date: Fri, 04 Jan 2013 14:47:29 -0800
In-Reply-To: <CAKocOON8_5RNp0oQZWFoTKDscdpcwkUNe9wX+B3uG9ET4h9e9g@mail.gmail.com>
	(Shuah Khan's message of "Fri, 4 Jan 2013 15:26:03 -0700")
Message-ID: <87k3rslg5a.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/2DyWkTaYs/rKvu+XsxEGVa2xVXPt644A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0142]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Shuah Khan <shuahkhan@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not enough ram for it
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan <shuahkhan@gmail.com> writes:

> On Fri, Jan 4, 2013 at 3:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Fri, Jan 4, 2013 at 1:02 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>>> Pani'cing the system doesn't sound like a good option to me in this
>>> case. This change to disable swiotlb is made for kdump. However, with
>>> this change several system fail to boot, unless crashkernel_low=72M is
>>> specified.
>>
>> this patchset is new feature to put second kdump kernel above 4G.
>>
> I understand this is just one of the patches to implement the new
> kdump feature. However, I think regression on existing behavior with a
> panic is a bit of a big hammer. Thie change causes panic on systems
> even when kdump is not enabled, if I understand it correctly.
>
> Granted kdump gets enabled by several distros, but it is not a
> required feature. However, expecting system to boot with devices that
> require swiotlb fully functioning is a basic feature. So I would argue
> that not breaking the basic functionality is a higher priority over
> enabling kdump in this case.

Yinghai Lu it looks like your autodetection of the problem case in this
patch is problematic and needs a rethink.  My quick skim says you are
trying to detect failure too early in the code.  Furthermore having
kexec on panic sized magic comments without explanation is wrong.

Shuah Khan this is motivated by kdump.  However a correct implementation
should be about dealing with the case when there is simply not enough
memory available below 4G for bounce buffers.

If a device needs an iommu, and swiotlb is the only iommu option, and 
there is not enough memory below 4G panic'ing is entirely reasonable.

Do I read this discussion right that we are waisting 64M on systems
that have the swiotlb code but don't use the swiotlb? 

Eric

