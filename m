Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1GGX1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 19:27:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1GGX1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 19:27:38 -0400
Date: Thu, 7 Jul 2011 16:27:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergiu Iordache <sergiu@google.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 3/3] char drivers: ramoops debugfs entry
Message-Id: <20110707162727.f361f053.akpm@linux-foundation.org>
In-Reply-To: <CAGDaqBT13wsz3AWbLy7_STT2_EY1O6w3h_bc2bFYhrLMQobefw@mail.gmail.com>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
	<1309994990-4729-4-git-send-email-sergiu@chromium.org>
	<20110707130130.8dd02f01.akpm@linux-foundation.org>
	<CAGDaqBQMp0xyBF7Z=P5qBqNcceG3JfWNEUX=T=yMZH74UP5kxA@mail.gmail.com>
	<20110707155426.fd95445f.akpm@linux-foundation.org>
	<CAGDaqBT13wsz3AWbLy7_STT2_EY1O6w3h_bc2bFYhrLMQobefw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 16:16:43 -0700
Sergiu Iordache <sergiu@google.com> wrote:

> Ramoops currently dumps the log of a panic/oops in a memory area which
> is known not to be overwritten on restart (for example 1MB starting at
> 15MB). The way it works is by dividing the memory area in records of a
> set size (fixed at 4K before my patches, configurable after) and by
> dumping a record there for each oops/panic. The problem is that right
> now you have to access that memory area through other means, such as
> /dev/mem, which is not always possible.
> 
> What my patch did was to add a debugfs entry which returns a valid
> record each time (a single dump done by ramoops). The first call
> returns the first dump. The first call after the last valid dump
> returns an empty buffer. .

Please fully describe this "record" in the v2 patch changelog.  We'll
want to review it for endianness, 32/64-bit compat issues,
maintainability, extensibility, etc.

> After it has returned nothing, the next
> calls return records from the start again.

That sounds a bit weird.  One would expect it to keep returning zero,
requiring userspace to lseek or close/open.

> The validity of a dump is
> checked by looking after the header. Any comments on this approach are
> welcome.
> 
> Changing the entry from debugfs to sysfs wouldn't be a problem. If
> sysfs is a valid solution I'll come with a patch that updates the
> documentation as well along with the sysfs entry.

sysfs sounds OK to me.  Then again, sysfs is supposed to be
one-value-per-file, so using it would be naughty.

I dunno, I'd be inclined to abuse the sysfs rule and hope that nobody
notices rather than create a fake char device.  But there's certainly
plenty of precedent for the fake char driver.


