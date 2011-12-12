Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1LLXMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:12:41 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36566 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1LLXMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:12:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 12 Dec 2011 16:12:02 -0700
Message-ID: <CAJfuBxx8jnBp-=YZ=NqcsdxEbRP2s=uR2+UAcJ5EKDkw9JGgxw@mail.gmail.com>
Subject: [patch 00/23] dynamic-debug enhancements
To: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 1:27 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> this patchset adds
> - dynamic-debug during module initialization
via $module.dyndbg
> - multiple queries in ddebug_query, module.dyndbg
>
> Unlike previous versions, it drops the pending-query approach in
> favor of  "fake module parameters"proposed by Thomas Renninger
>    https://lkml.org/lkml/2010/9/15/397
>

This revision fixes an overzealous rework in the previous;
the unknown-parameter callback from parse-args/parse-one
is not invoked in the boot-process, so boot-args were not picked up
for builtin modules, only for loadable modules.
So, this restores ddebug_boot_parse_args() to do that.

The char *modname added previously to the callback signature remains
(added in patch 18), this is needed by the callback (in patch 20), and is
unavailable in the param-name, which has already been stripped of its
module. prefix.
Im hoping this minor feature-before-use issue is forgettable; I could have
put patch 20 1st, but its useless unless modname is available,
which seemed to be a bigger violation.

I briefly looked at using a struct module* as pondered by Rusty,
and module:load_module() already uses it to fill args of params:parse_args(),
which would reduce sig to just (struct module*, callback*)
but other callers of parse_args, "booting kernel", "early options",
dont have a struct mod, and it seemed like massive overkill to dummy one up.
So I stuck with char *modname.



> Its based upon 3.2-rc3, since that has several patches to
> include/linux/dynamic_debug.h
> that are not in driver-core-next, and theyd need to be handled eventually.
>
> 1 - trivial bug in kernel/module.c under DEBUGP
> 2 - whitespace
> 3-12 dyndbg cleanups
> 13-17 multiple queries
> 18-23 dynamic-debug during module initialization
>
[jimc@groucho linux-2.6]$ git diff --stat v3.2-rc3..HEAD
 Documentation/dynamic-debug-howto.txt |  156 +++++++++++-----
 Documentation/kernel-parameters.txt   |   23 ++-
 drivers/pnp/base.h                    |    8 +-
 drivers/pnp/core.c                    |   12 ++
 include/linux/device.h                |    8 +-
 include/linux/dynamic_debug.h         |   30 +++-
 include/linux/kernel.h                |   10 +
 include/linux/moduleparam.h           |    7 +-
 include/linux/netdevice.h             |    8 +-
 include/linux/printk.h                |    8 +-
 init/main.c                           |    5 +-
 kernel/module.c                       |   49 +++---
 kernel/params.c                       |   36 ++--
 lib/Kconfig.debug                     |   17 +-
 lib/dynamic_debug.c                   |  335 +++++++++++++++++++++++----------
 15 files changed, 483 insertions(+), 229 deletions(-)
