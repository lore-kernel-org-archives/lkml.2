Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1FQFA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:00:57 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54548 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1FQFA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dtuJfVExMBhAPzFQh5zJOmwVnhfTI2OTM/2k8lKf9xuc36Vg8VaGbR8BkQW19C7Fm2
         +Ua6aE6aiJAIX9OuCR8wdt+U4hm455t02nxtEw/dfUe7h5hLefYFX05iaEY3V6epij/X
         KNhRHWHIdwpxPu5xKgrmcQ4wZ/14J4b1zxa/Y=
MIME-Version: 1.0
In-Reply-To: <1308272586.29421.5.camel@lappy>
References: <1308153214.7566.6.camel@jaguar>
	<BANLkTi=krV7p9gT3E064aVoUCToVyZoL6w@mail.gmail.com>
	<4DFA88CC.6050306@codemonkey.ws>
	<1308272586.29421.5.camel@lappy>
Date: Fri, 17 Jun 2011 06:00:54 +0100
Message-ID: <BANLkTimVG4GVoar6RHYRpdiDngCC+9rHTg@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 2:03 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Thu, 2011-06-16 at 17:50 -0500, Anthony Liguori wrote:
>> On 06/16/2011 09:48 AM, Pekka Enberg wrote:
>> > On Wed, Jun 15, 2011 at 6:53 PM, Pekka Enberg<penberg@kernel.org>  wrote:
>> >> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See the
>> >>   following URL for test result details: https://gist.github.com/1026888
>> >
>> > It turns out we were benchmarking the wrong guest kernel version for
>> > qemu-kvm which is why it performed so much worse. Here's a summary of
>> > qemu-kvm beating tools/kvm:
>> >
>> > https://raw.github.com/gist/1029359/9f9a714ecee64802c08a3455971e410d5029370b/gistfile1.txt
>> >
>> > I'd ask for a brown paper bag if I wasn't so busy eating my hat at the moment.
>>
>> np, it happens.
>>
>> Is that still with QEMU with IDE emulation, cache=writethrough, and
>> 128MB of guest memory?
>>
>> Does your raw driver support multiple parallel requests?  It doesn't
>> look like it does from how I read the code.  At some point, I'd be happy
>> to help ya'll do some benchmarking against QEMU.
>>
>
> Each virtio-blk device can process requests regardless of other
> virtio-blk devices, which means that we can do parallel requests for
> devices.
>
> Within each device, we support parallel requests in the sense that we do
> vectored IO for each head (which may contain multiple blocks) in the
> vring, we don't do multiple heads because when I've tried adding AIO
> I've noticed that at most there are 2-3 possible heads - and since it
> points to the same device it doesn't really help running them in
> parallel.

One thing that QEMU does but I'm a little suspicious of is request
merging.  virtio-blk will submit those 2-3 heads using
bdrv_aio_multiwrite() if they become available in the same virtqueue
notify.  The requests will be merged if possible.

My feeling is that we should already have merged requests coming
through virtio-blk and there should be no need to do any merging -
which could be a workaround for a poor virtio-blk vring configuration
that prevented the guest from sending large requests.  However, this
feature did yield performance improvements with qcow2 image files when
it was introduced, so that would be interesting to look at.

Are you enabling indirect descriptors on the virtio-blk vring?  That
should allow more requests to be made available because you don't run
out of vring descriptors so easily.

Stefan
