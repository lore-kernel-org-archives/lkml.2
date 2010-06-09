Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab0FISxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758162Ab0FISxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:53:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Reinstate null behaviour for the GDB remote protocol 'p'
	command
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 09 Jun 2010 19:52:22 +0100
Message-ID: <20100609185222.21720.31044.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reinstate the null behaviour that the in-kernel gdbstub had for the GDB remote
protocol 'p' command (retrieve a single register value) prior to the following
commit:

	commit 7ca8b9c0dafd1cb36289aa4c92c7beae7adcd34f
	Author: David Howells <dhowells@redhat.com>
	Date:   Mon May 24 14:32:54 2010 -0700
	Subject: frv: extend gdbstub to support more features of gdb

Before that, the 'p' command just returned an empty reply, which causes gdb to
then go and use the 'g' command.  However, since that commit, the 'p' command
returns an error string, which causes gdb to abort its connection to the
target.

Not all gdb versions are affected, some use try 'g' first, and if that works,
don't bother with 'p', and so don't see the error.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/gdb-stub.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index 84d103c..a4dba6b 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -1789,6 +1789,12 @@ void gdbstub(int sigval)
 			flush_cache = 1;
 			break;
 
+			/* pNN: Read value of reg N and return it */
+		case 'p':
+			/* return no value, indicating that we don't support
+			 * this command and that gdb should use 'g' instead */
+			break;
+
 			/* PNN,=RRRRRRRR: Write value R to reg N return OK */
 		case 'P':
 			ptr = &input_buffer[1];

