Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3AJOqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:46:31 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46614 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab3AJOqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:46:30 -0500
Date: Thu, 10 Jan 2013 15:46:26 +0100
From: Florian Westphal <fw@strlen.de>
To: linux-kernel@vger.kernel.org
Cc: gaowanlong@cn.fujitsu.com, alan@linux.intel.com,
        gregkh@linuxfoundation.org, frank@lichtenheld.de
Subject: regression, bisected: openpty fails from 3.7 onwards without devpts
Message-ID: <20130110144626.GA26279@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Lichtenheld discovered that openpty() doesn't work anymore when
/dev/pts is not present.

We bisected this down to

commit bbb63c514a3464342967237a51a21ea8f61ab951
Author: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: drivers:tty:fix up ENOIOCTLCMD error handling

The original program triggering the error was pptpd, but
the test program below is sufficient:
----
#include <stdio.h>
#include <pty.h>
int main(void) {
 int pty_fd, tty_fd;
 if (openpty(&pty_fd, &tty_fd, NULL, NULL, NULL) != 0) {
  perror("openpty");
  return 1;
 }
return 0;
}
----
[ compile with cc -lutil pty.c -o pty ]

If devpts is available or above commit reverted openpty works again.
