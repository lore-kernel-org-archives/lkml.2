Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1EMCho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:37:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43390 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1EMChn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:37:43 -0400
Message-ID: <4DCC996D.6050908@landley.net>
Date: Thu, 12 May 2011 21:37:33 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Don't understand comment in arch/x86/boot/compressed/misc.c
References: <4DCB1044.6030505@landley.net> <m1wrhwixpp.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrhwixpp.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 07:12 PM, Eric W. Biederman wrote:
> Rob Landley <rob@landley.net> writes:
> 
>> It talks about when decompression in place is safe to do:
>>
>>  * Getting to provable safe in place decompression is hard.
>>  * Worst case behaviours need to be analyzed.
>> ...
>>  * The buffer for decompression in place is the length of the
>>  * uncompressed data, plus a small amount extra to keep the algorithm safe.
>>  * The compressed data is placed at the end of the buffer.  The output
>>  * pointer is placed at the start of the buffer and the input pointer
>>  * is placed where the compressed data starts.  Problems will occur
>>  * when the output pointer overruns the input pointer.
>>  *
>>  * The output pointer can only overrun the input pointer if the input
>>  * pointer is moving faster than the output pointer.  A condition only
>>  * triggered by data whose compressed form is larger than the uncompressed
>>  * form.
>>
>> You have an output pointer at a lower address catching up to an input
>> pointer at a higher address.  If the input pointer is moving FASTER
>> than the output pointer, wouldn't the gap between them grow rather
>> than shrink?
> 
> The wording might be clearer but the basic concept in context seems
> fine.  The entire section is talking about how many bytes more than the
> uncompressed size of the data do you need to guarantee you won't overrun
> your compressed data.
> 
> For gzip that is a smidge over a single compressed block.
> 
> In the worst case you have to assume that none of your blocks
> actually compressed.
> 
> So an input pointer going faster than an output pointer is a problem
> if you try to limit yourself to exactly the area of memory that the
> decompressed data lives in.  In that case the input point will
> run off the end.

That's not a question of output catching up with intput and overwriting 
it, that's a question of making sure that your buffer is large enough 
to contain the whole of the input data, and that your input pointer 
didn't start before your output pointer.

That's starting conditions, not something that happens during 
operation.  When you allocate your buffer you can't just blindly take 
output size but have to take max(input_size,output_size) for the size 
of the buffer you're working with.

When you say:

 * The output pointer can only overrun the input pointer if the input
 * pointer is moving faster than the output pointer.

Input pointer starts after your output pointer, and input moves faster 
than output, how do they cross?  (Except for the address space wrapping 
which isn't relevant here.)  I don't understand the explanation.

>> The concern seems to be about COMPRESSING in place, rather than
>> decompressing...?
> 
> No.  In theory there is some data that when compressed will grow.  In
> the best case that data will grow only by a single bit.

Claude Shannon did a paper on this in 1948 proving every compression 
technique must have some input that will wind up larger, but when that 
happens it still means that at decompression time the decompressor 
would consume input faster than output.

> In case a picture will help.
> 
>   Decompressed data goes here       Compressed data comes from here
>   |                                 |
> 0 v->                               v->
> +---------------------------------------+-----+------------+
> |                                       |extra|decompressor|
> +---------------------------------------+-----+------------+

Wouldn't your "extra" gap be _before_ the compressed data?  You align 
the compressed data with the _end_ of the buffer, so the gap is before 
not after...

> The question is how large that extra chunk needs to be.  This matters
> either when nothing compresses (the worst case for extra space) or
> especially when you get a chunk of blocks at the end that don't
> compress (a plausible but almost worst case scenario).

When _nothing_ compresses then output starts before input and stays 
there, which has been my point.  In fact to hit the pathological case 
of a block actually expanding, none of the component run lookups can 
have accomplished anything, it's gotta be _all_ literals, so I'm not 
sure input can actually advance faster than output even temporarily 
during the block decompression enough to actually corrupt the data.  
(Remember, the "copy this previous run" stuff is done against the 
_uncompressed_ data.  I admit it's been ~15 years since I rewrote 
info-zip's deflate in Java 1.0, but I _think_ I remember how it works.)

In that case, your padding is just making sure that the buffer is big 
enough to hold the (larger than input) compressed data, it if could 
catch up it would be achieving compression.

Ah, but I see: in the case that data at the _start_ compresses but data 
at the _end_ doesn't, it's possible for output to advance upon input 
before you run out of input.  The question is can it advance enough to 
catch up, and if so under what circumstances?  If the "actually gets 
compression" case is safe (where the compressed data is right-aligned), 
and the "nothing compresses" case is safe (where the buffer is big 
enough to hold the whole input), what would be an example of a 
combination of the two that wouldn't be?

Hmmm...

It sounds to me like your pathological case is compressing a chunk of 
/dev/zero followed by a chunk of /dev/urandom.  Compress a decent sized 
chunk of /dev/random and measure the amount of expansion (say 100 
bytes), then re-compress it with 100 bytes of /dev/zero stuck on the 
beginning, and maybe decompressing that would eat into the data.  A 
case where the size of the input file and the size of the output file 
match so the expansion gets hidden, and thus mere right-alignment isn't 
sufficient.

Ok, _that_ might screw up an in-place decompression.  It wouldn't 
happen with real world data, and your extra bytes are probablly 
overkill to protect against this anyway, but what's there works, so...

Just trying to understand it. :)

> Things have changed a bit since I wrote that analysis.  The computation
> of the worst case space has moved to mkpiggy.c, support for other
> compression methods have been added, and we now have a mini ELF loader
> in misc.c which adds an extra step to everything.  But the overall
> concepts remain valid.

Typos:

From: Rob Landley <rob@landley.net>

Typo fixes.

Signed-off-by: Rob Landley <rob@landley.net>
---

 arch/x86/boot/compressed/misc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3a19d04..b66f083 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -69,16 +69,16 @@
  * of 5 bytes per 32767 bytes.
  *
  * The worst case internal to a compressed block is very hard to figure.
- * The worst case can at least be boundined by having one bit that represents
+ * The worst case can at least be bounded by having one bit that represents
  * 32764 bytes and then all of the rest of the bytes representing the very
  * very last byte.
  *
  * All of which is enough to compute an amount of extra data that is required
  * to be safe.  To avoid problems at the block level allocating 5 extra bytes
- * per 32767 bytes of data is sufficient.  To avoind problems internal to a
+ * per 32767 bytes of data is sufficient.  To avoid problems internal to a
  * block adding an extra 32767 bytes (the worst case uncompressed block size)
  * is sufficient, to ensure that in the worst case the decompressed data for
- * block will stop the byte before the compressed data for a block begins.
+ * a block will stop the byte before the compressed data for the block begins.
  * To avoid problems with the compressed data's meta information an extra 18
  * bytes are needed.  Leading to the formula:
  *
@@ -86,7 +86,7 @@
  *
  * Adding 8 bytes per 32K is a bit excessive but much easier to calculate.
  * Adding 32768 instead of 32767 just makes for round numbers.
- * Adding the decompressor_size is necessary as it musht live after all
+ * Adding the decompressor_size is necessary as it must live after all
  * of the data as well.  Last I measured the decompressor is about 14K.
  * 10K of actual data and 4K of bss.
  *

