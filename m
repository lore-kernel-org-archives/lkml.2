Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0LJPmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:42:33 -0500
Received: from mx4.sophos.com ([74.202.89.161]:48312 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab0LJPmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:42:32 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2010 10:42:32 EST
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Polling(2) /proc/mounts is broken?
Date: Fri, 10 Dec 2010 15:32:48 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5; KDE/4.4.4; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary-00=_hgkANv150JKbuzm"
Message-ID: <d8aa5094-8042-4172-8e1d-7d2c7f2299a7@us-col-exch1.green.sophos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hgkANv150JKbuzm
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi all,

So since we cannot get fanotify global mode we were told to poll(2) on
/proc/mounts and set up new mount marks dynamically.

Is the attached C program roughly how it should work?

Because on 2.6.37-rc5 it busy loops for me (POLLIN always reported), even
though if I remove the seek it gets EOF immediately after POLLIN.

Under 2.6.32 (Ubuntu flavour) I see the same behaviour.

Going further back to 2.6.24 (again Ubuntu flavour) and there it works, but=
 it
set POLLERR instead of POLLIN in revents.

So I guess it regressed somewhere in between. I'll look to provide a fix
unless someone more familiar with this area beats me to it.

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, Un=
ited Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.

--Boundary-00=_hgkANv150JKbuzm
Content-Type: text/x-csrc; charset="UTF-8"; name="pollmounts.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="pollmounts.c"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <poll.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    int fd;
    struct pollfd ev;
    int ret;
    ssize_t bytes;
    char buf[4096];
    long unsigned int cnt = 0;


    fd = open("/proc/mounts", O_RDONLY);

    do {
        ev.events = POLLIN;
        ev.fd = fd;
        ev.revents = 0;

        ret = poll(&ev, 1, -1);
        lseek(fd, 0, SEEK_SET);
        if (ret == 1 && ev.revents == POLLIN) {
            printf("####  %lu ########################################\n", cnt);
            while ((bytes = read(fd, buf, sizeof(buf))) > 0)
                write(1, buf, bytes);
            cnt++;
        }
    } while (ret >= 0);

    return 0;
}

--Boundary-00=_hgkANv150JKbuzm--
