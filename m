Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1JULHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:07:21 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47288 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab1JULHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:07:19 -0400
Message-ID: <4EA15224.10102@parallels.com>
Date: Fri, 21 Oct 2011 15:06:12 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, <linux-kernel@vger.kernel.org>,
        Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
References: <20111014110416.552685686@openvz.org> <20111014110511.670174429@openvz.org> <20111014171033.GC4294@google.com>
In-Reply-To: <20111014171033.GC4294@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 09:10 PM, Tejun Heo wrote:
> Hello,
>
> (cc'ing Oleg and Linus, and quoting whole body)
>
> On Fri, Oct 14, 2011 at 03:04:21PM +0400, Cyrill Gorcunov wrote:
>> This patch add ability to run that named "checkpoint" files by
>> enhancing Elf file format, which includes
>>
>>   - new Elf file type ET_CKPT
>>
>>   - three additional program header types PT_CKPT_VMA, PT_CKPT_CORE
>>     and PT_CKPT_PAGES.
>>
>>       PT_CKPT_VMA -- holds 'vma_entry' structure, which describes the
>>       memory area the kernel should map. It also might contain a file descriptor
>>       so the kernel will be mapping a file povided. Usually such file get
>>       opened by user-space helper tool which prepares 'vma_entry' structure
>>       for the kernel.
>>
>>       PT_CKPT_CORE -- 'core_entry' structure (registers, tls, tasks specific
>>       settings). The structure is defined as a 16K container which should be
>>       enough for most cases. 8K of it is reserved for arch specific settings.
>>
>>       PT_CKPT_PAGES -- a set of all pages which contents we should restored.
>>
>> Apart from Elf extension flush_old_exec() has been splitted to two
>> functions -- the former flush_old_exec() and flush_exec_keep_thread().
>> The later doesn't call for de_thread() allowing to keep threads
>> relationship. Also arch_setup_additional_pages_at() helper added
>> to setup vdso at predefined address.
>>
>> At moment only pure x86-64 architecture is supported.
>
> I don't think this is a good idea.  We already have most of interface
> necessary for restoring task state and there's no need to put it into
> the kernel as one piece.  If there's something which can't be done
> from userland using existing interfaces, let's please discuss what
> they are and whether they can be resolved differently first.
>
> The exec path is very intricate as it is and it would be very easy to
> introduce security or other bugs by altering its basic behavior.  exec
> presumes destruction of (most of) the current process and all its
> other threads and replacing them w/ fresh states from an executable.
> The scary part - interaction with process hierarchy and zapping of the
> current state - is handled from the core exec code.
>
> I see that you removed zapping to allow restoring multi-threaded
> process, which seems quite scary to me.  It might be okay, I don't
> know, but IMHO it just isn't a very good idea to introduce such
> variation to basic exec behavior for this rather narrow use case.
Agreed.

exec() is a fundamental interface to the kernel, and the change proposed 
here is too disruptive. Not only that, it is rather unannounced: since 
not always one knows kind of fmt file is being exec'd, it gets hard to 
infer which behavior to expect.

I am wondering, though: if exec is a problem, but the binary handler is 
not, maybe we can exec a process using this handler, and then have the 
handler itself to create the thread hierarchy. This way we avoid 
changing exec() behavior at all, yet achieving the same results.

What do you think?


