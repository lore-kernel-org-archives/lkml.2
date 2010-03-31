Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab0CaRtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:49:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37200 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924Ab0CaRtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:49:07 -0400
Message-ID: <4BB38A26.4070903@zytor.com>
Date: Wed, 31 Mar 2010 10:45:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: Ferenc Wagner <wferi@niif.hu>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org
Subject: Re: kernel decompressor interface
References: <877hotu6x9.fsf@tac.ki.iif.hu> <4BB29675.9050507@lougher.demon.co.uk>
In-Reply-To: <4BB29675.9050507@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 05:25 PM, Phillip Lougher wrote:
> Ferenc Wagner wrote:
>> Hi,
>>
>> While  working with SquashFS code recently, I got the impression that the
>> current decompress_fn interface isn't best suited for general use: it
>> rules out real scatter/gather operation, which -- one hopes -- is a
>> general feature of stream decompressors.  For example, if one has to
>> decompress data from a series of buffer_heads into a bunch of (cache)
>> pages (typical operation in compressed file systems), the inflate
>> interface in zlib.h provides the possibility of changing input and
>> output buffer addresses, but decompress_fn does not, necessitating extra
>> memory copying.  On the other hand, the latter is admittedly simpler.
> 
> The decompress_fn interface is rather limited, however, it must
> be borne in mind that it was adequate for the original intended
> users (initramfs/initrd decompression). Squashfs (and other filesystems) on
> the other hand can certainly make use of a much better multi-call interface.
> My strategy in adding LZMA support to Squashfs has been to get an implementation
> using the current interface mainlined, and one this has been done to look at
> improving the decompress_fn interface.

Well, it's adequate for the *current form* of initramfs decompression,
which is rather crippled: we fail to progressively free the memory used,
simply because we have no way to track it.

This is, in my opinion, a major shortcoming of the current implementation.

> LZMA decompressors have a quirk in that they use the output buffer
> as the history buffer (e.g. look for peek_old_byte() in decompress_unlzma.c).
> This means any multi-call interface such as zlib which modifies the output
> buffer pointer dynamically (without allowing the decompressor to look back at
> previously passed in buffers) won't work.   A multi-call interface that
> passes the output buffers in an iovec style array should work though
> (incidentally this is why Squashfs passes the output buffers as an array
> to the decompressor wrapper even though LZMA cannot as yet make use of it)

inflate has exactly the same behavior, except for the fact that the
standard zlib implementation maintains this state internally instead of
relying on being able to peek in the output buffer.  It's thus not an
inherent property of the compression algorithm.

The requirement that the output can't be processed incrementally is
another major disadvantage, which I'm not sure how to address (LZMA
requires insane amounts of memory if you don't let it use its output as
its look-behind buffer, which means that either for small or large
outputs we're wasting tons of memory -- in the former case with a
separate buffer and in the latter case with a "decompress all at once"
buffer.)

	-hpa
