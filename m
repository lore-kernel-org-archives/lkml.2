Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab2ISRKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:10:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50809 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2ISRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:10:07 -0400
MIME-Version: 1.0
In-Reply-To: <5059D015.2020104@linux.vnet.ibm.com>
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com>
 <20120918185310.GA27689@redhat.com> <5059D015.2020104@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Sep 2012 10:09:45 -0700
X-Google-Sender-Auth: lLMVrLyufMdcCoKRK7GdHIBmeRA
Message-ID: <CA+55aFwuO_8Wy6C7rALajiK2Pro84BrfzmKHpARx4EfG8qNMhw@mail.gmail.com>
Subject: Re: 3.6rc6 slab corruption.
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 7:00 AM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
>
> Create a 350 processes reading /sys/kernel/debug/kvm/spinlocks/histo_blocked
> file simultaneously in while loop for more than 3 hours on my box.

You need to open the file a single time, and then after that sinelg
open (either threaded or with fork()) do multiple concurrent copies
something like

   for (;;) {
      char buf[1024];
      lseek(fd, 0, SEEK_SET);
      read(fd, buf, sizeof(buf));
   }

or similar. But it's important that they all share the same struct file.

It's also likely to make it easier to trigger the race if you have a
kernel with preemption enabled.

And you need to have SLAB debugging enabled to actually *see* the
messages. Otherwise you'll have just (possibly silent) corruption or a
memory leak.

              Linus
