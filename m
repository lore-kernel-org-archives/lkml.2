Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0FBOHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:07:01 -0400
Received: from ozlabs.org ([203.10.76.45]:59434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242Ab0FBOHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:07:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 23:36:51 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006021523.00357.rusty@rustcorp.com.au> <alpine.LFD.2.00.1006020006420.8175@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006020006420.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006022336.53024.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 04:51:46 pm Linus Torvalds wrote:
> 
> On Wed, 2 Jun 2010, Rusty Russell wrote:
> > 
> > Moved all the sysfs-exposing stuff to the end just after we put in the
> > list (and thus to after the find check).
> 
> Yeah, makes more sense that way. No reason to expose anything to sysfs 
> early. And splitting it into two patches makes it easier to follow than 
> the patch I posted. Ack.

Found another locking issue: the code which verifies we don't export over
an existing symbol needs to be atomic wrt. adding us to the list.

This will be in tomorrow's linux-next.

And load_module is down to 259 lines.  The label chain at the end is no
shorter tho :(  I'll leave those cleanups until next merge window.

The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6 modules

Eric Dumazet (1):
      module: module_unload_init() cleanup

Linus Torvalds (4):
      module: Make the 'usage' lists be two-way
      module: move find_module check to end
      module: refactor load_module
      module: refactor load_module part 2

Rusty Russell (9):
      module: fix kdb's illicit use of struct module_use.
      module: move sysfs exposure to end of load_module
      module: Make module sysfs functions private.
      module: make locking more fine-grained.
      module: verify_export_symbols under the lock
      module: fix bne2 "gave up waiting for init of module libcrc32c"
      module: refactor load_module part 3
      module: refactor load_module part 4
      module: refactor load_module part 5

 include/linux/module.h      |   44 +--
 kernel/debug/kdb/kdb_main.c |   12 +-
 kernel/module.c             |  899 +++++++++++++++++++++++++------------------
 3 files changed, 547 insertions(+), 408 deletions(-)
