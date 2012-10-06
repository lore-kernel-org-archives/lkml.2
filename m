Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2JFA2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:28:12 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56627 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2JFA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:28:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<20121003165105.GA30214@jshin-Toonie>
	<CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com>
	<20121004164630.GB2244@phenom.dumpdata.com>
	<CAE9FiQUBohwjOzOm26yJME=JzZ7eH55hM+Q=Kc4Pz+ocaw90Jg@mail.gmail.com>
	<871uhcsk93.fsf@xmission.com>
	<CAE9FiQVx93B_imGbs1ms7gcu_-Z9HvkcGePQi9XpWQo0SKu-Kg@mail.gmail.com>
	<87ehlcr4et.fsf@xmission.com> <506F78A2.3050408@zytor.com>
Date: Fri, 05 Oct 2012 17:28:02 -0700
In-Reply-To: <506F78A2.3050408@zytor.com> (H. Peter Anvin's message of "Fri,
	05 Oct 2012 17:17:38 -0700")
Message-ID: <87zk40mokt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/8fiJkIqOajV5jbn6UvobH6z/+de0Bigg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 10/05/2012 02:32 PM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>>
>>> On Fri, Oct 5, 2012 at 2:04 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>> Is there a git commit that explains what the 'big range' problem is?
>>>>
>>>> At least on x86_64 this was recently tested and anywhere below 4G is
>>>> good, and there is a patch floating around somewhere to remove this
>>>> issue.
>>>
>>> patch for kernel or kexec-tools?
>>
>> kernel.
>>
>> The sgi guys needed a kdump kernel with 1G of ram to dump their all of
>> the memory on one of their crazy large machines and so investigated
>> this.
>>
>> Basically they found that a kdump kernel loaded anywhere < 4G worked,
>> the only change that was needed was to relaxy the 896M hard code.
>>
>> In one test they had a kdump kernel loaded above 2G.
>>
>
> Seriously, any case where we can't load anywhere in physical ram on x86-64 is a
> bug.  i386 is another matter.

As I recall there are data structures like the IDT that only have a
32bit base address.

According to the bzImage header we don't support ramdisks above 4G.
I think we also have a 32bit address for the kernel command line
in the bzImage header.

In the case of kdump in particular there is a need for DMAable
memory and in general that means memory below 4G.  So as long
as we only support one memory extent for kdump it makes sense
for that segment to be below 4G.

For a normal x86_64 kernel which gets to use most of the memory it
definitely should be loadable anywhere in memory.

Eric
