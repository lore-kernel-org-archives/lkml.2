Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab0KDUpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:45:35 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:58986 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab0KDUpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:45:33 -0400
Message-ID: <4CD31B6A.7040902@msgid.tls.msk.ru>
Date: Thu, 04 Nov 2010 23:45:30 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Detecting bind-mounts
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

There are quite some talks on the 'net - questions, not
answers - about detecting bind mounts - be it a directory
or a file.

There are 2 (mostly) different kinds of applications.  One
is cp/tar/find with --same-filesystem option (or equivalent),
that should not cross mountpoints.  And one more, apps like
mountpoint(1) from sysvinit - a utility to determine if a
given path is a mountpoint.

Neither of the two work when two directores on the same
filesystem are bind-mounted.

The usual idiom is to compare st_dev of current directory and
the parent - if they're different that's a mount point.  But
in this case, two st_devs will be the same, so such a mount
point will not be detected.

It is even worse for bind-mounted files (as opposed to dirs):
there's no path/file/.. entry to stat(2), and cutting the
last component from the pathname does not work reliable due
to symlinks (it may be a symlink from different filesystem).

So far I know only one way to detect a bind mount like this,
and it is unreliable anyway.  It is to parse /proc/mounts
and try to find the object(s) in question.  Unreliable because
of, again, symlinks, and possible complex mounts and bind-
mounts.  And this is also very slow - imagine using this way
for find/tar/cp --one-file-system.

Is there some simpler and more reliable way? Maybe use mount
syscall, like we use kill($pid, 0) to check existance of a
process?

And as far as I understand, the same applies to multiple
mounts of the same filesystem.

Thanks!

/mjt
