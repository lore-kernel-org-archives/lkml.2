Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab2I1Axv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:53:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61987 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab2I1Axe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:53:34 -0400
MIME-Version: 1.0
Date: Fri, 28 Sep 2012 03:53:33 +0300
Message-ID: <CADopi2OdoMs0ME32nufUNM-_1JBSJBosCab2ZKt8De8H-eF1=A@mail.gmail.com>
Subject: File append 100 times faster than modify
From: Matti Katila <matti.katila@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel people,


I would like to know why file appending is much more faster than
modifying file by other methods.
First let's just see how fast append is on my 3.2.0-18-generic-pae
#29-Ubuntu SMP

$ time for i in {1..1000}; do echo "asdf jkl" >> test ; done

real	0m0.039s
user	0m0.024s
sys	0m0.016s

That was pretty fast for old laptop.

Then insert a line. I think sed "in place" does temp file and then
move it over the original file.

$ time for i in {1..1000}; do sed -i "1iasdf jkl" test ; done

real	0m9.875s
user	0m1.300s
sys	0m6.372s

Quite slow compared to append. If we continue with append it doesn't
slow down even file size increases.

$ time for i in {1..1000}; do echo "asdf jkl" >> test ; done

real	0m0.037s
user	0m0.028s
sys	0m0.008s

Even creating new file is quite slow compared to that

$ time for i in {1..1000}; do echo "asdf jkl" > test ; done

real	0m0.719s
user	0m0.052s
sys	0m0.200s

Then let's try modifying the file in place without changing size of
the file. Here is a short command.

#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	char *file = argv[1];
	char *chunk = argv[2];
	int fd = open(file, O_WRONLY);
	write(fd, chunk, strlen(chunk));
	close(fd);
	return 0;
}

$ gcc -o simplewrite simplewrite.c
$ time for i in {1..1000}; do ./simplewrite test $i ; done

real	0m3.666s
user	0m0.308s
sys	0m1.352s

It's still very slow compared to appending. Why are other writes so
slow and are there any tricks that could make it faster? Please cc me
if you answer.


   -Matti
