Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031382Ab2CPQE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:04:28 -0400
Received: from mail1.windriver.com ([147.11.146.13]:61176 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031294Ab2CPQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:04:26 -0400
Message-ID: <4F63647A.2040306@windriver.com>
Date: Fri, 16 Mar 2012 11:04:10 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 2/4] kgdb: Make gdbstub_exit a nop unless gdb is attached
References: <cover.1331900215.git.jan.kiszka@siemens.com> <c0c7d3cced4ab0b8b00d452cd9fd99c085fc513e.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <c0c7d3cced4ab0b8b00d452cd9fd99c085fc513e.1331900215.git.jan.kiszka@siemens.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 07:17 AM, Jan Kiszka wrote:
> This allows to call gdbstub_exit without worrying if
> - CONFIG_KGDB is enabled
> - if an kgdb I/O driver is loaded
> - if a gdb frontend is currently attached

If you took a look at the alternate patch I sent in the 4 of 4 response, I made a modification for kdb to continue to work properly, namely disconnect and do not emit characters if we are in kdb mode.

>
> diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
> index c22d8c2..5d7ed0a 100644
> --- a/kernel/debug/gdbstub.c
> +++ b/kernel/debug/gdbstub.c
> @@ -1111,6 +1111,9 @@ void gdbstub_exit(int status)
> unsigned char checksum, ch, buffer[3];
> int loop;
>
> + if (!dbg_io_ops || !kgdb_connected)
> + return;
> +
> buffer[0] = 'W';
> buffer[1] = hex_asc_hi(status);
> buffer[2] = hex_asc_lo(status);

I patched against what you originally had there.

--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -1110,8 +1110,11 @@ void gdbstub_exit(int status)
 {
        unsigned char checksum, ch, buffer[3];
        int loop;
+       if (!kgdb_connected)
+               return;
+       kgdb_connected = 0;
 
-       if (!dbg_io_ops || !kgdb_connected)
+       if (!dbg_io_ops || dbg_kdb_mode)
                return;
 
        buffer[0] = 'W';

---

Depending on what we come to agreement on with patches 2-4 in your series I'll fold the changes into the reboot notifier.

It is possible to have both the reboot notifier and the low level modifications to the arch specific reboot hooks as a final catch, but I am interested to see what you think about just using the reboot notifier.

Cheers,
Jason.
