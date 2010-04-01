Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0DAMLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:11:52 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:53477 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab0DAMLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:11:44 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
Subject: Re: kernel decompressor interface
References: <877hotu6x9.fsf@tac.ki.iif.hu>
	<4BB29675.9050507@lougher.demon.co.uk> <4BB38A26.4070903@zytor.com>
Date: Thu, 01 Apr 2010 14:11:26 +0200
In-Reply-To: <4BB38A26.4070903@zytor.com> (H. Peter Anvin's message of "Wed,
	31 Mar 2010 10:45:10 -0700")
Message-ID: <87k4srv0cx.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/30/2010 05:25 PM, Phillip Lougher wrote:
>
>> Ferenc Wagner wrote:
>>
>>>
>>> While  working with SquashFS code recently, I got the impression that the
>>> current decompress_fn interface isn't best suited for general use: it
>>> rules out real scatter/gather operation, which -- one hopes -- is a
>>> general feature of stream decompressors.  For example, if one has to
>>> decompress data from a series of buffer_heads into a bunch of (cache)
>>> pages (typical operation in compressed file systems), the inflate
>>> interface in zlib.h provides the possibility of changing input and
>>> output buffer addresses, but decompress_fn does not, necessitating extra
>>> memory copying.  On the other hand, the latter is admittedly simpler.
>> 
>> LZMA decompressors have a quirk in that they use the output buffer
>> as the history buffer (e.g. look for peek_old_byte() in decompress_unlzma.c).
>> This means any multi-call interface such as zlib which modifies the output
>> buffer pointer dynamically (without allowing the decompressor to look back at
>> previously passed in buffers) won't work.   A multi-call interface that
>> passes the output buffers in an iovec style array should work though
>> (incidentally this is why Squashfs passes the output buffers as an array
>> to the decompressor wrapper even though LZMA cannot as yet make use of it)
>
> inflate has exactly the same behavior, except for the fact that the
> standard zlib implementation maintains this state internally instead of
> relying on being able to peek in the output buffer.  It's thus not an
> inherent property of the compression algorithm.
>
> The requirement that the output can't be processed incrementally is
> another major disadvantage, which I'm not sure how to address (LZMA
> requires insane amounts of memory if you don't let it use its output as
> its look-behind buffer, which means that either for small or large
> outputs we're wasting tons of memory -- in the former case with a
> separate buffer and in the latter case with a "decompress all at once"
> buffer.)

I guess this would indeed be a very welcome feature during unpacking the
initramfs.  Does the current algorithm require at least twice the
uncompressed size plus the compressed size, or is the compressed image
discarded before the cpio extraction begins?  (Streamed output is not an
issue for SquashFS right now, as it populates a block's worth of
pagecache pages in one go.)

More to the point, the memory requirement of LZMA decompression is
dominated by the dictionary size.  That's available for the decompressor
together with the uncompressed size, so if asked for streamed output it
could fall back to the one-go method if that requires less memory.
At the price of keeping the code of both algorithms around.
-- 
Regards,
Feri.
