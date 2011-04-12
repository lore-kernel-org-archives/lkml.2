Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1DLGd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 02:33:57 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:55914 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122Ab1DLGd4 (ORCPT
	<rfc822;groupwise-jlee@novell.com:4:1>);
	Tue, 12 Apr 2011 02:33:56 -0400
Message-Id: <4DA47EF0020000230002B353@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 12 Apr 2011 00:33:52 -0600
From: "Joey Lee" <jlee@novell.com>
To: <dmitry.torokhov@gmail.com>
Cc: <smfrench@gmail.com>, <akpm@linux-foundation.org>, <mjg@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: undefined reference to `sparse_keymap_free'
References: <BANLkTinNm_j_SpjTXKVPXkWFmyjBZAQWyQ@mail.gmail.com>
 <20110411224819.b349025a.akpm@linux-foundation.org>
 <20110412055851.GA1854@core.coreip.homeip.net>
In-Reply-To: <20110412055851.GA1854@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2011-04-11 於 22:58 -0700，Dmitry Torokhov 提到：
> On Mon, Apr 11, 2011 at 10:48:19PM -0700, Andrew Morton wrote:
> > (cc's added)
> > 
> > On Mon, 11 Apr 2011 23:18:04 -0500 Steve French <smfrench@gmail.com> wrote:
> > 
> > > 2.6.38-rc3 build error:
> > > 
> > > drivers/built-in.o: In function `msi_laptop_input_destroy':
> > > msi-laptop.c:(.text+0x1a3be1): undefined reference to `sparse_keymap_free'
> > > drivers/built-in.o: In function `msi_send_touchpad_key':
> > > msi-laptop.c:(.text+0x1a3c45): undefined reference to
> > > `sparse_keymap_report_event'
> > > drivers/built-in.o: In function `msi_init':
> > > msi-laptop.c:(.init.text+0xe055): undefined reference to `sparse_keymap_setup'
> > > msi-laptop.c:(.init.text+0xe07d): undefined reference to `sparse_keymap_free'
> > > 
> > 
> > Either a missing CONFIG_INPUT_SPARSEKMAP dependency, or missing stubs in
> > include/linux/input/sparse-keymap.h?
> > 
> 
> No, stubs for sparse keymap do not make sense (either one wants to use
> this library-like module or she does not), so it must be the missing
> "select" (sparse keymap should be selectable as long as selecting module
> depends on CONFIG_INPUT).
> 
> Thanks.
> 

Randy's patch in platform driver tree's linux-next branch fixed this
issue:

commit d0984225a888a84e44f23671c670a7bb035d1820
Author: Randy Dunlap <randy.dunlap@oracle.com>
Date:   Wed Mar 30 15:20:22 2011 -0700

    msi-laptop: fix config-dependent build error
    
    The msi-laptop driver uses input_*() and sparse_keymap_*() interfaces.
    It should depend on the INPUT subsystem being present and select
    INPUT_SPARSEKMAP so that those interfaces are present.
    
    ERROR: "input_free_device" [drivers/platform/x86/msi-laptop.ko] undefined!
    ERROR: "input_register_device" [drivers/platform/x86/msi-laptop.ko] undefined!
    ERROR: "sparse_keymap_setup" [drivers/platform/x86/msi-laptop.ko] undefined!
    ERROR: "input_allocate_device" [drivers/platform/x86/msi-laptop.ko] undefined!
    ERROR: "sparse_keymap_report_event" [drivers/platform/x86/msi-laptop.ko] undefined!
    ERROR: "input_unregister_device" [drivers/platform/x86/msi-laptop.ko] undefined!
    ERROR: "sparse_keymap_free" [drivers/platform/x86/msi-laptop.ko] undefined!
    
    Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
    Cc: Matthew Garrett <mjg@redhat.com>
    Cc: "Lee, Chun-Yi" <jlee@novell.com>
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2ee442c..0485e39 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -187,7 +187,8 @@ config MSI_LAPTOP
        depends on ACPI
        depends on BACKLIGHT_CLASS_DEVICE
        depends on RFKILL
-       depends on SERIO_I8042
+       depends on INPUT && SERIO_I8042
+       select INPUT_SPARSEKMAP
        ---help---
          This is a driver for laptops built by MSI (MICRO-STAR
          INTERNATIONAL):


