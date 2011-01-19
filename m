Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1ATCla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:41:30 -0500
Received: from ozlabs.org ([203.10.76.45]:49704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1ATCl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:41:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for January 18 (__modver_version_show)
Date: Thu, 20 Jan 2011 08:48:24 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@vmware.com>
References: <20110118122139.6c2a6f2f.sfr@canb.auug.org.au> <4D370CE6.3000505@oracle.com> <4D370D63.5070503@oracle.com>
In-Reply-To: <4D370D63.5070503@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101200848.25141.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 02:42:19 am Randy Dunlap wrote:
> >> On Tue, 18 Jan 2011 09:17:49 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>>
> >>> I'm seeing this on several builds (i386 and x86_64):
> >>>
> >>> lib/built-in.o:(__modver+0x8): undefined reference to `__modver_version_show'
> >>> lib/built-in.o:(__modver+0x2c): undefined reference to `__modver_version_show'
...
> You hit the nail.  They do not have SYSFS enabled.

Thanks, does this fix it?

Thanks,
Rusty.

module: fix linker error for MODULE_VERSION when !MODULE and CONFIG_SYSFS=n

lib/built-in.o:(__modver+0x8): undefined reference to `__modver_version_show'
lib/built-in.o:(__modver+0x2c): undefined reference to `__modver_version_show'

Simplest to just not emit anything: if they've disabled SYSFS they probably
want the smallest kernel possible.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -168,7 +168,7 @@ extern struct module __this_module;
   local headers in "srcversion".
 */
 
-#ifdef MODULE
+#if defined(MODULE) || !defined(CONFIG_SYSFS)
 #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
 #else
 #define MODULE_VERSION(_version)					\
