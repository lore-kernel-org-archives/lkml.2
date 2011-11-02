Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1KBJoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:44:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38164 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1KBJoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <20111030201618.GA7696@google.com>
References: <20110806121247.GC23937@htj.dyndns.org>
	<20111030044821.GA23741@spacedout.fries.net>
	<20111030201618.GA7696@google.com>
Date: Wed, 2 Nov 2011 18:44:31 +0900
Message-ID: <CAJ0PZbSRX6Rqn5NnnMkVGrPovtSuc2NWasysOYnjr3j9rON1VQ@mail.gmail.com>
Subject: Re: [linux-pm] hiberante hangs TCP Re: [EXAMPLE CODE] Parasite thread
 injection and TCP connection hijacking
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Fries <david@fries.net>, netdev@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 5:16 AM, Tejun Heo <tj@kernel.org> wrote:
> (cc'ing Rafael and linux-pm)
>
> On Sat, Oct 29, 2011 at 11:48:21PM -0500, David Fries wrote:
>> I saw the write up on this on lwn.net, pretty creative by the way, and
>> it got me thinking about a different checkpoint/restart problem I've
>> been running into.  Specifically in hibernating to disk.  In the
>> hibernate case active TCP connections hang after resuming, while an
>> idle TCP connection will continue after the system is back up.  My
>> observation is the kernel checkpoints itself to memory, enables
>> devices, writes out that checkpoint image to storage, then powers off.
>> The problem is if TCP packets are received while writing to storage,
>> the kernel will continue to queue and ack those TCP packets, but the
>> running kernel and it's network state is shortly lost.  When the
>> computer resumes, those TCP byte sequences hang the TCP connection for
>> an extended period of time while the resumed computer refuses to
>> acknowledge the data that was received after checkpointing and the now
>> running kernel knew nothing about, and the other computer tries in
>> vain to resend any data that hadn't yet been acknowledged, which is
>> always after the data that was lost, until one of them eventually
>> gives up.
>>
>> I've been wondering if it was safe or possible to leave any network
>> interfaces down after the checkpoint, or what the right solution would
>> be.  I didn't think marking every TCP connection with a ZOMBIE_KERNEL
>> bit just after the kernel checkpoint (for the kernel is walking dead
>> and won't remember anything that happens), and then prevent any TCP
>> acks from being sent for those connections would be the right
>> solution.  I've taken to unplugging the physical lan cable,
>> hibernating to disk, and plugging it back in after the system is down,
>> to avoid the problem.  Any ideas?
>
> Hmmm... sounds like taking down network interfaces before starting
> hibernation sequence should be enough, which shouldn't be too
> difficult to implement from userland.  Rafael, what do you think?
>
> Thanks.

Um... it seems that the "thaw" callbacks of network interfaces or TCP
should do something on this.

Probably, the "thaw" callbacks should make sure that the TCP
connections are closed?



Cheers,
MyungJoo


>
> --
> tejun
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
