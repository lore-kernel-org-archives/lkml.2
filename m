Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0C3Rtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:49:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49251 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0C3Rtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:49:40 -0400
Message-ID: <4BB238D3.7050808@zytor.com>
Date: Tue, 30 Mar 2010 10:45:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
CC: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: kernel decompressor interface
References: <877hotu6x9.fsf@tac.ki.iif.hu>
In-Reply-To: <877hotu6x9.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 09:10 AM, Ferenc Wagner wrote:
> Hi,
> 
> While working with SquashFS code recently, I got the impression that the
> current decompress_fn interface isn't best suited for general use: it
> rules out real scatter/gather operation, which -- one hopes -- is a
> general feature of stream decompressors.  For example, if one has to
> decompress data from a series of buffer_heads into a bunch of (cache)
> pages (typical operation in compressed file systems), the inflate
> interface in zlib.h provides the possibility of changing input and
> output buffer addresses, but decompress_fn does not, necessitating extra
> memory copying.  On the other hand, the latter is admittedly simpler.
> 
> However, I feel like their advantages could be combined by making the
> fill() and flush() callbacks able to change the buffer addresses, like
> int fill(void **, unsigned int) for example.  Even better, some context
> could also be passed around, so that they can easily carry private state.
> 
> A cursory look at the LZMA decompressor implementation suggests that
> this would be straightforward change (although I haven't done it).  Do
> you think that
> 1. it could be done for other decompressors (lzo, bunzip) as well, and
> 2. it should be done in any form (interface replacement or extension)?

I think the event-based interfaces in zlib.h are pretty good, myself,
and since they are so widely deployed they are also widely mimiced,
which makes it a good interface to rely on.  A simpler "one shot"
interface can then be implemented as a wrapper (since it just means:
create the context, point it at the two buffers, and then tell it to to
run to the end.)

LZO has some super-compact variants that don't support start and stop
operation, but even the "full featured" versions are small enough, that
I don't think it matters for something as large as the Linux kernel.  It
mattered to me when I was dealing with self-decompressing objects on the
order of a few tens of kilobytes.

	-hpa
