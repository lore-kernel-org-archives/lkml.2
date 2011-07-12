Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1GLUVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:21:51 -0400
Received: from p3plsmtpa01-03.prod.phx3.secureserver.net ([72.167.82.83]:58571
	"HELO p3plsmtpa01-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754896Ab1GLUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:21:50 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jul 2011 16:21:50 EDT
Date: Tue, 12 Jul 2011 16:16:16 -0400
From: MK <mk@cognitivedissonance.ca>
To: linux-kernel@vger.kernel.org
Subject: AVX "Sandy Bridge" hardware issue?
Message-Id: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi gang! I'd forgotten how busy this list is, I hope someone can help
me out.

I have a small VPS slice, run under openVZ, that I use for testing and
personal projects.  Recently, the provider migrated to new Xeon "Sandy
Bridge" processors, which according to wikipedia are the first and
thus far only commercially available processors using AVX.

After the migration, I had a number of apache mod_perl applications
break due to SIGILL.   Reproducible test case:

use Apache2::Const qw(SERVER_ERROR)

sub handler {
     return SERVER_ERROR;
};

Apache2::Const is the indirect culprit here; if I remove it and just
return 500 the module works.  Note that this is not a perl error. A
backtrace from running apache under gdb, triggering the issue, is here:

http://pastebin.com/16SrEzHM

I posted this to the mod_perl list and someone pointed me to a
backtrace identical in its final contexts, from a glibc bug
reported last year:

http://sourceware.org/bugzilla/show_bug.cgi?format=multiple&id=12113

Which involves AVX hardware.  The VPS provider has provided me with a
bare Fedora 14 slice for debugging this issue, and the "small
reproducer" available from the above bug report, verified by Ulrich
Drepper, does reproduce the issue.

So I filed a glibc bug with fedora to that effect:

https://bugzilla.redhat.com/show_bug.cgi?id=720176

In which Andreas Schwab points out (rightly or wrongly) that according
to the /proc/cpuinfo from the slice, the processor actually does not
support AVX.  However,  the "model name", "Intel(R) Xeon(R) CPU
E31230", is according to this a Sandy Bridge processor with AVX:

http://en.wikipedia.org/wiki/Sandy_Bridge#Server_processors

And while I do not have access to the hardware, the provider is very
unequivocal about the fact that these are Sandy Bridges, which
apparently include AVX.

So I am looking for a next step to take in debugging this.  The kernel
used on the slice (nb, openVZ does not allow for rolling your own) is 
2.6.32 built with gcc 4.1.2.  I think this may be prior to AVX support
in the kernel and gcc, but the glibc is 2.13, which apparently includes
it.  

Does anyone have any idea why I would get this identical backtrace, and
a failed reproducer test, on hardware which supposedly supports AVX
(but not according to the kernel in /proc/cpuinfo)?

Sincerely, MK   

-- 
"Enthusiasm is not the enemy of the intellect." (said of Irving Howe)
"The angel of history[...]is turned toward the past." (Walter Benjamin)

