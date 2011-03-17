Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1CQQ4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:56:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab1CQQ4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:56:38 -0400
MIME-Version: 1.0
In-Reply-To: <4D81D6F9.3040304@t-online.de>
References: <4D81D6F9.3040304@t-online.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Mar 2011 09:55:47 -0700
Message-ID: <AANLkTim=R7GVDY0Nt-6q1mjO3vas-qRy7=VxqgWWtz_s@mail.gmail.com>
Subject: Re: [BUG][2.6.38] IRQ Lock Inversion / i915 fails
To: Knut Petersen <Knut_Petersen@t-online.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, jesse.barnes@intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?David_M=FCller?= <d.mueller@elsoft.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 2:40 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
>
> Well, I updated my test partition to opensuse 11.4.
>
> The opensuse standard kernel is unusable for me, booting hangs
> most of the time, the same is true for shutdown. If booting succeeds the
> system will fail after a short time of usage.
>
> So I installed kernel 2.6.38.  That helped a lot ... for a few minutes.
>
> A possible irq lock inversion is detected during boot, after a short time
> X fails, restarting the X server does not work, a reboot is necessary.

Ok, so the lock inversion seems to be due to the sound/drivers/aloop.c
file, where the function "loopback_pos_update()" gets called from
within a softirq context. And it takes a lock (cable->lock) that is
also taken unprotected by loopback_trigger(). So that's liable to
deadlock as per lockdep. Jaroslav? Takashi?

The X problem seems to be something unrelated. You have those "GPU
hung" messages, along with i2c/EDID problems. But the actual oops is
at the very beginning of intel_release_load_detect_pipe(), here:

   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	89 cf                	mov    %ecx,%edi
   6:	56                   	push   %esi
   7:	53                   	push   %ebx
   8:	89 c3                	mov    %eax,%ebx
   a:	83 ec 0c             	sub    $0xc,%esp
   d:	8b 00                	mov    (%eax),%eax
   f:	8b 73 20             	mov    0x20(%ebx),%esi
  12:	80 7b 30 00          	cmpb   $0x0,0x30(%ebx)
  16:	8b 4b 28             	mov    0x28(%ebx),%ecx
  19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1c:*	8b 86 e0 01 00 00    	mov    0x1e0(%esi),%eax     <-- trapping
instruction
  22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  25:	74 2d                	je     0x54
  27:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  2e:	89 f0                	mov    %esi,%eax

where %esi is NULL. I think that is the "crtc->helper_private" load,
and crtc is NULL.

That code does look broken. The very same function explicitly sets
crtc to NULL, so clearly it _can_ be NULL. That said, this is all old
code. I suspect the thing that made it start trigger may be commit
f5afcd3dd0dc ("drm/i915/crt: Check for a analog monitor in case of
DVI-I"), which is the only real change to the crt_detect logic I can
see.

Jesse? Chris? Ideas?

                            Linus
