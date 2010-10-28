Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab0J1MAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:00:08 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:49920 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab0J1MAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:00:05 -0400
Message-ID: <4CC9647A.50108@collabora.co.uk>
Date: Thu, 28 Oct 2010 12:54:34 +0100
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        virtualization@lists.osdl.org
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk> <4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk> <4CBD7560.6080207@redhat.com> <4CC8226F.5080807@collabora.co.uk> <4CC94203.1080207@redhat.com>
In-Reply-To: <4CC94203.1080207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/10 10:27, Avi Kivity wrote:
> On 10/27/2010 03:00 PM, Ian Molton wrote:
>> On 19/10/10 11:39, Avi Kivity wrote:
>>> On 10/19/2010 12:31 PM, Ian Molton wrote:
>>
>>>>> 2. should start with a patch to the virtio-pci spec to document what
>>>>> you're doing
>>>>
>>>> Where can I find that spec?
>>>
>>> http://ozlabs.org/~rusty/virtio-spec/
>>
>> Ok, but I'm not patching that until theres been some review.
>
> Well, I like to review an implementation against a spec.

True, but then all that would prove is that I can write a spec to match 
the code.

The code is proof of concept. the kernel bit is pretty simple, but I'd 
like to get some idea of whether the rest of the code will be accepted 
given that theres not much point in having any one (or two) of these 
components exist without the other.

> Better, but still unsatisfying. If the server is busy, the caller would
> block. I guess it's expected since it's called from ->fsync(). I'm not
> sure whether that's the best interface, perhaps aio_writev is better.

The caller is intended to block as the host must perform GL rendering 
before allowing the guests process to continue.

The only real bottleneck is that processes will block trying to submit 
data if another process is performing rendering, but that will only be 
solved when the renderer is made multithreaded. The same would happen on 
a real GPU if it had only one queue too.

If you look at the host code, you can see that the data is already 
buffered per-process, in a pretty sensible way. if the renderer itself 
were made a seperate thread, then this problem magically disappears (the 
queuing code on the host is pretty fast).

In testing, the overhead of this was pretty small anyway. Running a few 
dozen glxgears and a copy of ioquake3 simultaneously on an intel video 
card managed the same framerate with the same CPU utilisation, both with 
the old code and the version I just posted. Contention during rendering 
just isn't much of an issue.

-Ian
