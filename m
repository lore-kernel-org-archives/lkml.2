Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2HXLXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:23:41 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:47146 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab2HXLXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:23:38 -0400
From: Jim Meyering <jim@meyering.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] kmemleak: avoid buffer overrun: NUL-terminate strncpy-copied command
In-Reply-To: <20120824102725.GH7585@arm.com> (Catalin Marinas's message of
	"Fri, 24 Aug 2012 11:27:26 +0100")
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-4-git-send-email-jim@meyering.net>
	<20120824102725.GH7585@arm.com>
Date: Fri, 24 Aug 2012 13:23:29 +0200
Message-ID: <876288o7ny.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On Mon, Aug 20, 2012 at 05:55:22PM +0100, Jim Meyering wrote:
>> From: Jim Meyering <meyering@redhat.com>
>>
>> strncpy NUL-terminates only when the length of the source string
>> is smaller than the size of the destination buffer.
>> The two other strncpy uses (just preceding) happen to be ok
>> with the current TASK_COMM_LEN (16), because the literals
>> "hardirq" and "softirq" are both shorter than 16.  However,
>> technically it'd be better to use strcpy along with a
>> compile-time assertion that they fit in the buffer.
>>
>> Signed-off-by: Jim Meyering <meyering@redhat.com>
>> ---
>>  mm/kmemleak.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>> index 45eb621..947257f 100644
>> --- a/mm/kmemleak.c
>> +++ b/mm/kmemleak.c
>> @@ -555,6 +555,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
>>  		 * case, the command line is not correct.
>>  		 */
>>  		strncpy(object->comm, current->comm, sizeof(object->comm));
>> +		object->comm[sizeof(object->comm) - 1] = 0;
>
> Does it really matter here? object->comm[] and current->comm[] have the
> same size, TASK_COMM_LEN.

TL;DR: either it may matter, and the patch is useful,
or else that use of strncpy is unwarranted.

----------------
Can we certify that those lengths will always be the same, i.e.,
by adding something like this ?

  static_assert (sizeof (object->comm) != sizeof(current->comm));

[I know we can't rely on this C11 syntax.  see below]

There are two reasons one might use strncpy:
  1) to truncate, when strlen(src) >= dest_buf_len
  2) to NUL-pad out to the length of dest_buf_len

The only uses of ->comm are to print that name, so (2) appears not to be
a concern.  Hence, if we are confident that the buffers will always have
the same length, then there is no reason to use strncpy in the first place.

In that case, what would you think of a patch to use strcpy instead?

  -		strncpy(object->comm, current->comm, sizeof(object->comm));
  +		strcpy(object->comm, current->comm);

Is there a preferred method of adding a static_assert-like statement?
I see compile_time_assert and a few similar macros, but I haven't
spotted anything that is used project-wide.
