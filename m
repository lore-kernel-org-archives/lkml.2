Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1LUP6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:58:04 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:57758 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1LUP6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:58:02 -0500
Date: Wed, 21 Dec 2011 10:58:01 -0500 (EST)
From: Ramon de C Valle <rcvalle@redhat.com>
Reply-To: Ramon de C Valle <rcvalle@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: brk() system call, RLIMIT_AS, and RLIMIT_DATA in 32-bit compatibility mode
Message-ID: <040c0443-00ee-4622-bc8f-41ffb07f7fec@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <ae7baec9-7075-4eca-b4ec-969b072fcd9d@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.9.26]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today I came across an interesting behaviour and would like some enlightenment of what I'm probably missing.

Considering the following program:

.globl _start

_start:
    xorl    %ebx,%ebx
    pushl   $0xc0000000
    popl    %ebx
continue:
    addl    $0x01000000,%ebx
    xorl    %eax,%eax
    movb    $0x2d,%al
    int     $0x80
    jmp     continue


This is the strace output of the above program in a 32-bit machine:

[...]

brk(0xb9000000)                         = 0xb9000000
brk(0xba000000)                         = 0xba000000
brk(0xbb000000)                         = 0xbb000000
brk(0xbc000000)                         = 0xbc000000
brk(0xbd000000)                         = 0xbd000000
brk(0xbe000000)                         = 0xbe000000
brk(0xbf000000)                         = 0xbf000000
brk(0xc0000000)                         = 0xbf000000
brk(0xc1000000)                         = 0xbf000000
brk(0xc2000000)                         = 0xbf000000
brk(0xc3000000)                         = 0xbf000000
brk(0xc4000000)                         = 0xbf000000
brk(0xc5000000)                         = 0xbf000000

[...]

brk(0xf9000000)                         = 0xbf000000
brk(0xfa000000)                         = 0xbf000000
brk(0xfb000000)                         = 0xbf000000
brk(0xfc000000)                         = 0xbf000000
brk(0xfd000000)                         = 0xbf000000
brk(0xfe000000)                         = 0xbf000000
brk(0xff000000)                         = 0xbf000000
brk(0)                                  = 0xbf000000
brk(0x1000000)                          = 0xbf000000
brk(0x2000000)                          = 0xbf000000
brk(0x3000000)                          = 0xbf000000
brk(0x4000000)                          = 0xbf000000
brk(0x5000000)                          = 0xbf000000
brk(0x6000000)                          = 0xbf000000
brk(0x7000000)                          = 0xbf000000
brk(0x8000000)                          = 0xbf000000
brk(0x9000000)                          = 0xbf000000
brk(0xa000000)                          = 0xa000000

[...]

Notice that from 0xc0000000 upwards it fails and returns the current break as expected. However, the following is the strace output of the same program in a 64-bit machine running in 32-bit compatibility mode:

[...]

brk(0xb9000000)                         = 0xffffffffb9000000
brk(0xba000000)                         = 0xffffffffba000000
brk(0xbb000000)                         = 0xffffffffbb000000
brk(0xbc000000)                         = 0xffffffffbc000000
brk(0xbd000000)                         = 0xffffffffbd000000
brk(0xbe000000)                         = 0xffffffffbe000000
brk(0xbf000000)                         = 0xffffffffbf000000
brk(0xc0000000)                         = 0xffffffffc0000000
brk(0xc1000000)                         = 0xffffffffc1000000
brk(0xc2000000)                         = 0xffffffffc2000000
brk(0xc3000000)                         = 0xffffffffc3000000
brk(0xc4000000)                         = 0xffffffffc4000000
brk(0xc5000000)                         = 0xffffffffc5000000

[...]

brk(0xf9000000)                         = 0xfffffffff9000000
brk(0xfa000000)                         = 0xfffffffffa000000
brk(0xfb000000)                         = 0xfffffffffb000000
brk(0xfc000000)                         = 0xfffffffffc000000
brk(0xfd000000)                         = 0xfffffffffd000000
brk(0xfe000000)                         = 0xfffffffffe000000
brk(0xff000000)                         = 0xffffffffff000000
brk(0)                                  = 0xffffffffff000000
brk(0x1000000)                          = 0xffffffffff000000
brk(0x2000000)                          = 0xffffffffff000000
brk(0x3000000)                          = 0xffffffffff000000
brk(0x4000000)                          = 0xffffffffff000000
brk(0x5000000)                          = 0xffffffffff000000
brk(0x6000000)                          = 0xffffffffff000000
brk(0x7000000)                          = 0xffffffffff000000
brk(0x8000000)                          = 0xffffffffff000000
brk(0x9000000)                          = 0x9000000
brk(0xa000000)                          = 0xa000000

[...]

Notice that from 0xc0000000 upwards it continues expanding the program break above 0xc0000000 up to 0xff000000 where it also starts failing and returning the current break. Is this an expected behaviour when running an application in 64-bit machine in 32-bit compatibility mode? Is RLIMIT_AS and RLIMIT_DATA being honoured?

Thanks,

-- 
Ramon de C Valle / Red Hat Security Response Team
