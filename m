Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0D0P0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:26:32 -0400
Received: from smtp.nokia.com ([192.100.122.230]:24410 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0D0P0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:26:31 -0400
Date: Tue, 27 Apr 2010 18:25:44 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: robert.richter@amd.com, schwidefsky@de.ibm.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] updates for oprofile
Message-ID: <20100427152544.GA9063@pcarmody-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 27 Apr 2010 15:26:11.0432 (UTC) FILETIME=[F7809680:01CAE61D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, et al., 

Regarding today's pulled request, containing:

commit bc078e4eab65f11bbaeed380593ab8151b30d703
Author: Martin Schwidefsky <schwidef...@de.ibm.com>
Date:   Tue Mar 2 16:01:10 2010 +0100

    oprofile: convert oprofile from timer_hook to hrtimer
    

Information is a touch scant, as I'm doing the investigation as I
write, but I believe that that patch can cause ooops regressions
via a null-pointer dereference in oprofile_add_sample().

That function declares:
"""
/**
 * Add a sample. This may be called from any context.
 */
void oprofile_add_sample(struct pt_regs * const regs, unsigned long event);
"""

And begins:
"""
void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
{
        int is_kernel = !user_mode(regs);
"""

Where on at least two major architectures (Arm, x86), user_mode()
unconditionally dereferences its parameter.

Now oprofile_add_sample() is called from this context:
"""
static enum hrtimer_restart oprofile_hrtimer_notify(struct hrtimer *hrtimer)
{
         oprofile_add_sample(get_irq_regs(), 0);
"""

And get_irq_regs() is NULL when not in an IRQ context.

Bang.

An example of this kind of thing kicking in has already been encountered 
last year:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg14069.html
(That thread got a little side-tracked onto OMAP specifics, but the 
original report is topical.)

Now would be a very good time for the "many eyes" principle to kick in.

I'm now looking into workarounds, but nothing that I'd necessarily
want to submit as a real fix.

Phil
cc:'d replies appreciated
