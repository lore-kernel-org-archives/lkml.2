Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1LCP5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 10:57:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58482 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1LCP5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 10:57:16 -0500
MIME-Version: 1.0
In-Reply-To: <20111201212017.GE2443@redhat.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com> <20111201212017.GE2443@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Sat, 3 Dec 2011 08:56:42 -0700
Message-ID: <CAJfuBxzbwRRfbWK8LQAi4SdoSBX8ByfpGUePvRia+0W5j4iJOA@mail.gmail.com>
Subject: Re: [patch 00/25] dynamic-debug during module initialization
To: Jason Baron <jbaron@redhat.com>
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 2:20 PM, Jason Baron <jbaron@redhat.com> wrote:
> On Wed, Nov 30, 2011 at 12:56:29PM -0700, jim.cromie@gmail.com wrote:
>> This patchset adds
>> - dynamic-debug during module initialization
>> - multiple queries
>>
>> Unlike previous versions, this drops pending-query approach in
>> favor of "fake module parameter" approach proposed by Thomas Renninger.
>>     https://lkml.org/lkml/2010/9/15/397
>>
>> Its based upon v3.2-rc3, cuz it includes a few adjustments to
>> dynamic_debug.h which are not in driver-core-next atm.
>>
>>
>> 1     bug-fix for kernel/module.c under DEBUGP
>> 2     whitespace cleanup
>> 3-12  dynamic-debug cleanups, should be relatively uncontroversial
>> 13-17 multiple queries in ddebug_query="..."
>>
>> 18-25 fake module parameter
>> 20    maybe fold into 18 (kept separate since 18 is Thomas's work)
>> 23    *.dyndbg=...
>> 25    BUILD_BUG_DECL (likely discussion point ;-)
>>
>
> I like 25, it truly makes 'dyndbg' a reserved module parameter, which is the
> intention.
>

heres a failing usage:

...
#include <linux/device.h>
#include <linux/netdevice.h>

BUILD_BUG_DECL(foo,(1==1));

heres what it looks like expanded:

static struct __BUILD_BUG_DECL_foo { int __BUILD_BUG_DECL_foo[1 -
2*!!(1==1)]; } __BUILD_BUG_DECL_foo[0] __attribute__((unused));

and heres the error:

  CALL    /home/jimc/projects/lx/linux-2.6/scripts/checksyscalls.sh
  CC      lib/dynamic_debug.o
/home/jimc/projects/lx/linux-2.6/lib/dynamic_debug.c:37:42: error:
size of array ‘__BUILD_BUG_DECL_foo’ is negative
make[3]: *** [lib/dynamic_debug.o] Error 1


I havent seen any unused-var warnings, but maybe Ive not stimulated it enough.
