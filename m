Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981Ab0GBUMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:12:06 -0400
Received: from ngc224.gerwinski.de ([213.133.98.203]:38945 "EHLO
	ngc224.gerwinski.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab0GBUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:12:04 -0400
X-Greylist: delayed 2149 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jul 2010 16:12:04 EDT
Date: Fri, 2 Jul 2010 21:35:50 +0200
Message-ID: <1278099350.18949.339668@goedel.fjf.gnu.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=us-ascii
Subject: procfs gives read/write access to RO/WO
	pipes
To: linux-kernel@vger.kernel.org
From: Frank Heckenbach <f.heckenbach@fh-soft.de>
User-Agent: semail 20060101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using /proc/*/fd, you can get read/write access to a pipe that you
have read-only or write-only access to. The program below
demonstrates this. It reads and writes through the "0" fd.
Tested with 2.6.34, i686.

At first sight, it doesn't look too serious if a program can write
to its own readable pipe, or read from its writeable pipe, but
perhaps I'm just not creative enough to see an exploit. Also, I
don't know it it might affect other file types where it might be a
real problem. At least, it does seem to violate the permissions.

#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

int main ()
{
  char a, n[64];
  int p[2], f, r;
  pipe (p);
  sprintf (n, "/proc/self/fd/%i", p[0]);
  f = open (n, O_RDWR);
  write (f, "x", 1);
  r = read (f, &a, 1);
  fprintf (stderr, "%i %c\n", r, a);
  return 0;
}
