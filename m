Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab1KWHj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:39:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42789 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab1KWHj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAFQmdRYTgQOb53kQOvk1jubZbvaOrfjVCq4aG1H0ceshw2vVPA@mail.gmail.com>
References: <20111123033850.GA11380@redhat.com>
	<CAFQmdRYTgQOb53kQOvk1jubZbvaOrfjVCq4aG1H0ceshw2vVPA@mail.gmail.com>
Date: Wed, 23 Nov 2011 15:39:57 +0800
Message-ID: <CAM_iQpVONaS8hA7Be-FkqdDJCbt2sx_p1sX64nMbMpY5RyCdiA@mail.gmail.com>
Subject: Re: tty related lockdep trace during bootup on 3.2-rc2
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 3:28 PM, Havard Skinnemoen
<hskinnemoen@google.com> wrote:
> On Tue, Nov 22, 2011 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
>> From Linus' current tree...
>>
>> related to 5dc2470c602da8851907ec18942cd876c3b4ecc1 maybe ?
>
> Yes, probably. I did have a bad feeling about the locking, but it
> seemed to behave well during testing. Wonder why I didn't see this.
>
> So what's happening is that tty_open() holds big_tty_mutex while
> calling acm_tty_open which takes open_lock, and acm_tty_close holds
> open_lock while calling tty_port_close_start which takes
> big_tty_mutex?

Yes, exactly.

>
> Not sure how to solve this. Not taking the lock before calling
> tty_port_close_start means the tty_port may get freed before it
> returns.

But...

static void acm_tty_hangup(struct tty_struct *tty)
{
        struct acm *acm = tty->driver_data;
        tty_port_hangup(&acm->port); //<---------------- No open_mutex
protected neither...
        mutex_lock(&open_mutex);
        acm_port_down(acm);
        mutex_unlock(&open_mutex);
}
