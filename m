Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab2B0BB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 20:01:29 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:59279 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250Ab2B0BB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 20:01:28 -0500
Date: Sun, 26 Feb 2012 17:01:28 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>
Message-ID: <106764274.1567181.1330304488097.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F4A2F60.1060700@windriver.com>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Thank you for the review. Comments inline.

----- Original Message -----
> From: "Jason Wessel" <jason.wessel@windriver.com>
> To: "Andrei Warkentin" <andreiw@vmware.com>
> Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
> Sent: Sunday, February 26, 2012 8:10:56 AM
> Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
> 
> I did not write the original code, but I can explain why there was
> some special logic.
> 
> When you restore the system back to the running state you do not want
> to send any other key scan codes back to the kernel.  The idea being
> that you type "go" and press enter to resume kernel execution.  At
> that point you do not want to send a random scan code back to the
> kernel, ideally you want to leave everything as it was.  This also
> handled the case where there was a PS/2 style mouse attached.

The input device is already reset on kdb exit to a safe state, however, by the
code inside kgdboc_post_exp_handler, which calls kgdboc_restore_input().

The existing logic also already correctly will handle the case of a PS/2 mouse, i.e.:

        /*
         * Ignore mouse events.
         */
        if (scanstatus & KBD_STAT_MOUSE_OBF)
                return -1;

...so there is nothing that the non-ENTER-specific code already doesn't deal with.
That special ENTER code also doesn't correctly handle typematic repeat, nor does it handle
key-pad enter (as I mentioned before in the patch description, this has a different
make and break codes, prefixed with 0xe0).

> 
> I do have a question about part of the section you deleted.
> 
> 
> > -	if ((scancode & 0x7f) == 0x1c) {
> > -		/*
> > -		 * enter key.  All done.  Absorb the release scancode.
> > -		 */
> > -		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
> > -			;
> 
> Seems there is a bug here.  There is a cpu_relax() missing.

Right, that's exactly what I said in the patch :-).

> 
> > -
> > -		/*
> > -		 * Fetch the scancode
> > -		 */
> > -		scancode = inb(KBD_DATA_REG);
> > -		scanstatus = inb(KBD_STATUS_REG);
> > -
> > -		while (scanstatus & KBD_STAT_MOUSE_OBF) {
> 
> There should also be a cpu_relax() right here.

Correct.

> 
> > -			scancode = inb(KBD_DATA_REG);
> > -			scanstatus = inb(KBD_STATUS_REG);
> > -		}
> > -
> 
> 
> If you put the two cpu_relax() pieces in do you still end up with a
> problem?  If this does not work for you the possibility to exists to
> clear the keyboard/mouse state on the kdb exit.

You will solve the multi-second hangs on ESX. However, this still doesn't fix the
bogus messages during typematic repeat (holding down ENTER) or keypad enter key use.

Basically, if you nuke the entire ENTER-key special case block, the existing key will
correctly handle both typematic, break codes, and KP ENTER key use (as well as any
mouse events). Cleanup of mouse/keyboard state is done already on kdb exit by kgdboc, which
is the only consumer of the kdb_keyboard code.

A
