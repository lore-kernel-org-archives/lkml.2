Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1L0XdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:33:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1L0XdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:33:06 -0500
Date: Tue, 27 Dec 2011 15:33:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-Id: <20111227153304.c585c5f6.akpm@linux-foundation.org>
In-Reply-To: <20111223124920.661126615@openvz.org>
References: <20111223124741.711871189@openvz.org>
	<20111223124920.661126615@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 16:47:42 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> The routine XORs the given pointer with a random value
> producing an ID (32 or 64 bit, depending on the arch).
> 
> Since it's a valuable information -- only CAP_SYS_ADMIN
> is allowed to obtain it.
> 
>  - Tejun worried about the single poison value was a weak side -
>    leaking one makes all the IDs vulnerable. To address this
>    several poison values - one per object type - are introduced.
>    They are stored in a plain array.
>  - Pekka proposed to initialized poison values in the late_initcall callback
>  - ... and move the code to mm/util.c
>
> ...
>

The code in general looks simple and reasonable to me.  I'm too much of
a security weenie to pass judgement on the security aspects.

>
> ...
>
> --- linux-2.6.git.orig/mm/Kconfig
> +++ linux-2.6.git/mm/Kconfig
> @@ -373,3 +373,19 @@ config CLEANCACHE
>  	  in a negligible performance hit.
>  
>  	  If unsure, say Y to enable cleancache
> +
> +config GENERIC_OBJECT_ID
> +	bool "Enable generic object ID infrastructure"
> +	depends on CHECKPOINT_RESTORE

Is c/r useless without GENERIC_OBJECT_ID?  If so, perhaps a `select'
would be good here.

> +	default n
> +	help
> +	  Turn on the functionality that can generate IDs for kernel
> +	  objects, which are exported to userspace via /proc filesystem.
> +
> +	  It is useful if you need to examinate kernel objects and test
> +	  if they are shared between several tasks. These IDs should never
> +	  be used for anything but the "sameness" test. Besides, the IDs are
> +	  dynamic and valid only while object is alive, once it get freed or
> +	  kernel is rebooted -- the IDs will be changed.
> +
> +	  If unsure, say N here.
> Index: linux-2.6.git/mm/Makefile
> ===================================================================
> --- linux-2.6.git.orig/mm/Makefile
> +++ linux-2.6.git/mm/Makefile
> @@ -51,3 +51,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoiso
>  obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
>  obj-$(CONFIG_CLEANCACHE) += cleancache.o
> +obj-$(CONFIG_GENERIC_OBJECT_ID) += gen_obj_id.o
> Index: linux-2.6.git/mm/gen_obj_id.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/mm/gen_obj_id.c
> @@ -0,0 +1,51 @@
> +#include <linux/kernel.h>
> +#include <linux/capability.h>
> +#include <linux/random.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/gen_obj_id.h>

Formally, we need more includes than this.  cache.h for __read_mostly,
bug.h for BUG(), maybe others.  Forgetting bug.h used to be (and maybe
still is) a popular way of breaking the build for alpha.

