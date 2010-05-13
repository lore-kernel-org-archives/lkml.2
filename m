Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0EMInr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:43:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59126 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0EMIno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=U+PT3uadWDfG6GZSCrJ3OWdCCIeGIzQ6HLdb7RETCT0yWocG0eLL20xNvDrW9EnGeZ
         +HMcHYcs4UndeEqpZUCmkDTp2CQPWtSWFi1WeuRcgy+sn2K+LmICjMszK3T3JOt3Liko
         2rTvTYrbFmjbdOOfPoC46Vf6P+Uk6qEMECc24=
Message-ID: <4BEBBBBB.3050201@suse.cz>
Date: Thu, 13 May 2010 10:43:39 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Changli Gao <xiaosuo@gmail.com>, akpm@linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com> <20100513134124.2164.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100513134124.2164.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 06:45 AM, KOSAKI Motohiro wrote:
> Hi
> 
>> void *kvmalloc(size_t size)
>> {
>> 	void *ptr;
>>
>> 	if (size < PAGE_SIZE)
>> 		return kmalloc(PAGE_SIZE, GFP_KERNEL);
>> 	ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
> 
> low order GFP_KERNEL allocation never fail. then, this doesn't works
> as you expected.

Hi, I suppose you mean the kmalloc allocation -- so kmalloc should fail
iff alloc_pages_exact (unless somebody frees a heap of memory indeed)?

>> 	if (ptr != NULL)
>> 		return ptr;
>>
>> 	return vmalloc(size);
> 
> On x86, vmalloc area is only 128MB address space. it is very rare 
> resource than physical ram. vmalloc fallback is not good idea.

These functions are a replacement for explicit
if (!(x = kmalloc()))
   x = vmalloc();
...
if (is_vmalloc(x))
  vfree(x);
else
  kfree(x);
in the code (like fdtable does this).

The 128M limit on x86_32 for vmalloc is configurable so if drivers in
sum need more on some specific hardware, it can be increased on the
command line (I had to do this on one machine in the past).

Anyway as this is a replacement for explicit tests, it shouldn't change
the behaviour in any way. Obviously when a user doesn't need virtually
contiguous space, he shouldn't use this interface at all.

thanks,
-- 
js
suse labs
