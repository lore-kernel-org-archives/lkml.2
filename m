Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2GQJ2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:28:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44732 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2GQJ2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:28:16 -0400
MIME-Version: 1.0
From: =?ISO-8859-1?B?QWRyaeFu?= <adrianbn@gmail.com>
Date: Tue, 17 Jul 2012 10:27:55 +0100
Message-ID: <CAFDTedp84TuxHpz2SJTG_jdjtkQ7r9qkCjqQWT5Zg22LrT7tTg@mail.gmail.com>
Subject: Setreuid distinction about (uid_t)-1
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

first I'd like to apologize if the question I'm asking is dumb or a
little bit out of the scope of the list. I've been doing some testing
on setuid functions family lately, and I found a weird behaviour I'm
not able to explain myself. I'm using this small program to try and
switch the uid of a user:

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main(int argc, char** argv){
        unsigned int uid;
        char *args[] = {"/bin/sh",NULL};

        if (argc < 2){
                printf("Usage: %s target_uid\n", argv[0]);
                exit(0);
        }
        uid = atoi(argv[1]);
        printf("%u\n",uid);
        if (setreuid(uid,uid)==-1){
                printf("Setreuid to %u failed\n ",uid);
                perror("E");
                exit(1);
        }
        execve("/bin/sh",args,NULL);
        return 1;
}

I've been calling this binary with a bunch of different uid numbers,
and I came across this weird behaviour with the (uid_t) -1 value:

adrian@home-pc:~$ /tmp/suid-tests
Usage: /tmp/suid-tests target_uid
adrian@home-pc:~$ /tmp/suid-tests 0
0
Setreuid to 0 failed
E: Operation not permitted
adrian@home-pc:~$ /tmp/suid-tests -1
4294967295
$ id
uid=1000(adrian) gid=1000(adrian)
groups=1000(adrian),4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),110(sambashare),111(admin)
adrian@home-pc:~$ /tmp/suid-tests -2
4294967294
Setreuid to 4294967294 failed
E: Operation not permitted
adrian@home-pc:~$ /tmp/suid-tests -3
4294967293
Setreuid to 4294967293 failed
E: Operation not permitted

If the binary is setuid, the -1 call effectively rises the euid to
root (0), although other arbitrary values are properly being set:

adrian@home-pc:~$ ls -hl /tmp/suid-tests
-rwsr-x--- 1 root adrian 8,5K 2012-07-17 10:53 /tmp/suid-tests
adrian@home-pc:~$ /tmp/suid-tests -1
4294967295
# id
uid=1000(adrian) gid=1000(adrian) euid=0(root)
groups=0(root),4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),110(sambashare),111(admin),1000(adrian)
adrian@home-pc:~$ /tmp/suid-tests -2
4294967294
$ id
uid=4294967294 gid=1000(adrian)
groups=4(adm),20(dialout),24(cdrom),46(plugdev),109(lpadmin),110(sambashare),111(admin),1000(adrian)


I've been looking into kernel/sys.c, reading the setreuid function for
an explanation. I've seen that there are several if cases for when the
uid value is (uid_t)-1 but I still don't understand why is this being
doing. I tried to trace down all the checks that take place, but I'm
not quite familiar with the kernel and I feel I'm missing something.
Is this an expected behaviour? If so, could someone please shed some
light on why?

Running kernels for the tests have been several on the 2.6.x, 2.6.38
x86_64 for example.


Thanks in advance and regards,
Adrián
