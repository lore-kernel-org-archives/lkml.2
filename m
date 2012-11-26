Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab2KZXG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:06:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50533 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab2KZXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:06:55 -0500
MIME-Version: 1.0
Date: Mon, 26 Nov 2012 15:06:53 -0800
Message-ID: <CAGXD9OfAMUmrdFBap3aOYXOhXE6=i8qL7=+SsJYnrdEr3kyMKw@mail.gmail.com>
Subject: vmalloc_sync_all(), 64bit kernel, patches 9c48f1c629ecfa114850c03f875c6691003214de,
 a79e53d85683c6dd9f99c90511028adc2043031f
From: Prasad Koya <prasad.koya@gmail.com>
To: dzickus@redhat.com, aarcange@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Before going into crashkernel, nmi_shootdown_cpus() calls
register_die_notifier(), which calls vmalloc_sync_all(). I'm seeing
lockup in sync_global_pgds() (init_64.c). From 3.2 and up,
register_die_notifier() is replaced with register_nmi_handler() (patch
9c48f1c629ecfa114850c03f875c6691003214de), which doesn't call
vmalloc_sync_all(). Is it ok to skip vmalloc_sync_all() in this path?
I see sync_global_pgds() was touched by this patch:
a79e53d85683c6dd9f99c90511028adc2043031f. There are no virtual
machines involved and I see lockups at times.

thank you.
Prasad

/* Halt all other CPUs, calling the specified function on each of them
  *
  * This function can be used to halt all other CPUs on crash
@@ -794,7 +784,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)

        atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
        /* Would it be better to replace the trap vector here? */
-       if (register_die_notifier(&crash_nmi_nb))
+       if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
+                                NMI_FLAG_FIRST, "crash"))
                return;         /* return what? */
