Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1JaGDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:03:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab1JaGDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:03:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=issYpN73KXwFoLX7fRqDIFeaMtks0/UUMIsDs+I3gprpPFAb6dMDZdDweOuRAb/+P
	XwRVhfLiSfXDYWjEJpoQw==
MIME-Version: 1.0
In-Reply-To: <4EAD360D.6010004@gmail.com>
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org>
	<4EAC0C18.5090602@gmail.com>
	<CAEYUcX1PUgniJLqYXKM5pf_9T06OPFg4q0ZUCFc8Deu1J_R9-A@mail.gmail.com>
	<4EAD360D.6010004@gmail.com>
Date: Sun, 30 Oct 2011 23:03:27 -0700
X-Google-Sender-Auth: FcKTaTD3ZTxrNu8ori6nCcZv7io
Message-ID: <CAEYUcX2yF1hw=D8XHMGE7p4Tty+G-vmVudNsFHXUOSTGGKoq=w@mail.gmail.com>
Subject: Re: [PATCH] ramoops appears geared to not support ARM
From: Bryan Freed <bfreed@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, msb@chromium.org,
        seiji.aguchi@hds.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 4:33 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
>
> Il 30/10/2011 03:07, Bryan Freed ha scritto:
>>
>> Right, and that is what I do to get ARM working.  The reserve() function
>> calls memblock_reserve() to reserve the memory for RAMOOPS.  Keeping it
>> part of main memory (by not using memblock_remove()) gets the memory
>> properly mapped.
>>
>
> According to Russell, it needs to use memblock_remove to exclude that piece of memory.
>
>> The problem I think we need to resolve is that this makes the ramoops
>> driver messy.
>
> I agree. Indeed I think we don't need to do anything in the driver. The problem is only how to exclude a piece of memory from kernel main memory view. For x86 it's trivial, for ARM it doesn't, but it's still possible.
>
> Marco

I will give that (using mem_remove()) a shot tomorrow.
My recollection on using it in last week's investigation showed the
ramoops driver ioremap() giving a mapping that did not correspond with
what the /dev/mem expected to see.  I vaguely recall /dev/mem was
effectively calling __va(0x02000000) which added a base address of
0xc0000000 giving 0xc2000000 as the resulting virtual address.  The
ramoops ioremap(), however, gave some arbitrary virtual address for
this memory.
The result was that using /dev/mem to read 0x02000000 caused a panic.

Another problem was that removing just 512KiB of memory for ramoops
screwed up the system memory initialization.  It appeared to me that
the ARM memory code expected sections to be 1MiB aligned.  I could
memblock_reserve anything, but I could only memblock_remove on a 1MiB
boundary.

And I cannot shake the feeling that we have a fairly simple disconnect
here.  Ramoops expects to use _device_ memory because it uses
ioremap().  But the buffer itself is accessed through /dev/mem which
(as we use it with no mmap() calls) expects to give access to _system_
memory.
It seems this disconnect could be removed if we provided a
/sys/class/ramoops/buffer file that an application could read instead
of having to rely on /dev/mem.

Marco, what is your opinion on that?

bryan.
