Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab0EDSYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:24:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46922 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab0EDSYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:24:52 -0400
Message-ID: <4BE06642.6080702@zytor.com>
Date: Tue, 04 May 2010 11:24:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Avi Kivity <avi@redhat.com>, Brian Gerst <brgerst@gmail.com>,
       "Cui, Dexuan" <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
References: <1272812038-32484-1-git-send-email-avi@redhat.com>	 <1272812038-32484-2-git-send-email-avi@redhat.com>	 <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com>	 <4BDDBA18.3080909@redhat.com> <4BDF4407.8000503@zytor.com>	 <4BDFCF9F.3030600@redhat.com> <1272996927.2833.13.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1272996927.2833.13.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 11:15 AM, Suresh Siddha wrote:
> On Tue, 2010-05-04 at 00:41 -0700, Avi Kivity wrote:
>> On 05/04/2010 12:45 AM, H. Peter Anvin wrote:
>>>
>>>> I was trying to avoid a performance regression relative to the current
>>>> code, as it appears that some care was taken to avoid the memory reference.
>>>>
>>>> I agree that it's probably negligible compared to the save/restore
>>>> code.  If the x86 maintainers agree as well, I'll replace it with
>>>> cpu_has_xsave.
>>>>
>>>>      
>>> I asked Suresh to comment on this, since he wrote the original code.  He
>>> did confirm that the intent was to avoid a global memory reference.
>>>
>>>    
>>
>> Ok, so you're happy with the patch as is?
> 
> As use_xsave() is in the hot context switch path, I would like to go
> with Avi's proposal.
> 

I would tend to agree.  Saving a likely cache miss in the hot context
switch path is worthwhile.

I would like to request one change, however.  I would like to see the
alternatives code to be:

	movb $0,reg
	movb $1,reg

... instead of using xor (which has to be padded with NOPs, which is of
course pointless since the slot is a fixed size.)  I would suggest using
a byte-sized variable instead of a dword-size variable to save a few
bytes, too.

Once the jump label framework is integrated and has matured, I think we
should consider using it to save the mov/test/jump.

	-hpa
