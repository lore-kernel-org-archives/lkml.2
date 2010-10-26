Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0JZNfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:35:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:49359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab0JZNfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:35:54 -0400
Message-ID: <4CC6D8FD.10802@kernel.org>
Date: Tue, 26 Oct 2010 15:34:53 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>,
        David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH] x86, percpu: revert commit fe8e0c25
References: <4CC69B22.2050708@kernel.org> <20101025224111.7798.38960.stgit@warthog.procyon.org.uk> <12101.1288088542@redhat.com> <4CC6C62F.1000804@kernel.org> <4CC6C941.2080003@kernel.org> <4CC6CD4D.3010501@kernel.org> <20101026132548.GA14666@elte.hu>
In-Reply-To: <20101026132548.GA14666@elte.hu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 13:34:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/26/2010 03:25 PM, Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Commit fe8e0c25 (x86, 32-bit: Align percpu area and irq stacks to THREAD_SIZE) 
>> aligned PERCPU section to THREAD_SIZE which can be larger than PAGE_SIZE, 
>> introduced DEFINE_PER_CPU_MULTIPAGE_ALIGNED() and used it to make irq stacks 
>> aligned to THREAD_SIZE on x86_32.
>>
>> This won't work.  The PERCPU output section is used as the template to prepare the 
>> percpu area and the actual percpu area is _alwasy_ aligned to PAGE_SIZE whether 
>> the source area is aligned to larger size or not.
> 
> The problem is, this will reintroduce a nasty boot crash which commit fe8e0c25 
> fixed. Do you say that fe8e0c25 didnt have the alignment effect?

AFAICS, not in a way which is correct.  The patch probably made the
following two differences.

* The stack in the template area is THREAD_SIZE aligned.  If something
  was dereferencing it before percpu init, this could have helped.
  IIRC, x86 early init code does use the template area.

* The percpu address would be THREAD_SIZE aligned while the translated
  kernel address for each cpu wouldn't be.  For masking stack pointer
  to find out task struct, I don't think aligning the percpu address
  would have been helpful.

It's simply broken and needs to be reverted.  If the patch somehow
fixed boot crash, yeah, we probably want to put a fix for it first
tho.

Thanks.

-- 
tejun
