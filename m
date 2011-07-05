Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1GEQMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:12:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59261 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab1GEQMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTim2Q93LhBvGODVvEnvJiowtOk=DsA@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-4-git-send-email-jim.cromie@gmail.com> <BANLkTim2Q93LhBvGODVvEnvJiowtOk=DsA@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Tue, 5 Jul 2011 10:12:16 -0600
Message-ID: <CAJfuBxwoifcYGyKFd6M=5XW+YMMD97uG+hpXwAF3PvXW465VDg@mail.gmail.com>
Subject: Re: [PATCH 03/11] dynamic_debug: process multiple commands on a line
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 4:50 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> Process multiple commands per line, separated by ';'.  All commands are
>> processed, independent of errors, allowing individual commands to fail,
>> for example when a module is not installed.  Last error code is returned.
>> With this, extensive command sets can be given on the boot-line.
>> +/* handle multiple queries, continue on error, return last error */
>> +static int ddebug_exec_queries(char *query)
>> +{
>> +       char *split = query;
>> +       int i, errs = 0, exitcode = 0, rc;
>> +
>> +       if (verbose)
>> +               /* clean up for logging */
>> +               for (; (split = strpbrk(split, "\t\n")); split++)
>> +                       *split = ' ';
>
> The above will join multiple lines into a single line and hence will
> cause a shell statement like the one below to be interpret as a single
> query:
>

oof.
I got impression from Documentation/dynamic-debug-howto.txt
that multiple commands were not supported.  Hence this change
in patch 3:

-Commands are bounded by a write() system call.  If you want to do
-multiple commands you need to do a separate "echo" for each, like:
+Commands are bounded by a write() system call.  Subject to this limit
+(or 1024 for boot-line parameter) you can send multiple commands,
+separated by ';'

Clearly by your example it is possible.
I'll remove those lines, they were for pretty debug messages anyway.

FWIW, using \n to separate multiple commands doesnt work
on kernel bootline (in mainline); the following kills the ddebug facility
(see 0007-dynamic_debug-dont-kill-entire-facility-on-error-par.patch)

root@voyage:~# more /proc/cmdline
root=LABEL=ROOT_FS console=ttyS0,115200n8 all_generic_ide \
ide_core.nodma=0.0 \
ddebug_query="module init_32 +p\n module suspend +p\n module freezer +p"

>
>> +       for (i = 0; query; query = split, i++) {
>> +
>
> No blank line past "for" please.

ack. will fix.
