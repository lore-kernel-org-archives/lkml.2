Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab0GIVoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 17:44:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab0GIVoI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 17:44:08 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTilBnb85HRYDVXSGzct-zTuxW_o6tcZwHXTN4R6N@mail.gmail.com>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
	<AANLkTilBnb85HRYDVXSGzct-zTuxW_o6tcZwHXTN4R6N@mail.gmail.com>
Date: Fri, 9 Jul 2010 14:43:33 -0700
Message-ID: <AANLkTik9Jvi9GEq9jk1XDPsqOSy3dg2NAN1ExM-YPuQM@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 5, 2010 at 3:22 AM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>
> I'm facing some drm issue with -rc4, my x-windows is messed up and can
> not be used. I got floods of following messages, kernel config is
> attached. I have the same issue on -mmotm-rc3.

It looks like the first oops that causes this problem is missing. It
looks to me that the "scheduling while atomic" issue happens because
you had an oops in drm_fb_release->mutex_lock_nested->oops, and then
when that kills the process, we get that secondary "scheduling while
atomic" thing.

But I'd really like to see the first oops itself. It _looks_ like it
should be a page fault with this backtrace:

> [   34.532219]  [<ffffffffa0023e39>] ? drm_fb_release+0x2f/0x7e [drm]
> [   34.532222]  [<ffffffff8127be8a>] ? __list_add+0x3f/0x81
> [   34.532225]  [<ffffffff814fa4e0>] __mutex_lock_common+0x131/0x461
> [   34.532233]  [<ffffffffa0023e39>] ? drm_fb_release+0x2f/0x7e [drm]
> [   34.532239]  [<ffffffffa001b104>] ? drm_release+0x2bd/0x63e [drm]
> [   34.532242]  [<ffffffff814fa8c5>] mutex_lock_nested+0x39/0x3e
> [   34.532250]  [<ffffffffa0023e39>] drm_fb_release+0x2f/0x7e [drm]
> [   34.532257]  [<ffffffffa001b1da>] drm_release+0x393/0x63e [drm]
> [   34.532259]  [<ffffffff8111a636>] fput+0x135/0x1e2
> [   34.532262]  [<ffffffff811177e5>] filp_close+0x68/0x72
> [   34.532265]  [<ffffffff811178cb>] sys_close+0xdc/0x116
> [   34.532268]  [<ffffffff81009cc2>] system_call_fastpath+0x16/0x1b

but I'd like to see the actual register state etc from the oops too.

And if it all scrolls away so quickly that you can't see it, then I
suspect we need some help in the form of a bisection or something. Was
2.6.35-rc3 fine for you? If so, it should bisect pretty well - there's
only a few hundred commits, so you should be able to do it in eight or
nine recompiles.

                   Linus
