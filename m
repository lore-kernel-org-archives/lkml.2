Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966074Ab1KJDvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:51:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44162 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935370Ab1KJDvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:51:02 -0500
Message-ID: <4EBB4A21.20707@codemonkey.ws>
Date: Wed, 09 Nov 2011 21:50:57 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 03:38 AM, Pekka Enberg wrote:
> Hi Linus,
>
> Please consider pulling the latest KVM tool tree from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool/for-linus
>

[snip]

> tools/kvm/virtio/net.c | 423 ++++++++
> tools/kvm/virtio/pci.c | 319 ++++++
> tools/kvm/virtio/rng.c | 185 ++++
> 186 files changed, 19071 insertions(+), 179 deletions(-)

So let's assume for a moment that a tool like this should live in the kernel. 
What's disturbing about a PULL request like this is the lack of reviewability of 
it and the lack of any real review from people that understand what's going on 
in this code base.

There are no Acked-by's by people that really understand what the code is doing 
or that have domain expertise in filesystems and networking.

There are major functionality short comings in this code base, data corruptors, 
and CVEs.  I'm not saying that the kvm-tool developers are bad developers, but 
the code is not at the appropriate quality level for the kernel.  It just looks 
pretty on the surface to people that are used to the kernel coding style.

To highlight a few of the issues:

1) The RTC emulation is limited to emulating CMOS and only the few fields used 
to store the date and time.  If code is added to arch/x86 that tries to make use 
of a CMOS field for something useful, kvm-tool is going to fall over.

None of the register A/B/C logic is implemented and none of the timer logic is 
implemented.  I imagine this requires kernel command line hackery to keep the 
kernel from throwing up.

If a kernel change that works on bare metal but breaks kvm-tool because kvm-tool 
is incomplete is committed, is that a regression that requires reverting the 
change in arch/x86?

2) The qcow2 code is a filesystem implemented in userspace.  Image formats are 
file systems.  It really should be reviewed by the filesystem maintainers. 
There is absolutely no attempt made to synchronize the metadata during write 
operations which means that you do not have crash consistency of the meta data.

If you experience a power failure or kvm-tool crashs, your image will get 
corrupted.  I highly doubt a file system would ever be merged into Linux that 
was this naive about data integrity.

3) The block probing code replicates a well known CVE from three years ago[1]. 
Using kvm-tool, a malicious guest could write the qcow2 signature to the zero 
sector and use that to attack the host.

I found these three issues in the course of about 30 seconds of looking through 
the kvm-tool code.  I'm sure if other people with expertise in these areas 
looked through the code, they would find a lot more issues.  I'm sure I could 
find many, many more issues.

This is really the problem with the tools/kvm approach.  It circumvents the 
normal review process in the kernel because the kernel maintainer structure is 
not equipped to properly review userspace code in tools.  This is a tool with 
data integrity and security implications.  It is not a pretty printing routine 
or a test case.

While I think it's a neat and potentially useful project, I think long before we 
get to the point where we discuss merging it into the kernel, the code quality 
has to improve considerably.

[1] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2008-2004

Regards,

Anthony Liguori
