Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab1KJIXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:23:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59671 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab1KJIXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:23:45 -0500
MIME-Version: 1.0
In-Reply-To: <m3pqh0tnoi.fsf@blackfin.pond.sub.org>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
 <4EBB4A21.20707@codemonkey.ws> <alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
 <m3pqh0tnoi.fsf@blackfin.pond.sub.org>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 10 Nov 2011 10:23:23 +0200
Message-ID: <CA+1xoqe22z9F3ZyFG_XnV9Y17HtkeSxtf1gbW4+CW1cuNQ=N5g@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
To: Markus Armbruster <armbru@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 9:57 AM, Markus Armbruster <armbru@redhat.com> wrote:
> Pekka Enberg <penberg@kernel.org> writes:
>
>> Hi Anthony,
>>
>>> On 11/04/2011 03:38 AM, Pekka Enberg wrote:
>>>> Hi Linus,
>>>>
>>>> Please consider pulling the latest KVM tool tree from:
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git
>>>> kvmtool/for-linus
>>>>
>>>
>>> [snip]
>>>
>>>> tools/kvm/virtio/net.c | 423 ++++++++
>>>> tools/kvm/virtio/pci.c | 319 ++++++
>>>> tools/kvm/virtio/rng.c | 185 ++++
>>>> 186 files changed, 19071 insertions(+), 179 deletions(-)
>>
>> On Wed, 9 Nov 2011, Anthony Liguori wrote:
>>> So let's assume for a moment that a tool like this should live in
>>> the kernel. What's disturbing about a PULL request like this is the
>>> lack of reviewability of it and the lack of any real review from
>>> people that understand what's going on in this code base.
>>>
>>> There are no Acked-by's by people that really understand what the
>>> code is doing or that have domain expertise in filesystems and
>>> networking.
>>>
>>> There are major functionality short comings in this code base, data
>>> corruptors, and CVEs.  I'm not saying that the kvm-tool developers
>>> are bad developers, but the code is not at the appropriate quality
>>> level for the kernel.  It just looks pretty on the surface to people
>>> that are used to the kernel coding style.
>>>
>>> To highlight a few of the issues:
> [...]
>>> 2) The qcow2 code is a filesystem implemented in userspace.  Image
>>> formats are file systems.  It really should be reviewed by the
>>> filesystem maintainers. There is absolutely no attempt made to
>>> synchronize the metadata during write operations which means that
>>> you do not have crash consistency of the meta data.
>>>
>>> If you experience a power failure or kvm-tool crashs, your image
>>> will get corrupted.  I highly doubt a file system would ever be
>>> merged into Linux that was this naive about data integrity.
>>
>> The QCOW2 is lagging behind because we lost the main developer. It's
>> forced as read-only for the issues you mention. If you think it's a
>> merge blocker, we can drop it completely from the tree until the
>> issues are sorted out.
>>
>> I personally don't see the issue of having it as a read-only filesystem.
>>
>>> 3) The block probing code replicates a well known CVE from three
>>> years ago[1]. Using kvm-tool, a malicious guest could write the
>>> qcow2 signature to the zero sector and use that to attack the host.
>>
>> We don't support QCOW2 snapshots so I don't see how the "arbitrary
>> file" thing can happen.
>
> You don't need snapshots for the hole.
>
> Start with a clean read/write raw image.  Probing declares it raw.
> Guest writes QCOW signature to it, with a backing file of its choice.
>
> Restart with the same image.  Probing declares it QCOW2.  Guest can read
> the backing file.  Oops.

Thats an excellent scenario why you'd want to have 'Secure KVM' with
seccomp filters :)

I'm actually not sure why KVM tool got QCOW support in the first
place. You can have anything QCOW provides if you use btrfs (among
several other FSs).
