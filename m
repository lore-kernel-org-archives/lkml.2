Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2KSNCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:02:45 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59195 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2KSNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:02:44 -0500
X-Nat-Received: from [202.181.97.72]:59386 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353330134.3955
To: dhowells@redhat.com
Cc: arnd@arndb.de, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
	<24020.1353323415@warthog.procyon.org.uk>
In-Reply-To: <24020.1353323415@warthog.procyon.org.uk>
Message-Id: <201211192202.IBE48444.VHFLtOSOQFOMJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 19 Nov 2012 22:02:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19112012 #8441341, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> The version of the compiler shouldn't have any effect as far as I can see.
> Can you add the following:
> 
> 	$(info XXXX $(srcdir)/$(hdr)) \
> 	$(info YYYY $(oldsrcdir)/$(hdr)) \
> 
> immediately before the marked line and look for the lines in the output from
> make.  The error suggests that neither pattern match worked.

Inserting

	$(info XXXX $(srcdir)/$(hdr)), \
	$(info YYYY $(oldsrcdir)/$(hdr)), \

did not work.

> Btw, are you supplying an O= flag to make when you build?

No. But supplying V=1 revealed that $(_dst) is an empty string at

  # Recursion
  hdr-inst := -rR -f $(srctree)/scripts/Makefile.headersinst obj
  .PHONY: $(subdirs)
  $(subdirs):
          $(Q)$(MAKE) $(hdr-inst)=$(obj)/$@ dst=$(_dst)/$@

when using GNU Make 3.80, while $(_dst) contains appropriate string when using
GNU Make 3.81.



With Make 3.81:
make -f scripts/Makefile.build obj=scripts build_unifdef
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/asm-generic dst=include/uapi/asm-generic
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/drm dst=include/uapi/drm
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/linux dst=include/uapi/linux
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/linux/byteorder dst=include/uapi/linux/byteorder
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/linux/caif dst=include/uapi/linux/caif
(...snipped...)

With Make 3.80:
make -f scripts/Makefile.build obj=scripts build_unifdef
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/asm-generic dst=/asm-generic
/usr/src/all/linux/scripts/Makefile.headersinst:50: *** Missing UAPI file /usr/src/all/linux/include/uapi/asm-generic/auxvec.h.  Stop.
make[2]: *** [asm-generic] Error 2
