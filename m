Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1ATAiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:38:20 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:49315 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1ATAiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s/PzzOu80958MfbJ+6QwS9H6SkRadMwBec/ykU1jhiEO9PTb0nxivoblC3F/zQd8pF
         PB1oq7vu/cgS3Cm5BOOIeF6PR+wORS2JmpN9eb2V1TS7wW4rXM2IIC75zQ8XmZ15TOEG
         Z4KueEb5ORACt5I8sVkhfjzOJ59WAuPxBWGyY=
Date: Wed, 19 Jan 2011 16:38:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 18 (__modver_version_show)
Message-ID: <20110120003808.GA14292@core.coreip.homeip.net>
References: <20110118122139.6c2a6f2f.sfr@canb.auug.org.au>
 <20110118091749.ac5823df.randy.dunlap@oracle.com>
 <20110119160951.2a14d0a0.sfr@canb.auug.org.au>
 <4D370CE6.3000505@oracle.com>
 <4D370D63.5070503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D370D63.5070503@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 08:12:19AM -0800, Randy Dunlap wrote:
> On 01/19/11 08:10, Randy Dunlap wrote:
> > On 01/18/11 21:09, Stephen Rothwell wrote:
> >> Hi Randy,
> >>
> >> On Tue, 18 Jan 2011 09:17:49 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>>
> >>> I'm seeing this on several builds (i386 and x86_64):
> >>>
> >>> lib/built-in.o:(__modver+0x8): undefined reference to `__modver_version_show'
> >>> lib/built-in.o:(__modver+0x2c): undefined reference to `__modver_version_show'
> >>>
> >>> It looks like the compiler or linker is dropping that function from the
> >>> build since it cannot see any references to it...
> >>> At least __modver_version_show is not in the kernel/params.o file.
> >>
> >> Do these builds have CONFIG_SYSFS set?
> >>
> > 
> > Yes, they all do (50 random builds have CONFIG_SYSFS=y).
> 
> Gawd, what bad grepping this morning.
> 
> You hit the nail.  They do not have SYSFS enabled.
> 

Argh, this one is my fault, the following should fix it.

-- 
Dmitry


>From 61b92c66e36e460ddcf4e53a950910fbc637c9c5 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dtor@vmware.com>
Date: Wed, 19 Jan 2011 16:33:06 -0800
Subject: [PATCH] Fix MODULE_VERSION() definition when SYSFS is disabled

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 include/linux/module.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 742ebad..e633951 100644
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
-- 
1.7.3.2

