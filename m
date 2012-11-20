Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2KTOkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:40:08 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59143 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTOkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:40:06 -0500
MIME-Version: 1.0
In-Reply-To: <1353090754-30233-1-git-send-email-ajax@redhat.com>
References: <1353090754-30233-1-git-send-email-ajax@redhat.com>
Date: Tue, 20 Nov 2012 09:40:05 -0500
Message-ID: <CA+5PVA54A3xcOyrm5GCMj3jE_338=eVFFBGFE61zLpNrh__imA@mail.gmail.com>
Subject: Re: [PATCH] vt: Drop K_OFF for VC_MUTE
From: Josh Boyer <jwboyer@gmail.com>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arthur Taylor <art@ified.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 1:32 PM, Adam Jackson <ajax@redhat.com> wrote:
> The "don't enqueue stuff" semantics of K_OFF shouldn't be a function of
> the keyboard map state; we should be able to switch among cooked/raw/
> unicode without changing whether events are delivered.  Otherwise - if
> changing to K_UNICODE undoes K_OFF - then suddenly Alt-F2 under
> Gnome will switch VT instead of summoning the "run command" dialog.
>
> Drop the K_OFF handling and replace it with a new "mute" ioctl pair.
> Anybody using K_OFF would already need to be prepared to handle it
> throwing -EINVAL for old kernel compatibility, so userspace will degrade
> gracefully.
>
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=859485
> Cc: Arthur Taylor <art@ified.ca>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Tested-by: Josh Boyer <jwboyer@redhat.com>
> Signed-off-by: Adam Jackson <ajax@redhat.com>

Well, I tested a build with this patch so the tested-by is accurate.
It fixes the problem when it builds.  But...

> diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> index 681765b..08d1d57 100644
> --- a/drivers/tty/vt/keyboard.c
> +++ b/drivers/tty/vt/keyboard.c

<snip>

> +int vt_do_kgdbmute(int console)
> +{
> +       struct kbd_struct * kbd = kbd_table + console;
> +       /* This is a spot read so needs no locking */
> +       return vc_kbd_mode(kbd, VC_MUTE);
> +}
> +

That should be vt_do_kdgkbmute.  I know kgdb is probably easier to type
because 'gdb' is ingrained into every developer's finger memory, but the
kernel gets really grumpy when function definitions don't match what
callers actually call:

drivers/built-in.o: In function `vt_ioctl':
/home/jwboyer/kernel/drivers/tty/vt/vt_ioctl.c:489: undefined
reference to `vt_do_kdgkbmute'


After that small fixup, the patch does build and does still fix the
problem with a properly fixed up Xorg.

josh
