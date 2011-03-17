Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1CQXeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:34:03 -0400
Received: from mailout11.t-online.de ([194.25.134.85]:60404 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab1CQXeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:34:01 -0400
Message-ID: <4D829A48.7020408@t-online.de>
Date: Fri, 18 Mar 2011 00:33:28 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Chris Wilson <chris@chris-wilson.co.uk>, jesse.barnes@intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?David_M=FCller?= <d.mueller@elsoft.ch>
Subject: Re: [BUG][2.6.38] IRQ Lock Inversion / i915 fails
References: <4D81D6F9.3040304@t-online.de> <AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com>
In-Reply-To: <AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: Z4K4wUZAQhja4egGjlsdGfxEbx-XSE9Z7dzG+IqH4i+-HVI2lh4sRI8LR-Xd44rZ4l
X-TOI-MSGID: 53f51a94-3cdb-47d0-9b08-52f52dbefd7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.03.2011 17:55, schrieb Linus Torvalds:
>
> Ok, so the lock inversion seems to be due to the sound/drivers/aloop.c
> file, where the function "loopback_pos_update()" gets called from
> within a softirq context. And it takes a lock (cable->lock) that is
> also taken unprotected by loopback_trigger(). So that's liable to
> deadlock as per lockdep. Jaroslav? Takashi?
Takashi Iwai already gave a solution for the irq inversion problem.

> The X problem seems to be something unrelated. You have those "GPU
> hung" messages, along with i2c/EDID problems. But the actual oops is
> at the very beginning of intel_release_load_detect_pipe(), here:
>
>    0:	55                   	push   %ebp
>    1:	89 e5                	mov    %esp,%ebp
>    3:	57                   	push   %edi
>    4:	89 cf                	mov    %ecx,%edi
>    6:	56                   	push   %esi
>    7:	53                   	push   %ebx
>    8:	89 c3                	mov    %eax,%ebx
>    a:	83 ec 0c             	sub    $0xc,%esp
>    d:	8b 00                	mov    (%eax),%eax
>    f:	8b 73 20             	mov    0x20(%ebx),%esi
>   12:	80 7b 30 00          	cmpb   $0x0,0x30(%ebx)
>   16:	8b 4b 28             	mov    0x28(%ebx),%ecx
>   19:	89 45 f0             	mov    %eax,-0x10(%ebp)
>   1c:*	8b 86 e0 01 00 00    	mov    0x1e0(%esi),%eax     <-- trapping
> instruction
>   22:	89 45 ec             	mov    %eax,-0x14(%ebp)
>   25:	74 2d                	je     0x54
>   27:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
>   2e:	89 f0                	mov    %esi,%eax
>
> where %esi is NULL. I think that is the "crtc->helper_private" load,
> and crtc is NULL.
>
> That code does look broken. The very same function explicitly sets
> crtc to NULL, so clearly it _can_ be NULL. That said, this is all old
> code. I suspect the thing that made it start trigger may be commit
> f5afcd3dd0dc ("drm/i915/crt: Check for a analog monitor in case of
> DVI-I"), which is the only real change to the crt_detect logic I can
> see.
>
Well, I think there are two i915 problems that are independent.

The i2c/edid thing might be related to the f5a...commit, but reverting
that commit alone does not help. i2c/edid error messages might be before
or after the "gpu hung" problem, Xorg seems to be able to cope with that.
But after a gpu lockup it's time to reboot.

If nobody has a better idea I'll try to bisect ... tomorrow.

cu,
 Knut
