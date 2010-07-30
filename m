Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab0G3DyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 23:54:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61308 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0G3DyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 23:54:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=U8RK1hWS2NCEXoAOFfsILx1rOR6GYsAPPjdPS8VyR29Z0YY9sTsoEkCjcIsTwTReW
	/7JvEACxjEWoArz+vibMg==
MIME-Version: 1.0
In-Reply-To: <201007300129.33912.rjw@sisk.pl>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<201007300129.33912.rjw@sisk.pl>
Date: Thu, 29 Jul 2010 20:54:05 -0700
Message-ID: <AANLkTikG+UJrfORXMXfFnZ6_BJEDz3E5+k_SZHSE0epU@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Hugh Dickins <hughd@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 4:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, July 29, 2010, Hugh Dickins wrote:
>>
>> Despite reading Documentation/power/freezing-of-tasks.txt, I have no
>> clear idea of what really needs freezing, and whether freezing can
>> fully handle the issues.  Rafael, please can you advise?
>
> Well, the rule of thumb (if it can be called this way) is that the contents of
> the image has to be consistent with whatever is stored in permanent storage.
> So, for example, filesystems that were mounted before creating the image
> cannot be modified until the image is restored.  Consequently, if there are
> any kernel threads that might cause that to happen, they need to be frozen.

Right, the filesystem part of it is easy to understand and to handle, I think.
But now we're worrying about potential for I/O to be interrupted by suspend
to RAM (or is that well handled by driver suspend methods?), and swap
getting misallocated during hibernation: what measures do we have
to prevent those?

In particular, is there or should there be some state global or test function
endangered code could use to for protection, without having to freeze?
For many threads, freezing would be easiest, but not possible for all.

>
> Now, if I understand it correctly, the failure mode is that certain page had
> been swapped out before the image was created and then it was swapped in
> while we were writing the image out and the slot occupied by it was re-used.

Not quite.  At some point in the past that certain page had been swapped out
and later swapped back in: it's correctly there in the image as swapped in,
but there's some code coming into play when allocating swap to write the
image, that might free its swap and reuse it for an unrelated page of image,
leaving a danger after resume that the original owner page might get freed
then wrong data swapped back in for it later.

> In that case the image would contain wrong information on the state of the
> swap and that would result in wrong data being loaded into memory on an attempt
> to swap that page in after resume.

Yes.

>
> So, generally, we have to avoid doing things that would result in swapping
> memory pages out after we have created a hibernation image.  If that can be
> achieved by freezing certain kernel threads, that probably is the simplest
> approach.

The vulnerable page isn't swapped out or in during or after creating the image,
yet it can still be vulnerable.  KAMEZAWA-san's patch should fix the recent
regression here, but I believe there remains a vulnerability, from swap cleanup
code in vmscan.c which page reclaim might pass through.  If there's some
"heading for hibernation" state we can test there, we can avoid it in those
cases.

I realize that snapshot.c does a lot of preparatory memory freeing e.g.
shrink_all_memory(), and that should make the chance of mis-reuse of
swap very tiny; but nonetheless your swap.c is doing memory allocations,
with the __GFP_WAIT flag, so could conceivably enter page reclaim.

We cannot freeze the hibernation, but we ought to make it swap-safe.

Hugh
