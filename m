Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2AUPym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 10:54:42 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57194 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752218Ab2AUPyk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:54:40 -0500
MIME-Version: 1.0
In-Reply-To: <20120121082857.GC32134@elte.hu>
References: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
	<CA+55aFwmDbDm5+12Nc0wnu7J8dsOKW0tCd_tVf-3pwQOq9MF3w@mail.gmail.com>
	<20120121082857.GC32134@elte.hu>
Date: Sun, 22 Jan 2012 00:54:40 +0900
Message-ID: <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
From: Hitoshi Mitake <h.mitake@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, linux-nvme@infradead.org,
        hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 17:28, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Thu, Jan 19, 2012 at 5:01 PM, Matthew Wilcox
>> <matthew.r.wilcox@intel.com> wrote:
>> > The only places that uses readq/writeq are in the initialisation
>> > path.  Since they're not performance critical, always use readl/writel.
>>
>> The arch rules are that i fthe architecture has readq/writeq, they
>> will be #define'd (they may be inline functions, but there will be a
>>
>>   #define readq readq
>>
>> to make it visible to the preprocessor as well).
>>
>> So if you don't need the atomicity guarantees of a "real" readq, you
>> can do this instead:
>>
>>   #ifndef readq
>>   static inline u64 readq(void __iomem *addr)
>>   {
>>         return readl(addr) | (((u64) readl(addr + 4)) << 32LL);
>>   }
>>   #endif
>>
>> and then use readq() as if it existed.
>>
>> And I do think we should expose this in some generic manner. Because
>> we currently don't, we already have that pattern copied in quite a few
>> drivers.
>>
>> Maybe <asm-generic/io-nonatomic.h> or something? Making it
>> clear that its not atomic, but avoiding the silly duplication
>> we do now..
>>
>> This whole mess was introduced in commit dbee8a0affd5 ("x86:
>> remove 32-bit versions of readq()/writeq()"), and it already
>> talked about the problems but didn't help with the drivers
>> that simply don't care.
>>
>> All the people in those threads were doing their
>> self-satisfied "writeq is broken", without much acknowledging
>> that 99% of users simply don't seem to care.
>>
>> "Occupy Writeq - We are the 99%"
>
> Agreed, and offering a generic facility for silly duplication
> was the motivation of the original commit by Hitoshi Mitake.
>
> This:
>
> | The presense of a writeq() implementation on 32-bit x86 that
> | splits the 64-bit write into two 32-bit writes turns out to
> | break the mpt2sas driver (and in general is risky for drivers
> | as was discussed in
> |   <http://lkml.kernel.org/r/adaab6c1h7c.fsf@cisco.com>).
>
> is actually a mostly bogus statement and creates more problems
> than it solves.
>
> Hitoshi-san, would you be interested in re-adding the generic
> readq/writeq definitions in a slight variation to 2c5643b1c5, to
> a separate io-nonatomic.h file, so that drivers that want it can
> #include that file and be happy?

It sounds nice. In the previous discussion, I suggested that
chaning the name of non-atomic readq/writeq to
readq_nonatomic/writeq_nonatomic. And James Bottomley
replied that it is fine but not really very useful:

https://lkml.org/lkml/2011/5/19/13

The idea of providing non-atomic readq/writeq in the new file
with the name which express non-atomicity clearly might be
able to satisfy both of safety and usefulness.

It will reduce the duplication of the definition. In addition
readq/writeq users don't have to type the long symbols with
_nonatomic suffix and can know non-atomicity from the name
of header file.

I'd like to hear opinions from James, Roland and folks who
dislike non-atomic readq/writeq.

-- 
Hitoshi Mitake
h.mitake@gmail.com
