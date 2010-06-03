Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0FCRPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:15:10 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47978 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab0FCRPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:15:08 -0400
Date: Thu, 3 Jun 2010 10:15:01 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: floppy driver assumes INITIAL_JIFFIES == 0
Message-ID: <20100603101501.5e5d7148@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ancient and crufty floppy driver has some serious problems if
used during the boot process. It will miss data, and cause OOPS
because of callback routines called in unexpected contexts.
All this goes away if INITIAL_JIFFIES is 0 as it was when this
driver was written.

The root cause of all this is lots of places that assume the initial
jiffies value is 0.  Examples:

floppy_open:
    if (!(mode & FMODE_NDELAY)) {
		if (mode & (FMODE_READ|FMODE_WRITE)) {
			UDRS->last_checked = 0;

start_motor:
	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR)) {
		if (!(FDCS->dor & (0x10 << UNIT(current_drive)))) {
			set_debugt();
			/* no read since this drive is running */
			DRS->first_read_date = 0;

and the relationship between select_date and select_delay.

The driver is a complex mess of spaghetti state. Does one of the original
authors have more background to fix this?
