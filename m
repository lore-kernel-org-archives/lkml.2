Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730Ab0JSEGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:06:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:30953 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0JSEG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 00:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,348,1283756400"; 
   d="scan'208";a="848514424"
From: "Ma, Ling" <ling.ma@intel.com>
To: "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 19 Oct 2010 12:06:23 +0800
Subject: RE: [PATCH V2 -tip] lib,x86_64: improve the performance of memcpy()
 for unaligned copy
Thread-Topic: [PATCH V2 -tip] lib,x86_64: improve the performance of
 memcpy() for unaligned copy
Thread-Index: ActvONNS3Q3Iz+7zS/KpTpkhtLpISwAATedw
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F15D77726AF@shsmsx502.ccr.corp.intel.com>
References: <4CAEC81C.1070108@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15C916E769@shsmsx502.ccr.corp.intel.com>
 <4CAEDE0D.2040009@cn.fujitsu.com> <4CB62543.7000605@zytor.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15CC203E71@shsmsx502.ccr.corp.intel.com>
 <4CBBE7FB.2060303@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15D77721FD@shsmsx502.ccr.corp.intel.com>
 <4CBBEA7F.7010604@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15D777221E@shsmsx502.ccr.corp.intel.com>
 <4CBBFA7F.1010109@cn.fujitsu.com>
 <C10D3FB0CD45994C8A51FEC1227CE22F15D77722D0@shsmsx502.ccr.corp.intel.com>
 <4CBD0830.4030301@cn.fujitsu.com>
In-Reply-To: <4CBD0830.4030301@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Oct 2010 16:01:13 +0800, Ma, Ling wrote:
>>>> rep_good will cause memcpy jump to memcpy_c, so not run this patch,
>>> we may continue to do further optimization on it later.
>>
>>> Yes, but in fact, the performance of memcpy_c is not better on some micro-architecture(such as:
>>> Wolfdale-3M, ), especially in the unaligned cases, so we need do optimization for it, and I think
>>> the first step of optimization is optimizing the original code of memcpy().
>>
>> As mentioned above , we will optimize further memcpy_c soon.
>> Two reasons :
>>    1. movs instruction need long lantency to startup
>>    2. movs instruction is not good for unaligned case.
>>
>>>> BTW the improvement is only from core2 shift register optimization,
>>>> but for most previous cpus shift register is very sensitive because of decode stage.
>>>> I have test Atom, Opteron, and Nocona, new patch is still better.
>>
>>> I think we can add a flag to make this improvement only valid for Core2 or other CPU like it,
>>> just like X86_FEATURE_REP_GOOD.
>>
>> We should optimize core2 in memcpy_c function in future, I think.

>But there is a problem, the length of new instruction must be less or equal the length of
>original instruction if we use alternatives, but IT seems the length of core2's optimization
>instruction may be greater than the original instruction. So I think we can't optimize core2
>in memcpy_c function, just in memcpy function.
We keep above rule because we worry about i-cache capability miss and impact total performance.
However we have several questions about it according to modern CPU arch.
1. Current Linux kernel is far more previous versions and i-cache size(32k). 
2. Hardware prefetch predication become more important and sophisticated, even when we access current cache line,
   Hardware prefetch will fetch next line/lines on intel and AMD platform.
3. Based on our test, we don't find compile operation Os(for size) is better than O2 (for performance) totally on modern CPU,
   such as specjbb2005/2000, volano, kbuild ...,
4. We have found memcpy_c have performance problem, we should manage to resolve it in small size as possible.
   It is strange to separate core2 from other cpus by appending new flag,
   And I think your patch must be bigger than last version.

Thanks
Ling


