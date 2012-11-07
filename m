Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2KGHDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:03:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28959 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2KGHDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:03:34 -0500
Message-ID: <509A078D.8060705@oracle.com>
Date: Wed, 07 Nov 2012 15:02:37 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <aedilger@gmail.com>,
        John Sobecki <john.sobecki@oracle.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, "arnd@arndb.de" <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>, "Ted Ts'o" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        jakub@redhat.com, drepper@redhat.com,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RESEND PATCH V3] binfmt_elf.c: use get_random_int() to fix entropy
 depleting
References: <5099F133.5030305@oracle.com> <5099FBAA.6000200@oracle.com> <CAGXu5jLpE5kTGGqLqDRwRaEOt+nhpKc52jQFs+rsa+0GVKA-vw@mail.gmail.com>
In-Reply-To: <CAGXu5jLpE5kTGGqLqDRwRaEOt+nhpKc52jQFs+rsa+0GVKA-vw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 02:21 PM, Kees Cook wrote:
> On Tue, Nov 6, 2012 at 10:11 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
>> Hello,
>>
>> This is the revised patch for fix entropy depleting.
>>
>> Changes:
>> --------
>> v3->v2:
>> - Tweak code comments of random_stack_user().
>> - Remove redundant bits mask and shift upon the random variable.
>>
>> v2->v1:
>> Fix random copy to check up buffer length that are not 4-byte multiples.
>>
>> v2 can be found at:
>> http://www.spinics.net/lists/linux-fsdevel/msg59418.html
>> v1 can be found at:
>> http://www.spinics.net/lists/linux-fsdevel/msg59128.html
>>
>> Many thanks to Andreas, Andrew as well as Kees for reviewing the patch of past!
>> -Jeff
>>
>>
>> Entropy is quickly depleted under normal operations like ls(1), cat(1),
>> etc...  between 2.6.30 to current mainline, for instance:
>>
>> $ cat /proc/sys/kernel/random/entropy_avail
>> 3428
>> $ cat /proc/sys/kernel/random/entropy_avail
>> 2911
>> $cat /proc/sys/kernel/random/entropy_avail
>> 2620
>>
>> We observed this problem has been occurring since 2.6.30 with
>> fs/binfmt_elf.c: create_elf_tables()->get_random_bytes(), introduced by
>> f06295b44c296c8f ("ELF: implement AT_RANDOM for glibc PRNG seeding").
>>
>> /*
>>  * Generate 16 random bytes for userspace PRNG seeding.
>>  */
>> get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
>>
>> The patch introduces a wrapper around get_random_int() which has lower
>> overhead than calling get_random_bytes() directly.
>>
>> With this patch applied:
>> $ cat /proc/sys/kernel/random/entropy_avail
>> 2731
>> $ cat /proc/sys/kernel/random/entropy_avail
>> 2802
>> $ cat /proc/sys/kernel/random/entropy_avail
>> 2878
>>
>> Analyzed by John Sobecki.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> Cc: John Sobecki <john.sobecki@oracle.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Andreas Dilger <aedilger@gmail.com>
>> Cc: Alan Cox <alan@linux.intel.com>
>> Cc: Arnd Bergmann <arnn@arndb.de>
>> Cc: James Morris <james.l.morris@oracle.com>
>> Cc: Ted Ts'o <tytso@mit.edu>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Jakub Jelinek <jakub@redhat.com>
>> Cc: Ulrich Drepper <drepper@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>
>> ---
>>  fs/binfmt_elf.c |   22 +++++++++++++++++++++-
>>  1 files changed, 21 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index fbd9f60..b6c59f6 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -48,6 +48,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
>>  static int load_elf_library(struct file *);
>>  static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
>>                                 int, int, unsigned long);
>> +static void randomize_stack_user(unsigned char *buf, size_t nbytes);
> 
> I think it would be easier to just move the function ahead of its use
> to avoid the predeclaration.
Yes, it's better.
> 
>>
>>  /*
>>   * If we don't support core dumping, then supply a NULL so we
>> @@ -200,7 +201,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>>         /*
>>          * Generate 16 random bytes for userspace PRNG seeding.
>>          */
>> -       get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
>> +       randomize_stack_user(k_rand_bytes, sizeof(k_rand_bytes));
>>         u_rand_bytes = (elf_addr_t __user *)
>>                        STACK_ALLOC(p, sizeof(k_rand_bytes));
>>         if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
>> @@ -558,6 +559,25 @@ static unsigned long randomize_stack_top(unsigned long stack_top)
>>  #endif
>>  }
>>
>> +/*
>> + * Use get_random_int() to implement AT_RANDOM while avoiding depletion
>> + * of the entropy pool.
>> + */
>> +static void randomize_stack_user(unsigned char *buf, size_t nbytes)
> 
> I think this name needs changing -- it has nothing to do with the
> stack except that that's where it ends up in userspace. Perhaps
> "get_atrandom_bytes"?
I racked my brains but can not think out a better name than yours. :)
> 
>> +{
>> +       unsigned char *p = buf;
>> +
>> +       while (nbytes) {
>> +               unsigned int random_variable;
>> +               size_t chunk = min(nbytes, sizeof(unsigned int));
>> +
>> +               random_variable = get_random_int();
> 
> I still want to hear at least from Ted about this changes -- we would
> be potentially increasing the predictability of these bytes...
We would not increasing that if this routine would be used for AT_RANDOM
only(and if the array keeping aligned to 4 bytes).
Otherwise, it would be, so let's waiting for further feedbacks.

Thanks,
-Jeff
> 
>> +               memcpy(p, &random_variable, chunk);
>> +               p += chunk;
>> +               nbytes -= chunk;
>> +       }
>> +}
>> +
>>  static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
>>  {
>>         struct file *interpreter = NULL; /* to shut gcc up */
>> --
>> 1.7.4.1
> 
> -Kees
> 

