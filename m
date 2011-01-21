Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1AUTbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:31:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab1AUTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:30:58 -0500
Subject: SELinux/SMACK/TOMOYO: ioctl permissions handling is wrong and
 nonsensicle
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov
Cc: sds@tycho.nsa.gov, jmorris@namei.org, casey@schaufler-ca.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        takedakn@nttdata.co.jp
Date: Fri, 21 Jan 2011 14:30:35 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295638239.3403.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I've included an AA person as well in case you ever decide to try to
mediate ioctl operations]

SELinux used to recognize certain individual ioctls and check
permissions based on the knowledge of the individual ioctl.  In commit
242631c49d4cf396 the SELinux code stopped trying to understand
individual ioctls and to instead looked at the ioctl access bits to
determine in we should check read or write for that operation.  This
same suggestion was made to SMACK (and I believe copied into TOMOYO).
But this suggestion is total rubbish.  The ioctl access bits are
actually the access requirements for the structure being passed into the
ioctl, and are completely unrelated to the operation of the ioctl or the
object the ioctl is being performed upon.

Take FS_IOC_FIEMAP as an example.  FS_IOC_FIEMAP is defined as:

FS_IOC_FIEMAP _IOWR('f', 11, struct fiemap)

So it has access bits R and W.  What this really means is that the
kernel is going to both read and write to the struct fiemap.  It has
nothing at all to do with the operations that this ioctl might perform
on the file itself!

If anything, our logic is exactly backwards, since an ioctl which writes
to userspace would be 'reading' something from the file and an ioctl
which reads from userspace would be 'writing' something to the file...

I'm planning to revert this SELinux commit, but I want other LSM authors
to realize that (assuming I'm not completely off in the woods somewhere)
you should take a look at your ioctl permissions checking as well....

-Eric

