Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0L2VQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 16:16:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38541 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0L2VQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 16:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=PRlxb87iKWau6VXZiQx3KH2t/VndzMY2+kjFyeH9YWslPdYtVfQ/WtpBIM65SQRRnk
         hRcEMLIu3gEhtO10Dt9ZnBIx8N0f/lKSAxgB0HUc9xetV9piBe3l0u+sTqZs7GtB+q3+
         F/qi4vhbZVpN2dSSFD0vC6iVDSWtFkSEo0pW0=
MIME-Version: 1.0
Date: Thu, 30 Dec 2010 06:16:17 +0900
Message-ID: <AANLkTimK9gh_LVW2faCbVMpwMeBFOJLRXHJkA4_3Oi6=@mail.gmail.com>
Subject: [PATCH 0/4] elf core: Write section header table first
From: HATAYAMA Daisuke <d.hatayama@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, jdike@addtoit.com, dhowells@redhat.com,
        gerg@snapgear.com, roland@redhat.com, oleg@redhat.com, mingo@elte.hu,
        viro@zeniv.linux.org.uk, andi@firstfloor.org, alan@lxorguk.ukuu.org.uk,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, suzuki@in.ibm.com,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset changes a position of section header table, if exists,
from the last to the next to ELF header. According to ELF
specification, the order of ELF component layout is not specified
except for ELF header. See:

  http://www.sco.com/developers/gabi/latest/ch4.intro.html#file_format

The merits are:
 - reducing tracing memory maps from 3 times to 2 times.
 - simple offset handling that makes the code easier to read.

 arch/ia64/kernel/elfcore.c |   16 -----
 arch/um/sys-i386/elfcore.c |   16 -----
 fs/binfmt_elf.c            |  136 +++++++++++++++++-------------------------
 fs/binfmt_elf_fdpic.c      |  141 ++++++++++++++++++--------------------------
 include/linux/elfcore.h    |    1 -
 kernel/elfcore.c           |    5 --
 6 files changed, 111 insertions(+), 204 deletions(-)

I built and tested this patchset on x86_64. I also built it on ia64,
um-i386 and frv using cross compilers to cover the range.

Here's a program useful to generate ELF core with many program header
entries, and three steps to produce such ELF core:

 $ sysctl vm.max_map_count=70000
 $ ulimit -c unlimted
 $ mkmmap 65535

== mkmmap.c
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
int main(int argc, char **argv)
{
        int maps_num;
        if (argc < 2) {
                fprintf(stderr, "mkmmaps [number of maps to be created]\n");
                exit(1);
        }
        if (sscanf(argv[1], "%d", &maps_num) == EOF) {
                perror("sscanf");
                exit(2);
        }
        if (maps_num < 0) {
                fprintf(stderr, "%d is invalid\n", maps_num);
                exit(3);
        }
        for (; maps_num > 0; --maps_num) {
                if (MAP_FAILED == mmap((void *)NULL, (size_t) 1, PROT_READ,
                                       MAP_SHARED | MAP_ANONYMOUS, (int) -1,
                                       (off_t) NULL)) {
                        perror("mmap");
                        exit(4);
                }
        }
        abort();
        {
                char buffer[128];
                sprintf(buffer, "wc -l /proc/%u/maps", getpid());
                system(buffer);
        }
        return 0;
}
==

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
