Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0KWXPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:15:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab0KWXPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=OH473Z88M2cQqDttJYIHRBewTfjVIB/duS+/41DxRjPqUJFhCCQRlxoDFzAzATtemv
         MnEjpAeDq9kBpaVPGgSKPg7Yv5R8abSJ4nYC9xCNTa6hQvv7vLzxnZBBWzy5BCGxyoBr
         QHJkFiOaDHuOWw3J0XG0S5QDNjamMTjeTCAU8=
MIME-Version: 1.0
Date: Wed, 24 Nov 2010 00:15:03 +0100
Message-ID: <AANLkTimkna-R1bhnx6inanobSUye423xqx99nZ27CLBA@mail.gmail.com>
Subject: Inotify memory leak
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Eugene Teo <eugene@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Inotify does not clean up properly when it fails to create the file
descriptor. So it leaks kernel memory. Watch "slabtop" while running
this program:

#include <sys/inotify.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
        int fds[2];

        /* Circumvent max inotify instances limit */
        while (pipe(fds) != -1)
                ;

        while (1)
                inotify_init();

        return 0;
}

Specifically, the problem is in inotify_init1 where the group pointer is leaked:

        group = inotify_new_group(user, inotify_max_queued_events);
[...]
        ret = anon_inode_getfd("inotify", &inotify_fops, group,
                                  O_RDONLY | flags);
        if (ret >= 0)
                return ret;

        atomic_dec(&user->inotify_devs);
out_free_uid:
        free_uid(user);
        return ret;

I think it should be easily fixed by calling fsnotify_put_group() at
the right place.


Vegard
