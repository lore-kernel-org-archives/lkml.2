Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2GBVqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:46:19 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33117 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab2GBVqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:46:17 -0400
MIME-Version: 1.0
From: Alex Henrie <alexhenrie24@gmail.com>
Date: Mon, 2 Jul 2012 15:45:56 -0600
Message-ID: <CAMMLpeQ+6WvJO97m+5eGMA7dEymU61CfqLxcGVHoY_9DpG0cAg@mail.gmail.com>
Subject: iopl not preserved across execve on x64
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux kernel developers,

I have a question about how iopl works with execve. Essentially, I
want to set iopl to 3 with one program, then call execve to change to
another program that writes to the system speaker. This works fine on
x86 kernels, but segfaults on x64 kernels. Why is this?

-Alex

---iopl3.c---
#include <stdio.h>
#include <unistd.h>

int main(int argc, char* argv[])
{
    if (iopl(3) == -1)
    {
        perror("iopl");
        return 1;
    }

    if (execvp(argv[1], &argv[1]) == -1)
    {
        perror("execvp");
        return 1;
    }

    return 0;
}

---beep.c---
#include <stdio.h>

int main()
{
    __asm__("movb $0xB6, %al\n"
            "outb %al, $0x43\n"
            "inb $0x61, %al\n"
            "orb $0x03, %al\n"
            "outb %al, $0x61\n"
            "movb $0x64, %al\n"
            "outb %al, $0x42\n"
            "movb $0x01, %al\n"
            "outb %al, $0x42\n");
    sleep(1);
    __asm__("inb $0x61, %al\n"
            "andb $0xFC, %al\n"
            "outb %al, $0x61\n");
    return 0;
}

---test.sh---
gcc iopl3.c -o iopl3
gcc beep.c -o beep
sudo setcap cap_sys_rawio+eip ./iopl3
./iopl3 ./beep
