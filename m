Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab0FJMHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:07:43 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55948 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892Ab0FJMHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:07:41 -0400
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] TOMOYO: Add conditional ACL support.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201006102107.EEE43266.VFQMFOLHOSOJtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 10 Jun 2010 21:07:37 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Wed, 9 Jun 2010, Tetsuo Handa wrote:
> 
> > This patch allows users to check argv[]/envp[] for execve() operation.
> > 
> > This patch allows users to check caller task's uid/gid etc. for each operation.
> 
> >  10 files changed, 1615 insertions(+), 96 deletions(-)
> 
> This is a huge patch, and I think it warrants more than two sentences of 
> changelog.
> 
> It'd be great to have some explanation of what these features are about in 
> terms of the security model, e.g. what threats do they address?
> 
> Also, this code needs wider technical review, to ensure it's being done 
> the best way.
> 
> It might help to cc: linux-kernel with your patches.

I see. Reposting as a patchset.



The xattr based security (e.g. SELinux/Smack) is good at isolating information
because access decision is not affected unless xattr on the inode changes. But,
I know that xattr parameter cannot control for what purposes information is
used if access is granted. I consider using information for purposes other than
the original intent as a security threat. Therefore, I implemented a parameter
based security (i.e. TOMOYO) which deals parameters which affect for what
purposes information is used.

Change of filename can change how the file is used. For example, renaming from
/var/www/html/index.txt to /var/www/html/.htaccess makes Apache handle the file
differently. Therefore, TOMOYO restricts string parameters that causes change
of filename (e.g. link() rename() mount()). This was done by Linux 2.6.34.

Change of DAC's permission can change how the file is used. For example,
removing execute bit from /sbin/init will make the system unbootable.
For example, adding group writable bit or world writable bit to
~/.ssh/authorized_keys will make SSH server refuse using the file (even if
write access to ~/.ssh/authorized_keys by non-owner is forbidden by MAC's
permission). Therefore, TOMOYO restricts numeric parameters (e.g. chmod()
chown()). This will be done by Linux 2.6.36 as the code is now in linux-next
tree.

Although in-kernel access control mechanism cannot deal all of parameters which
affect for what purposes information is used, argv[]/envp[] and symlink's
target are one of parameters which in-kernel access control mechanism can deal.
This patchset implements below things.

[1/4] Add caller task's credential condition support.
[2/4] Add argv[]/envp[] condition support.
[3/4] Add symlink's target condition support.
[4/4] Remove alias support.

Regards.
