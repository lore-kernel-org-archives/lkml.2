Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2E0MDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 08:03:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34104 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2E0MDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 08:03:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAK1sNPDMcX=D+=1uxVpX5HOgKyCzXr1EeUx7Eyky2j-2n3q0Ng@mail.gmail.com>
References: <CAK1sNPDMcX=D+=1uxVpX5HOgKyCzXr1EeUx7Eyky2j-2n3q0Ng@mail.gmail.com>
Date: Sun, 27 May 2012 16:03:50 +0400
Message-ID: <CAK1sNPDNz3E3PLq4mB6VagWu0BsGdhQVcew2YDmaG+JJBup3ug@mail.gmail.com>
Subject: Sparc32: BTFIXUPSET_CALL(pmd_clear, . . .)-related issue in older
 versions of the kernel
From: Ilya Malakhov <ilmalakhovthefirst@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi.

 While analyzing a rather nasty problem with an application running at
sun4m sparc32 hosts with "Fujitsu TurboSparc" and "TI Viking/MXCC"
MMUs, I realized, that as a 4Kb "Page Table" was freed, only the first
element in the corresponding `pmdv[]' array in

typedef struct { unsigned long pmdv[16]; } pmd_t;

was actually cleared, rather than all the 16 ones.

 The reason for that was the use of `BTFIXUPCALL_SWAPO0G0' instead of
`BTFIXUPCALL_NORM' for `pmd_clear' in case of "default" SRMMU (except
for some specific types of SRMMU) during initialization:
 . .
BTFIXUPSET_CALL(pmd_clear, srmmu_pmd_clear, BTFIXUPCALL_SWAPO0G0);
 . .

 That would probably be OK if pmd_t were `struct { unsigned long pmd;
}' as it used to be ten years ago, but seems to be erroneous nowadays,
doesn't it?

 From a user's point of view this leads to poorly diagnosable
problems. E.g., after a series of mmaps and munmaps one may find
himself in a situation, where different virtual addresses are mapped to
the same physical one.

 A recent commit by David Miller, where pmd_clear() is un-btfixupped,
is likely to solve this problem in future versions of the kernel. I
wonder, if any patches for older ones should be expected.

 Thanks,
 Ilya.
