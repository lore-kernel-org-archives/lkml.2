Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab2JOJBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:01:42 -0400
Received: from smtp-out-100.synserver.de ([212.40.185.100]:1081 "EHLO
	smtp-out-100.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2JOJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:01:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3316
Message-ID: <507BD13C.9020103@metafoo.de>
Date: Mon, 15 Oct 2012 11:02:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: UAPI fdpic problems
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just tried to build 3.7-rc1 and hit some problems when trying to build the
fdpic elf loader:

fs/binfmt_elf_fdpic.c:60: warning: ‘struct elf_fdpic_params’ declared inside
parameter list
fs/binfmt_elf_fdpic.c:60: warning: its scope is only this definition or
declaration, which is probably not what you want
fs/binfmt_elf_fdpic.c:62: warning: ‘struct elf_fdpic_params’ declared inside
parameter list
fs/binfmt_elf_fdpic.c:66: warning: ‘struct elf_fdpic_params’ declared inside
parameter list
fs/binfmt_elf_fdpic.c:73: warning: ‘struct elf_fdpic_params’ declared inside
parameter list
fs/binfmt_elf_fdpic.c:77: warning: ‘struct elf_fdpic_params’ declared inside
parameter list
fs/binfmt_elf_fdpic.c:124: warning: ‘struct elf_fdpic_params’ declared
inside parameter list
fs/binfmt_elf_fdpic.c:123: error: conflicting types for ‘elf_fdpic_fetch_phdrs’
fs/binfmt_elf_fdpic.c:60: error: previous declaration of
‘elf_fdpic_fetch_phdrs’ was here
...

The problem is caused by commit 607ca46e97a ("UAPI: (Scripted) Disintegrate
include/linux").

This is the change made by the patch to elf-fdpic.h, where struct
elf_fdpic_params is declared.

--- a/include/linux/elf-fdpic.h
+++ b/include/uapi/linux/elf-fdpic.h
@@ -31,6 +31,7 @@ struct elf32_fdpic_loadmap {

 #define ELF32_FDPIC_LOADMAP_VERSION    0x0000

+#ifndef __KERNEL__
 /*
  * binfmt binary parameters structure
  */
@@ -58,7 +59,6 @@ struct elf_fdpic_params {
 #define ELF_FDPIC_FLAG_PRESENT         0x80000000
 };

-#ifdef __KERNEL__
 #ifdef CONFIG_MMU
 extern void elf_fdpic_arch_lay_out_mm(struct elf_fdpic_params *exec_params,
                                      struct elf_fdpic_params


So the patch removed the #ifdef __KERNEL__ around
elf_fdpic_arch_lay_out_mm() and added a #ifndef __KERNEL__ around both
struct elf_fdpic_params and elf_fdpic_arch_lay_out_mm(), which does not seem
to make much sense, since both are used (only?) inside the kernel. David do
you know why your script made this change?

The fix I'm using for now is the following, but I'm not quite sure if it is
the correct solution.

--- a/include/uapi/linux/elf-fdpic.h
+++ b/include/uapi/linux/elf-fdpic.h
@@ -31,7 +31,7 @@ struct elf32_fdpic_loadmap {

 #define ELF32_FDPIC_LOADMAP_VERSION    0x0000

-#ifndef __KERNEL__
+#ifdef __KERNEL__
 /*
  * binfmt binary parameters structure
  */

Thanks,
- Lars
