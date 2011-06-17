Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab1FQNpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:45:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37986 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab1FQNpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:45:33 -0400
Message-ID: <4DFB5A75.2060206@codemonkey.ws>
Date: Fri, 17 Jun 2011 08:45:25 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
References: <1308153214.7566.6.camel@jaguar>	 <BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>	 <4DFA88CC.6050306@codemonkey.ws> <1308272586.29421.5.camel@lappy>
In-Reply-To: <1308272586.29421.5.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 08:03 PM, Sasha Levin wrote:
> On Thu, 2011-06-16 at 17:50 -0500, Anthony Liguori wrote:
> Each virtio-blk device can process requests regardless of other
> virtio-blk devices, which means that we can do parallel requests for
> devices.
>
> Within each device, we support parallel requests in the sense that we do
> vectored IO for each head (which may contain multiple blocks) in the
> vring, we don't do multiple heads because when I've tried adding AIO

A scatter/gather list isn't multiple requests, it's just one.  So you 
handle one request at a time ATM.  There's nothing with that, but 
there's no use in saying "we support it in the sense..." :-)

> I've noticed that at most there are 2-3 possible heads - and since it
> points to the same device it doesn't really help running them in
> parallel.

Sure it does.  If you use the host page cache (and you do), then if you 
have two requests, A and B, and request A requires a disk access and 
request B can be satisfied from the page cache, then being able to 
submit both requests means that you can return B almost immediately 
instead of stalling out to finish A before starting B.

Not to mention that modern disks work better with multiple in flight 
requests because they have their own cache and reordering algorithms in 
the drives cache.  With RAID and higher end storage devices, a single 
device may map to multiple spindles.  The only way to have them all spin 
at once is to submit parallel requests.

Regards,

Anthony Liguori
