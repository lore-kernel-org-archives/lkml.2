Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0CaAZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:25:46 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:61340 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756571Ab0CaAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 20:25:41 -0400
Message-ID: <4BB29675.9050507@lougher.demon.co.uk>
Date: Wed, 31 Mar 2010 01:25:25 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
CC: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel decompressor interface
References: <877hotu6x9.fsf@tac.ki.iif.hu>
In-Reply-To: <877hotu6x9.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner wrote:
> Hi,
> 
> While  working with SquashFS code recently, I got the impression that the
> current decompress_fn interface isn't best suited for general use: it
> rules out real scatter/gather operation, which -- one hopes -- is a
> general feature of stream decompressors.  For example, if one has to
> decompress data from a series of buffer_heads into a bunch of (cache)
> pages (typical operation in compressed file systems), the inflate
> interface in zlib.h provides the possibility of changing input and
> output buffer addresses, but decompress_fn does not, necessitating extra
> memory copying.  On the other hand, the latter is admittedly simpler.
> 

The decompress_fn interface is rather limited, however, it must
be borne in mind that it was adequate for the original intended
users (initramfs/initrd decompression). Squashfs (and other filesystems) on
the other hand can certainly make use of a much better multi-call interface.
My strategy in adding LZMA support to Squashfs has been to get an implementation
using the current interface mainlined, and one this has been done to look at
improving the decompress_fn interface.

> However, I feel like their advantages could be combined by making the
> fill() and flush() callbacks able to change the buffer addresses, like
> int fill(void **, unsigned int) for example.  Even better, some context
> could also be passed around, so that they can easily carry private state.
> 
> A cursory look at the LZMA decompressor implementation suggests that
> this would be straightforward change (although I haven't done it).  

LZMA decompressors have a quirk in that they use the output buffer
as the history buffer (e.g. look for peek_old_byte() in decompress_unlzma.c).
This means any multi-call interface such as zlib which modifies the output
buffer pointer dynamically (without allowing the decompressor to look back at
previously passed in buffers) won't work.   A multi-call interface that
passes the output buffers in an iovec style array should work though
(incidentally this is why Squashfs passes the output buffers as an array
to the decompressor wrapper even though LZMA cannot as yet make use of it)

The following original thread about inclusion of LZMA into the kernel
has some relevant information.

http://www.mail-archive.com/linux-embedded@vger.kernel.org/msg01371.html

Phillip

> Do
> you think that
> 1. it could be done for other decompressors (lzo, bunzip) as well, and
> 2. it should be done in any form (interface replacement or extension)?

