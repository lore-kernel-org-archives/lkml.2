Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2KMO1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:27:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab2KMO06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:26:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] UAPI: Strip the _UAPI prefix from header guards during
 header installation
To: torvalds@osdl.org
From: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Torcz <tomek@pipebreaker.pl>, Josh Boyer <jwboyer@redhat.com>
Date: Tue, 13 Nov 2012 14:26:41 +0000
Message-ID: <20121113142641.16744.72039.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip the _UAPI prefix from header guards during header installation so that
any userspace dependencies aren't affected.  glibc, for example, checks for
linux/types.h, linux/kernel.h, linux/compiler.h and linux/list.h by their
guards - though the last two aren't actually exported.

	libtool: compile:  gcc -std=gnu99 -DHAVE_CONFIG_H -I. -Wall -Werror -Wformat -Wformat-security -D_FORTIFY_SOURCE=2 -fno-delete-null-pointer-checks -fstack-protector -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -c child.c  -fPIC -DPIC -o .libs/child.o
	In file included from cli.c:20:0:
	common.h:152:8: error: redefinition of 'struct sysinfo'
	In file included from /usr/include/linux/kernel.h:4:0,
			 from /usr/include/linux/sysctl.h:25,
			 from /usr/include/sys/sysctl.h:43,
			 from common.h:50,
			 from cli.c:20:
	/usr/include/linux/sysinfo.h:7:8: note: originally defined here

Reported-by: Tomasz Torcz <tomek@pipebreaker.pl>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Josh Boyer <jwboyer@redhat.com>
---

 0 files changed

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index 239d22d..6c353ae 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -42,6 +42,9 @@ foreach my $filename (@files) {
 		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
 		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
 		$line =~ s/(^|\s|[(])(volatile)\b(\s|[(]|$)/$1__$2__$3/g;
+		$line =~ s/#ifndef _UAPI/#ifndef /;
+		$line =~ s/#define _UAPI/#define /;
+		$line =~ s!#endif /[*] _UAPI!#endif /* !;
 		printf {$out} "%s", $line;
 	}
 	close $out;

