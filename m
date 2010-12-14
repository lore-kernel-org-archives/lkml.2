Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0LNKU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:20:26 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:52962 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0LNKUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:20:25 -0500
Date: Tue, 14 Dec 2010 15:50:32 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 17/21] Calculate the size of the core file
Message-ID: <20101214155032.0aa762fc@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate the size of the core file

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>

---
 fs/proc/gencore-elf.c |    6 ++++++
 fs/proc/gencore.h     |    1 +
 2 files changed, 7 insertions(+)

Index: linux-2.6.36-rc7/fs/proc/gencore.h
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore.h
+++ linux-2.6.36-rc7/fs/proc/gencore.h
@@ -27,6 +27,7 @@ struct core_proc {
 	size_t elf_buflen;	/* size of elf_buf */
 	size_t nphdrs;		/* number of phdrs */
 	size_t notes_size;
+	size_t size;
 };
 
 extern void try_to_freeze_core_threads(struct core_proc *cp);
Index: linux-2.6.36-rc7/fs/proc/gencore-elf.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/proc/gencore-elf.c
+++ linux-2.6.36-rc7/fs/proc/gencore-elf.c
@@ -310,6 +310,9 @@ static int create_elf_header(struct core
 						dataoff, cp->nphdrs);
 		dataoff += sizeof(struct elf_shdr);
 	}
+
+	cp->size = dataoff;
+
 	/* Store the notes */
 	tinfo = cp->tinfo;
 	do {
@@ -371,6 +374,9 @@ ssize_t elf_read_gencore(struct core_pro
 		}
 	}
 
+	if (*fpos > cp->size)
+		goto out;
+
 out:
 	return ret;
 }
