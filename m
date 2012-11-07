Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2KGEVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:21:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31295 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2KGEVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:21:49 -0500
Message-ID: <5099E1C7.5000007@oracle.com>
Date: Wed, 07 Nov 2012 12:21:27 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: akpm@linux-foundation.org, aedilger@gmail.com, alan@linux.intel.com,
        arnn@arndb.de, drepper@redhat.com, gregkh@linuxfoundation.org,
        jakub@redhat.com, james.l.morris@oracle.com, john.sobecki@oracle.com,
        tytso@mit.edu, viro@zeniv.linux.org.uk,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
 added to -mm tree
References: <20121107001609.9B7A9100047@wpzn3.hot.corp.google.com> <CAGXu5jJ779UvpZwO-fi7-m+i=OfqwgXh1PC4GNwjhfD9GD82wQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJ779UvpZwO-fi7-m+i=OfqwgXh1PC4GNwjhfD9GD82wQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Kees,

Great thanks for both your comments!

On 11/07/2012 09:11 AM, Kees Cook wrote:
> Hrm, I don't like this. get_random_int() specifically says: "Get a
> random word for internal kernel use only." The intent of AT_RANDOM is
> for userspace pRNG seeding (though glibc currently uses it directly
> for stack protector and pointer mangling), which is not "internal
> kernel use only". :) Though I suppose this is already being used for
> the randomize_stack_top(), but I think it'd still be better to use
> higher quality bits.
Btw Kees, does it sounds make sense if we just return the 16 bytes
uninitialized stack array if the user disable the stack randomize via
"/proc/sys/kernel/randomize_va_space = 0" or via the related sysctl, or
even specified norandmaps on boot?

I guess this sounds more stupid since some scripts kids would like it
for writing exploits. :-P
> 
> Notes below...
> 
> On Tue, Nov 6, 2012 at 4:16 PM,  <akpm@linux-foundation.org> wrote:
>>
>> The patch titled
>>      Subject: binfmt_elf.c: use get_random_int() to fix entropy depleting
>> has been added to the -mm tree.  Its filename is
>>      binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
>> The -mm tree is included into linux-next and is updated
>> there every 3-4 working days
>>
>> ------------------------------------------------------
>> From: Jeff Liu <jeff.liu@oracle.com>
>> Subject: binfmt_elf.c: use get_random_int() to fix entropy depleting
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
>> ---
>>
>>  fs/binfmt_elf.c |   26 +++++++++++++++++++++++++-
>>  1 file changed, 25 insertions(+), 1 deletion(-)
>>
>> diff -puN fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting fs/binfmt_elf.c
>> --- a/fs/binfmt_elf.c~binfmt_elfc-use-get_random_int-to-fix-entropy-depleting
>> +++ a/fs/binfmt_elf.c
>> @@ -48,6 +48,7 @@ static int load_elf_binary(struct linux_
>>  static int load_elf_library(struct file *);
>>  static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
>>                                 int, int, unsigned long);
>> +static void randomize_stack_user(unsigned char *buf, size_t nbytes);
>>
>>  /*
>>   * If we don't support core dumping, then supply a NULL so we
>> @@ -200,7 +201,7 @@ create_elf_tables(struct linux_binprm *b
>>         /*
>>          * Generate 16 random bytes for userspace PRNG seeding.
>>          */
>> -       get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
>> +       randomize_stack_user(k_rand_bytes, sizeof(k_rand_bytes));
>>         u_rand_bytes = (elf_addr_t __user *)
>>                        STACK_ALLOC(p, sizeof(k_rand_bytes));
>>         if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
>> @@ -558,6 +559,29 @@ static unsigned long randomize_stack_top
>>  #endif
>>  }
>>
>> +/*
>> + * A wrapper of get_random_int() to generate random bytes which has lower
>> + * overhead than call get_random_bytes() directly.
>> + * create_elf_tables() call this function to generate 16 random bytes for
>> + * userspace PRNG seeding.
>> + */
>> +static void randomize_stack_user(unsigned char *buf, size_t nbytes)
>> +{
>> +       unsigned char *p = buf;
>> +
>> +       while (nbytes) {
>> +               unsigned int random_variable;
>> +               size_t chunk = min(nbytes, sizeof(unsigned int));
>> +
>> +               random_variable = get_random_int() & STACK_RND_MASK;
>> +               random_variable <<= PAGE_SHIFT;
> 
> Why is this using STACK_RND_MASK? That's not sensible. And the shift
> is especially odd. AIUI, these two lines should just be:
Definitely! I copied it from randomize_stack_top(), it's not proper to
use here, will fix it accordingly.

Thanks,
-Jeff
> 
> random_variable = get_random_int();
> 
>> +
>> +               memcpy(p, &random_variable, chunk);
>> +               p += chunk;
>> +               nbytes -= chunk;
>> +       }
>> +}
>> +
>>  static int load_elf_binary(struct linux_binprm *bprm)
>>  {
>>         struct file *interpreter = NULL; /* to shut gcc up */
>> _
>>
>> Patches currently in -mm which might be from jeff.liu@oracle.com are
>>
>> documentation-cgroups-memorytxt-s-mem_cgroup_charge-mem_cgroup_change_common.patch
>> mm-vmscanc-try_to_freeze-returns-boolean.patch
>> binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
>> binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
>>
> 
> -Kees
> 

