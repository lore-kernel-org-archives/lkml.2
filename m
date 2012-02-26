Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab2BZNLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 08:11:08 -0500
Received: from mail1.windriver.com ([147.11.146.13]:36284 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2BZNLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 08:11:06 -0500
Message-ID: <4F4A2F60.1060700@windriver.com>
Date: Sun, 26 Feb 2012 07:10:56 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andrei Warkentin <andreiw@vmware.com>
CC: <kgdb-bugreport@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
References: <1329522773-21359-1-git-send-email-andreiw@vmware.com>
In-Reply-To: <1329522773-21359-1-git-send-email-andreiw@vmware.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 05:52 PM, Andrei Warkentin wrote:
> This fixes the following problems:
> 1) Typematic-repeat of 'enter' gives warning message.
> 2) Use of 'keypad enter' gives warning message.
> 3) Lag on the order of seconds between "break" and "make" when
>    expecting the enter "break" code. Seen under virtualized
>    environments such as VMware ESX.
> 
> Explanations:
> 1) Holding down 'enter' will not set a repeating sequence
>    of 0x1c(make)-0x9c(make), but a repeating sequence
>    of make codes, followed by one break code when the key
>    is released. Thus, it's wrong to expect the break code
>    after seeing the 'enter' make code.
> 2) Keypad enter generates different make/break, namely
>    0xe0 0x1c and 0xe0 0x9c. The 'generic' logic handles
>    the 0xe0 escape already, but the special 'enter' logic
>    always expects '0x9c' and not '0xe0 0x9c', so you get
>    a warning message, again.
> 3) When expecting the 'enter' break code, the code polls
>    the status register in a tight loop, like so -
>    >  while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0);
> 
>    However, it really should do something like -
>    >  while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
>    >     cpu_relax(); /* pause */
> 
>    Basically, it's a common optimization to have a fast
>    path for accessing often accessed and slow changing I/O
>    in a virtualized environment. The tight spinning in KDB
>    seems to run against the logic by ESX keyboard virtualization
>    code to detect when the fast path or the slow path should
>    be used to satisfy the keyboard status read, leading to
>    multi-second timeouts before the 'real' status comes through.
>    Without knowing ESX internals, it's hard to say if this is
>    an ESX bug or not, but letting the VM be explicitely descheduled
>    seems to resolve the problem. I've seen something similar with
>    shared MMIO buffers with VMs on Hyper-V.
> 
>    Anyway, given (3), (2) and (1), we might as well blow away the
>    entire special casing for 'enter'. The break codes will already
>    be handled correctly, and we get rid of the bugs with repeat
>    enters and keypad enter key. And of course, there is no
>    need to AND with 0x7f when checking for 'enter', because we'll
>    never ever get to this code with a break code (checked for much
>    earlier).
> 
>    I tried to figure out the history behind the 'enter' key special
>    casing code, and it seems to have come from whatever the original
>    KDB patch was. Perhaps someone can chime in.
> 


I did not write the original code, but I can explain why there was some special logic.

When you restore the system back to the running state you do not want to send any other key scan codes back to the kernel.  The idea being that you type "go" and press enter to resume kernel execution.  At that point you do not want to send a random scan code back to the kernel, ideally you want to leave everything as it was.  This also handled the case where there was a PS/2 style mouse attached.

I do have a question about part of the section you deleted.


> Tested on ESX 5.0 and QEMU.
> 
> Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
> ---
>  kernel/debug/kdb/kdb_keyboard.c |   28 +---------------------------
>  1 files changed, 1 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
> index 4bca634..ed4a2f9 100644
> --- a/kernel/debug/kdb/kdb_keyboard.c
> +++ b/kernel/debug/kdb/kdb_keyboard.c
> @@ -178,34 +178,8 @@ int kdb_get_kbd_char(void)
>  		return -1;	/* ignore unprintables */
>  	}
>  
> -	if ((scancode & 0x7f) == 0x1c) {
> -		/*
> -		 * enter key.  All done.  Absorb the release scancode.
> -		 */
> -		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
> -			;

Seems there is a bug here.  There is a cpu_relax() missing.

> -
> -		/*
> -		 * Fetch the scancode
> -		 */
> -		scancode = inb(KBD_DATA_REG);
> -		scanstatus = inb(KBD_STATUS_REG);
> -
> -		while (scanstatus & KBD_STAT_MOUSE_OBF) {

There should also be a cpu_relax() right here.

> -			scancode = inb(KBD_DATA_REG);
> -			scanstatus = inb(KBD_STATUS_REG);
> -		}
> -


If you put the two cpu_relax() pieces in do you still end up with a problem?  If this does not work for you the possibility to exists to clear the keyboard/mouse state on the kdb exit.

Thanks,
Jason.
