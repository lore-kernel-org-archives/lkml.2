Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031256Ab2CFVD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:03:28 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60287 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031113Ab2CFVDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <1331064368-55675-1-git-send-email-avagin@openvz.org>
References: <CAPXgP10GRZ6Y3+dtNSw5zQMaM9FnSBBfLrCJmQ948gA3tALtfw@mail.gmail.com>
 <1331064368-55675-1-git-send-email-avagin@openvz.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 6 Mar 2012 22:03:05 +0100
Message-ID: <CAPXgP10qwPn2-QeyPpDy3GiEqvU6jB-wVuUOUXwcGBvOWOUA1Q@mail.gmail.com>
Subject: Re: [PATCH] uevent: send events in correct order according to seqnum
To: Andrew Vagin <avagin@openvz.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 21:06, Andrew Vagin <avagin@openvz.org> wrote:
>
> The queue handling in the udev daemon assumes that the events are
> ordered.
>
> Before this patch uevent_seqnum is incremented under sequence_lock,
> than an event is send uner uevent_sock_mutex. I want to say that code
> contained a window between incrementing seqnum and sending an event.
>
> This patch locks uevent_sock_mutex before incrementing uevent_seqnum.

I think we can remove the spin_lock(&sequence_lock); entirely now, right?

Also the section with:
  seq = ++uevent_seqnum;
can just be:
  add_uevent_var(env, "SEQNUM=%llu", (unsigned long long) ++uevent_seqnum);
right?

And the:
  mutex_lock(&uevent_sock_mutex);
can just move outside of the _NET ifdef and we always use the mutex
instead of the spinlock?

That could look much simpler than the current code, I think.

Thanks,
Kay
