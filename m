Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab1GMHZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 03:25:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1GMHZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 03:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAO+b5-pXKeQ8zk367M4FNG5r6vUm6dOVBcNRaoJr+4i=kOy35A@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-4-git-send-email-jim.cromie@gmail.com>
 <CAO+b5-pXKeQ8zk367M4FNG5r6vUm6dOVBcNRaoJr+4i=kOy35A@mail.gmail.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 13 Jul 2011 01:25:17 -0600
Message-ID: <CAJfuBxwuVMGSaGmbT02LrwfufHXO_gA-POvr1e7TQ4LYCtkcrA@mail.gmail.com>
Subject: Re: [PATCH 03/21] dynamic_debug: process multiple commands on a line
To: Bart Van Assche <bvanassche@acm.org>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:54 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>> Process multiple commands per line, separated by ';'.  All commands are
>> processed, independent of errors, allowing individual commands to fail,
>> for example when a module is not installed.  Last error code is returned.
>> With this, extensive command sets can be given on the boot-line.


> Does the above mean that semicolon is considered a valid separator but
> newline not ?
>
> Bart.
>


no, your printf example still works.
Note that it actually issues 2 writes to the control-file.

root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose
trol voyage:~# printf "module foo +ap\n module bar +ap" >
/dbg/dynamic_debug/cont
dynamic_debug:ddebug_proc_open: called
dynamic_debug:ddebug_proc_write: read 15 bytes from userspace
dynamic_debug:ddebug_exec_queries: query 0: "module foo +ap
"
dynamic_debug:ddebug_tokenize: split into words: "module" "foo" "+ap"
dynamic_debug:ddebug_parse_query: parsed func="" file="" module="foo"
format="" lineno=0-0
dynamic_debug:ddebug_parse_flags: flags_filter=0x0 op='+' flags=0x21
dynamic_debug:ddebug_parse_flags: *flagsp=0x21 *maskp=0xffffffff
dynamic_debug:ddebug_save_pending: add to pending: func="" file=""
module="foo" format="" lineno=0-0
dynamic_debug:ddebug_save_pending: query saved as pending 1
dynamic_debug:ddebug_exec_query: nfound 0 on func="" file=""
module="foo" format="" lineno=0-0
dynamic_debug:ddebug_exec_queries: processed 1 queries, with 0 errs
dynamic_debug:ddebug_proc_write: read 15 bytes from userspace
dynamic_debug:ddebug_exec_queries: query 0: " module bar +ap"
dynamic_debug:ddebug_tokenize: split into words: "module" "bar" "+ap"
dynamic_debug:ddebug_parse_query: parsed func="" file="" module="bar"
format="" lineno=0-0
dynamic_debug:ddebug_parse_flags: flags_filter=0x0 op='+' flags=0x21
dynamic_debug:ddebug_parse_flags: *flagsp=0x21 *maskp=0xffffffff
dynamic_debug:ddebug_save_pending: add to pending: func="" file=""
module="bar" format="" lineno=0-0
dynamic_debug:ddebug_save_pending: query saved as pending 2
dynamic_debug:ddebug_exec_query: nfound 0 on func="" file=""
module="bar" format="" lineno=0-0
root@voyage:~#

FWIW, the \n approach doesnt help on the boot-line;
on mainline, the following will break the facility -
/dbg/dynamic_debug will not get created.

Kernel command line: ...  ddebug_query="module pc8736x_gpio +p \n
module nsc_gpio +p "
