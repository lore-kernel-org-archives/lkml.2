Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0GZKYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 06:24:40 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:35429
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753884Ab0GZKYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 06:24:39 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L65U8P-01-1HL-02
X-M-MSG: 
Message-ID: <4C4D620E.9010008@amd.com>
Date: Mon, 26 Jul 2010 12:23:10 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090820)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] Fix off-by-one bug in mbind() syscall implementation
References: <1280136498-28219-1-git-send-email-andre.przywara@amd.com> <20100726094931.GA17756@basil.fritz.box>
In-Reply-To: <20100726094931.GA17756@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Jul 26, 2010 at 11:28:18AM +0200, Andre Przywara wrote:
>> When the mbind() syscall implementation processes the node mask
>> provided by the user, the last node is accidentally masked out.
>> This is present since the dawn of time (aka Before Git), I guess
>> nobody realized that because libnuma as the most prominent user of
>> mbind() uses large masks (sizeof(long)) and nobody cared if the
>> 64th node is not handled properly. But if the user application
>> defers the masking to the kernel and provides the number of valid bits
>> in maxnodes, there is always the last node missing.
>> However this also affect the special case with maxnodes=0, the manpage
>> reads that mbind(ptr, len, MPOL_DEFAULT, &some_long, 0, 0); should
>> reset the policy to the default one, but in fact it returns EINVAL.
>> This patch just removes the decrease-by-one statement, I hope that
>> there is no workaround code in the wild that relies on the bogus
>> behavior.
> 
> Actually libnuma and likely most existing users rely on it.
If grep didn't fool me, then the only users in libnuma aware of that bug 
are the test implementations in numactl-2.0.3/test, namely /test/tshm.c 
(NUMA_MAX_NODES+1) and test/mbind_mig_pages.c (old_nodes->size + 1).

Has this bug been known before?
> 
> The only way to change it would be to add new system calls.
That would probably be overkill, but if this behavior is now fixed, it 
should be documented (in the manpage and in the kernel code).
Also the actual libnuma code should be adjusted, then.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany
Tel: +49 351 448-3567-12

