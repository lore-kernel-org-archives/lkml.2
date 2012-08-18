Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2HROA2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 10:00:28 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:51041 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2HROAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 10:00:25 -0400
Message-ID: <502FA000.8090700@halfdog.net>
Date: Sat, 18 Aug 2012 14:00:32 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14a1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Search for patch for kernel stack disclosure in binfmt_script during
 execve
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm searching for a patch for linux kernel stack disclosure in
binfmt_script with crafted interpreter names when CONFIG_MODULES is
active (see [1]).

The simplest solution would be to return an error in load_script (from
fs/binfmt_script.c). when maximal recursion depth is reached, but I'm
not sure, if that is nice and could have any side effects. Apart from
that, some change in the loop condition in search_binary_handler (from
fs/exec.c) could have side effects hard to see and hence reintroduce
the bug (challenge to get that right in documentation).


Any comments?

- --- fs/binfmt_script.c  2012-01-19 23:04:48.000000000 +0000
+++ fs/binfmt_script.c        2012-08-18 13:55:25.735748407 +0000
@@ -22,9 +22,8 @@
        char interp[BINPRM_BUF_SIZE];
        int retval;

- -       if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
- -           (bprm->recursion_depth > BINPRM_MAX_RECURSION))
- -               return -ENOEXEC;
+       if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!')) return
- -ENOEXEC;
+        if (bprm->recursion_depth > BINPRM_MAX_RECURSION) return -ENOMEM;
        /*
         * This section does the #! interpretation.
         * Sorta complicated, but hopefully it will work.  -TYT

hd

[1]
http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlAvn0MACgkQxFmThv7tq+6nUACfdk7KWESuC6J1FXZcrMaa3kCb
eWoAn0wV6INdYGjAZydd6ytO0i5BnhGa
=cxbR
-----END PGP SIGNATURE-----
