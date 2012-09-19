Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2ISV1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 17:27:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2ISV1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 17:27:40 -0400
Date: Wed, 19 Sep 2012 14:27:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.6rc6 slab corruption.
In-Reply-To: <CA+55aFwuO_8Wy6C7rALajiK2Pro84BrfzmKHpARx4EfG8qNMhw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1209191340410.6273@chino.kir.corp.google.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918185310.GA27689@redhat.com> <5059D015.2020104@linux.vnet.ibm.com>
 <CA+55aFwuO_8Wy6C7rALajiK2Pro84BrfzmKHpARx4EfG8qNMhw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012, Linus Torvalds wrote:

> > Create a 350 processes reading /sys/kernel/debug/kvm/spinlocks/histo_blocked
> > file simultaneously in while loop for more than 3 hours on my box.
> 
> You need to open the file a single time, and then after that sinelg
> open (either threaded or with fork()) do multiple concurrent copies
> something like
> 
>    for (;;) {
>       char buf[1024];
>       lseek(fd, 0, SEEK_SET);

These are non-seekable files, so this will always fail.  That makes the 
race much more difficult to trigger: the read needs to call 
u32_array_read() with both threads finding *ppos == 0 and then race 
between the kfree() and resetting of file->private_data pointer.

 [ I'm surprised that Dave was able to trigger this so often that he has 
   800MB of log. ]

Anyway, I instrumented the kernel to open the race by sleeping after 
checking *ppos == 0 and immediately after the kfree() and I could 
reproduce the issue but with a "Object already free" error rather than a 
redzoning error.

I assumed this was because Dave didn't have a certain slub debug option 
enabled or redzoning was checked before double-free, but it turns out this 
should always be caught first.  For some reason the freed object is not 
being found on the partial slab's freelist.

>       read(fd, buf, sizeof(buf));
>    }
> 
> or similar. But it's important that they all share the same struct file.
> 
> It's also likely to make it easier to trigger the race if you have a
> kernel with preemption enabled.
> 
> And you need to have SLAB debugging enabled to actually *see* the
> messages. Otherwise you'll have just (possibly silent) corruption or a
> memory leak.
