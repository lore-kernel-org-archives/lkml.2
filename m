Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1G0WF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:05:28 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64728 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab1G0WFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 18:05:25 -0400
MIME-Version: 1.0
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 27 Jul 2011 16:04:53 -0600
Message-ID: <CAJfuBxx_cSTuYoJjLkrGX3kYMvgw4Ep+rEL2VDNv-Ti5PB1C4w@mail.gmail.com>
Subject: dynamic_debug: enabled vs FLAGS_PRINT, more filtering tricks.
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 3:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
>
>
> This patchset extends dynamic-debug facility to allow
> use of pr_debug() within a loadable module's module_init()
> function.  Query/rules can be given on the boot-line,
> and are saved to a pending list if they cannot be applied
> immediately.  Later, when the module is being loaded, the
> pending list is scanned, and matching rules are applied.
> Thus pr_debug() calls in the module's initialization function
> are active when it is invoked.
>

latest version (including fixes for Barts comments) is at
git://github.com/jimc/linux-2.6.git
in dyndbg-next branch.

Is there a reason for having both enabled and _DPRINTK_FLAGS_PRINT  ?

struct _ddebug {
...
#define _DPRINTK_FLAGS_PRINT   (1<<0)
...
#define _DPRINTK_FLAGS_DEFAULT 0
	unsigned int flags:8;
	char enabled;
} __attribute__((aligned(8)));

as things stand, you can disable print flag with " -p "
but the call-site may still be enabled, ie [tmlf]

New ability to clear all flags via  " =_ " handles this, but ..

OTOH,         if (descriptor.enabled)
becomes    if (descriptor.flags & _DPRINTK_FLAGS_PRINT)

then current flags can be filtered to enable/disable previously
selected callsites.
  echo " t+p " > /dbg/dynamic_debug/control

This suggests that unused flags can be named (x,y,z for example)
then used expressly for marking arbitrary sets of callsites,
and toggling their enabled/disabled states.

  echo " x+p " > /dbg/dynamic_debug/control
  echo " y-p " > /dbg/dynamic_debug/control
  echo " z+p " > /dbg/dynamic_debug/control
